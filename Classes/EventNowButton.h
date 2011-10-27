//
//  EventNowButton.h
//  rTeam
//
//  Created by Nick Wroblewski on 10/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrentEvent.h"

@interface EventNowButton : UIButton {
    
	CurrentEvent *event;
	UILabel *eventLabel;
	UILabel *teamLabel;
	UILabel *canceledLabel;
    UILabel *scoreLabel;
    
    NSString *scoreUs;
    NSString *scoreThem;
    NSString *interval;
    NSString *teamName;
    
    NSString *eventType;
    NSString *eventDate;
}
@property (nonatomic, strong) NSString *eventType;
@property (nonatomic, strong) NSString *eventDate;

@property (nonatomic, strong) NSString *scoreUs;
@property (nonatomic, strong) NSString *scoreThem;
@property (nonatomic, strong) NSString *interval;
@property (nonatomic, strong) NSString *teamName;

@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *canceledLabel;
@property (nonatomic, strong) CurrentEvent *event;
@property (nonatomic, strong) UILabel *teamLabel;
@property (nonatomic, strong) UILabel *eventLabel;
@end
