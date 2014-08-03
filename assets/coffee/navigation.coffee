# Encoding: utf-8
# Project : 
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

class Navigation extends serious.Widget


	bindUI: () =>
		@scope.pillen = ko.observableArray([])
		$.get("static/pillen.json", @retrieveData)

	retrieveData: (data) =>
		# for d in data
		# 	if d.colorz.length == 2
		# 		moy = chroma.interpolate(d.colorz[0], d.colorz[1], 0.5)
		# 		d.moy = moy
		# 	console.log d.colorz
		@scope.pillen(data)

# EOF
