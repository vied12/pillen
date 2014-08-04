# -----------------------------------------------------------------------------
# Project : a Serious Toolkit
# -----------------------------------------------------------------------------
# Author : Edouard Richard                                  <edou4rd@gmail.com>
# -----------------------------------------------------------------------------
# License : GNU Lesser General Public License
# -----------------------------------------------------------------------------
# Creation : 04-Aug-2012
# Last mod : 23-Jul-2014
# -----------------------------------------------------------------------------
# >  A Serious Toolkit for Serious Projects.

window.serious       = {} unless window.serious?
window.serious.Utils = {} unless window.serious.Utils?

# -----------------------------------------------------------------------------
#
# UTILS
#
# -----------------------------------------------------------------------------	

isDefined = (obj) ->
	return typeof(obj) != 'undefined' and obj != null

jQuery.fn.opacity = (int) ->
	$(this).css({opacity:int})

serious.Utils.clone = (obj) ->
	if not obj? or typeof obj isnt 'object'
		return obj
	if obj instanceof Date
		return new Date(obj.getTime()) 
	if obj instanceof RegExp
		flags = ''
		flags += 'g' if obj.global?
		flags += 'i' if obj.ignoreCase?
		flags += 'm' if obj.multiline?
		flags += 'y' if obj.sticky?
		return new RegExp(obj.source, flags) 
	newInstance = new obj.constructor()
	for key of obj
		newInstance[key] = window.serious.Utils.clone obj[key]
	return newInstance

serious.Utils.startswith = (string="", startsWith) ->
	if (startsWith.length > string.length)
		return false
	else return string.substring(0, startsWith.length) == startsWith

serious.Utils.getHashParams = ->
	hashParams = {}
	a = /\+/g # Regex for replacing addition symbol with a space
	r = /([^&;=]+)=?([^&;]*)/g
	d = (s) -> decodeURIComponent s.replace(a, " ")
	q = window.location.hash.substring(1)
	hashParams[d(e[1])] = d(e[2])  while e = r.exec(q)
	return hashParams

jQuery.fn.cloneTemplate = (dict, removeUnusedField=false) ->
	nui = $(this[0]).clone()
	nui = nui.removeClass("template hidden").addClass("actual")
	if typeof(dict) == "object"
		for klass, value of dict
			if value != null
				nui.find(".out."+klass).html(value)
		if removeUnusedField
			nui.find(".out").each ->
				if $(this).html() == ""
					$(this).remove()
	return nui

Object.size = (obj) ->
	size = 0
	for key of obj
		if obj.hasOwnProperty(key)
			size++
	return size

# EOF
