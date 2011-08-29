//
//  TwitterHelp.h
//  rTeam
//
//  Created by Nick Wroblewski on 12/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface TwitterHelp : UIViewController <ADBannerViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>{
	
	IBOutlet UIScrollView *scrollView;
	ADBannerView *myAd;
	BOOL bannerIsVisible;
}
@property BOOL bannerIsVisible;
@property (nonatomic, retain) UIScrollView *scrollView;
@end
