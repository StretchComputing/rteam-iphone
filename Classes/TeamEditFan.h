//
//  TeamEditFan.h
//  rTeam
//
//  Created by Nick Wroblewski on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TeamEditFan : UIViewController <UITextViewDelegate, UIActionSheetDelegate> {
    
    
}
@property bool fromHome;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) IBOutlet UILabel *errorLabel;
@property (nonatomic, strong) IBOutlet UIButton *deleteButton;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;



-(IBAction)deleteTeam;
@end

