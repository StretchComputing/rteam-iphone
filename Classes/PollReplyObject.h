//
//  PollReplyObject.h
//  iCoach
//
//  Created by Nick Wroblewski on 6/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PollReplyObject : NSObject {

	NSString *name;
	NSString *dateReplied;
	NSString *reply;
	NSString *memberId;
	NSString *teamId;
}
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *memberId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *dateReplied;
@property (nonatomic, retain) NSString *reply;
@end
