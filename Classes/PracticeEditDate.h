//
//  PracticeEditDate.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PracticeEditDate : UIViewController <UIActionSheetDelegate> {
	
	NSDate *practiceDate;
	IBOutlet UIDatePicker *practiceDatePicker;
	IBOutlet UIButton *submitButton;
}
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) NSDate* practiceDate;
@property (nonatomic, strong) UIDatePicker *practiceDatePicker;


-(IBAction)chooseDate;
@end