//
//  SelectTeamCal.h
//  rTeam
//
//  Created by Nick Wroblewski on 10/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"

@interface SelectTeamCal : UITableViewController {

}
@property (nonatomic, strong) NSString *singleOrMultiple;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSDate *finalDate;
@property (nonatomic, strong) NSString *event;
@property (nonatomic, strong) NSString *error;
@property (nonatomic, strong) NSArray *teams;


@end
