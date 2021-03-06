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
DOTQGIS=.qgis2

PLUGINNAME=pluginbuilder

PY_FILES = pluginbuilder.py pluginbuilder_dialog.py result_dialog.py __init__.py pluginspec.py

TEMPLATE_DIR = templateclass

EXTRAS = help.html icon.png plugin_builder.png metadata.txt

HELP_BUILD = help/build/html/*

UI_FILES = ui_pluginbuilder.py ui_results.py

RESOURCE_FILES = resources.py

default: compile

compile: $(UI_FILES) $(RESOURCE_FILES)

%.py : %.qrc
	pyrcc4 -o $@  $<

%.py : %.ui
	pyuic4 -o $@ $<

# The deploy  target only works on unix like operating system where
# the Python plugin directory is located at:
# $HOME/$(DOTQGIS)/python/plugins
deploy: compile
	mkdir -p $(HOME)/$(DOTQGIS)/python/plugins/$(PLUGINNAME)
	mkdir -p $(HOME)/$(DOTQGIS)/python/plugins/$(PLUGINNAME)/help
	cp -vf $(PY_FILES) $(HOME)/$(DOTQGIS)/python/plugins/$(PLUGINNAME)
	cp -vf $(UI_FILES) $(HOME)/$(DOTQGIS)/python/plugins/$(PLUGINNAME)
	cp -vf $(RESOURCE_FILES) $(HOME)/$(DOTQGIS)/python/plugins/$(PLUGINNAME)
	cp -vf $(EXTRAS) $(HOME)/$(DOTQGIS)/python/plugins/$(PLUGINNAME)
	cp -rvf $(TEMPLATE_DIR) $(HOME)/$(DOTQGIS)/python/plugins/$(PLUGINNAME)
	cp -rvf $(HELP_BUILD) $(HOME)/$(DOTQGIS)/python/plugins/$(PLUGINNAME)/help

# remove the deployed plugin
dclean: 
	rm -rf $(HOME)/$(DOTQGIS)/python/plugins/$(PLUGINNAME)

zip: dclean deploy
	rm -f $(PLUGINNAME).zip
	cd $(HOME)/$(DOTQGIS)/python/plugins; zip -9vr $(CURDIR)/$(PLUGINNAME).zip $(PLUGINNAME)
	

# eCreate a zip package. Requires passing a valid commit or tag as follows:
#   make package VERSION=Version_0.3.2
# Get the last commit hash
COMMITHASH=$(shell git rev-parse HEAD)
package: compile
		rm -f $(PLUGINNAME).zip
		git archive --prefix=$(PLUGINNAME)/ -o $(PLUGINNAME).zip $(COMMITHASH)
		@echo "Created package: $(PLUGINNAME).zip" 

clean:
	rm $(UI_FILES) $(RESOURCE_FILES)
