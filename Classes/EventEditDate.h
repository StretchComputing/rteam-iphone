//
//  EventEditDate.h
//  rTeam
//
//  Created by Nick Wroblewski on 10/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EventEditDate : UIViewController <UIActionSheetDelegate> {
	
	NSDate *practiceDate;
	IBOutlet UIDatePicker *practiceDatePicker;
	IBOutlet UIButton *submitButton;
}
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) NSDate* practiceDate;
@property (nonatomic, retain) UIDatePicker *practiceDatePicker;


-(IBAction)chooseDate;
@end
