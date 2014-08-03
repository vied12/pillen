#!/usr/bin/env python
# Encoding: utf-8
# -----------------------------------------------------------------------------
# Project : Pillen warnungen
# -----------------------------------------------------------------------------
# Author : Edouard Richard                                  <edou4rd@gmail.com>
# -----------------------------------------------------------------------------
# License : GNU General Public License
# -----------------------------------------------------------------------------
# Creation : 03-Aug-2014
# Last mod : 03-Aug-2014
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

from flask import Flask, render_template, request, send_file, g, \
	send_from_directory, Response, abort, session, redirect, url_for, make_response
from flask.ext.assets import Environment, YAMLLoader
from flask.ext.babel import Babel

# app
app = Flask(__name__)
app.config.from_pyfile("settings.cfg")
# assets
assets  = Environment(app)
bundles = YAMLLoader("assets.yaml").load_bundles()
assets.register(bundles)
# pyjade
app.jinja_env.add_extension('pyjade.ext.jinja.PyJadeExtension')
# i18n
babel = Babel(app)

# -----------------------------------------------------------------------------
#
# Site pages
#
# -----------------------------------------------------------------------------
@app.route('/')
def index():
	g.language = "en"
	response = make_response(render_template('home.jade'))
	return response


@app.route('/fr.html')
def page_fr():
	g.language = "fr"
	response = make_response(render_template('home.jade'))
	return response

@app.route('/de.html')
def page_de():
	g.language = "de"
	response = make_response(render_template('home.jade'))
	return response

# -----------------------------------------------------------------------------
#
#    UTILS
#
# -----------------------------------------------------------------------------
@babel.localeselector
def get_locale():
	# try to guess the language from the user accept
	# header the browser transmits.
	if not g.get("language"):
		g.language = request.accept_languages.best_match(['en', 'fr', 'de'])
	return g.get("language")

@app.template_filter('relative_url')
def relative_url_filter(s):
	if s.startswith(app.static_url_path):
		return s[1:]
	return s

# -----------------------------------------------------------------------------
#
# Main
#
# -----------------------------------------------------------------------------
if __name__ == '__main__':
	# run application
	app.run(extra_files=("assets.yaml",), host="0.0.0.0")

# EOF
