# Pomidor Timer #

A simple timer for use in <a href="http://pomodorotechnique.com">The Pomodoro Technique&reg;</a>, a time management system.  

One of the great things about <a href="http://pomodorotechnique.com">The Pomodoro Technique&reg;</a> all the resources needed to use the system are free!  You can download the book and worksheets as PDFs and if you want to support them you can buy stuff from them. That's a great company.  

## Requirements ##

OS X 10.6 to run it  
Xcode 4.0 to build it  

## Instructions ##

###Timer Tab:###  

![Timer tab](https://github.com/mikbe/pomidor_timer/raw/master/image%20resources/TimerTab.png)  

**Start Button**  
Press `Start` button to start the timer.  
The start button turns into a pause button that allows you to pause a work or break period.  

**\>\> Button**  
Press `>>` (fast forward) to finish the break/work period immediatly.  
This can be useful if you paused a break or work period and forgot to restart the timer.  

**Reset Button**  
Press `Reset` to reset work/break cycle.  
This does not reset user configured options.  
This will also quite any alarms.  

###Options Tab:###  

![Options tab](https://github.com/mikbe/pomidor_timer/raw/master/image%20resources/OptionsTab.png)  

**Work period in minutes:**  
How long each work period should be. The default matches The Pomidor Technique&reg; time of 25 minutes but you can change it to whatever time you use.  For instance when I'm programming I've found my personal work period is better at 35 minutes as this causes fewer breaks when I'm 'in the zone' but is short enough to catch me when I need a mental break.  

**Short break in minutes:**  
After every work period, execpt every fourth one, the timer will be set to this number of minutes. The default is 5 minutes.  

**Long break in minutes:**  
After every forth work period the timer will be set to this value. The default is 15 minutes.  

**Tick volume:**  
How loud the timer will tick every second.  

**Alarm volume:**  
How loud the alarm will be at the end of each work/break cycle.  


## What does "Pomidor" mean? ##

Pomidor is Polish for tomato. It's a play on the Italian word for tomato, pomodoro, so I don't have to worry about trademark/copyright infringment.  

## Why is it free? ##

They provide the resources for free so I thought I'd provide this simple timer for free.   

There are applications that cost money and do more but I wanted to do one thing and do it well; be a timer.

## Can I sell it and make billions? ##

No. <span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">Pomidor Timer</span> by <a xmlns:cc="http://creativecommons.org/ns#" href="http://mikbe.tk" property="cc:attributionName" rel="cc:attributionURL">Mike Bethany</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/">Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License</a>.<br />Based on a work at <a xmlns:dct="http://purl.org/dc/terms/" href="https://github.com/mikbe/pomidor_timer" rel="dct:source">github.com</a>.  

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-sa/3.0/88x31.png" /></a>  
Copyright© 2011 Mike Bethany - http://mikbe.tk  


## Attributions ##

Tomato icon is Copyright© 2011 <a href="http://www.artbees.net" target="new">Artbees</a>  
Licensed under Creative Commons <a href="http://creativecommons.org/licenses/by-nc-nd/3.0/" target="new">Attribution-NonCommercial-NoDerivs 3.0</a>  
Part of the beautiful <a href="http://www.artbees.net/paradise-fruits-icon-set" target="new">Paradise Fruits Icon Set</a>  

## To do ##


**future releases**

* Automatic, but simple, logging of actions so you can just do your work then later use the log for reference when entering data in your worksheet.
* Add sound selection from default system sounds? Running out of space on options tab.
* Make minute entry not show blue border when entering text.
* Add help me file.
* Clean up main menu.

**Non-application tasks**

* Add screenshots to webpage.
* Make webpage less ugly.

## Change History ##

**2011.05.22** Version: 1.0.4

Added Features:

* Work period configurable.
* Added tick and alarm sounds mute button.
* Added visual alarm indicators. (Useful for the hearing impared, colorblind should be able to see a pulsing difference in intensity).
* Automatically shows and focuses Pomidor timer when the alarm goes off. (I'm not sure I like this one but not sure if it should be an option.)

Fixes:

* None (it's perfect right?)

Misc:

* Removed minimize button. It didn't really have any purpose.
* Refactored fade animation to use proper methodologies.
* Refactored form hiding.
* General code cleanup.
* Changed fast forward tooltip to use interface standard. (I liked mine but it was too much outside the norm).
* Now with 100% less rapture.

**2011.05.19** Version: 1.0.3 (internal code release)

Added Features:  

* Growl alerts for alarms (requires Growl installed of course).  
* Added mute active alarm button.  
* When an alarm goes off the dock icon bounces if Pomidor Timer is not the front app (standard Apple design).  
* Fastforward popup description added.

Fixes:  

* Window does not hide when it was mearly inactive. It just becomes visible. This stops the annoying hiding of the window when you just wanted to view it.

**2011.04.28** Version: 1.0.2  

Fixed bugs:

* Missing font
* Window disappeared forever if you pressed icon or menu display too fast.

**2011.04.28** Version: 1.0.1  

* Changed tick sound to actual clock tick.
* Changed alarm sound to avoid confusion with message alerts.
* Added click show/hide ability to status bar and dock icon.
* Refactored sound controller (cleaned up some premature optimization).
* Changed version numbering to Major.Minor.Build because it's better.

Fixed bugs:  

* Sound volumes loaded after saved user settings.



2011.04.27 Version 1.0
Initial release
