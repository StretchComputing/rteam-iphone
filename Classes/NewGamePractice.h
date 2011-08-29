//
//  NewGamePractice.h
//  rTeam
//
//  Created by Nick Wroblewski on 9/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NewGamePractice : UIViewController <UIActionSheetDelegate> {
	
	IBOutlet UIDatePicker *startDate;
	IBOutlet UISegmentedControl *practiceOrGame;
	NSString *teamId;
	
	IBOutlet UIButton *createButton;
	IBOutlet UIButton *recurringEventButton;
	
	IBOutlet UILabel *singleLabel;
	
}
@property (nonatomic, retain) UILabel *singleLabel;
@property (nonatomic, retain) UIButton *recurringEventButton;

@property (nonatomic, retain) UIButton *createButton;
@property (nonatomic, retain) UISegmentedControl *practiceOrGame;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) UIDatePicker *startDate;

-(IBAction)recurringEvent;
-(IBAction)nextScreen;
-(IBAction)segmentSelect:(id)sender;
@end
