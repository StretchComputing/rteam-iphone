//
//  GoogleAppEngine.m
//  rTeam
//
//  Created by Joseph Wroblewski on 9/13/11.
//  Copyright 2011 Stretch Computing. All rights reserved.
//

#import "GoogleAppEngine.h"
#import "JSON/JSON.h"
#import "ServerAPI.h"

static NSString *baseUrl = @"https://rskybox-stretchcom.appspot.com/rest/v1";
static NSString *basicAuthUserName = @"token";
static NSString *basicAuthToken = @"4g1l42pg7sm5o508hmg26ko183";
static NSString *applicationId = @"ahRzfnJza3lib3gtc3RyZXRjaGNvbXITCxILQXBwbGljYXRpb24Y-dIBDA";
//static NSString *baseUrl = @"http://localhost:8888/rest";

@implementation GoogleAppEngine

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (NSDictionary *)sendCrashDetect:(NSString *)summary theStackData:(NSData *)stackData theDetectedDate:(NSDate *)detectedDate theUserName:(NSString *)userName{
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
    NSString *statusReturn = @"";
    
    if (summary == nil) {
        statusReturn = @"0";
        [returnDictionary setValue:statusReturn forKey:@"status"];
        return returnDictionary;
    }
    
    @try {
        NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
        NSDictionary *loginDict = [[NSDictionary alloc] init];
        
        [tempDictionary setObject:summary forKey:@"summary"];
        [tempDictionary setObject:userName forKey:@"userName"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *detectedDateStr = [dateFormat stringFromDate:detectedDate];
        [tempDictionary setObject:detectedDateStr forKey:@"date"];
        
        if(stackData) {
            // stackData is hex and needs to be base64 encoded before packaged inside JSON
            NSString *encodedStackData = [ServerAPI encodeBase64data:stackData];
            [tempDictionary setObject:encodedStackData forKey:@"stackData"];
        }
            
        loginDict = tempDictionary;
        NSString *requestString = [NSString stringWithFormat:@"%@", [loginDict JSONFragment], nil];
        //NSLog(@"%@", requestString);
        
        NSString *tmpUrl = [baseUrl stringByAppendingFormat:@"/applications/%@/crashDetects", applicationId];
        //NSLog(@"%@", tmpUrl);
        NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:tmpUrl]];
        [request setHTTPMethod: @"POST"];
        [request setHTTPBody: requestData];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSString *basicAuth = [GoogleAppEngine getBasicAuthHeader];
        
        
        [request setValue:basicAuth forHTTPHeaderField:@"Authorization"];
                        
        NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
        
        // parse the returned JSON object
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
        
        SBJSON *jsonParser = [SBJSON new];
        NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
        
        NSString *apiStatus = [response valueForKey:@"apiStatus"];
        if ([apiStatus isEqualToString:@"100"]) {
        }
        
        statusReturn = apiStatus;
        [returnDictionary setValue:statusReturn forKey:@"status"];
        return returnDictionary;
    }
    
    @catch (NSException *e) {
        statusReturn = @"1";
        [returnDictionary setValue:statusReturn forKey:@"status"];
        return returnDictionary;
    }
}

+(NSString *)getBasicAuthHeader {
    NSString *stringToEncode = [NSString stringWithFormat:@"%@:%@", basicAuthUserName, basicAuthToken];   

    NSString *encodedAuth = [ServerAPI encodeBase64:stringToEncode];
    return encodedAuth;
}

