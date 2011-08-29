//
//  Activity.h
//  rTeam
//
//  Created by Nick Wroblewski on 11/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Activity : NSObject {

	NSString *activityText;
	NSString *createdDate;
	NSString *cacheId;
	NSString *teamId;
	NSString *teamName;
	NSString *activityId;
	
	NSString *vote;   //like, dislike, none
	
	NSString *thumbnail;
	
	int numLikes;
	int numDislikes;
	
	bool isVideo;
	
}
@property bool isVideo;
@property (nonatomic, retain) NSString *thumbnail;
@property (nonatomic, retain) NSString *vote;
@property (nonatomic, retain) NSString *activityId;
@property int numLikes;
@property int numDislikes;
@property (nonatomic,retain) NSString *activityText;
@property (nonatomic,retain) NSString *createdDate;
@property (nonatomic,retain) NSString *cacheId;
@property (nonatomic,retain) NSString *teamId;
@property (nonatomic,retain) NSString *teamName;


@end
