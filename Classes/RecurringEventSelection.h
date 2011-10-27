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
@property (nonatomic, strong)  UILabel *orLabel;
@property (nonatomic, strong)  UITextView *calendarLabel;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) NSString *eventType;
@property (nonatomic, strong) UIButton *calendarButton;
@property (nonatomic, strong) UITableView *myTableView;

-(IBAction)calendar;
@end
