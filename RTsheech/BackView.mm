//
//  BackView.m
//  RTsheech
//
//  Created by telsafe-macpc1 on 12-11-13.
//  Copyright (c) 2012年 telsafe-macpc1. All rights reserved.
//

#import "BackView.h"

@implementation BackView
@synthesize lvlMeter_in;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.4;
        lvlMeter_in = [[AQLevelMeter alloc]initWithFrame:CGRectMake(250, 200, 512, 100)];
        UIColor *bgColor = [[UIColor alloc] initWithRed:.39 green:.44 blue:.57 alpha:.5];
        [lvlMeter_in setBackgroundColor:bgColor];
        [lvlMeter_in setBorderColor:bgColor];
        [bgColor release];
        [self addSubview:lvlMeter_in];
        
    }
    return self;
}

-(void)setVoice:(AudioQueueRef)Voice{
    [lvlMeter_in setAq:Voice];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
