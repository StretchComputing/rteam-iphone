//
//  PollResultsView.m
//  rTeam
//
//  Created by Nick Wroblewski on 9/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PollResultsView.h"


@implementation PollResultsView
@synthesize option1, option2, option3, option4, option5, numOption1, numOption2, numOption3, numOption4, numOption5, o1, o2, o3, o4, o5,
no1, no2, no3, no4, no5;



-(void)viewDidLoad{
	
	self.option1.lineBreakMode = UILineBreakModeMiddleTruncation;
	self.option2.lineBreakMode = UILineBreakModeMiddleTruncation;
	self.option3.lineBreakMode = UILineBreakModeMiddleTruncation;
	self.option4.lineBreakMode = UILineBreakModeMiddleTruncation;
	self.option5.lineBreakMode = UILineBreakModeMiddleTruncation;

	
	if (self.o1 != nil) {
		self.option1.text = self.o1;
	}
	
	if (self.o2 != nil) {
		self.option2.text = self.o2;

	}
	
	if (self.o3 != nil) {
		self.option3.text = self.o3;
		[self.option3 setHidden:NO];
	}else {
		[self.option3 setHidden:YES];
		[self.numOption3 setHidden:YES];

	}
	
	if (self.o4 != nil) {
		self.option4.text = self.o4;
		[self.option4 setHidden:NO];
		
	}else {
		[self.option4 setHidden:YES];
		[self.numOption4 setHidden:YES];

	}
	
	if (self.o5 != nil) {
		self.option5.text = self.o5;
		[self.option5 setHidden:NO];
		
	}else {
		[self.option5 setHidden:YES];
		[self.numOption5 setHidden:YES];

	}
	
	
	if (self.no1 != nil) {
		self.numOption1.text = self.no1;
		[self.numOption1 setHidden:NO];
	}else {
		[self.numOption1 setHidden:YES];
		
	}
	
	if (self.no2 != nil) {
		self.numOption2.text = self.no2;
		[self.numOption2 setHidden:NO];
		
	}else {
		[self.numOption2 setHidden:YES];
		
	}
	
	if (self.no3 != nil) {
		self.numOption3.text = self.no3;
		[self.numOption3 setHidden:NO];
		
	}else {
		[self.numOption3 setHidden:YES];
		
	}
	
	if (self.no4 != nil) {
		self.numOption4.text = self.no4;
		[self.numOption4 setHidden:NO];
		
	}else {
		[self.numOption4 setHidden:YES];
		
	}
	
	if (self.no5 != nil) {
		self.numOption5.text = self.no5;
		[self.numOption5 setHidden:NO];
		
	}else {
		[self.numOption5 setHidden:YES];
		
	}
	
	
}

-(void)setLabels{


	
	if (self.no1 != nil) {
		self.numOption1.text = self.no1;
		[self.numOption1 setHidden:NO];
	}else {
		[self.numOption1 setHidden:YES];
		
	}
	
	if (self.no2 != nil) {
		self.numOption2.text = self.no2;
		[self.numOption2 setHidden:NO];
		
	}else {
		[self.numOption2 setHidden:YES];
		
	}
	
	if (self.no3 != nil) {
		self.numOption3.text = self.no3;
		[self.numOption3 setHidden:NO];
		
	}else {
		[self.numOption3 setHidden:YES];
		
	}
	
	if (self.no4 != nil) {
		self.numOption4.text = self.no4;
		[self.numOption4 setHidden:NO];
		
	}else {
		[self.numOption4 setHidden:YES];
		
	}
	
	if (self.no5 != nil) {
		self.numOption5.text = self.no5;
		[self.numOption5 setHidden:NO];
		
	}else {
		[self.numOption5 setHidden:YES];
		
	}
	

	if (self.o1 != nil) {
		self.option1.text = self.o1;
	}
	
	if (self.o2 != nil) {
		self.option2.text = self.o2;
		
	}
	
	if ((self.o3 != nil) & ![self.o3 isEqualToString:@""]) {
		self.option3.text = self.o3;
		[self.option3 setHidden:NO];
	}else {
		[self.option3 setHidden:YES];
		[self.numOption3 setHidden:YES];
		
	}
	
	if ((self.o4 != nil)  &&  ![self.o4 isEqualToString:@""]) {
		self.option4.text = self.o4;
		[self.option4 setHidden:NO];
		
	}else {
		[self.option4 setHidden:YES];
		[self.numOption4 setHidden:YES];
		
	}
	
	if ((self.o5 != nil) && ![self.o5 isEqualToString:@""]) {
		self.option5.text = self.o5;
		[self.option5 setHidden:NO];
		
	}else {
		[self.option5 setHidden:YES];
		[self.numOption5 setHidden:YES];
		
	}
	
}

-(void)viewDidUnload{
	
	option1 = nil;
	option2 = nil;
	option3 = nil;
	option4 = nil;
	option5 = nil;
	numOption1 = nil;
	numOption2 = nil;
	numOption3 = nil;
	numOption4 = nil;
	numOption5 = nil;
	
	/*
	o1 = nil;
	o2 = nil;
	o3 = nil;
	o4 = nil;
	o5 = nil;
	
	no1 = nil;
	no2 = nil;
	no3 = nil;
	no4 = nil;
	no5 = nil;
	 */
	
	[super viewDidUnload];
}


- (void)dealloc {
	[option1 release];
	[option2 release];
	[option3 release];
	[option4 release];
	[option5 release];
    [numOption1 release];
	[numOption2 release];
	[numOption3 release];
	[numOption4 release];
	[numOption5 release];
	
	[o1 release];
	[o2 release];
	[o3 release];
	[o4 release];
	[o5 release];
	[no1 release];
	[no2 release];
	[no3 release];
	[no4 release];
	[no5 release];
    [super dealloc];
}


@end
