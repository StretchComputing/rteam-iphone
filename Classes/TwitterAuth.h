//
//  TwitterAuth.h
//  rTeam
//
//  Created by Nick Wroblewski on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TwitterAuth : UIViewController {

	IBOutlet UIWebView *webView;
	NSString *url;
    bool fromHome;
}
@property bool fromHome;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSString *url;
@end
