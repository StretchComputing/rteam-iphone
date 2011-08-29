//
//  QuickLinkButton.h
//  rTeam
//
//  Created by Nick Wroblewski on 9/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QuickLinkButton : UIButton {

	NSString *teamId;
	UILabel *teamName;
}

@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) UILabel *teamName;

-(void)addLabel;
@end
