#!/bin/bash
#
# Script de désinstallation de Postfix, Dovecot et Rainloop
# Auteur : Hardware <contact@meshup.net>
# Version : 1.0.0
# URLs : https://github.com/hardware/mailserver-autoinstall
#        http://mondedie.fr/viewtopic.php?pid=11746
#
# Désinstallation :
#
# chmod a+x uninstall.sh && ./uninstall.sh

CSI="\033["
CEND="${CSI}0m"
CRED="${CSI}1;31m"
CGREEN="${CSI}1;32m"
CYELLOW="${CSI}1;33m"
CBLUE="${CSI}1;34m"
CPURPLE="${CSI}1;35m"
CCYAN="${CSI}1;36m"
CBROWN="${CSI}0;33m"

# ##########################################################################

if [[ $EUID -ne 0 ]]; then
    echo ""
    echo -e "${CRED}/!\ ERREUR: Ce script doit être exécuté en tant que root.${CEND}" 1>&2
    echo ""
    exit 1
fi

# ##########################################################################

smallLoader() {
    echo ""
    echo ""
    echo -ne '[ + + +             ] 3s \r'
    sleep 1
    echo -ne '[ + + + + + +       ] 2s \r'
    sleep 1
    echo -ne '[ + + + + + + + + + ] 1s \r'
    sleep 1
    echo -ne '[ + + + + + + + + + ] Appuyez sur [ENTRÉE] pour continuer... \r'
    echo -ne '\n'

    read
}

checkBin() {
    echo -e "${CRED}/!\ ERREUR: Le programme '$1' est requis.${CEND}"
}

# Vérification des exécutables
command -v apt-get > /dev/null 2>&1 || { echo `checkBin apt-get` >&2; exit 1; }
command -v mysql > /dev/null 2>&1 || { echo `checkBin mysqladmin` >&2; exit 1; }
command -v mysqladmin > /dev/null 2>&1 || { echo `checkBin mysqladmin` >&2; exit 1; }

# ##########################################################################

clear

echo ""
echo -e "${CCYAN}          Script de désinstallation de Postfix, Dovecot et Rainloop${CEND}"
echo ""
echo -e "${CCYAN}
███╗   ███╗ ██████╗ ███╗   ██╗██████╗ ███████╗██████╗ ██╗███████╗   ███████╗██████╗
████╗ ████║██╔═══██╗████╗  ██║██╔══██╗██╔════╝██╔══██╗██║██╔════╝   ██╔════╝██╔══██╗
██╔████╔██║██║   ██║██╔██╗ ██║██║  ██║█████╗  ██║  ██║██║█████╗     █████╗  ██████╔╝
██║╚██╔╝██║██║   ██║██║╚██╗██║██║  ██║██╔══╝  ██║  ██║██║██╔══╝     ██╔══╝  ██╔══██╗
██║ ╚═╝ ██║╚██████╔╝██║ ╚████║██████╔╝███████╗██████╔╝██║███████╗██╗██║     ██║  ██║
╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚══════╝╚═════╝ ╚═╝╚══════╝╚═╝╚═╝     ╚═╝  ╚═╝

${CEND}"
echo ""

read -p "Appuyez sur [ENTRÉE] pour continuer ou faites CTRL+C pour annuler"

echo ""
echo -e "${CCYAN}-----------------------------${CEND}"
echo -e "${CCYAN}[  SUPPRESSION DES PAQUETS  ]${CEND}"
echo -e "${CCYAN}-----------------------------${CEND}"
echo ""

echo -e "${CGREEN}-> Désinstallation de Postfix, Dovecot et d'OpenDKIM ${CEND}"
echo ""
apt-get purge -y postfix postfix-mysql dovecot-core dovecot-imapd dovecot-lmtpd dovecot-mysql opendkim opendkim-tools opendmarc spamassassin spamc dovecot-sieve dovecot-managesieved
apt-get -y autoremove
apt-get -y clean

smallLoader
clear

echo -e "${CCYAN}-------------------------------------------------${CEND}"
echo -e "${CCYAN}[  SUPPRESSION DES FICHIERS/REPERTOIRES DIVERS  ]${CEND}"
echo -e "${CCYAN}-------------------------------------------------${CEND}"
echo ""

