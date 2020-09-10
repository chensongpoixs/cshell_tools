#!/bin/bash
#
#     记录ssh服务登录   cmd   interact
#
#
#
#
#

#!/usr/bin/expect -f
#set timeout 30
#trap {
#    set rows [stty rows]
#    set cols [stty columns]
#    stty rows $rows columns $cols < $spawn_out(slave,name)
#} WINCH
#spawn ssh -p22 -l killer 192.168.1.82
#expect "password:"
#send   killer\r
#interact
AUTO_SSH_CONFIG=`cat ~/.autosshrc`
BORDER_LINE="\033[1;31m############################################################ \033[0m"
echo -e $BORDER_LINE
echo -e "\033[1;31m#                     [AUTO SSH]                           # \033[0m"
echo -e "\033[1;31m#                                                          # \033[0m"
echo -e "\033[1;31m#                                                          # \033[0m"
i=0;

if [ "$AUTO_SSH_CONFIG" == "" ]; then
	echo -e "\033[1;31m#              Config(~/.autosshrc) Not Found              # \033[0m";
	echo -e "\033[1;31m#                                                          # \033[0m"
	echo -e "\033[1;31m#                                                          # \033[0m"
	echo -e $BORDER_LINE
else
	for server in $AUTO_SSH_CONFIG; do
		i=`expr $i + 1`
		SERVER=`echo $server | awk -F\| '{ print $1 }'`
		IP=`echo $server | awk -F\| '{ print $2 }'`
		NAME=`echo $server | awk -F\| '{ print $3 }'`
		LINE="\033[1;31m#"\ [$i]\ $SERVER\ -\ $IP':'$NAME
		MAX_LINE_LENGTH=`expr ${#BORDER_LINE}`
		CURRENT_LINE_LENGTH=`expr "${#LINE}"`
		DIS_LINE_LENGTH=`expr $MAX_LINE_LENGTH - $CURRENT_LINE_LENGTH - 9`
		echo -e $LINE"\c"
		for n in $(seq $DIS_LINE_LENGTH);
		do
		    echo -e " \c"
		done
		echo -e "# \033[0m"
	done
	echo -e "\033[1;31m#                                                          # \033[0m"
	echo -e "\033[1;31m#                                                          # \033[0m"
	echo -e $BORDER_LINE

	# GET INPUT CHOSEN OR GET PARAM
	if [ "$1" != "" ]; then
	    no=$1
	else
	    no=0
	    until [ $no -gt 0 -a $no -le $i ] 2>/dev/null
	    do
	        echo -e 'Server Number:\c'
	        read no
	    done
	fi
fi

i=0
for server in $AUTO_SSH_CONFIG; do
	i=`expr $i + 1`
	if [ $i -eq $no ] ; then
		IP=`echo $server | awk -F\| '{ print $2 }'`
		NAME=`echo $server | awk -F\| '{ print $3 }'`
		PASS=`echo $server | awk -F\| '{ print $4 }'`
		PORT=`echo $server | awk -F\| '{ print $5 }'`
		ISBASTION=`echo $server | awk -F\| '{ print $6 }'`
		FILE='/tmp/.login.sh'
		if [ "$PORT" == "" ]; then
			PORT=10022
		fi
        	echo '#!/usr/bin/expect -f' > $FILE
        	echo 'set timeout 30' >> $FILE
			echo 'trap {' >> $FILE
            echo '    set rows [stty rows]' >> $FILE
            echo '    set cols [stty columns]' >> $FILE
            echo '    stty rows $rows columns $cols < $spawn_out(slave,name)' >> $FILE
            echo '} WINCH' >> $FILE
        	echo "spawn ssh -p$PORT -l "$NAME $IP >> $FILE
        	if [ "$PASS" != "" ]; then
	        	echo 'expect "password:"' >> $FILE
	        	echo 'send   '$PASS"\r" >> $FILE
				if [ "$2" == 'sudo' ]; then
					echo 'expect "@"' >> $FILE
					echo 'send   "sudo su\r"' >> $FILE
					echo 'expect "password for"' >> $FILE
					echo 'send   '$PASS"\r" >> $FILE
				else
					if [ "$ISBASTION" == 1 ] && [ "$2" != "" ]; then
		        			echo 'expect ">"' >> $FILE
		        			echo 'send   '$2"\r" >> $FILE
		        			echo 'expect "password:"' >> $FILE
		        			echo 'send   '$PASS"\r" >> $FILE
							if [ "$3" == 'sudo' ]; then
								echo 'expect "@"' >> $FILE
								echo 'send   "sudo su\r"' >> $FILE
								echo 'expect "password for"' >> $FILE
								echo 'send   '$PASS"\r" >> $FILE
							fi
					fi
				fi
			fi
        	echo 'interact' >> $FILE
		chmod a+x $FILE
		$FILE
		echo '' > $FILE
		break;
	fi
done


