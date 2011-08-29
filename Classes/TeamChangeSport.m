//
//  TeamChangeSport.m
//  rTeam
//
//  Created by Nick Wroblewski on 10/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TeamChangeSport.h"
#import "TeamEdit.h"

@implementation TeamChangeSport
@synthesize sport, myTableView, allSports, allMatches, errorMessage;

-(void)viewDidLoad{
	
	
	self.title = @"New Team";
	
	self.myTableView.delegate = self;
	self.myTableView.dataSource = self;
	self.allMatches = [NSMutableArray array]; 
	[self.myTableView setHidden:YES];
	self.allSports = [NSArray arrayWithObjects:@"Archery", @"Biking", @"Cycling", @"Boating", @"Bowling", @"Climbing", @"Cricket", @"Lacrosse",
					  @"Fishing", @"Golf", @"Water Polo", @"Rugby", @"Skiing", @"Sailing", @"Swimming", @"Diving", @"Surfing", 
					  @"Field Hockey", @"Broomball", @"Softball", @"Curling", @"Volleyball", @"Laser Tag", @"Paintball",  @"Ultimate Frisbee", 
					  @"Track", @"Cross Country", @"Flag Football", @"Baseball", @"Basketball", @"Hockey", @"Soccer", @"Football",
					  @"Tennis", nil];
	
	
	
}

-(void)valueChanged{
	self.allMatches = [NSMutableArray array];
	NSString *currentText = self.sport.text;
	int length = currentText.length;
	
	if (length > 0) {
		
		for (int i = 0; i < [self.allSports count]; i++) {
			
			NSString *currentSport = [self.allSports objectAtIndex:i];
			
			if (currentSport.length > length) {
				
				NSString *substring = [currentSport substringToIndex:length];
				
				// if ([currentText isEqualToString:substring]) {
				//	[self.allMatches addObject:currentSport];
				// }
				
				if ([currentText localizedCaseInsensitiveCompare:substring] == 0) {
					[self.allMatches addObject:currentSport];
				}
				
			}
		}
	}
	
	if ([self.allMatches count] > 0) {
		[self.myTableView setHidden:NO];
		[self.myTableView reloadData];
	}else {
		[self.myTableView setHidden:YES];
	}
	
	
}

-(void)selectSport{
	
	if ([self.sport.text isEqualToString:@""]) {
		self.errorMessage.text = @"*You must enter a sport.";
	}
	
	NSArray *temp = [self.navigationController viewControllers];
	int num = [temp count];
	num = num - 2;
	
	TeamEdit *cont = [temp objectAtIndex:num];
	cont.newTeamName = self.sport.text;
	[self.navigationController popToViewController:cont animated:YES];
	
}




#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	return [self.allMatches count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *FirstLevelCell=@"FirstLevelCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc]
				 initWithStyle:UITableViewCellStyleDefault
				 reuseIdentifier: FirstLevelCell] autorelease];
	}
	
	NSUInteger row = [indexPath row];
	NSString *theSport = [self.allMatches objectAtIndex:row];
	cell.textLabel.text = [@" " stringByAppendingString:theSport];
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	cell.contentView.backgroundColor = [UIColor grayColor];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 25;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
	
	NSString *value = [self.allMatches objectAtIndex:row];
	
	self.sport.text = value;
	
	NSArray *temp = [self.navigationController viewControllers];
	int num = [temp count];
	num = num - 2;
	
	TeamEdit *cont = [temp objectAtIndex:num];
	cont.newTeamName = self.sport.text;
	[self.navigationController popToViewController:cont animated:YES];
	
}


-(void)endText{
	
}

-(void)viewDidUnload{
	sport = nil;
	myTableView = nil;
	//allSports = nil;
	//allMatches = nil;
	errorMessage = nil;
	[super viewDidUnload];
}

- (void)dealloc {
	[sport release];
	[myTableView release];
	[allMatches release];
	[allSports release];
	[errorMessage release];
    [super dealloc];
}


@end

