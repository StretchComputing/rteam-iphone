//
//  PracticeAttendance.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface PracticeAttendance : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	
	NSArray *players;
	NSString *teamId;
	NSString *allSelector;
	NSString *practiceId;
	NSMutableArray *attMarker;
	NSMutableArray *attMarkerTemp;
	
	IBOutlet UIButton *saveAll;
	IBOutlet UIButton *select;
	IBOutlet UIActivityIndicatorView *activity;
	IBOutlet UILabel *successLabel;
	
	NSString *startDate;
	
	NSArray *attReport;
	
	bool attendanceInfo;
	bool saveSuccess;
	
	IBOutlet UITableView *playerTableView;
	
	NSString *successString;
	bool successNoChoices;
    
	IBOutlet UIActivityIndicatorView *attActivity;
	IBOutlet UILabel *attActivityLabel;
	
	UIActivityIndicatorView *barActivity;
	
	NSString *userRole;
	bool isCoord;
	
	IBOutlet UIView *lineView;
}
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) NSString *userRole;
@property bool isCoord;
@property (nonatomic, strong) UIActivityIndicatorView *barActivity;

@property (nonatomic, strong) UILabel *attActivityLabel;
@property (nonatomic, strong) UIActivityIndicatorView *attActivity;

@property (nonatomic, strong) NSString *successString;
@property bool successNoChoices;
@property (nonatomic, strong) UITableView *playerTableView;
@property bool saveSuccess;
@property bool attendanceInfo;
@property (nonatomic, strong) NSArray *players;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *allSelector;
@property (nonatomic, strong) NSString *practiceId;
@property (nonatomic, strong) NSMutableArray *attMarker;
@property (nonatomic, strong) NSMutableArray *attMarkerTemp;

@property (nonatomic, strong) UIButton *saveAll;
@property (nonatomic, strong) UIButton *select;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) UILabel *successLabel;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSArray *attReport;

-(void)getAttendanceInfo;

-(IBAction)selectAllNone;
-(IBAction)save;
@end
