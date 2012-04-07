//
//  Activity.h
//  rTeam
//
//  Created by Nick Wroblewski on 11/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Activity : NSObject {

	
}
@property bool isCurrentUser;
@property (nonatomic, strong) NSString *senderName;
@property bool isVideo;
@property (nonatomic, strong) NSString *thumbnail;
@property (nonatomic, strong) NSString *profileImage;

@property (nonatomic, strong) NSString *vote;
@property (nonatomic, strong) NSString *activityId;
@property int numLikes;
@property int numDislikes;
@property (nonatomic,strong) NSString *activityText;
@property (nonatomic,strong) NSString *createdDate;
@property (nonatomic,strong) NSString *cacheId;
@property (nonatomic,strong) NSString *teamId;
@property (nonatomic,strong) NSString *teamName;
@property (nonatomic, strong) NSArray *replies;
@property (nonatomic, strong) NSString *lastEditDate;

//game info
@property (nonatomic, strong) NSString *participantRole;
@property (nonatomic, strong) NSString *eventType;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *sport;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *description;


@end
