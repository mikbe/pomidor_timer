# Pomidor Timer #

A simple timer for use in <a href="http://pomodorotechnique.com">The Pomodoro Technique®</a>, a time management system. 

One of the great things about <a href="http://pomodorotechnique.com">The Pomodoro Technique®</a> all the resources needed to use the system are free!  You can download the book and worksheets as PDFs and if you want to support them you can buy stuff from them. That's a great company. 

## Requirements ##

OS X 10.6 to run it
Xcode 4.0.1 to build it

## Instructions ##

**Timer Tab:**
Press `Start` button to start the timer.  
The start button turns into a pause button that allows you to pause a work or break period.

Press `>>` (fast forward) to finish the break/work period immediatly.  
This can be useful if you paused a break or work period and forgot to restart the timer.

Press `Reset` to reset work/break cycle.  
This does not reset user configured options.  
This will also quite any alarms.  

**Options Tab:**
Short break in minutes:   
After every work period, execpt every fourth one, the timer will be set to this number of minutes. The default is 5 minutes.

Long break in minutes:  
After every forth work period the timer will be set to this value. The default is 15 minutes.

Tick volume:  
How loud the timer will tick every second.

Alarm volume:  
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


## Change History ##

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
