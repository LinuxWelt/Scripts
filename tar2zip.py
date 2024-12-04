#!/usr/bin/python

import sys, tarfile, zipfile, glob, re

def convert_one_archive(in_file, out_file):
    with tarfile.open(in_file, mode='r:*') as tf:
        with zipfile.ZipFile(out_file, mode='a', compression=zipfile.ZIP_DEFLATED) as zf:
            for m in [m for m in tf.getmembers() if not m.isdir()]:
                if m.issym() or m.islnk():
                    print('Achtung: Symlink oder Hardlink zu Datei umgewandelt')
                f = tf.extractfile(m)
                fl = f.read()
                fn = m.name
                zf.writestr(fn, fl)

for in_file in sys.argv[1:]:
    out_file = re.sub(r'\.((tar(\.(gz|bz2|xz))?)|tgz|tbz|tbz2|txz)$', '.zip', in_file)
    if out_file == in_file:
        print(in_file, '---> [übersprungen]')
    else:
        print(in_file, '--->', out_file)
        convert_one_archive(in_file, out_file)
