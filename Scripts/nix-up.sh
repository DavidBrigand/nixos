#!/bin/sh
# Script de comparaison entre 2 updates
CURRENT=~/.config/current
NEW=~/.config/current_$(date +"%Y%m%d")

echo "Creation de la liste des packets actuels avant MAJ"
sleep 2
nix-store --query --requisites /run/current-system | cut -d- -f2- | sort > $CURRENT
echo "Rebuild et switch"
sudo nixos-rebuild switch --upgrade

echo "Creation de la liste des packets actuels apres MAJ"
sleep 2
nix-store --query --requisites /run/current-system | cut -d- -f2- | sort > $NEW

echo "####################################"
echo "# Differences entre les 2 versions #"
echo "####################################"
diff $CURRENT $NEW

exit



