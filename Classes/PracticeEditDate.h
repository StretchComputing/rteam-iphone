//
//  PracticeEditDate.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PracticeEditDate : UIViewController <UIActionSheetDelegate> {

}
@property (nonatomic, strong) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) NSDate* practiceDate;
@property (nonatomic, strong) IBOutlet UIDatePicker *practiceDatePicker;


-(IBAction)chooseDate;
@end