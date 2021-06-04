# Ubuntu de base avec VNC et SSH

Basé sur https://github.com/fcwu/docker-ubuntu-vnc-desktop

Voici le contenu de ce conteneur:

* Ubuntu 20.04
* VNCServer
* LXDE/LxQT
* Vim avec Vimified
* Jed
* Httpie
* Ranger
* Tmux
* FZF
* ugrep
*

# Utilisation

Pour construire l'image, on tape:

```
cd ./docker-ubuntu
docker-compose build
docker-compose up -d
```

## Pour se connecter par SSH

```
ssh -X ubuntu@localhost
ubuntu@localhost's password:
```

Le mot de passe est *ubuntu*

Le paramètre "-X" permet de créer un pont X11 pour l'affichage de Atom sur le
poste hôte bien que Atom s'exécute dans le conteneur.

## Pour se connecter par VNC

```
vncviewer localhost:5900
```

Pas de mot de passe

ou via un fureteur à l'adresse http://localhost:80


