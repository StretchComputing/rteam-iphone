//
//  InviteFan2.h
//  rTeam
//
//  Created by Nick Wroblewski on 8/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface InviteFan2 : UIViewController <ABPeoplePickerNavigationControllerDelegate, UIActionSheetDelegate>{

	IBOutlet UITextField *firstName;
	IBOutlet UITextField *lastName;
	IBOutlet UITextField *email;

	NSString *errorString;
	
	NSString *teamId;
	IBOutlet UIActivityIndicatorView *serverProcess;
	IBOutlet UIButton *submitButton;
	IBOutlet UILabel *error;
	bool createSuccess;
	
	
	NSString *userRole;
	bool addDone;
	bool hideHomeButton;
	
    NSMutableArray *multipleEmailArray;
    UIAlertView *multipleEmailAlert;

	
}
@property (nonatomic, retain) NSMutableArray *multipleEmailArray;
@property (nonatomic, retain) UIAlertView *multipleEmailAlert;
@property bool hideHomeButton;
@property (nonatomic, retain) NSString *errorString;
@property bool addDone;
@property (nonatomic, retain) NSString *userRole;
@property (nonatomic, retain) UITextField *firstName;
@property (nonatomic, retain) UITextField *lastName;
@property (nonatomic, retain) UITextField *email;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) UIActivityIndicatorView *serverProcess;
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) UILabel *error;
@property bool createSuccess;

-(IBAction) create;
-(IBAction)endText;
-(IBAction)showPicker:(id)sender;

@end
