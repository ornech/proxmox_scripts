#!/bin/bash

SERVEUR="pve"
PROMO="2023"
# VID du CT à cloner
CLONE="101"
#VID du premier CT
VM_ID="200"

for n in $(cat list.txt )
do
    # sépare les éléments de la ligne récupérée
    # Définit le séparateur IFS
    set -f; IFS=':'
    set -- $n
    # Assigne les valeurs récupérées
    NOM=$1; PASSWORD=$2; 
    set +f; unset IFS


    # Création du pool étudiant
    pvesh create /pools --poolid $PROMO-$NOM --comment "Pool dédié à $NOM $PROMO"
    
    # Création du compte proxmox étudiant
    pveum user add $NOM@$SERVEUR --groups $GROUP --password $PASSWORD --comment "$USER_COMMENT"
    
    # Assigne des droits d'accès PVEUser aux utilisateurs de GROUPE aux VM membre de MON$
    pveum aclmod /pool/$POOL/ --users $NOM -role PVEVMUser

    # clone d'un CT
    pct clone $CLONE $VM_ID --hostname $NOM-$USER --pool $GROUPE
    
    # démarre le container
    pct start $VM_ID
    
    # Création du compte linux dans le container
    echo "Création du compte $USER sur la VM $NOM$USER"
    pct exec $VM_ID -- bash -c 'useradd -m --shell /bin/bash -g users -G sudo $USER'
    
    # Définition du mot de passe
    echo "Défintion du mot de passe pour $USER:$PASSWORD"
    pct exec $VM_ID -- bash -c "echo '$USER:$PASSWORD' | chpasswd"
    
    VM_ID=$((VM_ID+1))

done
