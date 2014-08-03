#!/usr/bin/python
 
# CLI program to control the mediakeys on OS X. Used to emulate the mediakey on a keyboard with no such keys.
# Easiest used in combination with a launcher/trigger software such as Quicksilver.
# Main part taken from http://stackoverflow.com/questions/11045814/emulate-media-key-press-on-mac
# Glue to make it into cli program by Fredrik Wallner http://www.wallner.nu/fredrik/
 
# import Quartz
from Quartz import NSEvent, CGEventPost
import sys
 
# NSEvent.h
NSSystemDefined = 14
 
# hidsystem/ev_keymap.h
NX_KEYTYPE_SOUND_UP = 0
NX_KEYTYPE_SOUND_DOWN = 1
NX_KEYTYPE_PLAY = 16
NX_KEYTYPE_NEXT = 17
NX_KEYTYPE_PREVIOUS = 18
NX_KEYTYPE_FAST = 19
NX_KEYTYPE_REWIND = 20
 
supportedcmds = {'playpause': NX_KEYTYPE_PLAY, 'next': NX_KEYTYPE_NEXT, 'prev': NX_KEYTYPE_PREVIOUS, 'volup': NX_KEYTYPE_SOUND_UP, 'voldown': NX_KEYTYPE_SOUND_DOWN}
 
def HIDPostAuxKey(key):
    def doKey(down):
        ev = NSEvent.otherEventWithType_location_modifierFlags_timestamp_windowNumber_context_subtype_data1_data2_(
            NSSystemDefined, # type
            (0,0), # location
            0xa00 if down else 0xb00, # flags
            0, # timestamp
            0, # window
            0, # ctx
            8, # subtype
            (key << 16) | ((0xa if down else 0xb) << 8), # data1
            -1 # data2
            )
        cev = ev.CGEvent()
        CGEventPost(0, cev)
    doKey(True)
    doKey(False)
 
if __name__ == "__main__":
    try:
        command = sys.argv[1]
        assert(command in supportedcmds)
        HIDPostAuxKey(supportedcmds[command])
    except (IndexError, AssertionError):
        print "Usage: %s command" % (sys.argv[0],)
        print "\tSupported commands are %s" % supportedcmds.keys()
