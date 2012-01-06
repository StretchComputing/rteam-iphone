//
//  ReplyEditActivity.m
//  rTeam
//
//  Created by Nick Wroblewski on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ReplyEditActivity.h"

@implementation ReplyEditActivity
@synthesize segControl, messageText, activity, messageImage, cancelImageButton, errorLabel, isReply, originalMessage;

-(void)viewDidLoad{
    
    
    [self.messageText becomeFirstResponder];
    
    NSString *actionTitle = @"";
    if (self.isReply) {
        self.title = @"Reply";
        actionTitle = @"Send";
    }else{
        self.title = @"Edit Activity";
        actionTitle = @"Post";
        self.messageText.text = [NSString stringWithString:self.originalMessage];
    }
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
	[self.navigationItem setLeftBarButtonItem:addButton];
    
    

    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:actionTitle style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
	[self.navigationItem setRightBarButtonItem:saveButton];
}


-(void)cancelImage{
    
}

-(void)cancel{
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)submit{
    
}
-(void)viewDidUnload{
    
    segControl = nil;
    messageText = nil;
    activity = nil;
    messageImage = nil;
    cancelImageButton = nil;
    errorLabel = nil;
}
@end
