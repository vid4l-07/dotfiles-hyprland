WAYBAR_HEIGHT=32
CHECK_INTERVAL=0.2
HIDE_AFTER=3


hide_waybar() {
	kill $(pgrep -a waybar | grep volume | awk '{print $1}')
}

while ! [[ -z $(pgrep -a waybar | grep volume | awk '{print $1}') ]]; do
	last_interaction="$(/bin/cat /home/hvidal/.config/waybar/volume/interaction.txt)"

	now=$(date +%s)

	if [ $((now - last_interaction)) -ge $HIDE_AFTER ]; then
		hide_waybar
	fi

	sleep $CHECK_INTERVAL
done

