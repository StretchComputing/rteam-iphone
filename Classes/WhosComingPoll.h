//
//  WhosComingPoll.h
//  rTeam
//
//  Created by Nick Wroblewski on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WhosComingPoll : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIAlertView *noCoordAlert;
@property bool isGettingEvents;
@property bool newGame;
@property (nonatomic, strong) NSString *selectedMessageThreadId;
@property (nonatomic, strong) IBOutlet UILabel *displayLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *mainActivity;
@property (nonatomic, strong) NSString *eventType;
@property (nonatomic, strong) NSString *eventId;
@property bool areNoEvents;
@property (nonatomic, strong) NSArray *teamList;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) UIBarButtonItem *sendButton;


@property (nonatomic, strong) IBOutlet UITableView *selectTable;
@property (nonatomic, strong) IBOutlet UIView *selectView;
@property (nonatomic, strong) IBOutlet UIButton *teamSelectButton;
@property (nonatomic, strong) IBOutlet UIView *currentTeamsView;
@property (nonatomic, strong) NSMutableArray *eventList;
@property (nonatomic, strong) NSDate *initialDate;
@property (nonatomic, strong) NSString *selectedTeamId;
@property (nonatomic, strong) NSString *selectedGameId;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *eventActivity;
@property (nonatomic, strong) IBOutlet UIPickerView *eventPicker;


//New Event View
@property (nonatomic, strong) IBOutlet UIView *createEventView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *createEventSegment;
@property (nonatomic, strong) IBOutlet UIDatePicker *createEventDatePicker;
@property (nonatomic, strong) IBOutlet UIButton *createEventCancelButton;
@property (nonatomic, strong) IBOutlet UIButton *createEventSubmitButton;

@property (nonatomic, strong) NSString *createEventType;
@property (nonatomic, strong) NSString *createEventDate;

-(IBAction)createEventCancel;
-(IBAction)createEventSubmit;
-(IBAction)teamSelect;
@end
