//
//  AddMemberHelp.h
//  rTeam
//
//  Created by Nick Wroblewski on 11/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface AddMemberHelp : UIViewController <ADBannerViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
	
}
@property (nonatomic, strong) ADBannerView *myAd;

@property BOOL bannerIsVisible;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@end