echo -e "${CGREEN}-> Suppression des fichiers et répertoires restants ${CEND}"
echo ""

echo -n "> /etc/postfix"
rm -rf /etc/postfix
echo -e " ${CGREEN}[OK]${CEND}"

echo -n "> /etc/dovecot"
rm -rf /etc/dovecot
echo -e " ${CGREEN}[OK]${CEND}"

echo -n "> /etc/opendkim.conf"
rm -rf /etc/opendkim.conf
echo -e " ${CGREEN}[OK]${CEND}"

echo -n "> /etc/opendmarc.conf"
rm -rf /etc/opendmarc.conf
echo -e " ${CGREEN}[OK]${CEND}"

echo -n "> /etc/default/opendkim"
rm -rf /etc/default/opendkim
echo -e " ${CGREEN}[OK]${CEND}"

echo -n "> /etc/opendkim"
rm -rf /etc/opendkim
echo -e " ${CGREEN}[OK]${CEND}"

echo -n "> /etc/spamassassin"
rm -rf /etc/spamassassin
echo -e " ${CGREEN}[OK]${CEND}"

echo -n "> /var/www/postfixadmin"
rm -rf /var/www/postfixadmin
echo -e " ${CGREEN}[OK]${CEND}"

echo -n "> /var/www/rainloop"
rm -rf /var/www/rainloop
echo -e " ${CGREEN}[OK]${CEND}"

echo -n "> /etc/nginx/sites-enabled/postfixadmin.conf"
rm -rf /etc/nginx/sites-enabled/postfixadmin.conf
echo -e " ${CGREEN}[OK]${CEND}"

echo -n "> /etc/nginx/sites-enabled/rainloop.conf"
rm -rf /etc/nginx/sites-enabled/rainloop.conf
echo -e " ${CGREEN}[OK]${CEND}"

echo -n "> Suppression des certificats SSL"
rm -rf /etc/ssl/certs/mailserver_ca.crt
rm -rf /etc/ssl/certs/mailserver_postfix.crt
rm -rf /etc/ssl/certs/mailserver_dovecot.crt
rm -rf /etc/ssl/certs/mailserver_nginx.crt
rm -rf /etc/ssl/private/mailserver_ca.key
rm -rf /etc/ssl/private/mailserver_postfix.key
rm -rf /etc/ssl/private/mailserver_dovecot.key
rm -rf /etc/ssl/private/mailserver_nginx.key
echo -e " ${CGREEN}[OK]${CEND}"

echo ""
echo -e "${CGREEN}-> Redémarrage de Nginx...${CEND}"
service nginx restart

smallLoader
clear

echo -e "${CCYAN}----------------------------------------------${CEND}"
echo -e "${CCYAN}[  SUPPRESSION DE LA BASE DE DONNÉE POSTFIX  ]${CEND}"
echo -e "${CCYAN}----------------------------------------------${CEND}"
echo ""

echo -e "${CRED}-------------------------------------------------------------------------------${CEND}"
echo -e "${CRED} /!\ ATTENTION : CETTE ACTION SUPPRIME TOUTES LES ADRESSES EMAILS ET ALIAS /!\ ${CEND}"
echo -e "${CRED}-------------------------------------------------------------------------------${CEND}"
echo ""

read -p "VOULEZ-VOUS VRAIMENT CONTINUER ? [Tapez OUI pour continuer] : " IMA_FIRIN_MAH_LAZOR

