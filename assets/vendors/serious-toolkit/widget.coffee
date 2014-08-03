# -----------------------------------------------------------------------------
# Project : a Serious Toolkit
# -----------------------------------------------------------------------------
# Author : Edouard Richard                                  <edou4rd@gmail.com>
# -----------------------------------------------------------------------------
# License : GNU Lesser General Public License
# -----------------------------------------------------------------------------
# Creation : 04-Aug-2012
# Last mod : 16-Jul-2014
# -----------------------------------------------------------------------------
# >  A Serious Toolkit for Serious Projects.
# >  
# >  Inspired from Sébastien Pierre <http://github.com/sebastien>

window.serious = {} unless window.serious?

# -----------------------------------------------------------------------------
#
# WIDGET
#
# -----------------------------------------------------------------------------	

class window.serious.Widget

	@bindAll = (firsts...) ->
		if firsts
			for first in firsts
				Widget.ensureWidget($(first))
		$(".widget").each(->
			self = $(this)
			if not self.hasClass('template') and not self.parents().hasClass('template')
				Widget.ensureWidget(self)
		)

	# return the Widget instance for the given selector
	@ensureWidget  = (ui) ->
		ui = $(ui)
		if not ui.length 
			return null
		else if ui[0]._widget?
			return ui[0]._widget
		else
			widget_class = Widget.getWidgetClass(ui)
			if widget_class?
				widget = new widget_class()
				widget_class.Instance = widget
				widget.scope = {}
				widget.ui    = $(ui)
				widget.bindUI(ui)
				widget._bindUI(ui)
				# use http://knockoutjs.com as template manager
				ko.applyBindings(widget.scope, ui.get(0)) if ko?
				return widget
			else
				console.warn("widget not found for", ui)
				return null

	@getWidgetClass = (ui) ->
		return eval("(" + $(ui).attr("data-widget") + ")")

	_bindUI: (ui) =>
		if @ui[0]._widget
			delete @ui[0]._widget
		@ui[0]._widget = this # set widget in selector for ensureWidget
		@uis = {}
		# UIS
		if (typeof(@UIS) != "undefined")
			for key, value of @UIS
				nui = @ui.find(value)
				if nui.length < 1
					console.warn("uis", key, "not found in", ui)
				@uis[key] = nui

	hide: =>
		@ui.addClass "hidden"

	show: =>
		@ui.removeClass "hidden"

	_bindClick: (nui, action) ->
		if action? and action in @ACTIONS
			nui.click (e) =>
				this[action](e)
				e.preventDefault()

# EOF
