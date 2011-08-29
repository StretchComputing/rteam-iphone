//
//  VideoSelection.h
//  rTeam
//
//  Created by Nick Wroblewski on 1/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>


@interface VideoSelection : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate > {
	
	bool playMovie;
	NSString *basePath;
	NSData *movieData;
}
@property (nonatomic, retain) NSData *movieData;
@property (nonatomic, retain) NSString *basePath;

@end
