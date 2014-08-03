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
        @scope.colorFiltered = ko.observable("")
        @scope.pillen = ko.observableArray([])
        @scope.filteredPillen = ko.computed =>
            color = @scope.colorFiltered()
            if not color
                return @scope.pillen()
            else
                return ko.utils.arrayFilter @scope.pillen(), (item) ->
                    return item.base_color == color
        @scope.colors = ko.observableArray([])
        $.get("static/pillen.json", @retrieveData)
        @scope.filterPillen = (color) => @scope.colorFiltered(color)
    retrieveData: (data) =>
        # data = data[..10]
        colors = [
            "black"
            "#486A6A"
            "#8A8B49"
            "#6D7563"
            "#833636"
            "#F1CDB1"
            "#FF3366"
            "#FF6633"
            "#33CCFF"
            "#A37A35"
            "#739673"
            "#015563"
            "#B88A00"]
        for d in data
            if d.colorz.length == 2
                moy = chroma.interpolate(d.colorz[0], d.colorz[1], 0.5)
                d.color = moy.hex()
            else
                d.color = d.colorz[0]

        ordered_pillen = _.object(colors, [])
        for d in data
            color = chroma(d.color).lab()
            diff  = []
            for base_color, i in colors
                delta = 0
                for c1, j in chroma(base_color).lab()
                    delta += (c1 - color[j]) * (c1 - color[j])
                diff[i] = Math.sqrt(delta)
            index = diff.indexOf(Math.min.apply(null, diff))
            if index>-1
                ordered_pillen[colors[index]] = [] unless ordered_pillen[colors[index]]?
                ordered_pillen[colors[index]].push(d)
                d.base_color = colors[index]

        @scope.pillen(data)
        @scope.colors(colors)

# EOF
