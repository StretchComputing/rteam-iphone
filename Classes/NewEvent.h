//
//  NewEvent.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NewEvent : UIViewController {
	
	IBOutlet UIDatePicker *startDate;
	NSString *teamId;
	
}

@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) UIDatePicker *startDate;


-(IBAction)nextScreen;
@end
