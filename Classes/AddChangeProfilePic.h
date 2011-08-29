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
@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain)  UIActivityIndicatorView *activity;
@property bool fromCameraSelect;
@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) NSData *imageData;
@property (nonatomic, retain) NSString *imageString;
@property bool hasImage;
@property bool addImage;
@property (nonatomic, retain) UIButton *removeButton;
@property (nonatomic, retain) UIButton *addChangeButton;
@property (nonatomic, retain) UIImageView *profilePic;
@property (nonatomic, retain) UILabel *titleLabel;

@property (nonatomic, retain) UILabel *loadingImageLabel;
@property (nonatomic, retain) UIActivityIndicatorView *loadingImageActivity;

@property (nonatomic, retain) UILabel *displayLabel;

-(IBAction)remove;
-(IBAction)addChange;
-(void)getPhoto:(NSString *)option;
@end
