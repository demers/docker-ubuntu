FROM ubuntu:18.04

# Code pour VNC
# https://github.com/codeworksio/docker-ubuntu-desktop

MAINTAINER FND <fndemers@gmail.com>

ENV PROJECTNAME=UBUNTU

ENV TERM=xterm\
    TZ=America/Toronto\
    DEBIAN_FRONTEND=noninteractive

# Access SSH et VNC login
ENV USERNAME=ubuntu
ENV SYSTEM_USER=ubuntu
ENV PASSWORD=ubuntu

ENV EMAIL="fndemers@gmail.com"
ENV NAME="F.-Nicola Demers"

ENV WORKDIRECTORY=/home/ubuntu

# Venant de https://github.com/codeworksio/docker-ubuntu-desktop/blob/master/Dockerfile
ARG APT_PROXY
ARG APT_PROXY_SSL
ENV VNC_DISPLAY=":1" \
    VNC_RESOLUTION="1280x1024" \
    VNC_COLOUR_DEPTH="24" \
    VNC_PASSWORD="ubuntu"

RUN apt-get update
RUN apt install -y apt-utils vim-nox vim-gtk curl git nano psmisc
RUN apt-get install -y exuberant-ctags
RUN apt-get update

# Install a basic SSH server
RUN apt install -y openssh-server
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd
RUN /usr/bin/ssh-keygen -A

# Add user to the image
RUN adduser --quiet --disabled-password --shell /bin/bash --home ${WORKDIRECTORY} --gecos "User" ${USERNAME}
# Set password for the jenkins user (you may want to alter this).
RUN echo "$USERNAME:$PASSWORD" | chpasswd

RUN apt-get clean && apt-get -y update && apt-get install -y locales && locale-gen fr_CA.UTF-8
ENV TZ=America/Toronto
RUN unlink /etc/localtime
RUN ln -s /usr/share/zoneinfo/$TZ /etc/localtime

RUN apt install -y jed httpie ranger tmux tree fish

RUN echo "export PS1=\"\\e[0;31m $PROJECTNAME\\e[m \$PS1\"" >> ${WORKDIRECTORY}/.bash_profile

RUN echo "git config --global user.email '$EMAIL'" >> ${WORKDIRECTORY}/.bash_profile
RUN echo "git config --global user.name '$NAME'" >> ${WORKDIRECTORY}/.bash_profile

# Ajout des droits sudoers
RUN apt-get install -y sudo
RUN echo "%ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN echo "export DISPLAY=:0.0" >> ${WORKDIRECTORY}/.bash_profile
RUN echo "export DISPLAY=:0.0" >> /root/.bash_profile

RUN apt-get update
# Install Java
RUN apt-get install -qy --no-install-recommends python-dev default-jdk


WORKDIR ${WORKDIRECTORY}

# Standard SSH port
EXPOSE 22

# Installation X11.
RUN apt install -y xauth vim-gtk

RUN apt-get update
RUN apt-get install -y build-essential cmake

# Installation Python 3
RUN apt install -y git python3 python3-dev python3-pip python3-mock python3-tk
# Mise à jour PIP
RUN pip3 install --upgrade pip
RUN pip3 install flake8
RUN pip3 install flake8-docstrings
RUN pip3 install pylint
ENV PYTHONIOENCODING=utf-8

# https://github.com/Shougo/deoplete.nvim
RUN pip3 install pynvim


RUN cd ${WORKDIRECTORY} \
    && git clone git://github.com/zaiste/vimified.git \
    && ln -sfn vimified/ ${WORKDIRECTORY}/.vim \
    && ln -sfn vimified/vimrc ${WORKDIRECTORY}/.vimrc \
    && cd vimified \
    && mkdir bundle \
    && mkdir -p tmp/backup tmp/swap tmp/undo \
    && git clone https://github.com/gmarik/vundle.git bundle/vundle \
    && echo "let g:vimified_packages = ['general', 'coding', 'fancy', 'indent', 'css', 'os', 'ruby', 'js', 'haskell', 'python', 'color']" > local.vimrc

RUN mkdir -p ${WORKDIRECTORY}/vimified/

COPY after.vimrc ${WORKDIRECTORY}/vimified/

COPY extra.vimrc ${WORKDIRECTORY}/vimified/

RUN chown -R ubuntu:ubuntu ${WORKDIRECTORY}/vimified/

# Générer les tags de ctags.
RUN echo "ctags -f ${WORKDIRECTORY}/mytags -R ${WORKDIRECTORY}" >> ${WORKDIRECTORY}/.bash_profile

#if ! [ -f /run/user/$UID/runonce_myscript ]; then
    #touch /run/user/$UID/runonce_myscript
    #/path/to/myscript
#fi

# Compiling Vim plugins only once...
RUN echo "if ! [ -f ~/.runonce_install ]; then" >> ${WORKDIRECTORY}/.bash_profile
RUN echo "touch ~/.runonce_install" >> ${WORKDIRECTORY}/.bash_profile
RUN echo "vim +BundleInstall +qall" >> ${WORKDIRECTORY}/.bash_profile
RUN echo "fi" >> ${WORKDIRECTORY}/.bash_profile
RUN echo "cd ~/" >> ${WORKDIRECTORY}/.bash_profile

RUN chown -R ubuntu:ubuntu ${WORKDIRECTORY}/.bash_profile

RUN apt -qy install gcc g++ make
RUN apt install -y software-properties-common apt-transport-https wget

RUN set -ex && \
    \
    # install system packages
    if [ -n "$APT_PROXY" ]; then echo "Acquire::http { Proxy \"http://${APT_PROXY}\"; };" > /etc/apt/apt.conf.d/00proxy; fi && \
    if [ -n "$APT_PROXY_SSL" ]; then echo "Acquire::https { Proxy \"https://${APT_PROXY_SSL}\"; };" > /etc/apt/apt.conf.d/00proxy; fi && \
    apt-get --yes update && \
    apt-get --yes upgrade && \
    apt-get --yes install \
        dbus-x11 \
        tightvncserver \
        xbase-clients \
        xfce4 \
        xfce4-terminal \
        xfonts-100dpi \
        xfonts-75dpi \
        xfonts-base \
        xfonts-scalable \
    && \
    # configure system user
    echo "root:$VNC_PASSWORD" | chpasswd && \
    mkdir -p /home/$SYSTEM_USER/.vnc && \
    touch /home/$SYSTEM_USER/.Xresources && \
    touch /home/$SYSTEM_USER/.Xauthority && \
    \
    # SEE: https://github.com/stefaniuk/dotfiles
    export USER_NAME=$SYSTEM_USER && \
    export USER_EMAIL=${SYSTEM_USER}@local && \
    curl -L https://raw.githubusercontent.com/stefaniuk/dotfiles/master/dotfiles -o - | /bin/bash -s -- \
        --directory=/home/$SYSTEM_USER \
    && \
    # configure system user
    chown -R $SYSTEM_USER:$SYSTEM_USER /home/$SYSTEM_USER && \
    chsh -s /bin/bash $SYSTEM_USER && \
    \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* /var/cache/apt/* && \
    rm -f /etc/apt/apt.conf.d/00proxy

COPY init.sh /
RUN chmod a+x /init.sh

EXPOSE 5901-5999

# AJOUTER_ICI

# Start SSHD server...
#CMD ["/usr/sbin/sshd", "-D"]
CMD [ "/init.sh" ]
