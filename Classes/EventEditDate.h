//
//  EventEditDate.h
//  rTeam
//
//  Created by Nick Wroblewski on 10/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EventEditDate : UIViewController <UIActionSheetDelegate> {
	

}
@property (nonatomic, strong) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) NSDate* practiceDate;
@property (nonatomic, strong) IBOutlet UIDatePicker *practiceDatePicker;


-(IBAction)chooseDate;
@end
