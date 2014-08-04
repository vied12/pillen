#!/usr/bin/env python
# Encoding: utf-8
# -----------------------------------------------------------------------------
# Project : Pillenwarnungen
# -----------------------------------------------------------------------------
# Author : Edouard Richard                                  <edou4rd@gmail.com>
# -----------------------------------------------------------------------------
# License : 
# -----------------------------------------------------------------------------
# Creation : 03-Aug-04
# Last mod : 03-Aug-04
# -----------------------------------------------------------------------------
import glob

try:
    import Image
except ImportError:
    from PIL import Image

def resize(filename):
    img = Image.open(filename)
    img.thumbnail((100, 100))
    img.save(filename)
   
if __name__ == "__main__":
    for image in glob.glob("../static/pillen/*"):
        resize(image)

# EOF
