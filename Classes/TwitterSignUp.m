//
//  TwitterSignUp.m
//  rTeam
//
//  Created by Nick Wroblewski on 11/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TwitterSignUp.h"
#import "TraceSession.h"

@implementation TwitterSignUp
@synthesize webView;

-(void)viewWillAppear:(BOOL)animated{
    [TraceSession addEventToSession:@"TwitterSignUp - View Will Appear"];

}
-(void)viewDidLoad{
	
	self.title = @"Twitter Sign Up";
	NSString *urlAddress = @"https://twitter.com/signup";
	//NSString *urlAddress = self.urlString;
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:urlAddress];
	
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	//Load the request in the UIWebView.
	[webView loadRequest:requestObj];
	
}

-(void)viewDidUnload{
	
	webView = nil;
	[super viewDidUnload];
}

@end
