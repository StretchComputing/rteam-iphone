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
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) NSDate* gameDate;
@property (nonatomic, strong) UIDatePicker *gameDatePicker;


-(IBAction)chooseDate;
@end
