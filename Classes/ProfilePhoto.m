//
//  ProfilePhoto.m
//  rTeam
//
//  Created by Nick Wroblewski on 1/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProfilePhoto.h"
#import "QuartzCore/QuartzCore.h"


@implementation ProfilePhoto
@synthesize nameLabel, teamLabel, photo, imageData, backView, nameString, teamString;

-(void)viewDidLoad{
	
    self.title = @"Profile";
	self.nameLabel.text = self.nameString;
	self.teamLabel.text = self.teamString;
	
	UIImage *tmpImage = [UIImage imageWithData:self.imageData];
	self.photo.image = tmpImage;
    
    if (tmpImage.size.height > tmpImage.size.width) {
        //Profile
        self.backView.frame = CGRectMake(54, 99, 212, 282);
        self.photo.frame = CGRectMake(55, 100, 210, 280);
    }else{
        self.backView.frame = CGRectMake(19, 108, 282, 210);
        self.photo.frame = CGRectMake(20, 109, 280, 210);
    }
	self.backView.layer.masksToBounds = YES;
	self.backView.layer.cornerRadius = 10.0;
	
	self.photo.layer.masksToBounds = YES;
	self.photo.layer.cornerRadius = 10.0;
}


-(void)viewDidUnload{
	
	nameLabel = nil;
	teamLabel = nil;
	photo = nil;
	backView = nil;
	[super viewDidUnload];
}


@end
