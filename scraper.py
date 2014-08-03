#!/usr/bin/env python
# Encoding: utf-8
# -----------------------------------------------------------------------------
# Project : Pillenwarnungen
# -----------------------------------------------------------------------------
# Author : Edouard Richard                                  <edou4rd@gmail.com>
# -----------------------------------------------------------------------------
# License : 
# -----------------------------------------------------------------------------
# Creation : 30-Jul-04
# Last mod : 30-Jul-04
# -----------------------------------------------------------------------------

from pprint import pprint as pp
from lxml import etree, html
import json
import requests
import os

results = []
html    = html.fromstring(open("page.html").read())
names   = map(lambda _: _.text_content(),  html.get_element_by_id("cc").findall("h2"))
for i, tag in enumerate(html.find_class("inhalt_pillen")):
    infos           = dict(Name=names[i])
    infos["images"] = map(lambda _: _.get("src"), tag.findall("img"))
    for image in infos["images"]:
        r = requests.get("http://www.mindzone.info/%s" % (image), stream=True)
        with open(os.path.join("img", os.path.basename(image)), 'wb') as f:
            for chunk in r.iter_content(chunk_size=1024): 
                if chunk: # filter out keep-alive new chunks
                    f.write(chunk)
                    f.flush()
    for line in etree.tostring(tag).split("\n"):
        tag_idx = line.find("<strong>")
        if tag_idx > -1:
            key, value = line[tag_idx+8:].replace("</strong>", "").split(":", 1)
            infos[key] = value.rstrip().lstrip()
    results.append(infos)
print json.dumps(results, indent=4)

# EOF
