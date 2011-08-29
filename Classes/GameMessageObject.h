//
//  GameMessageObject.h
//  rTeam
//
//  Created by Nick Wroblewski on 1/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GameMessageObject : NSObject {

	NSString *threadId;
	NSString *teamId;
	NSString *subject;
	
	NSString *body;
	NSString *status;
	NSString *messageDate;
	
	NSString *senderName;
	NSString *senderId;
	
	NSString *teamName;
}
@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *threadId;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *messageDate;

@property (nonatomic, retain) NSString *senderName;
@property (nonatomic, retain) NSString *senderId;
@end
