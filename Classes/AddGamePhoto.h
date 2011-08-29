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
@property (nonatomic, retain) NSData *movieData;
@property (nonatomic, retain) UIButton *removePhotoButton;
@property bool fromCameraSelect;
@property (nonatomic, retain) NSData *selectedImageData;
@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain) UIActivityIndicatorView *submitActivity;

@property (nonatomic, retain) UILabel *errorLabel;
@property (nonatomic, retain) UILabel *noImageLabel;
@property (nonatomic, retain) UILabel *countLabel;
@property (nonatomic, retain) UITextField *activityText;
@property (nonatomic, retain) NSData *imageData;
@property bool stayHere;
@property (nonatomic, retain) UIImageView *imagePreview;
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) UIButton *newPhotoButton;

@property (nonatomic, retain) UIActionSheet *photoAction;
@property bool hideAction;

-(IBAction)submit;
-(IBAction)newPhoto;
-(IBAction)endText;
-(IBAction)removePhoto;
-(void)getImageCamera;
-(void)getImageVideo;
-(void)getImageLibrary;

@end
