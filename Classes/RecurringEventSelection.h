//
//  RecurringEventSelection.h
//  rTeam
//
//  Created by Nick Wroblewski on 1/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RecurringEventSelection : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {

	IBOutlet UIButton *calendarButton;
	IBOutlet UITableView *myTableView;
	
	NSString *eventType;
	
	IBOutlet UILabel *typeLabel;
	
	NSString *teamId;
	
	IBOutlet UILabel *orLabel;
	IBOutlet UITextView *calendarLabel;
}
@property (nonatomic, retain)  UILabel *orLabel;
@property (nonatomic, retain)  UITextView *calendarLabel;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) UILabel *typeLabel;
@property (nonatomic, retain) NSString *eventType;
@property (nonatomic, retain) UIButton *calendarButton;
@property (nonatomic, retain) UITableView *myTableView;

-(IBAction)calendar;
@end
