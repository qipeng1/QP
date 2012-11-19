//
//  MainSpeakViewController.m
//  RTsheech
//
//  Created by telsafe-macpc1 on 12-11-9.
//  Copyright (c) 2012年 telsafe-macpc1. All rights reserved.
//

#import "MainSpeakViewController.h"



@implementation MainSpeakViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//	// Do any additional setup after loading the view.
//}

-(BOOL)shouldAutorotate

{
    
    return YES;
    
}

-(NSUInteger)supportedInterfaceOrientations{
    
    
    
    return UIInterfaceOrientationMaskLandscape; //UIInterfaceOrientationMaskLandscape、UIInterfaceOrientationMaskAll、UIInterfaceOrientationMaskAllButUpsideDown
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return ((interfaceOrientation ==UIDeviceOrientationLandscapeLeft)||(interfaceOrientation ==UIDeviceOrientationLandscapeRight));
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
