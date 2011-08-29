//
//  Directions.h
//  rTeam
//
//  Created by Nick Wroblewski on 9/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Directions : UIViewController <UIActionSheetDelegate> {
	
	IBOutlet UIWebView *webView;
	NSString *urlString;
}
@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) UIWebView *webView;
@end
