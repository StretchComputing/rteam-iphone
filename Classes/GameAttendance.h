//
//  GameAttendance.h
//  iCoach
//
//  Created by Nick Wroblewski on 4/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GameAttendance : UIViewController <UITableViewDelegate, UITableViewDataSource> {

	NSArray *players;
	NSString *teamId;
	NSString *allSelector;
	NSString *gameId;
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
    IBOutlet UITableView *playerTableViewPre;
	
	NSString *successString;
	bool successNoChoices;

	
	IBOutlet UIActivityIndicatorView *attActivity;
	IBOutlet UILabel *attActivityLabel;
	
	UIActivityIndicatorView *barActivity;
    
    UIBarButtonItem *switchButton;
    IBOutlet UILabel *topLabel;
}
@property (nonatomic, retain) UILabel *topLabel;
@property (nonatomic, retain) UITableView *playerTableViewPre;

@property (nonatomic, retain) UIBarButtonItem *switchButton;
@property (nonatomic, retain) UIActivityIndicatorView *barActivity;

@property (nonatomic, retain) UILabel *attActivityLabel;
@property (nonatomic, retain) UIActivityIndicatorView *attActivity;

@property bool successNoChoices;
@property (nonatomic, retain) NSString* successString;
@property (nonatomic, retain) UITableView *playerTableView;
@property bool saveSuccess;
@property bool attendanceInfo;
@property (nonatomic, retain) NSArray *players;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *allSelector;
@property (nonatomic, retain) NSString *gameId;
@property (nonatomic, retain) NSMutableArray *attMarker;
@property (nonatomic, retain) NSMutableArray *attMarkerTemp;


@property (nonatomic, retain) UIButton *saveAll;
@property (nonatomic, retain) UIButton *select;
@property (nonatomic, retain) UIActivityIndicatorView *activity;
@property (nonatomic, retain) UILabel *successLabel;
@property (nonatomic, retain) NSString *startDate;
@property (nonatomic, retain) NSArray *attReport;

-(void)getAttendanceInfo;

-(IBAction)selectAllNone;
-(IBAction)save;
@end
