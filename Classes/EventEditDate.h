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
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) NSDate* practiceDate;
@property (nonatomic, strong) UIDatePicker *practiceDatePicker;


-(IBAction)chooseDate;
@end
