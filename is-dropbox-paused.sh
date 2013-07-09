#!/usr/bin/env zsh -f
# Show a Growl alert if Dropbox has been paused using `kill -STOP`
#
# From:	Timothy J. Luoma
# Mail:	luomat at gmail dot com
# Date:	2013-07-08

DB_STATUS=$(ps cx | awk -F' ' '/ Dropbox$/{print $3}')

case "$DB_STATUS" in
	T)
				# Dropbox is paused
				:
	;;

	*)
				exit 0
	;;
esac

NAME="$0:t:r"

TERMINAL_NOTIFIER='/Applications/terminal-notifier-dropbox.app/Contents/MacOS/terminal-notifier-dropbox'

if [[ -x "$TERMINAL_NOTIFIER" ]]
then
	if (( $+commands[dropbox-pause-unpause.sh] ))
	then
			# if 'dropbox-pause-unpause.sh' exists, offer to use it

			###
			${TERMINAL_NOTIFIER} -group ALL -title "Reminder: Dropbox is paused." -message "Click to resume." -remove "$NAME" -execute "dropbox-pause-unpause.sh --resume"
			###
	else
			PID=$(ps cx | awk -F' ' '/ Dropbox$/{print $1}')

			###
			${TERMINAL_NOTIFIER} -group ALL -title "Reminder: Dropbox is paused." -message "\`kill -CONT $PID\` to continue" -remove "$NAME"
			###
	fi

else
		# if growlnotify command is found and if Growl is running,
	if (( $+commands[growlnotify])) && { ps cx | egrep -q ' Growl$' || open -a Growl }
	then

			growlnotify \
				--appIcon "Dropbox" \
				--identifier "$NAME" \
				--message "Reminder: Dropbox is paused (kill -STOP)" \
				--title "$NAME"
	fi

fi


exit
#
#EOF
