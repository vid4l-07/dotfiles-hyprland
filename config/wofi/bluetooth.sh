#!/bin/bash
# Para que un dispositivo se conecte automaticamente tiene que estar en trusted devices y pairable tiene que estar en on (settings)
# Creo que para que detecte mejor los dispositivos viene bien tener el pairable on
# Dicoberable hace que otros dispositivos se puedan conectar al ordenador

function status (){
	bluetoothctl show | grep -w $1 | awk '{print $2}'
}

function changeStat(){
	if [ $1 == 'yes' ];then
		echo 'on'
	else
		echo 'off'
	fi
}

function togglePower(){
	if [ $powerStatus == 'on' ];then
		bluetoothctl power off > /dev/null
	else
		bluetoothctl power on > /dev/null
	fi
}

function toggleDisc(){
	if [ $discStatus == 'on' ];then
		bluetoothctl discoverable off > /dev/null
	else
		bluetoothctl discoverable on > /dev/null
	fi
}

function togglePair(){
	if [ $pairStatus == 'on' ];then
		bluetoothctl pairable off > /dev/null
	else
		bluetoothctl pairable on > /dev/null
	fi
}

function settings(){

while true;do
	powerStatus=$(status 'PowerState')
	powerOption="Power ($powerStatus)"
	discStatus=$(changeStat $(status 'Discoverable'))
	discOption="Discoverable ($discStatus)"
	pairStatus=$(changeStat $(status 'Pairable'))
	pairOption="Pairable ($pairStatus)"
	eleccion=$(echo -e "$powerOption\n$discOption\n$pairOption" | wofi -dmen)
	case "$eleccion" in
		$powerOption)
			togglePower 
			;;
		$discOption)
			toggleDisc 
			;;
		$pairOption)
			togglePair
			;;
		*)
			break 
			;;
	esac
done
}

function disconnect(){
	local tmpfile=$(mktemp)
	bluetoothctl devices Connected > $tmpfile
	eleccion=$(/bin/cat $tmpfile | awk '{for (i=3; i<=NF; i++) printf "%s ", $i; print ""}' | wofi -dmen)
	eleccion="${eleccion%" "}"
	mac=$(grep "$eleccion" $tmpfile | awk '{print $2}')
	bluetoothctl disconnect $mac > /dev/null &
}

function connect(){
	local tmpfile=$(mktemp)

	notify-send -t 7000 'Bluetooth' 'Escaneando dispositivos...'
	bluetoothctl --timeout 7 scan on | grep 'NEW' > $tmpfile

	eleccion=$(/bin/cat $tmpfile | awk '{for (i=4; i<=NF; i++) printf "%s ", $i; print ""}' | grep -vE '([0-9A-F]{2}[:-]){5}[0-9A-F]{2}' | wofi -dmen)
	eleccion="${eleccion%" "}"

	mac=$(grep "$eleccion" $tmpfile | awk '{print $3}')

	if ! [[ -z $eleccion ]];then
		trusopt='Trust'
		notrustopt='Dont trust'
		trust=$(echo -e "$trusopt\n$notrustopt" | wofi -dmen)

		if [ $trust == $trusopt ];then
				bluetoothctl trust $mac > /dev/null
		elif [ $trust == $notrustopt ];then
				bluetoothctl untrust $mac > /dev/null
		fi

		if ! bluetoothctl devices Paired | grep -q $mac;then
				bluetoothctl pair $mac > /dev/null
		fi
		bluetoothctl connect $mac > /dev/null
	fi
}

function pairedDevices(){
	local tmpfile=$(mktemp)

	bluetoothctl devices Paired > $tmpfile

	eleccion=$(/bin/cat $tmpfile | awk '{for (i=3; i<=NF; i++) printf "%s ", $i; print ""}' | grep -vE '([0-9A-F]{2}[:-]){5}[0-9A-F]{2}' | wofi -dmen)
	eleccion="${eleccion%" "}"

	mac=$(grep "$eleccion" $tmpfile | awk '{print $2}')

	if ! [[ -z $eleccion ]];then
		connectOpt='Conectar'
		unpairOpt='Olvidar dispositivo'

		action=$(echo -e "$connectOpt\n$unpairOpt" | wofi -dmen)
		if [ $action == $connectOpt ];then
				bluetoothctl connect $mac > /dev/null
		elif [ $action == $unpairOpt ];then
				bluetoothctl remove $mac > /dev/null
		fi
	fi

}


function trustedDevices(){
	local tmpfile=$(mktemp)

	bluetoothctl devices Trusted > $tmpfile

	eleccion=$(/bin/cat $tmpfile | awk '{for (i=3; i<=NF; i++) printf "%s ", $i; print ""}' | grep -vE '([0-9A-F]{2}[:-]){5}[0-9A-F]{2}' | wofi -dmen)
	eleccion="${eleccion%" "}"

	mac=$(grep "$eleccion" $tmpfile | awk '{print $2}')

	forwardOpt='Olvidar'
	exitOpt='Salir'

	if ! [[ -z $eleccion ]];then
		action=$(echo -e "$forwardOpt\n$exitOpt" | wofi -dmen)
		if [ $action == $forwardOpt ];then
				bluetoothctl untrust $mac > /dev/null
		fi
	fi
}


while true;do
	disconnectOption="Deconectar un dispositivo"
	connectOption="Conectar un dispositivo"
	pairdevsOption="Dispositivos emparejados"
	trustedOption="Dispositivos confiables"
	settingsOption="Cofiguracion"

	eleccion=$(echo -e "$settingsOption\n$connectOption\n$disconnectOption\n$pairdevsOption\n$trustedOption" | wofi -dmen)
	case "$eleccion" in
		$settingsOption)
			settings 
			;;
		$disconnectOption)
			disconnect 
			;;
		$connectOption)
			connect 
			;;
		$pairdevsOption)
			pairedDevices
			;;
		$trustedOption)
			trustedDevices
			;;
		*)
			break 
			;;
	esac
done
