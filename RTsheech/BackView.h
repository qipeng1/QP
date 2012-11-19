//
//  BackView.h
//  RTsheech
//
//  Created by telsafe-macpc1 on 12-11-13.
//  Copyright (c) 2012年 telsafe-macpc1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQLevelMeter.h"


@interface BackView : UIView{
    AQLevelMeter*		lvlMeter_in;
    AudioQueueRef       mVoice;
}
@property (nonatomic, retain)	AQLevelMeter		*lvlMeter_in;
-(void)setVoice:(AudioQueueRef)Voice;


@end
