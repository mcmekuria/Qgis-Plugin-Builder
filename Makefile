#/***************************************************************************
#    PluginBuilder
#
#    Creates a QGIS plugin template for use as a starting point in plugin
#    development.
#                             -------------------
#        begin                : 2011-01-20
#        copyright            : (C) 2011 by GeoApt LLC
#        email                : gsherman@geoapt.com
# ***************************************************************************/
#
#/***************************************************************************
# *                                                                         *
# *   This program is free software; you can redistribute it and/or modify  *
# *   it under the terms of the GNU General Public License as published by  *
# *   the Free Software Foundation; either version 2 of the License, or     *
# *   (at your option) any later version.                                   *
# *                                                                         *
# ***************************************************************************/
# Makefile for a PyQGIS plugin 
#
PLUGINNAME=pluginbuilder

PY_FILES = PluginBuilder.py PluginBuilderDialog.py ResultDialog.py __init__.py pluginspec.py

TEMPLATE_DIR = templateclass

EXTRAS = help.html icon.png plugin_builder.png

UI_FILES = Ui_PluginBuilder.py Ui_Results.py

RESOURCE_FILES = resources.py

default: compile

compile: $(UI_FILES) $(RESOURCE_FILES)

%.py : %.qrc
	pyrcc4 -o $@  $<

%.py : %.ui
	pyuic4 -o $@ $<

# The deploy  target only works on unix like operating system where
# the Python plugin directory is located at:
# $HOME/.qgis/python/plugins
deploy: compile
	mkdir -p $(HOME)/.qgis/python/plugins/$(PLUGINNAME)
	cp -vf $(PY_FILES) $(HOME)/.qgis/python/plugins/$(PLUGINNAME)
	cp -vf $(UI_FILES) $(HOME)/.qgis/python/plugins/$(PLUGINNAME)
	cp -vf $(RESOURCE_FILES) $(HOME)/.qgis/python/plugins/$(PLUGINNAME)
	cp -vf $(EXTRAS) $(HOME)/.qgis/python/plugins/$(PLUGINNAME)
	cp -rvf $(TEMPLATE_DIR) $(HOME)/.qgis/python/plugins/$(PLUGINNAME)