+ (NSDictionary *)sendFeedback:(NSData *)recordedData theRecordedDate:(NSDate *)recordedDate theRecordedUserName:(NSString *)recordedUserName theInstanceUrl:(NSString *)instanceUrl{
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
    NSString *statusReturn = @"";
    
    if (recordedData == nil) {
        statusReturn = @"0";
        [returnDictionary setValue:statusReturn forKey:@"status"];
        return returnDictionary;
    }
    
    @try {
        NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
        NSDictionary *loginDict = [[NSDictionary alloc] init];
        
        // recordedData needs to be base64 encoded before packaged inside JSON
        NSString *encodedRecordedData = [ServerAPI encodeBase64data:recordedData];
        
        [tempDictionary setObject:encodedRecordedData forKey:@"voice"];
        [tempDictionary setObject:recordedUserName forKey:@"userName"];
        [tempDictionary setObject:instanceUrl forKey:@"instanceUrl"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *recordedDateStr = [dateFormat stringFromDate:recordedDate];

        [tempDictionary setObject:recordedDateStr forKey:@"date"];

        loginDict = tempDictionary;
        NSString *requestString = [NSString stringWithFormat:@"%@", [loginDict JSONFragment], nil];
        //NSLog(@"%@", requestString);
        
        NSString *tmpUrl = [baseUrl stringByAppendingFormat:@"/applications/%@/feedback", applicationId];

        //NSLog(@"%@", tmpUrl);
        NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:tmpUrl]];
        [request setHTTPMethod: @"POST"];
        [request setHTTPBody: requestData];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSString *basicAuth = [GoogleAppEngine getBasicAuthHeader];
        [request setValue:basicAuth forHTTPHeaderField:@"Authorization"];
        NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
        
        // parse the returned JSON object
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
       // NSLog(@"%@", returnString);
        SBJSON *jsonParser = [SBJSON new];
        NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
        
        NSString *apiStatus = [response valueForKey:@"apiStatus"];
        if ([apiStatus isEqualToString:@"100"]) {
        }
        
        statusReturn = apiStatus;
        [returnDictionary setValue:statusReturn forKey:@"status"];
        return returnDictionary;
    }
    
    @catch (NSException *e) {
        statusReturn = @"1";
        [returnDictionary setValue:statusReturn forKey:@"status"];
        return returnDictionary;
    }
}


+ (NSDictionary *)sendExceptionCaught:(NSException *)exception inMethod:(NSString *)methodName theRecordedDate:(NSDate *)recordedDate theRecordedUserName:(NSString *)recordedUserName theInstanceUrl:(NSString *)instanceUrl{
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
    NSString *statusReturn = @"";
    
    if (exception == nil) {
        statusReturn = @"0";
        [returnDictionary setValue:statusReturn forKey:@"status"];
        return returnDictionary;
    }
    
    @try {
        
        //NSLog(@"*************METHOD NAME: %@", methodName);
        NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
        NSDictionary *loginDict = [[NSDictionary alloc] init];
        
        [tempDictionary setObject:recordedUserName forKey:@"userName"];
        [tempDictionary setObject:instanceUrl forKey:@"instanceUrl"];
        // logLevel possible values: [debug, info, error, exception]
        [tempDictionary setObject:@"exception" forKey:@"logLevel"];
        [tempDictionary setObject:[exception reason]  forKey:@"message"];
        
        NSString *completeStackTrace = @"";
        NSArray *stackSymbols = [exception callStackSymbols];
        if(stackSymbols) {
            for (NSString *str in stackSymbols) {
                completeStackTrace = [completeStackTrace stringByAppendingFormat:@" %@", str];
            }
        }
        [tempDictionary setObject:completeStackTrace  forKey:@"stackBackTrace"];
        
        loginDict = tempDictionary;
        NSString *requestString = [NSString stringWithFormat:@"%@", [loginDict JSONFragment], nil];
        //NSLog(@"%@", requestString);
        
        NSString *tmpUrl = [baseUrl stringByAppendingFormat:@"/applications/%@/clientLogs", applicationId];
        //NSLog(@"%@", tmpUrl);
        NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:tmpUrl]];
        [request setHTTPMethod: @"POST"];
        [request setHTTPBody: requestData];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSString *basicAuth = [GoogleAppEngine getBasicAuthHeader];
        [request setValue:basicAuth forHTTPHeaderField:@"Authorization"];
        NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
        
        // parse the returned JSON object
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
        //NSLog(@"%@", returnString);
        SBJSON *jsonParser = [SBJSON new];
        NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
        
        NSString *apiStatus = [response valueForKey:@"apiStatus"];
        if ([apiStatus isEqualToString:@"100"]) {
        }
        
        statusReturn = apiStatus;
        [returnDictionary setValue:statusReturn forKey:@"status"];
        return returnDictionary;
    }
    
    @catch (NSException *e) {
        statusReturn = @"1";
        [returnDictionary setValue:statusReturn forKey:@"status"];
        return returnDictionary;
    }
}

@end
