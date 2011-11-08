//
//  NewGamePractice.h
//  rTeam
//
//  Created by Nick Wroblewski on 9/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NewGamePractice : UIViewController <UIActionSheetDelegate> {
	

	
}
@property (nonatomic, strong) IBOutlet UILabel *singleLabel;
@property (nonatomic, strong) IBOutlet UIButton *recurringEventButton;

@property (nonatomic, strong) IBOutlet UIButton *createButton;
@property (nonatomic, strong) IBOutlet UISegmentedControl *practiceOrGame;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) IBOutlet  UIDatePicker *startDate;

-(IBAction)recurringEvent;
-(IBAction)nextScreen;
-(IBAction)segmentSelect:(id)sender;
@end
