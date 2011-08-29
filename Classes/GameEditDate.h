//
//  GameEditDate.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GameEditDate : UIViewController <UIActionSheetDelegate> {

	NSDate *gameDate;
	IBOutlet UIDatePicker *gameDatePicker;
	IBOutlet UIButton *submitButton;
}
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) NSDate* gameDate;
@property (nonatomic, retain) UIDatePicker *gameDatePicker;


-(IBAction)chooseDate;
@end
