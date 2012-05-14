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
#import "TraceSession.h"
#import "rTeamAppDelegate.h"
#import "UIDevice-Hardware.h"

static NSString *baseUrl = @"https://rskybox-stretchcom.appspot.com/rest/v1";
static NSString *basicAuthUserName = @"token";
static NSString *basicAuthToken = @"f59gi8rd80kl3sm94j4hpj33eg";
static NSString *applicationId = @"ahRzfnJza3lib3gtc3RyZXRjaGNvbXITCxILQXBwbGljYXRpb24Y9agCDA";
static NSString *versionNumber = @"3.1";

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
        [tempDictionary setObject:versionNumber forKey:@"version"];

        
        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        NSString *dateString = [dateFormat stringFromDate:today];
        
        [tempDictionary setObject:dateString forKey:@"date"];

        
        
        if(stackData) {
            // stackData is hex and needs to be base64 encoded before packaged inside JSON
            NSString *encodedStackData = [ServerAPI encodeBase64data:stackData];
            [tempDictionary setObject:encodedStackData forKey:@"stackData"];
        }
            
        //Adding the last 20 actions
        NSMutableArray *finalArray = [NSMutableArray array];
        NSMutableArray *appActions = [NSMutableArray arrayWithArray:[TraceSession getActions]];
        NSMutableArray *appTimestamps = [NSMutableArray arrayWithArray:[TraceSession getTimestamps]];
        
        
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
        NSString *basicAuth = [GoogleAppEngine getBasicAuthHeader];
        
        
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
        
        if (recordedUserName == nil) {
            recordedUserName = @"";
        }
        
        NSString *encodedRecordedData = [ServerAPI encodeBase64data:recordedData];
        
        [tempDictionary setObject:encodedRecordedData forKey:@"voice"];
        [tempDictionary setObject:recordedUserName forKey:@"userName"];
        [tempDictionary setObject:versionNumber forKey:@"version"];

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

//logName -> methodName
//logMessage -> [exception reason]
//logLevel = logLevel
//username = Fname Lname, email, phone
//userId = token


+(void)sendClientLog:(NSString *)logName logMessage:(NSString *)logMessage logLevel:(NSString *)logLevel exception:(NSException *)exception{

    @try {
        
        NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
        NSDictionary *loginDict = [[NSDictionary alloc] init];
        
        //Fill parameter dictionary from input method parameters
        [tempDictionary setObject:logName  forKey:@"logName"];
        [tempDictionary setObject:logLevel forKey:@"logLevel"];
        [tempDictionary setObject:logMessage forKey:@"message"];
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *username = [NSString stringWithFormat:@"%@ %@, %@, %@", mainDelegate.firstName, mainDelegate.lastName, mainDelegate.emailAddress, mainDelegate.phoneNumber];

        [tempDictionary setObject:username forKey:@"userName"];
        [tempDictionary setObject:mainDelegate.token forKey:@"userId"];

        //HardCoded at top of page
        [tempDictionary setObject:versionNumber forKey:@"version"];

        //Get the device and platform information, and add to a summary string
        float version = [[[UIDevice currentDevice] systemVersion] floatValue]; 
        NSString *platform = [[UIDevice currentDevice] platformString];
        NSString *summaryString = [NSString stringWithFormat:@"iOS Version: %f, Device: %@, App Version: %@", version, platform, versionNumber];
        [tempDictionary setObject:summaryString forKey:@"summary"];
        
        //Send in the current date
        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        NSString *dateString = [dateFormat stringFromDate:today];
        
        [tempDictionary setObject:dateString forKey:@"date"];
        
        //If its an exception, send in the stackBackTrace in an array
        if (exception != nil) {
            NSMutableArray *stackTraceArray = [NSMutableArray array];
            NSArray *stackSymbols = [exception callStackSymbols];
            if(stackSymbols) {
                for (NSString *str in stackSymbols) {
                    
                    [stackTraceArray addObject:str];
                    
                }
            }
            
            [tempDictionary setObject:stackTraceArray  forKey:@"stackBackTrace"];
        }
        
        
        
        //Adding the App Actions
        NSMutableArray *finalArray = [NSMutableArray array];
        NSMutableArray *appActions = [NSMutableArray arrayWithArray:[TraceSession getActions]];
        NSMutableArray *appTimestamps = [NSMutableArray arrayWithArray:[TraceSession getTimestamps]];
        
        
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
        
        //Make the call to the server
        NSString *requestString = [NSString stringWithFormat:@"%@", [loginDict JSONFragment], nil];
                
        NSString *tmpUrl = [baseUrl stringByAppendingFormat:@"/applications/%@/clientLogs", applicationId];

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
        
        NSString *logStatus = [response valueForKey:@"logStatus"];
        NSString *apiStatus = [response valueForKey:@"apiStatus"];
        
        if (![apiStatus isEqualToString:@"100"]) {
            //NSLog(@"Send Client Log Failed.");
        }

        
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *logChecklist = [NSMutableDictionary dictionaryWithDictionary:[standardUserDefaults valueForKey:@"logChecklist"]];
        
        //If the log is b
        if ([logStatus isEqualToString:@"inactive"]) {
            
            [logChecklist setObject:@"off" forKey:logName];
            [standardUserDefaults setObject:logChecklist forKey:@"logChecklist"];
            
            
        }
      
    }
    
    @catch (NSException *e) {
        
    }

    
}

/*
+ (NSDictionary *)sendExceptionCaught:(NSException *)exception inMethod:(NSString *)methodName theRecordedDate:(NSDate *)recordedDate theRecordedUserName:(NSString *)recordedUserName theInstanceUrl:(NSString *)instanceUrl{
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
    NSString *statusReturn = @"";
    
    
    if (exception == nil) {
        statusReturn = @"0";
        [returnDictionary setValue:statusReturn forKey:@"status"];
        return returnDictionary;
    }
    
    @try {
        
        NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
        NSDictionary *loginDict = [[NSDictionary alloc] init];
        
        [tempDictionary setObject:recordedUserName forKey:@"userName"];
        [tempDictionary setObject:methodName  forKey:@"logName"];

        [tempDictionary setObject:@"exception" forKey:@"logLevel"];
        [tempDictionary setObject:[exception reason]  forKey:@"message"];
        [tempDictionary setObject:versionNumber forKey:@"version"];
        
        float version = [[[UIDevice currentDevice] systemVersion] floatValue]; 

        NSString *platform = [[UIDevice currentDevice] platformString];
            
        NSString *summaryString = [NSString stringWithFormat:@"iOS Version: %f, Device: %@, App Version: %@", version, platform, versionNumber];
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
        NSMutableArray *appActions = [NSMutableArray arrayWithArray:[TraceSession getActions]];
        NSMutableArray *appTimestamps = [NSMutableArray arrayWithArray:[TraceSession getTimestamps]];
        
        
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
        NSString *basicAuth = [GoogleAppEngine getBasicAuthHeader];
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
*/

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
        [tempDictionary setObject:versionNumber forKey:@"version"];
        
    
      
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
