//
//  GameEdit.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GameEdit : UIViewController <UITextViewDelegate, UIActionSheetDelegate> {

	IBOutlet UIActivityIndicatorView *activity;
	IBOutlet UIButton *saveChanges;
	IBOutlet UITextField *gameOpponent;
	IBOutlet UILabel *gameDate;
	IBOutlet UITextView *gameDescription;
	IBOutlet UIButton *gameChangeDate;
	
	NSString *teamId;
	NSString *gameId;
	NSString *stringDate;
	NSString *opponent;
	NSString *description;
	
	NSDate *gameDateObject;
	
	bool fromDateChange;
	bool createSuccess;
	
	IBOutlet UILabel *errorMessage;
	
	bool notifyTeam;
	NSString *errorString;
	IBOutlet UIButton *deleteButton;
	
	UIActionSheet *deleteActionSheet;
	
	bool isCancel;
	
}
@property (nonatomic, retain) UIActionSheet *deleteActionSheet;

@property (nonatomic, retain) UIButton *deleteButton;
@property (nonatomic, retain) NSString *errorString;
@property bool notifyTeam;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *gameId;
@property (nonatomic, retain) NSString *stringDate;
@property (nonatomic, retain) NSString *opponent;
@property (nonatomic, retain) NSString *description;

@property (nonatomic, retain) UIActivityIndicatorView *activity;
@property (nonatomic, retain) UIButton *saveChanges;
@property (nonatomic, retain) UIButton *gameChangeDate;
@property (nonatomic, retain) UITextView *gameDescription;
@property (nonatomic, retain) UITextField *gameOpponent;
@property (nonatomic, retain) UILabel *gameDate;

@property (nonatomic, retain) NSDate *gameDateObject;
@property (nonatomic, retain) UILabel *errorMessage;

@property bool fromDateChange;
@property bool createSuccess;

-(IBAction)deleteGame;
-(IBAction)submit;
-(IBAction)changeDate;
-(IBAction)endText;
@end
