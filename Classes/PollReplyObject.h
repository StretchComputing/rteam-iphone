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
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *dateReplied;
@property (nonatomic, strong) NSString *reply;
@end
