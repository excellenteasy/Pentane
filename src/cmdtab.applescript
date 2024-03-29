property detectedBrowser : "com.google.chrome"
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
	set myPath to POSIX path of (path to me) & "Contents/Resources/"
	set detectedBrowser to do shell script myPath & "defbrowser"
	
	set UrlFilePath to myPath & "url.applescript"
	try
		set srcFile to load script UrlFilePath
		set theUrl to (theUrl of srcFile)
		loopThruChrome(theUrl)
	on error
		try
			display dialog "Please provide the url of your webapp" default answer "keeplook.in"
			set theAnswer to (text returned of result)
			script UrlFile
				property theUrl : theAnswer
			end script
			store script UrlFile in UrlFilePath
			loopThruChrome(theAnswer)
		on error
			quit
		end try
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
			if input starts with "http" then
				tell window 1 to make new tab with properties {URL:input}
			else
				tell window 1 to make new tab with properties {URL:"http://" & input}
			end if
		end if
	end tell
end loopThruChrome