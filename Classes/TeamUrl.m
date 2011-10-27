//
//  TeamUrl.m
//  rTeam
//
//  Created by Nick Wroblewski on 11/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TeamUrl.h"


@implementation TeamUrl
@synthesize webView, url;

-(void)viewDidLoad{
	
	self.title = @"Team Home Pgae";
	
	NSString *urlAddress = self.url;
	//Create a URL object.
	NSURL *newUrl = [NSURL URLWithString:urlAddress];
	
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:newUrl];
	
	//Load the request in the UIWebView.
	[webView loadRequest:requestObj];
	
}


-(void)viewDidUnload{
	
	webView = nil;
	//url = nil;
	[super viewDidUnload];
	
}


@end
