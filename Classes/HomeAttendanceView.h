//
//  HomeAttendanceView.h
//  rTeam
//
//  Created by Nick Wroblewski on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HomeAttendanceView : UIViewController {
    
    IBOutlet UIButton *fullScreenButton;
    bool isFullScreen;
    int initY;
    
    //Team Name, score us, score them, interval
    NSString *teamName;
    NSString *yesCount;
    NSString *noCount;
    NSString *noReplyCount;
    NSString *eventDate;
    NSString *eventType;
    
    IBOutlet UILabel *teamLabel;
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *yesLabel;
    IBOutlet UILabel *noLabel;
    IBOutlet UILabel *noReplyLabel;

}
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) NSString *yesCount;
@property (nonatomic, retain) NSString *noCount;
@property (nonatomic, retain) NSString *noReplyCount;
@property (nonatomic, retain) NSString *eventDate;
@property (nonatomic, retain) NSString *eventType;

@property (nonatomic, retain)  UILabel *teamLabel;
@property (nonatomic, retain)  UILabel *yesLabel;
@property (nonatomic, retain)  UILabel *noLabel;
@property (nonatomic, retain)  UILabel *noReplyLabel;


@property int initY;
@property bool isFullScreen;
@property (nonatomic, retain) UIButton *fullScreenButton;

-(IBAction)fullScreen;
-(void)setLabels;

@end
