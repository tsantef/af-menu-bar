#
#  MenuBar.rb
#  af-menu-bar
#
#  Created by Tim Santeford on 10/5/12.
#  Copyright 2012 AppFog. All rights reserved.
#
require 'rubygems'

class MenuBar < NSMenu

  attr_accessor :appitems
  attr_accessor :parent
  attr_accessor :username, :password # Very bad

  def init
    @appitems = []

    initWithTitle 'AFMenuBar'

    mi = NSMenuItem.new
    mi.title = 'Web Console'
    mi.action = 'openWebConsole:'
    mi.target = self
    addItem mi

    mi = NSMenuItem.new
    mi.title = 'Services'
    mi.action = 'test:'
    mi.target = self
    mi.Submenu =  NSMenu.new
    addItem mi

    mi = NSMenuItem.new
    mi.title = 'Add-ons'
    mi.action = 'test:'
    mi.target = self
    mi.Submenu =  NSMenu.new
    addItem mi

    addItem NSMenuItem.separatorItem

    addItem NSMenuItem.separatorItem

    console = ConsoleController.alloc.init
    if !NSBundle.loadNibNamed("ConsoleController", owner:console)
      puts "Error loading Nib for document!"
    else
      mi = NSMenuItem.new
      mi.target = self
      mi.view = console.view
      addItem mi
    end

    addItem NSMenuItem.separatorItem

    mi = NSMenuItem.new
    mi.title = 'Preferences'
    mi.action = 'test:'
    mi.target = self
    addItem mi

    addItem NSMenuItem.separatorItem

    mi = NSMenuItem.new
    mi.title = 'Quit'
    mi.action = 'quit:'
    mi.target = self
    addItem mi
  end

  def updateAppItems

    @appitems.reverse.each do |appinfo|

      aivc = AppItemViewController.alloc.init
      if !NSBundle.loadNibNamed("AppItemViewController", owner:aivc)
        puts "Error loading Nib for document!"
      else
        aivc.appName.stringValue = appinfo['name']
        aivc.appMemory.stringValue = "#{appinfo['resources']['memory']}MB"
        aivc.appImage.image = NSImage.imageNamed "icon-#{appinfo['staging']['model']}.png"

        mi = NSMenuItem.new
        mi.target = self
        mi.view = aivc.view
        insertItem mi, atIndex:4
      end

    end

  end

  def openWebConsole(sender)
      url = NSURL.URLWithString 'https://console.appfog.com'
      ws = NSWorkspace.sharedWorkspace
      ws.openURL url
      #alert = NSAlert.new
      #alert.messageText = 'This is MacRuby Status Bar Application'
      #alert.informativeText = 'Cool, huh?'
      #alert.alertStyle = NSInformationalAlertStyle
      #alert.addButtonWithTitle("Yeah!")
      #response = alert.runModal
  end

  def test(sender)
    api = RestClient.new
    api.post_json("https://api.appfog.com/users/#{username}/tokens",
      { :password => password },
      { :content_type => 'application/json', :accept => 'application/json' }
    ) do |response, data|
      if response.statusCode === 200
        dataObj = JSON.parse(data)
        @api_token = dataObj['token']

        headers = { "AUTHORIZATION" => @api_token }
        api.get_json("https://api.appfog.com/apps", headers) do |response, data|
          puts response.statusCode
          @appitems = data

          updateAppItems
        end
      else
        puts response.statusCode
        puts data
      end
    end
  end

  def quit(sender)
      app = NSApplication.sharedApplication
      app.terminate(self)
  end

end