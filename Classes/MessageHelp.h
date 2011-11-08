//
//  MessageHelp.h
//  rTeam
//
//  Created by Nick Wroblewski on 1/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface MessageHelp : UIViewController <ADBannerViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>{
	
}
@property (nonatomic, strong) ADBannerView *myAd;

@property BOOL bannerIsVisible;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@end
