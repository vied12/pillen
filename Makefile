# -----------------------------------------------------------------------------
# Author : Edouard Richard                                  <edou4rd@gmail.com>
# -----------------------------------------------------------------------------
# License : GNU General Public License
# -----------------------------------------------------------------------------
# This file is part of Serious-Toolkit.
# 
#     Serious-Toolkit is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
# 
#     Serious-Toolkit is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
# 
#     You should have received a copy of the GNU General Public License
#     along with Serious-Toolkit.  If not, see <http://www.gnu.org/licenses/>.

PROJECT_NAME = "Pillen"
PYC          = $(wildcard *.pyc */*.pyc sources/*/*.pyc sources/*/*/*.pyc sources/*/*/*/*.pyc sources/*/*/*/*/*.pyc scripts/*.pyc)
CACHE        = $(wildcard static/.webassets-cache static/gen)
WEBAPP       = $(wildcard webapp.py)
RM           = rm -fr
MV           = mv -f
VENV         = `pwd`/.env
VIRTUALENV   = virtualenv
PIP          = pip
PYTHON       = python
DEBUG        = True
HOST         = "http://localhost:5000"
DIST_DIR     = "build/"
TIMESTAMP   = $(shell date "+%Y-%m-%d")

ifndef BASE_URL
	BASE_URL = $(HOST)
endif

run: clean
	. `pwd`/.env ; export DEBUG=$(DEBUG) ; python $(WEBAPP)

clean:
	$(RM) $(PYC)
	$(RM) $(CACHE)

install:
	virtualenv venv --no-site-packages --distribute --prompt=$(PROJECT_NAME)
	. `pwd`/.env ; pip install -r requirements.txt
	. `pwd`/.env ; npm install
	@echo "installed"

freeze: clean
	$(RM) build -r
	. `pwd`/.env ;  export DEBUG="False" ; export BASE_URL=$(BASE_URL) ;python -c "from webapp import app; from flask_frozen import Freezer; freezer = Freezer(app); freezer.freeze()"
	$(RM) build/static/.webassets-cache/ -r
	@echo "freezed in $(DIST_DIR)"

update_i18n:
	pybabel extract -F babel.cfg -o translations/messages.pot .
	pybabel update -i translations/messages.pot -d translations

compile_i18n:
	pybabel compile -d translations

archive: freeze
	@cp -r $(DIST_DIR) $(PROJECT_NAME)-$(TIMESTAMP)
	@tar cvjf "$(PROJECT_NAME)-$(TIMESTAMP).tar.bz2" "$(PROJECT_NAME)-$(TIMESTAMP)"
	@rm -rf $(PROJECT_NAME)-$(TIMESTAMP)
	@echo "archive $(PROJECT_NAME)-$(TIMESTAMP).tar.bz2 created"

updatedata: clean
	# $(RM) tmp/** -r
	-mkdir tmp/pictures
	-mkdir tmp/pillen
	. `pwd`/.env ; python scripts/scraper.py > tmp/pillen.json
	. `pwd`/.env ; python scripts/get_colors.py > tmp/pillen_with_zcolor.json
	. `pwd`/.env ; python scripts/resize_pillen.py
	. `pwd`/.env ; glue tmp/pillen static/sprites
	convert static/sprites/pillen.png static/sprites/pillen.jpg
	sed -i 's/\.png/\.jpg/g' static/sprites/pillen.css
	$(RM) static/sprites/pillen.png
	$(MV) tmp/pillen_with_zcolor.json static/pillen.json

# EOF
