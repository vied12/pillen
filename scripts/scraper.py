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
# Last mod : 03-Aug-04
# -----------------------------------------------------------------------------

from pprint import pprint as pp
from lxml import etree, html
import json
import requests
import os
import sys
import HTMLParser

MOLECULES = map(str.lower, [
    "TFMPP",
    "MDMA*HCl",
    "MDMA*HCI",
    "Methamphetamin",
    "Amphetamin*HCl",
    "MBZP",
    "mdma",
    "mda",
    "Paracetamol",
    "Methadon",
    "pmma",
    "2C-B",
    "25C-NBOMe",
    "25I-NBOMe",
    "MDHOET",
    "Amphetamin",
    "Fluorampheatmin",
    "mcpp",
    "m-cpp",
    "methylon",
    "F-FA",
    "mephedron",
    "fluoramphetamin",
    "Koffein",
    "Domperidon"
    "MDPV",
    "Amphetamin",
    "Amphetami",
    "Coffein",
    "MDDMA",
    "4-Fa",
    "Buflomedil",
    "Amoxicillin",
    "m-CCP",
    "4-F-A",
    ])
if __name__ == "__main__":
    html_parser = HTMLParser.HTMLParser()
    results = []
    html    = html.fromstring(open("tmp/page.html").read())
    names   = map(lambda _: _.text_content(),  html.get_element_by_id("cc").findall("h2"))
    for i, tag in enumerate(html.find_class("inhalt_pillen")):
        infos  = dict(name=names[i])
        images = map(lambda _: _.get("src"), tag.findall("img"))
        for image in images:
            image_filename = os.path.join("tmp/pictures", os.path.basename(image))
            if not os.path.isfile(image_filename):
                r = requests.get("http://www.mindzone.info/%s" % (image), stream=True)
                with open(image_filename, 'wb') as f:
                    for chunk in r.iter_content(chunk_size=1024): 
                        if chunk: # filter  keep-alive new chunks
                            f.write(chunk)
                            f.flush()
        infos["images"] = map(lambda _: os.path.basename(_), images)
        if not infos["images"]: continue
        for line in etree.tostring(tag).split("\n"):
            tag_idx = line.find("<strong>")
            if tag_idx > -1:
                key, value = line[tag_idx+8:].replace("</strong>", "").split(":", 1)
                infos[key.lower()] = html_parser.unescape(value.rstrip().lstrip())
        # composition
        # inhalt =  infos.get("inhalt")
        results.append(infos)
    import re
    import itertools
    for i, result in enumerate(results):
        line = result.get("inhalt", "")
    #     mdma = ""
    #     if "mdma" in line.lower():
    #         number = ""
    #         mol    = ""
    #         is_a_digit = False
    #         is_a_mol   = False
    #         for _ in line:
    #             if _.isdigit() or _ in [".", ","]:
    #                 is_a_digit = True
        def parse_qte(qte):
            qte = qte.replace(",", ".").replace(" ", "")
            number = re.match("\f", qte)
            number = re.match("\d+\.*\d*", qte)
            if number:
                qte = number.group(0)
            return qte
        composition = {}
        mol_is_before_number = False
        every_char_exept_unit = "-qwertyuiopasdfhjklzxcvbnm"
        number_occurences, number_occurences_bck = itertools.tee(re.finditer("(\d+(?!["+every_char_exept_unit+"])\.?,? ?\d*\ ?(?!["+every_char_exept_unit+"])*(mg|g)?)(?!-)", line, re.IGNORECASE))
        number_occurences = list(number_occurences)
        try:
            before_first_number = line[:number_occurences_bck.next().start()]
            if before_first_number:
                if not "+" in before_first_number:
                    mol_is_before_number = True
            if mol_is_before_number:
                # search before
                previous_occ = 0
                for occ in number_occurences:
                    before = line[previous_occ:occ.start()]
                    for mol in MOLECULES:
                        if mol in before.lower():
                            composition[mol] = parse_qte(occ.group(0))
                            break
                    previous_occ = occ.end()
            else:
                number_occurences.reverse()
                if not number_occurences: continue
                next_occ = None
                for occ in number_occurences:
                    after = line[occ.end():next_occ]
                    for mol in MOLECULES:
                        if mol in after.lower():
                            composition[mol] = parse_qte(occ.group(0))
                            break
                    next_occ = 0 - (len(line) - occ.start())
                pass
        except StopIteration as e:
            pass
        # if len(composition) != len(number_occurences):
        #     print line
        #     print [_.group(0) for _ in number_occurences], composition
        result["composition"] = composition
    # print sum(len(_["composition"])> 0 for _ in results), "/", len(results)
    print json.dumps(results, indent=4)

# EOF
