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
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UITableView *playerTableViewPre;

@property (nonatomic, strong) UIBarButtonItem *switchButton;
@property (nonatomic, strong) UIActivityIndicatorView *barActivity;

@property (nonatomic, strong) UILabel *attActivityLabel;
@property (nonatomic, strong) UIActivityIndicatorView *attActivity;

@property bool successNoChoices;
@property (nonatomic, strong) NSString* successString;
@property (nonatomic, strong) UITableView *playerTableView;
@property bool saveSuccess;
@property bool attendanceInfo;
@property (nonatomic, strong) NSArray *players;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *allSelector;
@property (nonatomic, strong) NSString *gameId;
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
