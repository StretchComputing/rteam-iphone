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
@property bool isVideo;
@property (nonatomic, strong) NSString *thumbnail;
@property (nonatomic, strong) NSString *vote;
@property (nonatomic, strong) NSString *activityId;
@property int numLikes;
@property int numDislikes;
@property (nonatomic,strong) NSString *activityText;
@property (nonatomic,strong) NSString *createdDate;
@property (nonatomic,strong) NSString *cacheId;
@property (nonatomic,strong) NSString *teamId;
@property (nonatomic,strong) NSString *teamName;


@end
