//
//  HomeAttendanceView.h
//  rTeam
//
//  Created by Nick Wroblewski on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Home.h"

@interface HomeAttendanceView : UIViewController {

    
}
@property (nonatomic, strong) NSString *sport;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *participantRole;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) IBOutlet UIButton *goToButton;
@property (nonatomic, strong) IBOutlet UIButton *pollButton;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *yesCount;
@property (nonatomic, strong) NSString *noCount;
@property (nonatomic, strong) NSString *noReplyCount;
@property (nonatomic, strong) NSString *eventDate;
@property (nonatomic, strong) NSString *eventType;

@property (nonatomic, strong) IBOutlet UILabel *teamLabel;
@property (nonatomic, strong) IBOutlet UILabel *yesLabel;
@property (nonatomic, strong) IBOutlet UILabel *noLabel;
@property (nonatomic, strong) IBOutlet UILabel *noReplyLabel;


@property int initY;

-(void)setLabels;

-(IBAction)sendPoll;
-(IBAction)goToPage;

@end
