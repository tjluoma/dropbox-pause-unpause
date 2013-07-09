dropbox-pause-unpause
=====================

A shell script to programmatically "pause" and "un-pause" Dropbox on Mac OS X

## Disclaimer ##

Before I begin, let me make a few things clear: 

* There is no way to ***properly*** pause/un-pause the Dropbox Mac app via scripting. Doing so would select the Dropbox menu bar item and then the appropriate menu item. So far, no one has found a reliable way to do that. 

* My solution here has at least one significant problem that you should understand before you consider using it. See the 'Warning' section below.

* Dropbox on Linux has had a command-line tool for years, and Dropbox users have asked Dropbox, Inc. to make one for Mac (and even Windows) but so far it has fallen on deaf ears. *However,* I highly encourage you to vote for this feature at <https://www.dropbox.com/votebox/2713/command-line-interface>

## How to use this script ##

The script **`dropbox-pause-unpause.sh`** can be used in one of three ways:

1) If you want to see Dropbox.app's status, use:

		dropbox-pause-unpause.sh

2) If you want to 'pause' Dropbox, use:

		dropbox-pause-unpause.sh --pause

3) If you want to 'resume' Dropbox, use:

		dropbox-pause-unpause.sh --resume

## How it works (technical details) ##

Under the hood, **`dropbox-pause-unpause.sh`** is doing some very basic Unix-y things.

If you tell **`dropbox-pause-unpause.sh`** to pause Dropbox, it will send:

		kill -STOP <pid>

where `<pid>` is the process ID number for Dropbox.app. This will have the effect of "freezing" Dropbox.app so it will not consume any bandwidth or any CPU.

If you tell **`dropbox-pause-unpause.sh`** to resume/un-pause, the script will send:

		kill -CONT <pid>

which will tell Dropbox.app to resume its normal functionality.

If you try to pause Dropbox.app when it is not running, the script will not do anything (because the assumption is that the user intends to stop Dropbox from doing anything, which is its current state).

If you try to un-pause/resume Dropbox.app when it is not running, the script will launch Dropbox.app (because the assumption is that the user intends for Dropbox to be running regularly now).



## Warning ##

If you pause Dropbox.app, the menu bar icon will 'freeze' in its current state, which means that you will most likely see one of these icons (or the black-and-white equivalents) in the menu bar:
<img alt='[icon representing "Dropbox is busy"]' src="dropboxstatus-busy.tiff" width="18" height="18" border="0" />
<img alt='[icon representing "Dropbox is up to date"]' src="dropboxstatus-idle.tiff" width="18" height="18" border="0" />

However, Dropbox.app ***will not actually be busy or up-to-date.***

Ideally there would be a way to make Dropbox's menu bar look like this:
<img alt='[image]' src="dropboxstatus-pause.tiff" width="18" height="18" border="0" /> but I am not aware of any way to do that.

*Why is this a bad thing?* Because if you forget that you have paused Dropbox, you might glance at your menu bar and see <img alt='[icon representing "Dropbox is up to date"]' src="dropboxstatus-idle.tiff" width="18" height="18" border="0" /> and think "OK, my Dropbox is fully sync'd" when, in fact, it is not. Or you might see <img alt='[icon representing "Dropbox is busy"]' src="dropboxstatus-busy.tiff" width="18" height="18" border="0" /> and think Dropbox is actively syncing, when it is not.

### "Dropbox is Paused" reminders via `launchd`

I suggest running a `launchd` process to remind you when Dropbox is paused, so you don't forget.

1. Install [com.tjluoma.is-dropbox-paused.plist](com.tjluoma.is-dropbox-paused.plist) to **~/Library/LaunchAgents/**.

2. Install [is-dropbox-paused.sh](is-dropbox-paused.sh) somewhere in your `$PATH`

If you're on Mountain Lion, you might want to install [terminal-notifier-dropbox](http://files.tjluoma.com/terminal-notifier-dropbox.zip). Otherwise the notifications will be sent via [Growl] and [growlnotify] -- assuming they are installed, otherwise the notifications will not be visible, which would be rather pointless.

By default, **`is-dropbox-paused.sh`** will run every 15 minutes (900 seconds) but you can change that by editing this part of **`com.tjluoma.is-dropbox-paused.plist`**:

		<key>StartInterval</key>
		<integer>900</integer>

Change '900' to however many seconds you want to elapse between checks.

Note that **`is-dropbox-paused.sh`** is intentionally designed to exit very quickly if Dropbox is *not* paused, so it should have a negligible effect on your Mac. However, **`dropbox-pause-unpause.sh`** is designed to automatically load **`com.tjluoma.is-dropbox-paused.plist`** when Dropbox is paused and unload it when it is un-paused, so it will not be running unless you have paused Dropbox.

[growlnotify]: http://growl.info/downloads
[Growl]: http://growl.info

