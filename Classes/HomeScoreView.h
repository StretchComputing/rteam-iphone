//
//  HomeScoreView.h
//  rTeam
//
//  Created by Nick Wroblewski on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Home.h"
#import <iAd/iAd.h>

@class Home;

@interface HomeScoreView : UIViewController <UIImagePickerControllerDelegate, ADBannerViewDelegate, UINavigationControllerDelegate> {
    
}
@property (nonatomic, strong) IBOutlet UIButton *saveScoreEditButton;
@property (nonatomic, strong) IBOutlet UITextField *scoreUsTextField;
@property (nonatomic, strong) IBOutlet UITextField *scoreThemTextField;

@property (nonatomic, strong) IBOutlet UIView *frontView;
@property BOOL bannerIsVisible;
@property (nonatomic, strong) ADBannerView *myAd;

//Post Image
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) NSData *imageDataToSend;
@property (nonatomic, strong) IBOutlet UIView *postImageBackView;
@property (nonatomic, strong) IBOutlet UIView *postImageFrontView;
@property (nonatomic, strong) IBOutlet UIImageView *postImagePreview;
@property (nonatomic, strong) IBOutlet UITextField *postImageTextView;
@property (nonatomic, strong) NSString *postImageText;
@property (nonatomic, strong) IBOutlet UIButton *postImageSubmitButton;
@property (nonatomic, strong) IBOutlet UIButton *postImageCancelButton;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *postImageActivity;
@property (nonatomic, strong) IBOutlet UILabel *postImageErrorLabel;
@property (nonatomic, strong) IBOutlet UILabel *postImageLabel;

@property (nonatomic, strong) NSString *sendOrientation;

//Game Image scrolling
@property int picCount;
@property int currentImageDisplayCell;
@property bool home;
@property (nonatomic, strong) NSMutableArray *gameImageArray;
@property (nonatomic, strong) IBOutlet UIView *fullBackView;
@property (nonatomic, strong) IBOutlet UIView *imageBackView;
@property (nonatomic, strong) IBOutlet UIButton *rightButton;
@property (nonatomic, strong) IBOutlet UIButton *leftButton;
@property (nonatomic, strong) IBOutlet UIButton *imageButton;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;



@property bool isSwitch;
@property (nonatomic, strong) IBOutlet UIButton *cameraButton;
@property bool gameday;
@property (nonatomic, strong) IBOutlet UILabel *linkLabel;
@property (nonatomic, strong) IBOutlet UIView *linkLine;

@property (nonatomic, strong) NSTimer *myTimer;
@property (nonatomic, strong) IBOutlet UIButton *mapButton;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *opponent;

@property (nonatomic, strong) Home *homeSuperView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *overActivity;
@property (nonatomic, strong) IBOutlet UIButton *gameOverButton;
@property (nonatomic, strong) NSString *eventStringDate;
@property (nonatomic, strong) NSString *eventDescription;
@property (nonatomic, strong) IBOutlet UIButton *addIntervalButton;
@property (nonatomic, strong) IBOutlet UIButton *subIntervalButton;;

@property (nonatomic, strong) IBOutlet UIButton *addUsButton;
@property (nonatomic, strong) IBOutlet UIButton *addThemButton;
@property (nonatomic, strong) IBOutlet UIButton *subUsButton;
@property (nonatomic, strong) IBOutlet UIButton *subThemButton;
@property (nonatomic, strong) NSString *eventDate;
@property (nonatomic, strong) IBOutlet UIButton *goToButton;
@property (nonatomic, strong) IBOutlet UIButton *scoreButton;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *participantRole;
@property (nonatomic, strong) NSString *sport;


@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *scoreUs;
@property (nonatomic, strong) NSString *scoreThem;
@property (nonatomic, strong) NSString *interval;

@property (nonatomic, strong) IBOutlet UILabel *topLabel;
@property (nonatomic, strong) IBOutlet UILabel *usLabel;
@property (nonatomic, strong) IBOutlet UILabel *themLabel;
@property (nonatomic, strong) IBOutlet UILabel *scoreUsLabel;
@property (nonatomic, strong) IBOutlet UILabel *scoreThemLabel;
@property (nonatomic, strong) IBOutlet UILabel *intervalLabel;

@property int initY;
@property bool isFullScreen;
@property bool isKeepingScore;
@property (nonatomic, strong) IBOutlet UIButton *fullScreenButton;

-(IBAction)fullScreen;
-(void)setLabels;
-(void)doReset;

-(IBAction)goToPage;
-(IBAction)keepScore;


-(IBAction)addInterval;
-(IBAction)subInterval;
-(IBAction)addUs;
-(IBAction)addThem;
-(IBAction)subUs;
-(IBAction)subThem;

-(IBAction)gameOver;
-(IBAction)takePhoto;
-(IBAction)mapAction;

-(void)startTimer;
-(void)setNewInterval;


-(IBAction)imageSelected:(id)sender;
-(IBAction)rightButtonAction;
-(IBAction)leftButtonAction;

-(void)displayCamera;

-(IBAction)postImageCancel;
-(IBAction)postImageSubmit;

-(IBAction)endText;
-(IBAction)doneButton;
@end
