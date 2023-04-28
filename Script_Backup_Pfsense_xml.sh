#!/bin/sh
# Author: Mr Xhark -> @xhark
# License : Creative Commons http://creativecommons.org/licenses/by-nd/4.0/deed.fr
# Website : https://blogmotion.fr/systeme/script-backup-pfsense-configuration-16496
# backup pfsense from v2.2.6 to v2.6 and more (https://docs.netgate.com/pfsense/en/latest/backup/remote-backup.html)
# Modificado por Lucas Tavares Soares - 27-04-2023
# e-Mail: lucastavarestga@gmail.com

VERSION="2022.08.18_cURL-multi"
RUNDIR="$( cd "$( dirname "$0" )" && pwd )"

CHMOD=`which chmod`
CAT=`which cat`
CUT=`which cut`
ECHO=`which echo`
AWK=`which awk`
MKDIR=`which mkdir`

##############################
######### VARIABLES  #########

# pfSense host OR IP (note: do not include the final /, otherwise backup will fail)
LISTE_SRV="
https://200.200.200.2:2017
https://201.201.201.2:10443
http://202.202.202.2
"

# login - password

PFSENSE_USER='backup'
PFSENSE_PASS='Backup_2022_SalvaVidas_777947832jxFqLpq'

# data
TODAY=`date +%Y%m%d`

# where to store backups
BACKUP_DIR="${RUNDIR}/conf_backup/cliente1/${TODAY}"

######## END VARIABLES ########
##############################

######################################### NE RIEN TOUCHER SOUS CETTE LIGNE #########################################

echo
echo "*** pfMotion-backup script by @xhark and lucastavarestga@gmail.com (v${VERSION}) ***"
echo

curl -V $i >/dev/null 2>&1 || { echo "ERROR : cURL MUST be installed to run this script."; exit 1; }

for PFSENSE_HOST in $LISTE_SRV
        do

        # variables
        COOKIE_FILE="`mktemp /tmp/pfsbck.XXXXXXXX`"
        CSRF1_TOKEN="`mktemp /tmp/csrf1.XXXXXXXX`"
        CSRF2_TOKEN="`mktemp /tmp/csrf2.XXXXXXXX`"
        CONFIG_TMP="`mktemp /tmp/config-tmp-xml.XXXXXXXX`"
        NOW=`date +%Y%m%d%H%M%S`

        unset RRD PKG PW

        if [ "$BACKUP_RRD" = "0" ] ;     then RRD="&donotbackuprrd=yes" ; fi
        if [ "$BACKUP_PKGINFO" = "0" ] ; then PKG="&nopackages=yes" ; fi
        if [ -n "$BACKUP_PASSWORD" ] ;   then PW="&encrypt_password=$BACKUP_PASSWORD&encrypt_passconf=$BACKUP_PASSWORD&encrypt=on" ; fi

        mkdir -p "$BACKUP_DIR"

        # fetch login
        curl -Ss --noproxy '*' --insecure --cookie-jar $COOKIE_FILE "$PFSENSE_HOST/diag_backup.php" \
          | grep "name='__csrf_magic'" | sed 's/.*value="\(.*\)".*/\1/' > $CSRF1_TOKEN \
          || echo "ERROR: FETCH"

        # submit the login
        curl -Ss --noproxy '*' --insecure --location --cookie-jar $COOKIE_FILE --cookie $COOKIE_FILE \
          --data "login=Login&usernamefld=${PFSENSE_USER}&passwordfld=${PFSENSE_PASS}&__csrf_magic=$(cat $CSRF1_TOKEN)" \
         "$PFSENSE_HOST/diag_backup.php"  | grep "name='__csrf_magic'" \
          | sed 's/.*value="\(.*\)".*/\1/' > $CSRF2_TOKEN \
          || echo "ERROR: SUBMIT THE LOGIN"

        # submit download to save config xml
        curl -Ss --noproxy '*' --insecure --cookie-jar $COOKIE_FILE --cookie $COOKIE_FILE \
          --data "Submit=download&download=download&donotbackuprrd=yes&__csrf_magic=$(head -n 1 $CSRF2_TOKEN)" \
          "$PFSENSE_HOST/diag_backup.php" > $CONFIG_TMP \
          || echo "ERROR: SAVING XML FILE"

        # check if credentials are valid
        if grep -qi 'username or password' $CONFIG_TMP; then
                        echo ; echo "   !!! AUTHENTICATION ERROR (${PFSENSE_HOST}): PLEASE CHECK LOGIN AND PASSWORD"; echo
                        rm -f $CONFIG_TMP
                        continue
        fi

        # xml file contains doctype when the URL is wrong
        if grep -qi 'doctype html' $CONFIG_TMP; then
                echo ; echo "   !!! URL ERROR (${PFSENSE_HOST}): HTTP OR HTTPS ?"; echo
                rm -f $CONFIG_TMP
                continue
        fi

        hostname=$(grep -m1 '<hostname' $CONFIG_TMP | cut -f2 -d">"|cut -f1 -d"<")
        domain=$(grep -m1 '<domain' $CONFIG_TMP | cut -f2 -d">"|cut -f1 -d"<")
        ip_hosts=$($ECHO $PFSENSE_HOST | $AWK -F '/' '{print $3}' | $AWK -F ':' '{print $1}')
        backup_file="bkp-pfw-${ip_hosts}-${hostname}_${domain}-${NOW}.xml"

        # definitive config file name
        mv $CONFIG_TMP "$BACKUP_DIR/$backup_file" && echo "Backup OK : $BACKUP_DIR/$backup_file" || echo "Backup NOK !!! ERROR !!!"

        # cleaning tmp and cookie files
        rm -f "$COOKIE_FILE" "$CSRF1_TOKEN" "$CSRF2_TOKEN"

done

$CHMOD -R 777 $BACKUP_DIR

echo
exit 0
