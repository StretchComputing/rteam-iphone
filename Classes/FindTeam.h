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
@property (nonatomic, strong) UITextField *teamName;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UITableView *tableList;

-(IBAction)submit;
-(IBAction)endText;
@end
