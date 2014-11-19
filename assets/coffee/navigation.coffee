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

    @COLORS = [
        "#486A6A"
        "#99A0AB"
        "#8A8B49"
        "#C4D1DF"
        "#E8B9CC"
        "#6D7563"
        "#833636"
        "#F1CDB1"
        "#FF6633"
        "#A37A35"
        "#739673"
        "#B88A00"]

    bindUI: () =>
        @UIS =
            modal_box : '#myModal'
        @scope.selectedPil    = ko.observable(null)
        @scope.colorFiltered  = ko.observable("")
        @scope.searchKeywords = ko.observable("")
        @scope.pillen         = ko.observableArray([])
        @scope.colors         = ko.observableArray([])
        @scope.filterPillen   = (color) => @scope.colorFiltered(color)
        @scope.showInfos      = (pil) =>
            @scope.selectedPil(pil)
            @uis.modal_box.foundation('reveal', 'open')
            # update hash url
            index = @scope.pillen().length - @scope.pillen().indexOf(pil)
            window.location.hash = "pill=#{index}"
        @scope.filteredPillen = ko.computed =>
            search_keywords = @scope.searchKeywords()
            color           = @scope.colorFiltered()
            result          = @scope.pillen()
            if search_keywords
                result = result.filter (item) ->
                    return serious.Utils.startswith(item.name.toLowerCase(), search_keywords.toLowerCase())
            if color
                result = result.filter (item) ->  item.base_color == color
            return result
        $.get("static/pillen.json", @retrieveData)
        $(document).on 'closed', '[data-reveal]', ->
            window.location.hash = "pill="


    retrieveData: (data) =>
        # data = data[..10]
        for d in data
            # remove file extension from images names
            d.classe = d.images[0].substr(0, d.images[0].lastIndexOf('.'))
            if d.colorz.length == 2
                d.color = chroma.interpolate(d.colorz[0], d.colorz[1], 0.5).hex()
            else
                d.color = d.colorz[0]

        ordered_pillen = _.object(Navigation.COLORS, [])
        for d in data
            # default values
            d.inhalt      = d.inhalt      or ""
            d.bruchrille  = d.bruchrille  or ""
            d.datum       = d.datum       or ""
            d.dicke       = d.dicke       or ""
            d.durchmesser = d.durchmesser or ""
            d.ort         = d.ort         or ""
            color = chroma(d.color).lab()
            diff  = []
            for base_color, i in Navigation.COLORS
                delta = 0
                for c1, j in chroma(base_color).lab()
                    delta += (c1 - color[j]) * (c1 - color[j])
                diff[i] = Math.sqrt(delta)
            index = diff.indexOf(Math.min.apply(null, diff))
            if index>-1
                ordered_pillen[Navigation.COLORS[index]] = [] unless ordered_pillen[Navigation.COLORS[index]]?
                ordered_pillen[Navigation.COLORS[index]].push(d)
                d.base_color = Navigation.COLORS[index]
        @scope.pillen(data)
        @scope.colors(Navigation.COLORS)
        # init from url
        hash = serious.Utils.getHashParams()
        if hash.pill? and hash.pill != ""
            @scope.showInfos(data[data.length - hash.pill])

# EOF
