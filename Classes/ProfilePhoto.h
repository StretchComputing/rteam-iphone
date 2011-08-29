//
//  ProfilePhoto.h
//  rTeam
//
//  Created by Nick Wroblewski on 1/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ProfilePhoto : UIViewController {

	
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *teamLabel;
	IBOutlet UIImageView *photo;
	IBOutlet UIView *backView;
	
	NSData *imageData;
	NSString *nameString;
	NSString *teamString;
}
@property (nonatomic, retain ) NSString *nameString;
@property (nonatomic, retain ) NSString *teamString;

@property (nonatomic, retain) UIView *backView;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain)  UILabel *teamLabel;
@property (nonatomic, retain)  UIImageView *photo;

@property (nonatomic, retain) NSData *imageData;
@end