if [[ "$IMA_FIRIN_MAH_LAZOR" = "OUI" ]] || [[ "$IMA_FIRIN_MAH_LAZOR" = "oui" ]]; then

    echo ""
    echo -e "${CGREEN}------------------------------------------------------------------${CEND}"
    read -sp "> Veuillez saisir le mot de passe de l'utilisateur root de MySQL : " MYSQLPASSWD
    echo ""
    echo -e "${CGREEN}------------------------------------------------------------------${CEND}"
    echo ""

    SQLQUERY="GRANT USAGE ON *.* TO 'postfix'@'localhost'; \
              DROP USER 'postfix'@'localhost';"

    BDDEXIST=1

    until mysql -uroot -p$MYSQLPASSWD "postfix" -e "$SQLQUERY" &> /tmp/mysql-resp.tmp
    do
        fgrep -q "Unknown database" /tmp/mysql-resp.tmp

        # La base de donnée n'existe pas
        if [ $? -eq 0 ]; then
            BDDEXIST=0
            break
        fi

        # La base de donnée existe donc c'est le mot de passe qui n'est pas bon
        echo -e "${CRED}\n /!\ ERREUR: Mot de passe root incorrect \n ${CEND}" 1>&2
        read -sp "> Veuillez re-saisir le mot de passe : " MYSQLPASSWD
        echo ""
    done

    if [ $BDDEXIST -eq 1 ]; then
        echo ""
        echo -e "${CGREEN}-> Suppression de l'utilisateur Postfix ${CEND}"
        echo -e "${CGREEN}-> Suppression de la base de donnée Postfix ${CEND}"
        mysqladmin -f -uroot -p$MYSQLPASSWD drop postfix &> /dev/null
    else
        echo ""
        echo -e "${CCYAN}-> La base de donnée 'Postfix' n'existe pas, le script ${CEND}"
        echo -e "${CCYAN}-> d'installation n'a probablement pas eu le temps de ${CEND}"
        echo -e "${CCYAN}-> de la créer. ${CEND}"
    fi
fi
# IF IMA_FIRIN_MAH_LAZOR

# Reset de la variable de confirmation
# ----------------------------------------
IMA_FIRIN_MAH_LAZOR="VOUS NE PASSEREZ PAS !!! Gandalf !"
# ----------------------------------------

smallLoader
clear

echo -e "${CCYAN}-----------------------------------------------------${CEND}"
echo -e "${CCYAN}[  SUPPRESSION DE L'UTILISATEUR ET DU GROUPE VMAIL  ]${CEND}"
echo -e "${CCYAN}-----------------------------------------------------${CEND}"
echo ""

echo -e "${CRED}----------------------------------------------------------------------------------${CEND}"
echo -e "${CRED} /!\ ATTENTION : CETTE ACTION SUPPRIME TOUS LES EMAILS STOCKÉS SUR LE SERVEUR /!\ ${CEND}"
echo -e "${CRED}----------------------------------------------------------------------------------${CEND}"
echo ""

read -p "VOULEZ-VOUS VRAIMENT CONTINUER ? [Tapez OUI pour continuer] : " IMA_FIRIN_MAH_LAZOR

if [[ "$IMA_FIRIN_MAH_LAZOR" = "OUI" ]] || [[ "$IMA_FIRIN_MAH_LAZOR" = "oui" ]]; then

    echo ""
    echo -e "${CGREEN}-> Suppression du groupe et de l'utilisateur vmail ${CEND}"
    echo ""

    echo -n "> Suppression de l'utilisateur vmail UID[5000]"
    userdel -fr vmail &> /dev/null
    echo -e " ${CGREEN}[OK]${CEND}"

    echo -n "> Suppression du groupe vmail GID[5000]"
    groupdel vmail &> /dev/null
    echo -e " ${CGREEN}[OK]${CEND}"

else

    echo ""
    echo -e "${CGREEN}L'utilisateur${CEND} ${CCYAN}vmail${CEND} ${CGREEN}n'a pas été supprimé.${CEND}"
    echo -e "${CGREEN}Vous pouvez sauvegarder les mails stockés dans le${CEND}"
    echo -e "${CGREEN}répertoire${CEND} ${CCYAN}/var/mail${CEND} ${CGREEN}puis relancer le script${CEND}"
    echo -e "${CGREEN}de désinstallation.${CEND}"
    echo ""

fi
# IF IMA_FIRIN_MAH_LAZOR

smallLoader
clear

echo -e "${CGREEN}-------------------------------------------${CEND}"
echo -e "${CGREEN}[  DÉINSTALLATION EFFECTUÉE AVEC SUCCÈS ! ]${CEND}"
echo -e "${CGREEN}-------------------------------------------${CEND}"
echo ""

exit 0
