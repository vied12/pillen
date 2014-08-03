# Encoding: utf-8
# Project : 
# -----------------------------------------------------------------------------
# Author : Edouard Richard                                  <edou4rd@gmail.com>
# -----------------------------------------------------------------------------
# License : GNU General Public License
# -----------------------------------------------------------------------------
# Creation : 02-Jul-2014
# Last mod : 02-Jul-2014
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

class Navigation extends serious.Widget

	constructor: ->
		@feature = [
				{
					feature     : "Webapp Flask based"
				}
				{
					feature     : "Write your"
					write       : [
						{ from : "Javascript", to : "coffeescript" }
						{ from : "html"      , to : "jade" }
						{ from : "css"       , to : ["clevercss", "less"] }
					]
				}
				{
					feature     : "Front-End Template Engine"
					description : "with Knockout.js"
				}
				{
					feature     : "Mechanism to render the application into a set of static files"
					description : "with Frozen-Flask"
				}
				{
					feature     : "Translation supported"
					description : "thanks to Flask-Babel"
				}
				{
					feature     : "<a href=\"https://github.com/vied12/serious-toolkit/tree/master/assets/vendors/serious-toolkit/widget.coffee\", target=\"_blank\">widget.js</a> as front-end controller"
				}
			]

	bindUI: () =>
		@scope.features = ko.observableArray(@feature)

# EOF
