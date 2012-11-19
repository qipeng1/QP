//
//  MainViewController.m
//  RTsheech
//
//  Created by telsafe-macpc1 on 12-11-9.
//  Copyright (c) 2012年 telsafe-macpc1. All rights reserved.
//

#import "MainViewController.h"
#import "NetWorkController.h"
#include "wav_to_flac.h"

@implementation MainViewController
@synthesize recorder;
@synthesize mtextview;
@synthesize playbackWasInterrupted;
@synthesize inBackground;

- (void)registerForBackgroundNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(resignActive)
												 name:UIApplicationWillResignActiveNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(enterForeground)
												 name:UIApplicationWillEnterForegroundNotification
											   object:nil];
}

- (void)resignActive
{
    if (recorder->IsRunning()) [self stopRecord];
    inBackground = true;
}

- (void)enterForeground
{
    OSStatus error = AudioSessionSetActive(true);
    if (error) printf("AudioSessionSetActive (true) failed");
	inBackground = false;
}

-(NSString *)timeStampAsString
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"EEE-MMM-dd-hh-mm-ss"];
    NSString *locationString = [@"RT" stringByAppendingString:[df stringFromDate:nowDate]];
    return [locationString stringByAppendingFormat:@".wav"];
}

-(IBAction)Speakaction:(id)sender{
    if (mVoiceArray == nil) {
        mVoiceArray = [[NSMutableArray alloc]initWithObjects: nil];
    }
   // btn_record.titleLabel.text = @"停止";
    //[btn_record setTitle:@"停止" forState:0];
    btn_updata.enabled = NO;
    NSString *mFile = [self timeStampAsString];
  //  NSString *mFile2 = [[@"recordedFile" stringByAppendingFormat:@"%d",mVoiceArray.count] stringByAppendingString:@".flac"];
    [mVoiceArray addObject:mFile];
   // recorder->StartRecord(CFSTR("recordedFile.caf"));
    NSLog(@"mFile %@",mFile);
    recorder->StartRecord((CFStringRef)mFile);
  //  recorder->StartRecord((CFStringRef)mFile2);
    [self setFileDescriptionForFormat:recorder->DataFormat() withName:@"Recorded File"];
    mBackView = [[BackView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    mStop = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [mStop setTitle:@"停止" forState:0];
    mStop.frame = CGRectMake(450, 500, 100, 40);
    [mStop addTarget:self action:@selector(stopRecord) forControlEvents:UIControlEventTouchUpInside];
    [mView addSubview:mBackView];
    [mView addSubview:mStop];
    [mBackView setVoice: recorder->Queue()];
}

-(void)stopPlayQueue
{
    [mBackView setVoice: nil];
	//[lvlMeter_in setAq: nil];
	btn_record.enabled = YES;
    [mBackView removeFromSuperview];
    mBackView = NULL;
}

- (void)stopRecord
{
	// Disconnect our level meter from the audio queue
	[mBackView setVoice: nil];
	
	recorder->StopRecord();
	
	// dispose the previous playback queue
    
	btn_updata.enabled = YES;
        
    [mStop removeFromSuperview];
    [mBackView removeFromSuperview];
    mBackView = NULL;
	// Set the button's state back to "record"
   // btn_record.titleLabel.text = @"听写";
    
}

-(void)pausePlayQueue
{
	playbackWasPaused = YES;
}

#pragma mark AudioSession listeners
void interruptionListener(	void *	inClientData,
                          UInt32	inInterruptionState)
{
	MainViewController *THIS = (MainViewController*)inClientData;
	if (inInterruptionState == kAudioSessionBeginInterruption)
	{
		if (THIS->recorder->IsRunning()) {
			[THIS stopRecord];
		}
		
	}
//	else if ((inInterruptionState == kAudioSessionEndInterruption) && THIS->playbackWasInterrupted)
//	{
//		// we were playing back when we were interrupted, so reset and resume now
//		
//		[[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueResumed" object:THIS];
//		THIS->playbackWasInterrupted = NO;
//	}
}

//# pragma mark Notification routines
//- (void)playbackQueueStopped:(NSNotification *)note
//{
//	[mPlay setTitle:[@"播放" stringByAppendingFormat:@"%d",mVoiceArray.count] forState:0 ];
//	//[lvlMeter_in setAq: nil];
//    [mBackView setVoice: nil];
//	btn_record.enabled = YES;
//    [mBackView removeFromSuperview];
//    mBackView = NULL;
//}
//
//- (void)playbackQueueResumed:(NSNotification *)note
//{
//    mBackView = [[BackView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
//	[mPlay setTitle:@"stop" forState:0 ];
//	btn_record.enabled = NO;
//    [mView addSubview:mBackView];
//    
//	//[lvlMeter_in setAq: player->Queue()];
//}


void propListener(	void *                  inClientData,
                  AudioSessionPropertyID	inID,
                  UInt32                  inDataSize,
                  const void *            inData)
{
	MainViewController *THIS = (MainViewController*)inClientData;
	if (inID == kAudioSessionProperty_AudioRouteChange)
	{
		CFDictionaryRef routeDictionary = (CFDictionaryRef)inData;
		//CFShow(routeDictionary);
		CFNumberRef reason = (CFNumberRef)CFDictionaryGetValue(routeDictionary, CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
		SInt32 reasonVal;
		CFNumberGetValue(reason, kCFNumberSInt32Type, &reasonVal);
		if (reasonVal != kAudioSessionRouteChangeReason_CategoryChange)
		{
			/*CFStringRef oldRoute = (CFStringRef)CFDictionaryGetValue(routeDictionary, CFSTR(kAudioSession_AudioRouteChangeKey_OldRoute));
             if (oldRoute)
             {
             printf("old route:\n");
             CFShow(oldRoute);
             }
             else
             printf("ERROR GETTING OLD AUDIO ROUTE!\n");
             
             CFStringRef newRoute;
             UInt32 size; size = sizeof(CFStringRef);
             OSStatus error = AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &size, &newRoute);
             if (error) printf("ERROR GETTING NEW AUDIO ROUTE! %d\n", error);
             else
             {
             printf("new route:\n");
             CFShow(newRoute);
             }*/
            
//			if (reasonVal == kAudioSessionRouteChangeReason_OldDeviceUnavailable)
//			{
//				if (THIS->player->IsRunning()) {
//					[THIS pausePlayQueue];
//					[[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueStopped" object:THIS];
//				}
//			}
            
			// stop the queue if we had a non-policy route change
			if (THIS->recorder->IsRunning()) {
				[THIS stopRecord];
			}
		}
	}
	else if (inID == kAudioSessionProperty_AudioInputAvailable)
	{
		if (inDataSize == sizeof(UInt32)) {
			UInt32 isAvailable = *(UInt32*)inData;
			// disable recording if input is not available
			THIS->btn_record.enabled = (isAvailable > 0) ? YES : NO;
		}
	}
}


#pragma mark Initialization routines
- (void)awakeFromNib
{
	// Allocate our singleton instance for the recorder & player object
	recorder = new AQRecorder();
	    
	OSStatus error = AudioSessionInitialize(NULL, NULL, interruptionListener, self);
	if (error) printf("ERROR INITIALIZING AUDIO SESSION! %d\n", (int)error);
	else
	{
		UInt32 category = kAudioSessionCategory_PlayAndRecord;
		error = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
		if (error) printf("couldn't set audio category!");
        
		error = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, propListener, self);
		if (error) printf("ERROR ADDING AUDIO SESSION PROP LISTENER! %d\n", (int)error);
		UInt32 inputAvailable = 0;
		UInt32 size = sizeof(inputAvailable);
		
		// we do not want to allow recording if input is not available
		error = AudioSessionGetProperty(kAudioSessionProperty_AudioInputAvailable, &size, &inputAvailable);
		if (error) printf("ERROR GETTING INPUT AVAILABILITY! %d\n", (int)error);
		btn_record.enabled = (inputAvailable) ? YES : NO;
		
		// we also need to listen to see if input availability changes
		error = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioInputAvailable, propListener, self);
		if (error) printf("ERROR ADDING AUDIO SESSION PROP LISTENER! %d\n", (int)error);
        
		error = AudioSessionSetActive(true);
		if (error) printf("AudioSessionSetActive (true) failed");
	}
	
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackQueueStopped:) name:@"playbackQueueStopped" object:nil];
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackQueueResumed:) name:@"playbackQueueResumed" object:nil];
    
	
	
	// disable the play button since we have no recording to play yet
	playbackWasInterrupted = NO;
	playbackWasPaused = NO;
    
    [self registerForBackgroundNotifications];
}


