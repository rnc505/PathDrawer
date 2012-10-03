//
//  PDAppDelegate.h
//  PathDrawer
//
//  Created by Robby Cohen on 10/3/12.
//  Copyright (c) 2012 Robby Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDViewController;

@interface PDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PDViewController *viewController;

@end
