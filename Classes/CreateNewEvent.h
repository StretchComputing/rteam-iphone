//
//  CreateNewEvent.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CreateNewEvent : UIViewController {

	IBOutlet UISegmentedControl *selection;
	NSString *teamId;
	NSDate *eventDate;
	IBOutlet UIDatePicker *eventTime;
	IBOutlet UILabel *titleLabel;
	IBOutlet UILabel *error;
	NSArray *teamList;
	bool haveTeamList;
	bool teamListFailed;
	
	IBOutlet UIButton *createButton;
	
	IBOutlet UIButton *createMultipleButton;
	IBOutlet UILabel *createSingleLabel;
}
@property (nonatomic, retain) UIButton *createMultipleButton;
@property (nonatomic, retain) UILabel *createSingleLabel;
@property (nonatomic, retain) UIButton *createButton;
@property (nonatomic, retain) UILabel *error;
@property bool teamListFailed;
@property bool haveTeamList;
@property (nonatomic, retain) NSArray *teamList;
@property (nonatomic, retain) UISegmentedControl *selection;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSDate *eventDate;
@property (nonatomic, retain) UIDatePicker *eventTime;
@property (nonatomic, retain) UILabel *titleLabel;

-(IBAction)create;
-(IBAction)createMultiple;
-(IBAction)segmentSelect:(id)sender;

@end
