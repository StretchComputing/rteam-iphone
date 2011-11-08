//
//  GameEditDate.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GameEditDate : UIViewController <UIActionSheetDelegate> {
   
}
@property (nonatomic, strong) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) NSDate* gameDate;
@property (nonatomic, strong) IBOutlet UIDatePicker *gameDatePicker;


-(IBAction)chooseDate;
@end
