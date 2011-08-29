//
//  TeamUrl.h
//  rTeam
//
//  Created by Nick Wroblewski on 11/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TeamUrl : UIViewController {

	IBOutlet UIWebView *webView;
	NSString *url;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSString *url;
@end
