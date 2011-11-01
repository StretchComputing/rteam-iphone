//
//  AttendingButton.h
//  rTeam
//
//  Created by Nick Wroblewski on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventNowButton.h"

@interface AttendingButton : EventNowButton {

}
@property bool isAttendance;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIView *tableLineTop;
@property (nonatomic, strong) UIView *tableLineBottom;
@property (nonatomic, strong) UIView *tableLineLeft;
@property (nonatomic, strong) UIView *tableLineRight;

@property (nonatomic, strong) UIView *buttonView;

@property (nonatomic, strong)UIView *tableDisplayView;
@property (nonatomic, strong)UILabel *attendingLabel;
@property (nonatomic, strong)UILabel *yesLabel;
@property (nonatomic, strong)UILabel *yesCount;
@property (nonatomic, strong)UILabel *noLabel;
@property (nonatomic, strong)UILabel *noCount;
@property (nonatomic, strong)UILabel *qLabel;
@property (nonatomic, strong)UILabel *qCount;

@property (nonatomic, strong)UIButton *pollButton;
@property (nonatomic, strong)UIButton *goToPageButton;



@end
