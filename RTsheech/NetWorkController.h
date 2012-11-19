//
//  NetWorkController.h
//  RTsheech
//
//  Created by telsafe-macpc1 on 12-11-14.
//  Copyright (c) 2012年 telsafe-macpc1. All rights reserved.
//
//#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CFNetwork/CFNetwork.h>

@interface NetWorkController : NSObject<NSURLConnectionDelegate,NSStreamDelegate,NSURLConnectionDownloadDelegate>{
    BOOL finished;
}

-(void)initWithFile:(NSString*)file;

@end
