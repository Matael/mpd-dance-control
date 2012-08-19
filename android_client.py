#!/usr/bin/env python2.6
#-*-encoding: utf8-*-
"""
Small python script to interact with mpc
"""

# Test of Lists
import android
import urllib2
import sys

droid = android.Android()

HOST = '192.168.1.14'
PORT = 3000

#Choose which list type you want.
def getaction():
    "get user action"
    droid.dialogCreateAlert("MPD Remote Controler")
    droid.dialogSetItems(["Start", "Pause", "Stop", "Previous", "Next"])
    droid.dialogShow()
    result = droid.dialogGetResponse().result
    if result.has_key("item"):
        return result["item"]
    else:
        return -1

#Choose List
action = getaction()

if action < 0:
    droid.makeToast("no item chosen")
    droid.close()
    sys.exit()

real_acts = [
    'start',
    'pause',
    'stop',
    'previous',
    'next'
]

result = urllib2.urlopen("http://{0}:{1}/{2}".format(
    HOST,
    PORT,
    real_acts[action])
)

toast = '\n'.join(result.readlines())
droid.makeToast(toast.rstrip())

droid.close()
sys.exit()

