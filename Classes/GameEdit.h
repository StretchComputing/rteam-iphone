//
//  GameEdit.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GameEdit : UIViewController <UITextViewDelegate, UIActionSheetDelegate> {

	
}
@property (nonatomic, strong) NSString *theGameDescription;
@property (nonatomic, strong) NSString *theGameOpponent;

@property bool isCancel;

@property (nonatomic, strong) UIActionSheet *deleteActionSheet;

@property (nonatomic, strong) IBOutlet UIButton *deleteButton;
@property (nonatomic, strong) NSString *errorString;
@property bool notifyTeam;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *gameId;
@property (nonatomic, strong) NSString *stringDate;
@property (nonatomic, strong) NSString *opponent;
@property (nonatomic, strong) NSString *description;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, strong) IBOutlet UIButton *saveChanges;
@property (nonatomic, strong) IBOutlet UIButton *gameChangeDate;
@property (nonatomic, strong) IBOutlet UITextView *gameDescription;
@property (nonatomic, strong) IBOutlet UITextField *gameOpponent;
@property (nonatomic, strong) IBOutlet UILabel *gameDate;

@property (nonatomic, strong) NSDate *gameDateObject;
@property (nonatomic, strong) IBOutlet UILabel *errorMessage;

@property bool fromDateChange;
@property bool createSuccess;

-(IBAction)deleteGame;
-(IBAction)submit;
-(IBAction)changeDate;
-(IBAction)endText;
@end
