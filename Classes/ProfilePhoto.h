//
//  ProfilePhoto.h
//  rTeam
//
//  Created by Nick Wroblewski on 1/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ProfilePhoto : UIViewController {

}
@property (nonatomic, strong ) NSString *nameString;
@property (nonatomic, strong ) NSString *teamString;

@property (nonatomic, strong) IBOutlet UIView *backView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong)  IBOutlet UILabel *teamLabel;
@property (nonatomic, strong)  IBOutlet UIImageView *photo;

@property (nonatomic, strong) NSData *imageData;
@end
