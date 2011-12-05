//
//  PracticeAttendance.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface PracticeAttendance : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
}
@property (nonatomic, strong) IBOutlet UIView *lineView;
@property (nonatomic, strong) NSString *userRole;
@property bool isCoord;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) IBOutlet UILabel *topLabel;
@property (nonatomic, strong) IBOutlet UITableView *playerTableViewPre;

@property (nonatomic, strong) UIBarButtonItem *switchButton;
@property (nonatomic, strong) UIActivityIndicatorView *barActivity;

@property (nonatomic, strong) IBOutlet UILabel *attActivityLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *attActivity;

@property bool successNoChoices;
@property (nonatomic, strong) NSString* successString;
@property (nonatomic, strong) IBOutlet UITableView *playerTableView;
@property bool saveSuccess;
@property bool attendanceInfo;
@property (nonatomic, strong) NSArray *players;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *allSelector;
@property (nonatomic, strong) NSString *practiceId;
@property (nonatomic, strong) NSMutableArray *attMarker;
@property (nonatomic, strong) NSMutableArray *attMarkerTemp;

@property (nonatomic, strong) NSMutableArray *preMarker;
@property (nonatomic, strong) NSMutableArray *preMarkerTemp;


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

