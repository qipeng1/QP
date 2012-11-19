//
//  AppDelegate.h
//  RTsheech
//
//  Created by telsafe-macpc1 on 12-11-9.
//  Copyright (c) 2012年 telsafe-macpc1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainSpeakViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    MainSpeakViewController * viewController;
}

@property (strong, nonatomic) UIWindow *window;

@end
