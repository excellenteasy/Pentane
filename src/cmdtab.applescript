property timeDelay : 1

on run
	runCode()
end run

on idle
	tell application "System Events"
		set frontProcess to name of first process whose frontmost is true
		set appFileName to name of (info for (path to me))
		if appFileName starts with frontProcess then my runCode()
	end tell
	return timeDelay
end idle

on runCode()
	set UrlFilePath to POSIX path of (path to me) & "Contents/Resources/url.applescript"
	try
		set srcFile to load script UrlFilePath
		set theUrl to (theUrl of srcFile)
		loopThruChrome(theUrl)
	on error
		display dialog "Please provide the url of your webapp" default answer "http://keeplook.in"
		set theAnswer to (text returned of result)
		script UrlFile
			property theUrl : theAnswer
		end script
		store script UrlFile in UrlFilePath
		loopThruChrome(theAnswer)
	end try
end runCode

on loopThruChrome(input)
	tell application "Google Chrome"
		activate
		
		if (count every window) = 0 then
			make new window
		end if
		
		set found to false
		set theTabIndex to -1
		repeat with theWindow in every window
			set theTabIndex to 0
			repeat with theTab in every tab of theWindow
				set theTabIndex to theTabIndex + 1
				if theTab's URL contains input then
					set found to true
					exit repeat
				end if
			end repeat
			
			if found then
				set active tab index of theWindow to theTabIndex
				exit repeat
			end if
		end repeat
		
		if not found then
			set currentClip to get the clipboard
			set the clipboard to (input as text)
			tell application "System Events"
				keystroke "t" using command down
				keystroke "v" using command down
				keystroke return
			end tell
		end if
	end tell
end loopThruChrome