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
@property (nonatomic, strong) UIButton *createMultipleButton;
@property (nonatomic, strong) UILabel *createSingleLabel;
@property (nonatomic, strong) UIButton *createButton;
@property (nonatomic, strong) UILabel *error;
@property bool teamListFailed;
@property bool haveTeamList;
@property (nonatomic, strong) NSArray *teamList;
@property (nonatomic, strong) UISegmentedControl *selection;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSDate *eventDate;
@property (nonatomic, strong) UIDatePicker *eventTime;
@property (nonatomic, strong) UILabel *titleLabel;

-(IBAction)create;
-(IBAction)createMultiple;
-(IBAction)segmentSelect:(id)sender;

@end
