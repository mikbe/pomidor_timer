# Pomidor Timer #

A simple work/break timer for use in your favorite time management system, e.g. [The Pomodoro Technique&reg;](http://pomodorotechnique.com).

You start the timer and start working. It keeps track of your work periods and your work cycle so you can concentrate on working; not wasting time with worksheets or losing scraps of paper with tick marks on them.

## Requirements ##

OS X 10.6 to run it  
Xcode 4.0 to build it  

## Installation Instructions ##

Download and unzip the precompiled dmg file:  
[PomidorTimer-1.0.4.dmg.zip](https://github.com/mikbe/pomidor_timer/blob/master/installs/PomidorTimer-1.0.4.dmg.zip?raw=true)  

Open the dmg file and drag the Pomidor Timer onto the Applications shortcut.  

Look in your Applications folder and you'll see the app.  

## Usage Instructions ##

The use of the app is, hopefully, very intuitive so should work how you would expect it to.

### Timer Tab ###

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

### Options Tab ###

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

**Mute/Unmute sounds**  
This will turn off or on the tick and alarm sounds. Buttons will still make a sound when clicked.  

## Timer display ##

The countdown time is displayed on the timer tab but also on the menu bar. You can click on the menu bar timer to bring the app forward or hide it.

![menu bar](https://github.com/mikbe/pomidor_timer/raw/master/image%20resources/MenuBar-Example.png)


## Alarms ##

When the alarm goes off the timer will bring make itself the app active pulsing from grey to red:
![timer tab alarm](https://github.com/mikbe/pomidor_timer/raw/master/image%20resources/TimerAlarm-Animation.gif)

The menubar display will also flash an alarm:

![menu bar alarm](https://github.com/mikbe/pomidor_timer/raw/master/image%20resources/MenuBarAlarm-Animation.gif)

If you have [Growl](http://growl.info/) installed it will also send a Growl alert.
![growl alarm](https://github.com/mikbe/pomidor_timer/raw/master/image%20resources/GrowlAlarm.png)  

To silence the alarm without starting the next work/break period you can click in the dark grey area where it says "mute alarm", click the menu bar, or the click the application icon in the dock. Clicking on the menu bar or the app icon will hide the app as usual but of course won't start the next period.

## What does "Pomidor" mean? ##

Pomidor is Polish for tomato. It's a play on the Italian word for tomato, pomodoro, so I don't have to worry about trademark/copyright infringment.  

## Why is it free? ##

They provide the resources for free so I thought I'd provide this simple timer for free.   

There are applications that cost money and do more but I wanted to do one thing and do it well; be a timer.

## Can I sell it and make billions? ##

No.<br>
<br>
<span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">Pomidor Timer</span> by <a xmlns:cc="http://creativecommons.org/ns#" href="http://mikbe.tk" property="cc:attributionName" rel="cc:attributionURL">Mike Bethany</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/">Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License</a>.<br />Based on a work at <a xmlns:dct="http://purl.org/dc/terms/" href="https://github.com/mikbe/pomidor_timer" rel="dct:source">github.com</a>.  

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-sa/3.0/88x31.png" /></a>  
Copyright© 2011 Mike Bethany - http://mikbe.tk  

## The Pomodoro Technique&reg; ##

One of the great things about [The Pomodoro Technique&reg;](http://pomodorotechnique.com) company is all the resources needed to use the system are available for free! You can download the book and worksheets as PDFs and if you really like the system you can support them by purchasing their stuff; that's a great company.  


## Attributions ##

This product is not approved or endorsed by the Pomodoro Team or [Francesco Cirillo](http://francescocirillo.com).   
[The Pomodoro Technique&reg;](http://pomodorotechnique.com) is a registered trademark belonging to Francesco Cirillo.  

Tomato icon is Copyright© 2011 <a href="http://www.artbees.net" target="new">Artbees</a>  
Licensed under Creative Commons <a href="http://creativecommons.org/licenses/by-nc-nd/3.0/" target="new">Attribution-NonCommercial-NoDerivs 3.0</a>  
The tomato icon is part of the beautiful <a href="http://www.artbees.net/paradise-fruits-icon-set" target="new">Paradise Fruits Icon Set</a>  

## To do ##

**future release**

* Automatic, but simple, logging of actions so you can just do your work then later use the log for reference when entering data in your worksheet. There will be no integration with other apps in the free version as I'm not going to worry about tightly coupling to some other interface. If you want it to work with iCal cool, write the code to do it.
* Add sound selection from default system sounds? Running out of space on options tab.
* Add help me file.

## Change History ##

**2011.05.23**  
Version: 1.0.4  

Added Features:  

* Work period is now configurable.
* Added tick and alarm sounds mute button.
* Added visual alarm indicators. (Useful for the hearing impaired, the colorblind should be able to see a pulsing difference in intensity).
* Automatically shows and focuses Pomidor Timer when the alarm goes off. (I'm not sure I like this one but also not sure if it should be an option.)

Fixes:  

* None (it's perfect right?)

Misc:  

* Removed minimize button. It didn't really have any purpose.
* Refactored fade animation to use proper methodologies.
* Refactored form hiding.
* General code cleanup.
* Changed fast forward tooltip to use interface standard. (I liked mine but it was too outside the norm).
* Now with 100% less rapture.

**2011.05.19**  
Version: 1.0.3 (internal code release)  

Added Features:  

* Growl alerts for alarms (requires Growl installed of course).  
* Added mute active alarm button.  
* When an alarm goes off the dock icon bounces if Pomidor Timer is not the front app (standard Apple design).  
* Fastforward popup description added.

Fixes:  

* Window does not hide when it was mearly inactive. It just becomes visible. This stops the annoying hiding of the window when you just wanted to view it.

**2011.04.28**  
Version: 1.0.2  

Fixed bugs:  

* Missing font
* Window disappeared forever if you pressed icon or menu display too fast.

**2011.04.28**  
Version: 1.0.1  

* Changed tick sound to actual clock tick.
* Changed alarm sound to avoid confusion with message alerts.
* Added click show/hide ability to status bar and dock icon.
* Refactored sound controller (cleaned up some premature optimization).
* Changed version numbering to Major.Minor.Build because it's better.

Fixed bugs:  

* Sound volumes loaded after saved user settings.

**2011.04.27**  
Version 1.0  
Initial release  

