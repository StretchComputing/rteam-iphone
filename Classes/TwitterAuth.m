//
//  TwitterAuth.m
//  rTeam
//
//  Created by Nick Wroblewski on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TwitterAuth.h"
#import "TeamsTabs.h"
#import "NewTeam.h"

@implementation TwitterAuth
@synthesize webView, url, fromHome;

-(void)viewDidLoad{
	
	NSArray *tmp = [self.navigationController viewControllers];
	int num = [tmp count];
	
	if ([[tmp objectAtIndex:num-2] class] == [NewTeam class]) {
		[self.navigationItem setHidesBackButton:YES];
        
        NSString *title = @"";
        if (self.fromHome) {
            title = @"Home";
        }else{
            title = @"Teams";
        }
		UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:self action:@selector(goTeams)];
		[self.navigationItem setLeftBarButtonItem:backButton];
		[backButton release];
	}
	
	
	self.title = @"Twitter";
	NSString *urlAddress = self.url;
	//Create a URL object.
	
	NSURL *url1 = [NSURL URLWithString:urlAddress];
	
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url1];
	
	//Load the request in the UIWebView.
	[webView loadRequest:requestObj];
	
}

-(void)goTeams{
	
	NSArray *temp = [self.navigationController viewControllers];
	int num = [temp count];
	
    if (self.fromHome){
        
        [self.navigationController dismissModalViewControllerAnimated:YES];
    }else{
        
        if ([[temp objectAtIndex:num-4] class] == [TeamsTabs class]) {
            
            TeamsTabs *tmp = [temp objectAtIndex:num-4];
            [self.navigationController popToViewController:tmp animated:YES];
            
        }else if ([[temp objectAtIndex:num-5] class] == [TeamsTabs class]) {
            
            TeamsTabs *tmp = [temp objectAtIndex:num-5];
            [self.navigationController popToViewController:tmp animated:YES];
        }
    }
	
}

-(void)viewDidUnload{
	
	webView = nil;
	//url = nil;
	[super viewDidUnload];
	
}

-(void)dealloc{
	
	[webView release];
	[url release];
	[super dealloc];
}

@end
