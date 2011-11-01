//
//  Directions.h
//  rTeam
//
//  Created by Nick Wroblewski on 9/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Directions : UIViewController <UIActionSheetDelegate> {
	

}
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@end
