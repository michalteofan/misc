# info o sieci rhel z nm

LOGFILE=/tmp/`basename $0`.log
echo "--------------------------------------------------" | tee -a $LOGFILE
echo "$0 execustion started at `date`" | tee -a $LOGFILE
echo | tee -a $LOGFILE
echo "Current network configuration:" | tee -a $LOGFILE

nmcli connection | tee -a $LOGFILE
ip -4 a | tee -a $LOGFILE
ifconfig -a | tee -a $LOGFILE
ip route | tee -a $LOGFILE
netstat -s | tee -a $LOGFILE
netstat -i | tee -a $LOGFILE

CONNAMES=$(nmcli connection show | grep -vw NAME | awk '{print $1}')
for CONNAME in $CONNAMES; do
    echo $CONNAME | tee -a $LOGFILE
	nmcli connection show $CONNAME | tee -a $LOGFILE
done

INTNAMES=$(nmcli connection show | grep -vw NAME | awk '{print $4}' | grep -vw "\-\-")
for INTNAME in $INTNAMES; do
	echo $INTNAME | tee -a $LOGFILE
	ethtool $INTNAME | tee -a $LOGFILE
	ethtool -i $INTNAME | tee -a $LOGFILE
	ethtool -S $INTNAME | tee -a $LOGFILE
	ethtool -k $INTNAME | tee -a $LOGFILE
done

TEAMNAMES=$(nmcli connection show | grep -i team | awk '{print $4}')
for TEAMNAME in $TEAMNAMES; do
    echo $TEAMNAME | tee -a $LOGFILE
	teamdctl $TEAMNAME state view -v | tee -a $LOGFILE
done
