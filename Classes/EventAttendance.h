//
//  EventAttendance.h
//  rTeam
//
//  Created by Nick Wroblewski on 10/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EventAttendance : UIViewController <UITableViewDelegate, UITableViewDataSource> {

}
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) IBOutlet UIView *lineView;
@property (nonatomic, strong) NSString *userRole;
@property bool isCoord;

@property (nonatomic, strong) UIActivityIndicatorView *barActivity;

@property (nonatomic, strong) IBOutlet UILabel *attActivityLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *attActivity;

@property (nonatomic, strong) NSString *successString;
@property bool successNoChoices;
@property (nonatomic, strong) IBOutlet UITableView *playerTableView;
@property bool saveSuccess;
@property bool attendanceInfo;
@property (nonatomic, strong) NSArray *players;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *allSelector;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSMutableArray *attMarker;
@property (nonatomic, strong) NSMutableArray *attMarkerTemp;

@property (nonatomic, strong) IBOutlet UIButton *saveAll;
@property (nonatomic, strong) IBOutlet UIButton *select;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, strong) IBOutlet UILabel *successLabel;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSArray *attReport;

-(void)getAttendanceInfo;

-(IBAction)selectAllNone;
-(IBAction)save;
@end
