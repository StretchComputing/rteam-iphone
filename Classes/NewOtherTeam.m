//
//  NewOtherTeam.m
//  iCoach
//
//  Created by Nick Wroblewski on 6/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NewOtherTeam.h"
#import "NewTeam.h"
#import "rTeamAppDelegate.h"
#import "FastActionSheet.h"

@implementation NewOtherTeam
@synthesize sport, myTableView, allSports, allMatches, errorMessage, continueButton, fromHome;

-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
}

-(void)viewDidLoad{
	
	
	self.title = @"New Team";
	
	self.myTableView.delegate = self;
	self.myTableView.dataSource = self;
	self.allMatches = [NSMutableArray array]; 
	[self.myTableView setHidden:YES];
	self.myTableView.backgroundColor = [UIColor clearColor];
	self.allSports = [NSArray arrayWithObjects:@"Archery", @"Biking", @"Cycling", @"Boating", @"Bowling", @"Climbing", @"Cricket", @"Lacrosse",
					  @"Fishing", @"Golf", @"Water Polo", @"Rugby", @"Skiing", @"Sailing", @"Swimming", @"Diving", @"Surfing", 
					  @"Field Hockey", @"Broomball", @"Softball", @"Curling", @"Volleyball", @"Laser Tag", @"Paintball",  @"Ultimate Frisbee", 
					  @"Track", @"Cross Country", @"Flag Football", @"Baseball", @"Basketball", @"Hockey", @"Soccer", @"Football",
					  @"Tennis", nil];
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.continueButton setBackgroundImage:stretch forState:UIControlStateNormal];
	
	
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

-(void)nextScreen{
	
	if ([self.sport.text isEqualToString:@""]) {
		self.errorMessage.text = @"*You must enter a sport.";
	}
	
	bool tmp = [self doesMatchSport];
	
	if (!tmp) {
		//Alert the user that their entered sport doesn't match
		UIAlertView *tmp = [[UIAlertView alloc] initWithTitle:@"The sport entered did not match any in our database." message:@"Continue Anyway?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
		[tmp show];
	}else {
		NewTeam *nextController = [[NewTeam alloc] init];
		nextController.from = self.sport.text;
		nextController.other = true;
        nextController.fromHome = self.fromHome;
		[self.navigationController pushViewController:nextController animated:YES];
	}
    
	
	
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
    
    if(buttonIndex == 0) {	
        
    }else if (buttonIndex == 1) {
        
        NewTeam *nextController = [[NewTeam alloc] init];
        nextController.from = self.sport.text;
        nextController.other = true;
        nextController.fromHome = self.fromHome;
        [self.navigationController pushViewController:nextController animated:YES];
        
    }
    
}

-(bool)doesMatchSport{
	
	for (int i = 0; i < [self.allSports count]; i++) {
		
		NSString *currentSport = [self.allSports objectAtIndex:i];
		
        if ([self.sport.text localizedCaseInsensitiveCompare:currentSport] == 0) {
            return true;
        }
        
		
	}
	return false;
    
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
		cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier: FirstLevelCell];
	}
    
	NSUInteger row = [indexPath row];
	NSString *theSport = [self.allMatches objectAtIndex:row];
	cell.textLabel.text = [@" " stringByAppendingString:theSport];
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	
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
	
	
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.type == UIEventSubtypeMotionShake) {
		
		FastActionSheet *actionSheet = [[FastActionSheet alloc] init];
		actionSheet.delegate = self;
		[actionSheet showInView:self.view];
	}
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
	[FastActionSheet doAction:self :buttonIndex];
	
	
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}
-(void)endText{
	
}
-(void)viewDidUnload{
	sport = nil;
	myTableView = nil;
	allMatches = nil;
	allSports = nil;
	errorMessage = nil;
	continueButton = nil;
	[super viewDidUnload];
}



@end
