#!/usr/bin/env python3
import subprocess
import time
import os

key = "com.canonical.Unity.Devices"
bl_file = os.environ["HOME"]+"/.blacklist_data"

while True:
    time.sleep(2)

    current = subprocess.check_output([
        "gsettings", "get", key, "blacklist",
        ]).decode("utf-8")
    if "@as" in current:
        current = []
    else:
        current = eval(current)        
    try:
        r = open(bl_file).read()
        r = [] if r == '' else r.splitlines()           
    except FileNotFoundError:
        r = []
    if current != r:
        newlist = list(set([d for d in current+r if not d == '']))
        open(bl_file, "wt").write("\n".join(newlist))
        subprocess.Popen(["gsettings", "set", key, "blacklist", str(newlist)])