//
//  Fans.h
//  rTeam
//
//  Created by Nick Wroblewski on 8/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fans : UIViewController <UITableViewDataSource, UITableViewDelegate> {

}
@property (nonatomic, strong) NSMutableArray *fanPics;
@property (nonatomic, strong) IBOutlet UITableView *fanTable;
@property (nonatomic, strong) IBOutlet UILabel *fanActivityLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *fanActivity;
@property (nonatomic, strong) UIActivityIndicatorView *barActivity;

@property (nonatomic, strong) NSString *error;
@property (nonatomic, strong) NSString *currentMemberId;
@property (nonatomic, strong) UIImageView *currentIcon;
@property (nonatomic, strong) NSArray *fans;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *userRole;
@end
