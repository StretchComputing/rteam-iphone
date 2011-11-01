//
//  QuickLinkButton.h
//  rTeam
//
//  Created by Nick Wroblewski on 9/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QuickLinkButton : UIButton {
    

}

@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) UILabel *teamName;

-(void)addLabel;
@end
