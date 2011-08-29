//
//  NewPractice.h
//  iCoach
//
//  Created by Nick Wroblewski on 4/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NewPractice : UIViewController {
	
	IBOutlet UIDatePicker *startDate;
	NSString *teamId;
	
}

@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) UIDatePicker *startDate;


-(IBAction)nextScreen;
@end
