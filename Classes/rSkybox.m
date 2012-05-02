//
//  rSkybox.m
//  rTeam
//
//  Created by Nick Wroblewski on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "rSkybox.h"
#import "rTeamAppDelegate.h"
#import "JSON/JSON.h"
#import "UIDevice-Hardware.h"
#import "Encoder.h"


static NSString *baseUrl = @"https://rskybox-stretchcom.appspot.com/rest/v1";
static NSString *basicAuthUserName = @"token";
static NSString *basicAuthToken = @"f59gi8rd80kl3sm94j4hpj33eg";
static NSString *applicationId = @"ahRzfnJza3lib3gtc3RyZXRjaGNvbXITCxILQXBwbGljYXRpb24Y9agCDA";


@implementation rSkybox


+ (NSDictionary *)sendCrashDetect:(NSString *)summary theStackData:(NSData *)stackData theDetectedDate:(NSDate *)detectedDate theUserName:(NSString *)userName{
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
    NSString *statusReturn = @"";
    
    if (userName == nil) {
        userName = @"";
    }
    
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
        [tempDictionary setObject:@"3.1" forKey:@"version"];
        
        
        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        NSString *dateString = [dateFormat stringFromDate:today];
        
        [tempDictionary setObject:dateString forKey:@"date"];
        
        
        
        if(stackData) {
            // stackData is hex and needs to be base64 encoded before packaged inside JSON
            NSString *encodedStackData = [rSkybox encodeBase64data:stackData];
            [tempDictionary setObject:encodedStackData forKey:@"stackData"];
        }
        
        //Adding the last 20 actions
        NSMutableArray *finalArray = [NSMutableArray array];
        NSMutableArray *appActions = [NSMutableArray arrayWithArray:[rSkybox getActions]];
        NSMutableArray *appTimestamps = [NSMutableArray arrayWithArray:[rSkybox getTimestamps]];
        
        
        for (int i = 0; i < [appActions count]; i++) {
            NSMutableDictionary *actDictionary = [NSMutableDictionary dictionary];
            
            [actDictionary setObject:[appActions objectAtIndex:i] forKey:@"description"];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
            NSString *dateString = [dateFormat stringFromDate:[appTimestamps objectAtIndex:i]];
            
            [actDictionary setObject:dateString forKey:@"timestamp"];
            
            [finalArray addObject:actDictionary];
            
        }
        
        [tempDictionary setObject:finalArray forKey:@"appActions"];
        
        loginDict = tempDictionary;
        NSString *requestString = [NSString stringWithFormat:@"%@", [loginDict JSONFragment], nil];
        //NSLog(@"%@", requestString);
        
        NSString *tmpUrl = [baseUrl stringByAppendingFormat:@"/applications/%@/crashDetects", applicationId];
        // NSLog(@"%@", tmpUrl);
        NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:tmpUrl]];
        [request setHTTPMethod: @"POST"];
        [request setHTTPBody: requestData];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSString *basicAuth = [rSkybox getBasicAuthHeader];
        
        
        [request setValue:basicAuth forHTTPHeaderField:@"Authorization"];
        
        NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
        
        // parse the returned JSON object
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
        
        //NSLog(@"ReturnString Crash: %@", returnString);
        
        
        SBJSON *jsonParser = [SBJSON new];
        NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
        
        NSString *apiStatus = [response valueForKey:@"apiStatus"];
        if ([apiStatus isEqualToString:@"100"]) {
            
        }else{
            
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
    
    NSString *encodedAuth = [rSkybox encodeBase64:stringToEncode];
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
        
        if (recordedUserName == nil) {
            recordedUserName = @"";
        }
        
        NSString *encodedRecordedData = [rSkybox encodeBase64data:recordedData];
        
        [tempDictionary setObject:encodedRecordedData forKey:@"voice"];
        [tempDictionary setObject:recordedUserName forKey:@"userName"];
        [tempDictionary setObject:@"3.1" forKey:@"version"];
        
        //[tempDictionary setObject:instanceUrl forKey:@"instanceUrl"];
        
        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        NSString *dateString = [dateFormat stringFromDate:today];
        
        [tempDictionary setObject:dateString forKey:@"date"];
        
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
        NSString *basicAuth = [rSkybox getBasicAuthHeader];
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
        [tempDictionary setObject:methodName  forKey:@"logName"];
        
        [tempDictionary setObject:@"exception" forKey:@"logLevel"];
        [tempDictionary setObject:[exception reason]  forKey:@"message"];
        [tempDictionary setObject:@"3.1" forKey:@"version"];
        
        float version = [[[UIDevice currentDevice] systemVersion] floatValue]; 
        
        NSString *platform = [[UIDevice currentDevice] platformString];
        
        NSString *summaryString = [NSString stringWithFormat:@"iOS Version: %f, Device: %@, App Version: %@", version, platform, @"3.1"];
        [tempDictionary setObject:summaryString forKey:@"summary"];
        
        
        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        NSString *dateString = [dateFormat stringFromDate:today];
        
        [tempDictionary setObject:dateString forKey:@"date"];
        
        NSMutableArray *stackTraceArray = [NSMutableArray array];
        NSArray *stackSymbols = [exception callStackSymbols];
        if(stackSymbols) {
            for (NSString *str in stackSymbols) {
                
                [stackTraceArray addObject:str];
                
            }
        }
        
        [tempDictionary setObject:stackTraceArray  forKey:@"stackBackTrace"];
        
        
        //Adding the last 20 actions
        NSMutableArray *finalArray = [NSMutableArray array];
        NSMutableArray *appActions = [NSMutableArray arrayWithArray:[rSkybox getActions]];
        NSMutableArray *appTimestamps = [NSMutableArray arrayWithArray:[rSkybox getTimestamps]];
        
        
        for (int i = 0; i < [appActions count]; i++) {
            NSMutableDictionary *actDictionary = [NSMutableDictionary dictionary];
            
            [actDictionary setObject:[appActions objectAtIndex:i] forKey:@"description"];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
            NSString *dateString = [dateFormat stringFromDate:[appTimestamps objectAtIndex:i]];
            
            
            [actDictionary setObject:dateString forKey:@"timestamp"];
            
            
            [finalArray addObject:actDictionary];
            
        }
        
        [tempDictionary setObject:finalArray forKey:@"appActions"];        
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
        NSString *basicAuth = [rSkybox getBasicAuthHeader];
        [request setValue:basicAuth forHTTPHeaderField:@"Authorization"];
        NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
        
        // parse the returned JSON object
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
        
        // NSLog(@"Return String Log: %@", returnString);
        
        SBJSON *jsonParser = [SBJSON new];
        NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
        
        NSString *apiStatus = [response valueForKey:@"apiStatus"];
        NSString *logStatus = [response valueForKey:@"logStatus"];
        
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *logChecklist = [NSMutableDictionary dictionaryWithDictionary:[standardUserDefaults valueForKey:@"logChecklist"]];
        
        if ([logStatus isEqualToString:@"inactive"]) {
            
            [logChecklist setObject:@"off" forKey:methodName];
            [standardUserDefaults setObject:logChecklist forKey:@"logChecklist"];
            
            
        }
        
        
        
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

+ (NSDictionary *)createEndUser{
    
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
    NSString *statusReturn = @"";
    
    
    @try {
        
        //NSLog(@"*************METHOD NAME: %@", methodName);
        NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
        NSDictionary *loginDict = [[NSDictionary alloc] init];
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [tempDictionary setObject:mainDelegate.token forKey:@"userName"];
        [tempDictionary setObject:@"rTeam" forKey:@"application"];
        [tempDictionary setObject:@"3.1" forKey:@"version"];
        
        
        
        loginDict = tempDictionary;
        NSString *requestString = [NSString stringWithFormat:@"%@", [loginDict JSONFragment], nil];
        // NSLog(@"%@", requestString);
        
        NSString *tmpUrl = [baseUrl stringByAppendingFormat:@"/applications/%@/endUsers", applicationId];
        //NSLog(@"%@", tmpUrl);
        NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:tmpUrl]];
        [request setHTTPMethod: @"POST"];
        [request setHTTPBody: requestData];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSString *basicAuth = [rSkybox getBasicAuthHeader];
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



//Maximum number of App Actions to save
#define NUMBER_EVENTS_STORED 20


static NSMutableArray *traceSession;
static NSMutableArray *traceTimeStamps;



//App Actions Methods
+(void)initiateSession{
    
    traceSession = [NSMutableArray array];
    traceTimeStamps = [NSMutableArray array];
    
}

+(void)addEventToSession:(NSString *)event{
    
    NSDate *myDate = [NSDate date];
    
    if ([traceSession count] < NUMBER_EVENTS_STORED) {
        [traceSession addObject:event];
        [traceTimeStamps addObject:myDate];
    }else{
        [traceSession removeObjectAtIndex:0];
        [traceSession addObject:event];
        [traceTimeStamps removeObject:0];
        [traceTimeStamps addObject:myDate];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss.SSS"];
    
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *tmpTrace = @"";
    NSString *tmpTraceTime = @"";
    
    
    for (int i = 0; i < [traceSession count]; i++) {
        
        if (i == ([traceSession count] - 1)) {
            tmpTrace = [tmpTrace stringByAppendingFormat:@"%@", [traceSession objectAtIndex:i]];
            
            tmpTraceTime = [tmpTraceTime stringByAppendingFormat:@"%@", [dateFormatter stringFromDate:[traceTimeStamps objectAtIndex:i]]];
            
        }else{
            tmpTrace = [tmpTrace stringByAppendingFormat:@"%@,", [traceSession objectAtIndex:i]];
            tmpTraceTime = [tmpTraceTime stringByAppendingFormat:@"%@,", [dateFormatter stringFromDate:[traceTimeStamps objectAtIndex:i]]];
            
        }
    }
    
    mainDelegate.lastTwenty = [NSString stringWithString:tmpTrace];
    mainDelegate.lastTwentyTime = [NSString stringWithString:tmpTraceTime];
    [mainDelegate saveUserInfo];
    
}

+(NSMutableArray *)getActions{
    
    return [NSMutableArray arrayWithArray:traceSession];
}

+(NSMutableArray *)getTimestamps{
    return [NSMutableArray arrayWithArray:traceTimeStamps];
    
}

+(void)setSavedArray:(NSMutableArray *)savedArray :(NSMutableArray *)savedArrayTime{
    
    traceSession = [NSMutableArray arrayWithArray:savedArray];
    traceTimeStamps = [NSMutableArray arrayWithArray:savedArrayTime];
}

+(void)printTraceSession{
    
    
    for (int i = 0; i < [traceSession count]; i++) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss.SSS"];
        NSString *dateString = [dateFormatter stringFromDate:[traceTimeStamps objectAtIndex:i]];
        
        NSLog(@"%d: %@ - %@", i, [traceSession objectAtIndex:i], dateString);
    }
    
}


//Base64 Encoder methods
+ (NSString *)encodeBase64data:(NSData *)encodeData{
	
    @try {
        //NSData *encodeData = [stringToEncode dataUsingEncoding:NSUTF8StringEncoding]
        char encodeArray[500000];
        
        memset(encodeArray, '\0', sizeof(encodeArray));
        
        // Base64 Encode username and password
        encode([encodeData length], (char *)[encodeData bytes], sizeof(encodeArray), encodeArray);
        NSString *dataStr = [NSString stringWithCString:encodeArray length:strlen(encodeArray)];
        
        // NSString *dataStr = [NSString stringWithCString:encodeArray encoding:NSUTF8StringEncoding];
        
        NSString *encodedString =[@"" stringByAppendingFormat:@"%@", dataStr];
        
        
        return encodedString;
    }
    @catch (NSException *e) {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        [rSkybox sendExceptionCaught:e inMethod:@"encodeBase64 - Data" theRecordedDate:[NSDate date] theRecordedUserName:mainDelegate.token theInstanceUrl:@""];
        
        return @"";
    }
    
    
}

+ (NSString *)encodeBase64:(NSString *)stringToEncode{
	
    @try {
        NSData *encodeData = [stringToEncode dataUsingEncoding:NSUTF8StringEncoding];
        char encodeArray[512];
        
        memset(encodeArray, '\0', sizeof(encodeArray));
        
        // Base64 Encode username and password
        encode([encodeData length], (char *)[encodeData bytes], sizeof(encodeArray), encodeArray);
        
        NSString *dataStr = [NSString stringWithCString:encodeArray length:strlen(encodeArray)];
        
        NSString *encodedString =[@"" stringByAppendingFormat:@"Basic %@", dataStr];
        
        return encodedString;
    }
    @catch (NSException *e) {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        [rSkybox sendExceptionCaught:e inMethod:@"encodeBase64 - String" theRecordedDate:[NSDate date] theRecordedUserName:mainDelegate.token theInstanceUrl:@""];
        
        return @"";
    }
    
}

@end




