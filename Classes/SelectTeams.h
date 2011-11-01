//
//  SelectTeams.h
//  rTeam
//
//  Created by Nick Wroblewski on 10/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectTeams : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *myTableView;

@property bool isPrivate;
@property bool isPoll;
@property (nonatomic, strong) NSArray *myTeams;
@property (nonatomic, strong) NSMutableArray *rowsSelected;
@end
