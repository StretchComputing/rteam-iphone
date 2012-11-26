//
//  TwitterAuth.m
//  rTeam
//
//  Created by Nick Wroblewski on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TwitterAuth.h"
#import "NewTeam.h"
#import "MyTeams.h"
#import "TraceSession.h"

@implementation TwitterAuth
@synthesize webView, url, fromHome;


-(void)viewWillAppear:(BOOL)animated{
    [TraceSession addEventToSession:@"TwitterAuth - View Will Appear"];

}
-(void)viewDidLoad{
	
	NSArray *tmp = [self.navigationController viewControllers];
	int num = [tmp count];
	
	if ([tmp[num-2] class] == [NewTeam class]) {
		[self.navigationItem setHidesBackButton:YES];
        
        NSString *title = @"";
        if (self.fromHome) {
            title = @"Home";
        }else{
            title = @"Teams";
        }
		UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:self action:@selector(goTeams)];
		[self.navigationItem setLeftBarButtonItem:backButton];
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
        
        if ([temp[num-4] class] == [MyTeams class]) {
            
            MyTeams *tmp = temp[num-4];
            [self.navigationController popToViewController:tmp animated:YES];
            
        }else if ([temp[num-5] class] == [MyTeams class]) {
            
            MyTeams *tmp = temp[num-5];
            [self.navigationController popToViewController:tmp animated:YES];
        }
    }
	
}

-(void)viewDidUnload{
	
	webView = nil;
	//url = nil;
	[super viewDidUnload];
	
}


@end
