//
//  InviteFan.h
//  rTeam
//
//  Created by Nick Wroblewski on 8/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface InviteFan : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {

}
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) IBOutlet UILabel *loadingLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *loadingActivity;
@property (nonatomic, strong) IBOutlet UILabel *error;
@property bool noRightButton;
@property (nonatomic, strong) NSMutableArray *teamArray;
@property (nonatomic, strong) NSMutableArray *teamArrayTemp;

@property (nonatomic, strong) IBOutlet UITableView *listOfTeams;


@end
