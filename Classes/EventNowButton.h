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
    

}
@property (nonatomic, strong) NSString *sport;
@property (nonatomic, strong) NSString *participantRole;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *eventId;

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
