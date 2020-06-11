# Ubuntu de base

Voici le contenu de ce conteneur:

* Ubuntu 18.04
* SSH
* TightVNCServer
* Vim avec Vimified
* Jed
* Httpie
* Ranger
* Tmux
* X11 pour l'exécution graphique avec SSH (*port forwarding*)
* Interface XFCE 4 pour un démarrage graphique avec VNC

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
vncviewer localhost:5901
```

Le mot de passe est *ubuntu*


