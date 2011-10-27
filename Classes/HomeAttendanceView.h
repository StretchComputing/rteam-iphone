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
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *yesCount;
@property (nonatomic, strong) NSString *noCount;
@property (nonatomic, strong) NSString *noReplyCount;
@property (nonatomic, strong) NSString *eventDate;
@property (nonatomic, strong) NSString *eventType;

@property (nonatomic, strong)  UILabel *teamLabel;
@property (nonatomic, strong)  UILabel *yesLabel;
@property (nonatomic, strong)  UILabel *noLabel;
@property (nonatomic, strong)  UILabel *noReplyLabel;


@property int initY;
@property bool isFullScreen;
@property (nonatomic, strong) UIButton *fullScreenButton;

-(IBAction)fullScreen;
-(void)setLabels;

@end
