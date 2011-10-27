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
@property (nonatomic, strong) NSMutableArray *multipleEmailArray;
@property (nonatomic, strong) UIAlertView *multipleEmailAlert;
@property bool hideHomeButton;
@property (nonatomic, strong) NSString *errorString;
@property bool addDone;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) UITextField *firstName;
@property (nonatomic, strong) UITextField *lastName;
@property (nonatomic, strong) UITextField *email;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) UIActivityIndicatorView *serverProcess;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UILabel *error;
@property bool createSuccess;

-(IBAction) create;
-(IBAction)endText;
-(IBAction)showPicker:(id)sender;

@end
