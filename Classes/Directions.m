//
//  Directions.m
//  rTeam
//
//  Created by Nick Wroblewski on 9/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Directions.h"
#import "rTeamAppDelegate.h"
#import "FastActionSheet.h"
#import "TraceSession.h"

@implementation Directions
@synthesize webView, urlString;


-(void)viewWillAppear:(BOOL)animated{
    [TraceSession addEventToSession:@"Directions - View Will Appear"];

}
-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
	
}

-(void)viewDidLoad{
	
	self.title = @"Directions";
	//NSString *urlAddress = @"http://www.google.com";
	NSString *urlAddress = self.urlString;
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:urlAddress];
	
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	//Load the request in the UIWebView.
	[webView loadRequest:requestObj];
	
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

@end
