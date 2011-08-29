//
//  MyClass.h
//  rTeam
//
//  Created by Nick Wroblewski on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventNowButton.h"

@interface ScoreButton : EventNowButton {
    
    UIView *buttonView;
    
    UIView *tableDisplayView;
    UILabel *attendingLabel;
    UILabel *yesLabel;
    UILabel *yesCount;
    UILabel *noLabel;
    UILabel *noCount;
    UILabel *qLabel;
    UILabel *qCount;
    
    UIButton *pollButton;
    UIButton *goToPageButton;
    UIButton *closeButton;
    
    UIView *tableLineTop;
    UIView *tableLineBottom;
    UIView *tableLineLeft;
    UIView *tableLineRight;
    
    bool isAttendance;
}
@property bool isAttendance;
@property (nonatomic, retain) UIButton *closeButton;
@property (nonatomic, retain) UIView *tableLineTop;
@property (nonatomic, retain) UIView *tableLineBottom;
@property (nonatomic, retain) UIView *tableLineLeft;
@property (nonatomic, retain) UIView *tableLineRight;

@property (nonatomic, retain) UIView *buttonView;

@property (nonatomic, retain)UIView *tableDisplayView;
@property (nonatomic, retain)UILabel *attendingLabel;
@property (nonatomic, retain)UILabel *yesLabel;
@property (nonatomic, retain)UILabel *yesCount;
@property (nonatomic, retain)UILabel *noLabel;
@property (nonatomic, retain)UILabel *noCount;
@property (nonatomic, retain)UILabel *qLabel;
@property (nonatomic, retain)UILabel *qCount;

@property (nonatomic, retain)UIButton *pollButton;
@property (nonatomic, retain)UIButton *goToPageButton;



@end

