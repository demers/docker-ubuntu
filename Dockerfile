FROM dorowu/ubuntu-desktop-lxde-vnc:focal

# Code VNC de:
# https://github.com/fcwu/docker-ubuntu-vnc-desktop

MAINTAINER FND <fndemers@gmail.com>

ENV PROJECTNAME=UBUNTU

ENV TERM=xterm\
    TZ=America/Toronto\
    DEBIAN_FRONTEND=noninteractive

# Access SSH et VNC login
ENV USERNAME=ubuntu
ENV SYSTEM_USER=$USERNAME
ENV PASSWORD=ubuntu

ENV USER_EMAIL="fndemers@gmail.com"
ENV NAME="F.-Nicola Demers"

ENV UID=1000
ENV GID=1000

ENV WORKDIRECTORY=/home/ubuntu

RUN apt-get update
#RUN apt-get --yes upgrade

# Standard SSH port
EXPOSE 6080
EXPOSE 5900

# Installation de la commande ping
RUN apt-get install -y iputils-ping

# Installation htop
RUN apt-get install -y htop

RUN apt install -y apt-utils vim-nox vim-gtk curl git nano psmisc
RUN apt-get install -y exuberant-ctags
RUN apt-get update

# Install a basic SSH server
RUN apt install -y openssh-server
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd
RUN /usr/bin/ssh-keygen -A

# Add user to the image
RUN groupadd -g 1000 ubuntu
RUN adduser --quiet --disabled-password --shell /bin/bash --home ${WORKDIRECTORY} --gecos "User" --uid $UID --gid $GID ${USERNAME}
RUN echo "$USERNAME:$PASSWORD" | chpasswd

RUN apt-get clean && apt-get -y update && apt-get install -y locales && locale-gen fr_CA.UTF-8
ENV TZ=America/Toronto
RUN unlink /etc/localtime
RUN ln -s /usr/share/zoneinfo/$TZ /etc/localtime

RUN apt install -y jed httpie ranger tmux tree fish fzf

RUN echo "export PS1=\"\\e[0;31m $PROJECTNAME\\e[m \$PS1\"" >> ${WORKDIRECTORY}/.bash_profile

RUN echo "git config --global user.email '$USER_EMAIL'" >> ${WORKDIRECTORY}/.bash_profile
RUN echo "git config --global user.name '$NAME'" >> ${WORKDIRECTORY}/.bash_profile

# Ajout des droits sudoers
RUN apt-get install -y sudo
RUN echo "%$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN echo "export DISPLAY=:0.0" >> ${WORKDIRECTORY}/.bash_profile
RUN echo "export DISPLAY=:0.0" >> /root/.bash_profile

RUN apt-get update
# Install Java
RUN apt-get install -qy --no-install-recommends python-dev default-jdk


WORKDIR ${WORKDIRECTORY}

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

# Installation VIM et Vimified
RUN apt install -y vim-gtk

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

RUN chown -R $USERNAME:$PASSWORD ${WORKDIRECTORY}/vimified/

# Fin installation VIM

# Configuration Ranger
RUN ranger --copy-config=all
COPY rc.conf /tmp/
COPY commands.py /tmp/
RUN cat /tmp/rc.conf >> ${WORKDIRECTORY}/.config/ranger/rc.conf
RUN cat /tmp/commands.py >> ${WORKDIRECTORY}/.config/ranger/commands.py
RUN rm -f /tmp/rc.conf /tmp/commands.py
RUN chown -R $USERNAME:$PASSWORD ${WORKDIRECTORY}/.config
RUN echo "export TERM=xterm" >> ${WORKDIRECTORY}/.bash_profile

# Outils d'archivage
RUN apt install -y libarchive-tools atool unrar rar

# Installation de ugrep
RUN git clone https://github.com/Genivia/ugrep

RUN apt install -y libz-dev

RUN cd ${WORKDIRECTORY}/ugrep && \
    ./build.sh && \
    make install

# Générer les tags de ctags.
RUN echo "ctags -f ${WORKDIRECTORY}/mytags -R ${WORKDIRECTORY}" >> ${WORKDIRECTORY}/.bash_profile

# Compiling Vim plugins only once...
RUN echo "if ! [ -f ~/.runonce_install ]; then" >> ${WORKDIRECTORY}/.bash_profile
RUN echo "touch ~/.runonce_install" >> ${WORKDIRECTORY}/.bash_profile
RUN echo "vim +BundleInstall +qall" >> ${WORKDIRECTORY}/.bash_profile

RUN echo "fi" >> ${WORKDIRECTORY}/.bash_profile

RUN apt -qy install gcc g++ make
RUN apt install -y software-properties-common apt-transport-https wget


# AJOUTER_ICI

# Standard SSH port
EXPOSE 22

RUN sed -i '1 a service ssh start' /startup.sh

# Start SSHD and /startup.sh (VNC) server...
CMD ["/startup.sh"]