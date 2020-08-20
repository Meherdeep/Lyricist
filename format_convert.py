#!/usr/bin/env python
import os
import re
import sys
import glob
import subprocess
from optparse import OptionParser

def help():
    head, tail = os.path.split(sys.argv[0])
    print "Help:\n       " + tail + " <folder> <src_fmt> <dst_fmt>\n       for example :" + sys.argv[0] + " ./ aac mp3"

def Convert_Audio(src_fmt, dst_fmt):
    all_src_file = sorted(glob.glob("*.*"))
    file_patten = "[a-zA-Z0-9_]*." + src_fmt
    file_patten_regex = re.compile(file_patten)
    for file in all_src_file:
        lower_file_name = file.lower()
        result = file_patten_regex.match(lower_file_name)
        if (result):
            src_file_info = file.split(".")
            file_name = src_file_info[0]
            print "    convert " + file + " to " + file_name + "." + dst_fmt
            cmd = "ffmpeg -i " + file + " " + file_name + "." + dst_fmt
            print cmd
            os.system(cmd)

def Convert_AV(src_fmt, dst_fmt):
    all_src_file = sorted(glob.glob("*.*"))
    file_patten = r"[a-zA-Z0-9_]*." + src_fmt
    file_patten_regex = re.compile(file_patten)
    for file in all_src_file:
        lower_file_name = file.lower()
        result = file_patten_regex.match(lower_file_name)
        if (result):
            src_file_info = file.split(".")
            file_name = src_file_info[0]
            print "    convert " + file + " to " + file_name + "." + dst_fmt
            cmd = "ffmpeg -i " + file + " -acodec copy -vcodec copy -copytb 1 -copyts " + file_name + "." + dst_fmt
            os.system((cmd))

def Convert(folder, src_fmt, dst_fmt):
    child_env = os.environ.copy()
    if not os.path.isdir(folder):
        print "Folder: " + folder + " does not exist"
        return

    os.chdir(folder)
    if dst_fmt in ["aac", "mp3", "wav", "m4a"]:
        Convert_Audio(src_fmt, dst_fmt)
    else:
        Convert_AV(src_fmt, dst_fmt)


if __name__ == "__main__":
    if len(sys.argv) != 4:
        help()
        sys.exit(0)

    folder = sys.argv[1]
    src_fmt = sys.argv[2]
    dst_fmt = sys.argv[3]

    print "convert from %s to %s" % (src_fmt, dst_fmt)
    Convert(folder, src_fmt, dst_fmt)

