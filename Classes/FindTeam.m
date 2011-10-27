//
//  BecomeFan.m
//  rTeam
//
//  Created by Nick Wroblewski on 7/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FindTeam.h"


@implementation FindTeam
@synthesize teamName, submitButton, tableList;

-(void)viewDidLoad{
	
	self.title = @"Find A Team:";
	self.tableList.delegate = self;
	self.tableList.dataSource = self;
	
	[self.tableList setHidden:YES];
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	//self.select.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
	[self.submitButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
}

-(void)submit{
	
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	//return [self.allMatches count];
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *FirstLevelCell=@"FirstLevelCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier: FirstLevelCell];
	}
	
	//NSUInteger row = [indexPath row];
    
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 25;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//NSUInteger row = [indexPath row];
	
    
	
	
}

-(void)endText{
	
}

-(void)viewDidUnload{
	teamName = nil;
	submitButton = nil;
	tableList = nil;
}


@end
