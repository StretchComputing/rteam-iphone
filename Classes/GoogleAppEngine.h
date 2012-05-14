//
//  GoogleAppEngine.h
//  rTeam
//
//  Created by Joseph Wroblewski on 9/13/11.
//  Copyright 2011 Stretch Computing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleAppEngine : NSObject

+ (NSDictionary *)sendCrashDetect:(NSString *)summary theStackData:(NSData *)stackData theDetectedDate:(NSDate *)detectedDate theUserName:(NSString *)userName;

+ (NSDictionary *)sendFeedback:(NSData *)recordedData theRecordedDate:(NSDate *)recordedDate theRecordedUserName:(NSString *)recordedUserName theInstanceUrl:(NSString *)instanceUrl;

//+ (NSDictionary *)sendExceptionCaught:(NSException *)exception inMethod:(NSString *)methodName theRecordedDate:(NSDate *)recordedDate theRecordedUserName:(NSString *)recordedUserName theInstanceUrl:(NSString *)instanceUrl;

+ (NSString *)getBasicAuthHeader;


+(void)sendClientLog:(NSString *)logName logMessage:(NSString *)logMessage logLevel:(NSString *)logLevel exception:(NSException *)exception;

+ (NSDictionary *)createEndUser;
@end
