//
//  AddChangeProfilePic.h
//  rTeam
//
//  Created by Nick Wroblewski on 1/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AddChangeProfilePic : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate> {
    
	IBOutlet UIButton *removeButton;
	IBOutlet UIButton *addChangeButton;
	IBOutlet UIImageView *profilePic;
	IBOutlet UILabel *titleLabel;
	
	IBOutlet UILabel *loadingImageLabel;
	IBOutlet UIActivityIndicatorView *loadingImageActivity;
	
	IBOutlet UILabel *displayLabel;
	
	bool addImage;
	bool hasImage;
	NSString *imageString;
	NSData *imageData;
	
	bool fromCameraSelect;
	UIImage *selectedImage;
	
	NSString *errorString;
	IBOutlet UIActivityIndicatorView *activity;
    
    bool newImage;
    
    bool portrait;
	
}
@property bool portrait;
@property bool newImage;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong)  UIActivityIndicatorView *activity;
@property bool fromCameraSelect;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSString *imageString;
@property bool hasImage;
@property bool addImage;
@property (nonatomic, strong) UIButton *removeButton;
@property (nonatomic, strong) UIButton *addChangeButton;
@property (nonatomic, strong) UIImageView *profilePic;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *loadingImageLabel;
@property (nonatomic, strong) UIActivityIndicatorView *loadingImageActivity;

@property (nonatomic, strong) UILabel *displayLabel;

-(IBAction)remove;
-(IBAction)addChange;
-(void)getPhoto:(NSString *)option;
@end
