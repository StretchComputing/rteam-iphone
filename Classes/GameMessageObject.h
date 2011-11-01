//
//  GameMessageObject.h
//  rTeam
//
//  Created by Nick Wroblewski on 1/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GameMessageObject : NSObject {

}
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *threadId;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *messageDate;

@property (nonatomic, strong) NSString *senderName;
@property (nonatomic, strong) NSString *senderId;
@end
