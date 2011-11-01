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
	
}
@property (nonatomic, strong) NSString *theFirstName;
@property (nonatomic, strong) NSString *theLastName;
@property (nonatomic, strong) NSString *theEmail;


@property (nonatomic, strong) NSMutableArray *multipleEmailArray;
@property (nonatomic, strong) UIAlertView *multipleEmailAlert;
@property bool hideHomeButton;
@property (nonatomic, strong) NSString *errorString;
@property bool addDone;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) IBOutlet UITextField *firstName;
@property (nonatomic, strong) IBOutlet UITextField *lastName;
@property (nonatomic, strong) IBOutlet UITextField *email;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *serverProcess;
@property (nonatomic, strong) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) IBOutlet UILabel *error;
@property bool createSuccess;

-(IBAction) create;
-(IBAction)endText;
-(IBAction)showPicker:(id)sender;

@end
