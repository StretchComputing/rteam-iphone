//
//  rSkybox.h
//  rTeam
//
//  Created by Nick Wroblewski on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface rSkybox : NSObject

//rSkybox server communication methods
+ (NSDictionary *)sendCrashDetect:(NSString *)summary theStackData:(NSData *)stackData theDetectedDate:(NSDate *)detectedDate theUserName:(NSString *)userName;
+ (NSDictionary *)sendFeedback:(NSData *)recordedData theRecordedDate:(NSDate *)recordedDate theRecordedUserName:(NSString *)recordedUserName theInstanceUrl:(NSString *)instanceUrl;
+ (NSDictionary *)sendExceptionCaught:(NSException *)exception inMethod:(NSString *)methodName theRecordedDate:(NSDate *)recordedDate theRecordedUserName:(NSString *)recordedUserName theInstanceUrl:(NSString *)instanceUrl;
+ (NSString *)getBasicAuthHeader;
+ (NSDictionary *)createEndUser;


//App Actions Methods
+(void)initiateSession;
+(void)addEventToSession:(NSString *)event;
+(void)printTraceSession;
+(NSMutableArray *)getActions;
+(NSMutableArray *)getTimestamps;
+(void)setSavedArray:(NSMutableArray *)savedArray :(NSMutableArray *)savedArrayTime;

//Base64 Encoder methods
+ (NSString *)encodeBase64data:(NSData *)encodeData;
+ (NSString *)encodeBase64:(NSString *)stringToEncode;

@end
