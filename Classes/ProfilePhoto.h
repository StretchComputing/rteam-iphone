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
@property (nonatomic, strong ) NSString *nameString;
@property (nonatomic, strong ) NSString *teamString;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong)  UILabel *teamLabel;
@property (nonatomic, strong)  UIImageView *photo;

@property (nonatomic, strong) NSData *imageData;
@end
