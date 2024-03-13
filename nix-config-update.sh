#!/bin/sh
clear
echo "Mise à jour de la configuration Nix"
cd /tmp

if [ -d "/tmp/nixos" ]; then
    echo "  --> Nettoyage du dossier /tmp/nixos"
    rm -Rf /tmp/nixos
fi

echo "Clonage du repo"
git clone https://github.com/DavidBrigand/nixos.git

# Le dossier a été créé par le git clone on continue
if [ -d "/tmp/nixos" ]; then
    cd /tmp/nixos
    echo " "
    echo "Comparaison des checksum"
    LOCAL=$(md5sum "/etc/nixos/configuration.nix" | cut -d ' ' -f 1)
    REMOTE=$(md5sum "/tmp/nixos/configuration.nix" | cut -d ' ' -f 1)
else
	echo "Erreur de Git Clone"
	exit
fi

if [ "$LOCAL" != "$REMOTE" ]; then
	echo "Les Fichiers sont différents"
        echo "  --> Sauvegarde de la configuration"
        sudo cp -f /etc/nixos/configuration.nix /etc/nixos/configuration.old
        echo "  --> Copie du Fichier configuration.nix"
        sudo cp -f /tmp/nixos/configuration.nix /etc/nixos/configuration.nix
        
	echo "  --> Copie des Scripts"
	if [ -d "~/Scripts" ]; then
		cp -f Scripts/nix-up.sh ~/Scripts/nix-up.sh
  	else
 		mkdir ~/Scripts && cp -f Scripts/nix-up.sh ~/Scripts/nix-up.sh
  	fi
else
	echo "Rien à faire : Verification des Fichiers"
	LOCAL=$(md5sum "/etc/nixos/configuration.nix" | cut -d ' ' -f 1)
	REMOTE=$(md5sum "/tmp/nixos/configuration.nix" | cut -d ' ' -f 1)
	echo "LOCAL : $LOCAL"
	echo "REMOTE : $REMOTE"
	exit
fi

echo "  --> Mise à jour de la configuration"
sudo nixos-rebuild switch
