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
	
}
@property (nonatomic, strong) NSString *theActivityText;
@property bool portrait;
@property (nonatomic, strong) NSData *movieData;
@property (nonatomic, strong) IBOutlet UIButton *removePhotoButton;
@property bool fromCameraSelect;
@property (nonatomic, strong) NSData *selectedImageData;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *submitActivity;

@property (nonatomic, strong) IBOutlet UILabel *errorLabel;
@property (nonatomic, strong) IBOutlet UILabel *noImageLabel;
@property (nonatomic, strong) IBOutlet UILabel *countLabel;
@property (nonatomic, strong) IBOutlet UITextField *activityText;
@property (nonatomic, strong) NSData *imageData;
@property bool stayHere;
@property (nonatomic, strong) IBOutlet UIImageView *imagePreview;
@property (nonatomic, strong) IBOutlet UIButton *submitButton;
@property (nonatomic, strong, getter = theNewPhotoButton) IBOutlet UIButton *newPhotoButton;

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
