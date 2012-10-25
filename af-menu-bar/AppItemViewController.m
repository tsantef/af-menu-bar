//
//  AppItemViewController.m
//  af-menu-bar
//
//  Created by Tim Santeford on 10/8/12.
//  Copyright (c) 2012 AppFog. All rights reserved.
//

#import "AppItemViewController.h"

@interface AppItemViewController ()

@end

@implementation AppItemViewController
@synthesize appName;
@synthesize appImage;
@synthesize appMemory;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
