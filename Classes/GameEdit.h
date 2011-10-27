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
@property (nonatomic, strong) UIActionSheet *deleteActionSheet;

@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) NSString *errorString;
@property bool notifyTeam;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *gameId;
@property (nonatomic, strong) NSString *stringDate;
@property (nonatomic, strong) NSString *opponent;
@property (nonatomic, strong) NSString *description;

@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) UIButton *saveChanges;
@property (nonatomic, strong) UIButton *gameChangeDate;
@property (nonatomic, strong) UITextView *gameDescription;
@property (nonatomic, strong) UITextField *gameOpponent;
@property (nonatomic, strong) UILabel *gameDate;

@property (nonatomic, strong) NSDate *gameDateObject;
@property (nonatomic, strong) UILabel *errorMessage;

@property bool fromDateChange;
@property bool createSuccess;

-(IBAction)deleteGame;
-(IBAction)submit;
-(IBAction)changeDate;
-(IBAction)endText;
@end
