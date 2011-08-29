//
//  BecomeFan.h
//  rTeam
//
//  Created by Nick Wroblewski on 7/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FindTeam : UIViewController <UITableViewDelegate, UITableViewDataSource> {

	IBOutlet UITextField *teamName;
	IBOutlet UIButton *submitButton;
	IBOutlet UITableView *tableList;
	
}
@property (nonatomic, retain) UITextField *teamName;
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) UITableView *tableList;

-(IBAction)submit;
-(IBAction)endText;
@end
