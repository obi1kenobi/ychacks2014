Touch
===========

Context aware remote controls for your Mac. This project was a [submission for YC Hacks 2014](http://challengepost.com/software/touch) and you can read more about it on [Ryhan's Blog](http://ryhan.org/post/94409414906/as-part-of-yc-hacks-this-past-weekend-i-worked-on).
The team for this project included [Predrag Gruevski](https://github.com/obi1kenobi), [David Wetterau](https://github.com/dwetterau), [Ryhan Hassan](https://github.com/ryhan), and [Damon Doucet](https://github.com/damondoucet).

# Installation

To install the native client you first must have python and node installed on your computer.

Next you must install the python [watchdog](https://pypi.python.org/pypi/watchdog) package.

You must also have [Quartz](http://xquartz.macosforge.org/landing/) installed on your mac to enable the media controls.

After installing the dependencies, run `npm install` to install all of the necessary node modules.

# Running the client

After installing all dependencies and node modules, run `npm start` in your project directory to start the Mac client.

Before starting the Mac client however, it's a good idea to first navigate to the [mobile app website](https://ychacks.firebaseapp.com) on your phone so that you're ready to type in the pairing code.

Starting the client will cause a 6 digit number to be displayed in the terminal where you started the client that must be typed into your phone within 15 seconds to finish the pairing process.

After you have entered the pairing code on your phone, you should be ready to control your mac with your phone!
