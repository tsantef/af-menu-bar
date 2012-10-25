//
//  main.m
//  af-menu-bar
//
//  Created by Tim Santeford on 10/5/12.
//  Copyright (c) 2012 AppFog. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <MacRuby/MacRuby.h>

int main(int argc, char *argv[])
{
    return macruby_main("rb_main.rb", argc, argv);
}