//-(void)Playaction:(UIButton*)sender{
//    NSLog(@"sender tag = %d",sender.tag);
//    // now create a new queue for the recorded file
//	recordFilePath = (CFStringRef)[NSTemporaryDirectory() stringByAppendingPathComponent: [mVoiceArray objectAtIndex:sender.tag-1]];
//    NSLog(@"recordFilePath %@ ,%@",recordFilePath,[mVoiceArray objectAtIndex:sender.tag-1]);
//	player->CreateQueueForFile(recordFilePath);
//    if (player->IsRunning())
//	{
//		if (playbackWasPaused) {
//			OSStatus result = player->StartQueue(true);
//            playbackWasPaused = NO;
//			if (result == noErr)
//				[[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueResumed" object:self];
//		}
//		else
//			[self stopPlayQueue];
//	}
//	else
//	{
//		OSStatus result = player->StartQueue(false);
//		if (result == noErr)
//			[[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueResumed" object:self];
//	}
//}

-(IBAction)Translate:(id)sender{
    NSString *recordFile = [NSTemporaryDirectory() stringByAppendingPathComponent: [mVoiceArray objectAtIndex:0]];
    NSString *flacFile = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test.flac"];
    const char * wave_file = [recordFile UTF8String];
    const char * flac_file = [flacFile UTF8String];
    int conversionResult = convertWavToFlac(wave_file, flac_file);
//    NSLog(@"conversionResult%d",conversionResult);
  //  url = CFURLCreateWithString(kCFAllocatorDefault, (CFStringRef)recordFile, NULL);
     NetWorkController* network = [NetWorkController alloc];
    [network initWithFile:recordFile];
   // [network initWithFile:@"/Users/telsafe-macpc1/Documents/RT周四-11月-15-02-57-13.wav"];
}

char *OSTypeToStr(char *buf, OSType t)
{
	char *p = buf;
	char str[4] = {0};
    char *q = str;
	*(UInt32 *)str = CFSwapInt32(t);
	for (int i = 0; i < 4; ++i) {
		if (isprint(*q) && *q != '\\')
			*p++ = *q++;
		else {
			sprintf(p, "\\x%02x", *q++);
			p += 4;
		}
	}
	*p = '\0';
	return buf;
}


-(void)setFileDescriptionForFormat: (CAStreamBasicDescription)format withName:(NSString*)name
{
	char buf[5];
	const char *dataFormat = OSTypeToStr(buf, format.mFormatID);
	NSString* description = [[NSString alloc] initWithFormat:@"(%ld ch. %s @ %g Hz)", format.NumberChannels(), dataFormat, format.mSampleRate, nil];
	mtextview.text = [mtextview.text stringByAppendingString:description];
	[description release];
}

- (void)dealloc
{
	[btn_record release];
	[btn_updata release];
	[mtextview release];
    [mVoiceArray release];
	
	delete recorder;
	
	[super dealloc];
}


@end
