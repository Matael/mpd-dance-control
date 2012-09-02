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

HOST = '192.168.1.65'
PORT = 3000

while True:
    droid.dialogCreateAlert("MPD Remote Controler")
    droid.dialogSetItems(['Pause',
                          'Next',
                          'Previous',
                          'Volume +',
                          'Volume -',
                          'Current Song',
                          'Start',
                          'Stop'])
    droid.dialogSetNegativeButtonText("Cancel")
    droid.dialogShow()
    result = droid.dialogGetResponse().result
    if result.has_key("item"):
        action = result["item"]
    else:
        action = -1


    if action < 0:
        droid.makeToast("No item chosen\nGoodbye.")
        droid.close()
        sys.exit()

    real_acts = [
        'pause',
        'next',
        'previous',
        'volinc',
        'voldec',
        'current',
        'start',
        'stop'
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

