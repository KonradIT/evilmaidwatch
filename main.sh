# Evil Maid Watch

# Evil Maid Watch
# Args:
#	-l = watch lid state
#	-u = watch USB state
#	-s = silent

function push_message(){
	if [[ -f $HOME/.PBtoken ]];
		then
			PBtoken=`cat ~/.PBtoken`
			PBDeviceID=`cat ~/.PBDeviceID`
			curl -s --silent -q -u $PBtoken: -X POST https://api.pushbullet.com/v2/pushes --header 'Content-Type: application/json' --data-binary '{"type": "note", "title":"'"USB inserted"'","body":"'"$(date)"'", "source_device_iden":"'"$PBMissileID"'"}';
		else
			echo -ne "Enter the Pushbullet Access Token, get yours here: https://www.pushbullet.com/account  "
			read NewPBtoken
			echo $NewPBtoken > ~/.PBtoken;
			PBtoken=`cat ~/.PBtoken`;
			PBDeviceID=`curl -u $PBtoken: -X POST https://api.pushbullet.com/v2/devices -d nickname=EvilMaidWatch -d type=stream | sed 's/"iden":"/\n/g' | sed 's/","created/\ncreated/g' | sed -n 2p`;
			echo $PBDeviceID > ~/.PBDeviceID;
			echo "Access token set up correctly"
	fi
}

old=$(lsusb)
sleep 1
while true
	do
	new_usb=$(diff <(echo "$old") <(lsusb))
	if [[ $new_usb != "" ]];
		then
			old=$(lsusb)
				if [[ $1 == "-u" ]] || [[ $2 == "-u" ]] || [[ $3 == "-u" ]]
					then
						if [[ $1 == "-s" ]] || [[ $2 == "-s" ]] || [[ $3 == "-s" ]]
						then
							push_message
							#add other commands here (eg: poweroff)
						else
							push_message
							notify-send "USB inserted!"
							#add other commands here (eg: poweroff)
						fi
				fi
	fi
done
