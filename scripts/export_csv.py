import csv
import json
from pprint import pprint as pp
data = json.load(open("static/pillen.json"))

pills        = []
molecules    = []
compositions = []
for pill_id, pill in enumerate(data[:]):
    images = iter("http://vied12.github.io/pillen/static/pillen/" + name for name in pill.get("images", []))
    date   = pill.get("datum").split(".")
    date.reverse()
    date   = "/".join(date)
    pills.append(dict(
        pill_id     = pill_id,
        name        = pill.get("name"),
        logo        = pill.get("logo"),
        image       = next(images, None),
        image_back  = next(images, None),
        break_notch = pill.get("bruchrille").lower() == "nein",
        color       = ",".join(pill.get("colorz", [])),
        weight      = pill.get("gewicht"),
        diameter    = pill.get("durchmesser"),
        thickness   = pill.get("dicke"),
        place       = pill.get("ort"),
        date        = date,
        more_infos  = "",
    ))
    for molecule_name, qqt in pill.get("composition", {}).items():
        molecule = next((m for m in molecules if m.get("name") == molecule_name), None)
        if not molecule:
            molecule = dict(
                molecule_id = len(molecules) + 1,
                name        = molecule_name
            )
            molecules.append(molecule)
        composition             = dict(
            pill_id             = pill_id,
            molecule_id         = molecule.get("molecule_id"),
            molecules_contained = ""
        )
        composition["quantity_(in_milligrams)."] = qqt
        compositions.append(composition)

pills_keys = ("Pill_id","name","logo","image","image_back","break_notch","color","weight","diameter","thickness","place","date","more_infos")
with open('static/pillen.csv', 'wb') as csvfile:
    spamwriter = csv.writer(csvfile, quoting=csv.QUOTE_ALL)
    spamwriter.writerow(pills_keys)
    for pill in pills:
        # ordered_values = sorted(pill.items(), key=lambda k: map(str.lower, pills_keys).index(k[0]))
        ordered_values = [""] * len(pills_keys)
        for k,v in pill.items():
            if v is not None:
                ordered_values[map(str.lower, pills_keys).index(k)] = v
        spamwriter.writerow([unicode(val).encode("utf8") for val in ordered_values])

molecules_keys = ("Molecule_id", "name")
with open('static/molecules.csv', 'wb') as csvfile:
    spamwriter = csv.writer(csvfile, quoting=csv.QUOTE_ALL)
    spamwriter.writerow(molecules_keys)
    for mol in molecules:
        spamwriter.writerow([mol["molecule_id"], unicode(mol["name"]).encode("utf8")])

compositions_keys = ("Pill_id","molecules_contained","Molecule_id","quantity_(in_milligrams).")
with open('static/compositions.csv', 'wb') as csvfile:
    spamwriter = csv.writer(csvfile, quoting=csv.QUOTE_ALL)
    spamwriter.writerow(compositions_keys)
    for comp in compositions:
        ordered_values = sorted(comp.items(), key=lambda k: map(str.lower, compositions_keys).index(k[0]))
        spamwriter.writerow([unicode(val[1]).encode("utf8") for val in ordered_values])

# EOF
