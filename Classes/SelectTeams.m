//
//  SelectTeams.m
//  rTeam
//
//  Created by Nick Wroblewski on 10/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SelectTeams.h"
#import "Team.h"
#import "ActivityPost.h"
#import "SelectRecipients.h"
#import "TraceSession.h"

@implementation SelectTeams
@synthesize myTeams, myTableView, rowsSelected, isPoll, isPrivate;

-(void)viewWillAppear:(BOOL)animated{
    [TraceSession addEventToSession:@"SelectTeams - View Will Appear"];

}
- (void)viewDidLoad
{
    self.title = @"Select Team";
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    myTableView = nil;
    [super viewDidUnload];

}

-(void)save{
    
    bool anyTeams = false;
    
    for (int i = 0; i < [self.rowsSelected count]; i++) {
        
        if (![[self.rowsSelected objectAtIndex:i] isEqualToString:@""]) {
            anyTeams = true;
            break;
        }
    }
    
    if (anyTeams) {
        NSArray *viewControllers = [self.navigationController viewControllers];
        
        ActivityPost *tmp = [viewControllers objectAtIndex:[viewControllers count] - 2];
        tmp.savedTeams = true;
        tmp.selectedTeams = [NSMutableArray arrayWithArray:self.rowsSelected];
        
        [self.navigationController popToViewController:tmp animated:YES];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Select Team" message:@"You must select at least one team." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	
	return [self.myTeams count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *FirstLevelCell=@"FirstLevelCell";
	
	static NSInteger fieldTag = 1;
    static NSInteger imageTag = 2;
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier: FirstLevelCell];
		
		CGRect frame;
		frame.origin.x = 10;
		frame.origin.y = 11;
		frame.size.height = 22;
		frame.size.width = 250;
		
		UILabel *fieldLabel = [[UILabel alloc] initWithFrame:frame];
		fieldLabel.tag = fieldTag;
		[cell.contentView addSubview:fieldLabel];
        
        UIImageView *blueCheck = [[UIImageView alloc] initWithFrame:CGRectMake(275, 13, 20, 19)];
        blueCheck.image = [UIImage imageNamed:@"blueCheck.png"];
        blueCheck.tag = imageTag;
        [cell.contentView addSubview:blueCheck];
        
	}
	
	UILabel *fieldLabel = (UILabel *)[cell.contentView viewWithTag:fieldTag];
	UIImageView *blueCheck = (UIImageView *)[cell.contentView viewWithTag:imageTag];
    
    blueCheck.hidden = YES;
	fieldLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
	fieldLabel.textColor = [UIColor blackColor];
	fieldLabel.backgroundColor = [UIColor clearColor];
	NSUInteger row = [indexPath row];
    
    Team *tmpTeam = [self.myTeams objectAtIndex:row];
    
    fieldLabel.text =  tmpTeam.name;
    
    if ([[self.rowsSelected objectAtIndex:row] isEqualToString:@""]) {
        blueCheck.hidden = YES;
    }else{
        blueCheck.hidden = NO;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
	return cell;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    [TraceSession addEventToSession:@"Team Select Page - Team Selected"];

    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    
    NSUInteger row = [indexPath row];
    Team *tmpTeam = [self.myTeams objectAtIndex:row];
    
    if (self.isPrivate) {
        SelectRecipients *tmp = [[SelectRecipients alloc] init];
        tmp.teamId = tmpTeam.teamId;
        tmp.isPrivate = true;
        [self.navigationController pushViewController:tmp animated:YES];
        
    }else if (self.isPoll){
        
        SelectRecipients *tmp = [[SelectRecipients alloc] init];
        tmp.teamId = tmpTeam.teamId;
        tmp.isPoll = true;
        [self.navigationController pushViewController:tmp animated:YES];
        
    }else{
        for (int i = 0; i < [self.rowsSelected count]; i++) {
            if ([[self.rowsSelected objectAtIndex:i] isEqualToString:@"s"]) {
                [self.rowsSelected replaceObjectAtIndex:i withObject:@""];
            }
        }
        
        
        [self.rowsSelected replaceObjectAtIndex:row withObject:@"s"];
        
        
        NSArray *viewControllers = [self.navigationController viewControllers];
        
        ActivityPost *tmp = [viewControllers objectAtIndex:[viewControllers count] - 2];
        tmp.savedTeams = true;
        tmp.selectedTeams = [NSMutableArray arrayWithArray:self.rowsSelected];
        Team *tmpTeam = [self.myTeams objectAtIndex:row];
        tmp.postTeamId = [NSString stringWithString:tmpTeam.teamId];
        
        [self.navigationController popToViewController:tmp animated:YES];
    }
    
  
}



@end
