//
//  HomeAttendanceView.h
//  rTeam
//
//  Created by Nick Wroblewski on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HomeAttendanceView : UIViewController {

    
}
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
@property bool isFullScreen;
@property (nonatomic, strong) IBOutlet UIButton *fullScreenButton;

-(IBAction)fullScreen;
-(void)setLabels;

@end
