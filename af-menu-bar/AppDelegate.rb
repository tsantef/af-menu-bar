#
#  AppDelegate.rb
#  af-menu-bar
#
#  Created by Tim Santeford on 10/5/12.
#  Copyright 2012 AppFog. All rights reserved.
#

require 'keychain'

class AppDelegate

  attr_accessor :window
  attr_accessor :credentials_window
  attr_accessor :username_text, :username
  attr_accessor :password_text, :password
  attr_accessor :menu_bar
  attr_accessor :keychain

  def applicationDidFinishLaunching(a_notification)
    username = "email address here"
    password = "password here"

    keychain = MRKeychain::GenericItem.item_for_service(getBundleIdentifier, username:username)

    if keychain.nil?
      keychain = MRKeychain::GenericItem.add_item_for_service(getBundleIdentifier, username:username, password:password )
    end

    puts keychain.username

    status_bar = NSStatusBar.systemStatusBar
    status_item = status_bar.statusItemWithLength(NSVariableStatusItemLength)
    menu_bar = MenuBar.new
    status_item.setMenu menu_bar
    img = NSImage.imageNamed 'menu-gray.png'
    status_item.setImage(img)

    # Load app info from file
    begin
      rootPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, 1).objectAtIndex 0
      plistPath = rootPath.stringByAppendingPathComponent "Data.json"
      menu_bar.username = keychain.username
      menu_bar.password = keychain.password
      menu_bar.appitems = JSON.parse(IO.read(plistPath))

      menu_bar.updateAppItems
    rescue
    end
  end

  def applicationShouldTerminate(sender)
    puts "Good Bye"
    error = Pointer.new "@"
    rootPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, 1).objectAtIndex 0
    plistPath = rootPath.stringByAppendingPathComponent "Data.json"
    File.open(plistPath,"w") do |f|
      f.write(menu_bar.appitems.to_json)
    end
    NSTerminateNow
  end

  def getBundleIdentifier
    NSBundle.mainBundle.bundleIdentifier
  end

  def submitLogin(sender)

  end

  def hideLogin(sender)

  end

end
