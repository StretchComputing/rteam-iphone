//
//  AddGamePhoto.h
//  rTeam
//
//  Created by Nick Wroblewski on 1/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AddGamePhoto : UIViewController <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,
UITextFieldDelegate>{
    
	bool hideAction;
	UIActionSheet *photoAction;
	
	IBOutlet UILabel *noImageLabel;
	IBOutlet UIButton *submitButton;
	IBOutlet UIButton *newPhotoButton;
	IBOutlet UIImageView *imagePreview;
	IBOutlet UIActivityIndicatorView *submitActivity;
	IBOutlet UITextField *activityText;
	
	bool stayHere;
	
	NSData *imageData;
	
	IBOutlet UILabel *countLabel;
	IBOutlet UILabel *errorLabel;
	
	NSString *errorString;
	NSString *teamId;
	
	bool fromCameraSelect;
	NSData *selectedImageData;
	UIImage *selectedImage;
	
	IBOutlet UIButton *removePhotoButton;
	
	NSData *movieData;
    
    bool portrait;
	
}
@property bool portrait;
@property (nonatomic, strong) NSData *movieData;
@property (nonatomic, strong) UIButton *removePhotoButton;
@property bool fromCameraSelect;
@property (nonatomic, strong) NSData *selectedImageData;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) UIActivityIndicatorView *submitActivity;

@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) UILabel *noImageLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UITextField *activityText;
@property (nonatomic, strong) NSData *imageData;
@property bool stayHere;
@property (nonatomic, strong) UIImageView *imagePreview;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong, getter = theNewPhotoButton) UIButton *newPhotoButton;

@property (nonatomic, strong) UIActionSheet *photoAction;
@property bool hideAction;

-(IBAction)submit;
-(IBAction)newPhoto;
-(IBAction)endText;
-(IBAction)removePhoto;
-(void)getImageCamera;
-(void)getImageVideo;
-(void)getImageLibrary;

@end
