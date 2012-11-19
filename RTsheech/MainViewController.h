//
//  MainViewController.h
//  RTsheech
//
//  Created by telsafe-macpc1 on 12-11-9.
//  Copyright (c) 2012年 telsafe-macpc1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQRecorder.h"
#import "BackView.h"


//#import "iFlyMSC/IFlyRecognizeControl.h"
//
//#define APPID @"50a1b3ef"
//#define ENGINE_URL @"http://dev.voicecloud.cn:1028/index.htm"
//#define H_CONTROL_ORIGIN CGPointMake(20, 70)

@interface MainViewController : NSObject<UITextViewDelegate>{
    IBOutlet UIButton*	btn_record;
	IBOutlet UIButton*	btn_updata;
    UIButton *mPlay;
    UIButton *mStop;
    NSMutableArray * mVoiceArray;
    UITextView * mtextview;
    IBOutlet UIView *  mView;
    AQRecorder*					recorder;
    CFStringRef					recordFilePath;
    BackView *                  mBackView;
    BOOL						playbackWasInterrupted;
	BOOL						playbackWasPaused;

}
@property (readonly)			AQRecorder			*recorder;
@property						BOOL				playbackWasInterrupted;
@property (nonatomic, assign)	BOOL                inBackground;
@property(nonatomic,retain) IBOutlet UITextView * mtextview;
-(IBAction)Speakaction:(id)sender;
-(IBAction)Translate:(id)sender;
- (void)registerForBackgroundNotifications;

@end
