//
//  TeamPicture.h
//  rTeam
//
//  Created by Nick Wroblewski on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TeamPicture : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate> {
	
}
@property bool portrait;
@property (nonatomic, strong) NSString *toOrientation;
@property bool dontMove;
@property bool newImage;
@property (nonatomic, strong) UIView *allWhiteView;
@property (nonatomic, strong) UIActionSheet *camerActionSheet;
@property (nonatomic, strong) UIImageView *largeImageView;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;
@property bool fromCameraSelect;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSString *imageString;
@property bool hasImage;
@property bool addImage;
@property (nonatomic, strong) IBOutlet UIButton *removeButton;
@property (nonatomic, strong) IBOutlet UIButton *addChangeButton;
@property (nonatomic, strong) IBOutlet UIImageView *profilePic;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) IBOutlet UILabel *loadingImageLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *loadingImageActivity;

@property (nonatomic, strong) IBOutlet UILabel *displayLabel;

-(IBAction)remove;
-(IBAction)addChange;
-(void)getPhoto:(NSString *)option;
@end
