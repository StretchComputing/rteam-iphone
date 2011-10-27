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
@property (nonatomic, strong) UILabel *singleLabel;
@property (nonatomic, strong) UIButton *recurringEventButton;

@property (nonatomic, strong) UIButton *createButton;
@property (nonatomic, strong) UISegmentedControl *practiceOrGame;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) UIDatePicker *startDate;

-(IBAction)recurringEvent;
-(IBAction)nextScreen;
-(IBAction)segmentSelect:(id)sender;
@end
