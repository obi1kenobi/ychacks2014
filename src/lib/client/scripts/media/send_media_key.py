#!/usr/bin/python
 
# CLI program to control the mediakeys on OS X. Used to emulate the mediakey on a keyboard with no such keys.
# Easiest used in combination with a launcher/trigger software such as Quicksilver.
# Main part taken from http://stackoverflow.com/questions/11045814/emulate-media-key-press-on-mac
# Glue to make it into cli program by Fredrik Wallner http://www.wallner.nu/fredrik/
 
# import Quartz
from Quartz import NSEvent, CGEventPost
import os
import sys
import time

from watchdog.events import FileSystemEventHandler
from watchdog.observers import Observer
 
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
 
class OnCreatedEventHandler(FileSystemEventHandler):
    def on_created(self, event):
        command = event.src_path[event.src_path.rindex('/') + 1:]
        if command in supportedcmds:
            HIDPostAuxKey(supportedcmds[command])
            try:
                os.remove(event.src_path)
            except OSError:
                pass

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
    event_handler = OnCreatedEventHandler()
    observer = Observer()
    observer.schedule(event_handler, './', recursive=True)
    observer.start()
    try:
        while True:
            print "I'm running!"
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()
