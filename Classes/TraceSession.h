//
//  TraceSession.h
//  rTeam
//
//  Created by Nick Wroblewski on 10/27/11.
//  Copyright (c) Stretch Computing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TraceSession : NSObject

+(void)initiateSession;
+(void)addEventToSession:(NSString *)event;
+(void)printTraceSession;
+(NSMutableArray *)getActions;
+(NSMutableArray *)getTimestamps;
+(void)setSavedArray:(NSMutableArray *)savedArray :(NSMutableArray *)savedArrayTime;
@end

