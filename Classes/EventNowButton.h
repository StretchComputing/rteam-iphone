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
@property (nonatomic, retain) NSString *eventType;
@property (nonatomic, retain) NSString *eventDate;

@property (nonatomic, retain) NSString *scoreUs;
@property (nonatomic, retain) NSString *scoreThem;
@property (nonatomic, retain) NSString *interval;
@property (nonatomic, retain) NSString *teamName;

@property (nonatomic, retain) UILabel *scoreLabel;
@property (nonatomic, retain) UILabel *canceledLabel;
@property (nonatomic, retain) CurrentEvent *event;
@property (nonatomic, retain) UILabel *teamLabel;
@property (nonatomic, retain) UILabel *eventLabel;
@end
