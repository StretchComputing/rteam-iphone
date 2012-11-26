//
//  iCoachAppDelegate.m
//  iCoach
//
//  Created by Nick Wroblewski on 10/27/09.

/*
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc.
 ("Apple") in consideration of your agreement to the following terms, and your
 use, installation, modification or redistribution of this Apple software
 constitutes acceptance of these terms.  If you do not agree with these terms,
 please do not use, install, modify or redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and subject
 to these terms, Apple grants you a personal, non-exclusive license, under
 Apple's copyrights in this original Apple software (the "Apple Software"), to
 use, reproduce, modify and redistribute the Apple Software, with or without
 modifications, in source and/or binary forms; provided that if you redistribute
 the Apple Software in its entirety and without modifications, you must retain
 this notice and the following text and disclaimers in all such redistributions
 of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may be used
 to endorse or promote products derived from the Apple Software without specific
 prior written permission from Apple.  Except as expressly stated in this notice,
 no other rights or licenses, express or implied, are granted by Apple herein,
 including but not limited to any patent rights that may be infringed by your
 derivative works or by other works in which the Apple Software may be
 incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
 WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
 WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
 COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR
 DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF
 CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF
 APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2009 Apple Inc. All Rights Reserved.*/

#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "MyViewController.h"
#import "ServerAPI.h"
#import "Reachability.h"
#import "GANTracker.h"
#import "GoogleAppEngine.h"
#import "TraceSession.h"
#import <CrashReporter/CrashReporter.h>
#import "UIDevice-Hardware.h"

@implementation rTeamAppDelegate

@synthesize window;
@synthesize navController, dataFilePath, token, registered, pushToken, startNew, quickLinkOne, quickLinkTwo, quickLinkOneName, quickLinkTwoName, quickLinkOneImage, quickLinkTwoImage, displayedConnectionError, returnHome, displayName, phoneOnlyArray, justAddName, showSwipeAlert, crashSummary, crashUserName, crashDetectDate, crashStackData, crashInstanceUrl, lastTwenty, lastTwentyTime, messageImageDictionary, replyDictionary, lastPostTeamId, showCreateAlert, firstName, lastName, emailAddress, phoneNumber;

- (id) init {

    [TraceSession initiateSession];

	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *logChecklist = [NSMutableDictionary dictionary];
    
    if ([standardUserDefaults valueForKey:@"logChecklist"] == nil) {
        [standardUserDefaults setObject:logChecklist forKey:@"logChecklist"];
    }

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = paths[0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"teams.dat"];
    [self setDataFilePath:path];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
    self.showSwipeAlert = @"true";
    self.showCreateAlert = @"true";
	if([fileManager fileExistsAtPath:dataFilePath]){
		//open it and read it
		NSMutableData *theData;
		NSKeyedUnarchiver *decoder;
		NSString *tempToken = @"";
		NSString *tempLinkOne = @"";
		NSString *tempLinkTwo = @"";
		NSString *tempLinkOneName = @"";
		NSString *tempLinkTwoName = @"";
		NSString *tempLinkOneImage = @"";
		NSString *tempLinkTwoImage = @"";
        NSString *tmpSwipeAlert = @"";
        NSString *tmpCreateAlert = @"";
        NSString *tempLastTwenty = @"";
        NSString *tempLastTwentyTime = @"";
        NSString *tmpLastPostTeamId = @"";
        
        NSString *tmpFirstName = @"";
        NSString *tmpLastName = @"";
        NSString *tmpEmailAddress = @"";
        NSString *tmpPhoneNumber = @"";




		
		theData = [NSData dataWithContentsOfFile:dataFilePath];
		decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:theData];
		tempToken = [decoder decodeObjectForKey:@"token"];
		tempLinkOne = [decoder decodeObjectForKey:@"quickLinkOne"];
		tempLinkTwo = [decoder decodeObjectForKey:@"quickLinkTwo"];
		tempLinkOneName = [decoder decodeObjectForKey:@"quickLinkOneName"];
		tempLinkTwoName = [decoder decodeObjectForKey:@"quickLinkTwoName"];
		tempLinkOneImage = [decoder decodeObjectForKey:@"quickLinkOneImage"];
		tempLinkTwoImage = [decoder decodeObjectForKey:@"quickLinkTwoImage"];
        tmpSwipeAlert = [decoder decodeObjectForKey:@"showSwipeAlert"];
        tmpCreateAlert = [decoder decodeObjectForKey:@"showCreateAlert"];

        tempLastTwenty = [decoder decodeObjectForKey:@"lastTwenty"];
        tempLastTwentyTime = [decoder decodeObjectForKey:@"lastTwentyTime"];
        tmpLastPostTeamId = [decoder decodeObjectForKey:@"lastPostTeamId"];
        
        tmpFirstName = [decoder decodeObjectForKey:@"firstName"];
        tmpLastName = [decoder decodeObjectForKey:@"lastName"];
        tmpEmailAddress = [decoder decodeObjectForKey:@"emailAddress"];
        tmpPhoneNumber = [decoder decodeObjectForKey:@"phoneNumber"];






        
		[self setQuickLinkOne:tempLinkOne];
		[self setQuickLinkTwo:tempLinkTwo];
		[self setQuickLinkOneName:tempLinkOneName];
		[self setQuickLinkTwoName:tempLinkTwoName];
		[self setQuickLinkOneImage:tempLinkOneImage];
		[self setQuickLinkTwoImage:tempLinkTwoImage];
		[self setToken:tempToken];
        [self setShowSwipeAlert:tmpSwipeAlert];
        [self setShowCreateAlert:tmpCreateAlert];
        
        [self setFirstName:tmpFirstName];
        [self setLastName:tmpLastName];
        [self setEmailAddress:tmpEmailAddress];
        [self setPhoneNumber:tmpPhoneNumber];

        [self setLastPostTeamId:tmpLastPostTeamId];

        
        [self setLastTwenty:tempLastTwenty];
        [self setLastTwentyTime:tempLastTwentyTime];
        
        @try {
            
            if ([self.lastTwenty length] > 0) {
                //Set the trace session array
                NSMutableArray *tmpTraceArray = [NSMutableArray arrayWithArray:[self.lastTwenty componentsSeparatedByString:@","]];

                NSMutableArray *tmpTraceTimeArray = [NSMutableArray arrayWithArray:[self.lastTwentyTime componentsSeparatedByString:@","]];

                NSMutableArray *tmpDateArray = [NSMutableArray array];

                for (int i = 0; i < [tmpTraceTimeArray count]; i++) {
                    NSString *tmpTime = tmpTraceTimeArray[i];
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss.SSS"];
                    NSDate *theDate = [dateFormatter dateFromString:tmpTime];
                    
                    [tmpDateArray addObject:theDate];
                }
                
                [TraceSession setSavedArray:tmpTraceArray :tmpDateArray];
                
            }

        }
        @catch (NSException *exception) {
           
        }
      
        
               
        
		[decoder finishDecoding];
        
		bool reset = false;
        
		if (reset) {
			self.token = @"";
			self.quickLinkOne = @"create";
			self.quickLinkOneName = @"";
			self.quickLinkTwo = @"";
			self.quickLinkTwoName = @"";
			self.quickLinkOneImage = @"";
			self.quickLinkTwoImage = @"";
            self.showSwipeAlert = @"true";
            self.showCreateAlert = @"true";
            self.lastPostTeamId = @"";
            self.firstName = @"";
            self.lastName = @"";
            self.emailAddress = @"";
            self.phoneNumber = @"";
		}
	} else {
		self.token = @"";
	}
    
	displayedConnectionError = NO;
    
	initChange = false;
    
    self.messageImageDictionary = [NSMutableDictionary dictionary];
    self.replyDictionary = [NSMutableDictionary dictionary];

    
	return self;
	
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
	

    [TraceSession addEventToSession:@"Application Finished Loading"];

    
    [[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-280128-4"
                                           dispatchPeriod:10
                                                 delegate:nil];
    
	if ([launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey] != nil) {
		[self.navController dismissModalViewControllerAnimated:NO];
		[self.navController popToRootViewControllerAnimated:NO];
        
	}
    
	
    // Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
    // method "reachabilityChanged" will be called. 
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
	
	hostReach = [Reachability reachabilityWithHostName: @"www.rteamtest.appspot.com"];
	//[hostReach startNotifier];
	//[self updateInterfaceWithReachability: hostReach];
	
    
    internetReach = [Reachability reachabilityForInternetConnection];
	[internetReach startNotifier];
	[self updateInterfaceWithReachability: internetReach];
	
    wifiReach = [Reachability reachabilityForLocalWiFi];
	//[wifiReach startNotifier];
	//[self updateInterfaceWithReachability: wifiReach];

    
	@try {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge
                                                                               | UIRemoteNotificationTypeSound)];
    }
    @catch (NSException *exception) {
        if (self.token == nil) {
            self.token = @"";
        }

        
        [GoogleAppEngine sendClientLog:@"rTeamAppDelegate.m - didFinishLaunchingWithOptions"logMessage:[exception reason] logLevel:@"exception" exception:exception];

        
    }
	
    
    
    // JPW added to integrate PLCrashDetector
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    NSError *error;
    
    /* Check if we previously crashed */
    if ([crashReporter hasPendingCrashReport]) {
        
        [self handleCrashReport];
    }

    if (![crashReporter enableCrashReporterAndReturnError: &error]){
        //NSLog(@"*************************Warning: Could not enable crash reporter: %@", error);
    }
    
    
    // Override point for customization after application launch
	[window addSubview: navController.view];
	[window makeKeyAndVisible];
    
	return YES;
   
}


/**
 * Called to handle a pending crash report.
 */
- (void) handleCrashReport {
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    NSData *crashData;
    NSError *error;
    self.crashDetectDate = [NSDate date];
    self.crashStackData = nil;
    self.crashUserName = mainDelegate.token;
    //self.crashInstanceUrl = mainDelegate.sncurl;
    
    /* Try loading the crash report */
    bool isNil = false;
    crashData = [crashReporter loadPendingCrashReportDataAndReturnError: &error];
    if (crashData == nil) {
        //NSLog(@"Could not load crash report: %@", error);
        isNil = true;
    }
    
    if (!isNil) {
        /* We could send the report from here, but we'll just print out
         * some debugging info instead */
        PLCrashReport *report = [[PLCrashReport alloc] initWithData: crashData error: &error];
        bool thisIsNil = false;
        if (report == nil) {
            self.crashSummary = @"Could not parse crash report";
            //NSLog(@"%@", self.crashSummary);
            [self performSelectorInBackground:@selector(sendCrashDetect) withObject:nil];
            thisIsNil = true;
        }
        
        if (!thisIsNil) {
            
            @try {
                if (![[GANTracker sharedTracker] trackEvent:@"action"
                                                     action:@"Crash Reported"
                                                      label:mainDelegate.token
                                                      value:-1
                                                  withError:nil]) {
                }
                
                NSString *platform = [[UIDevice currentDevice] platformString];

                // NSLog(@"Crashed on %@", report.systemInfo.timestamp);
                self.crashSummary = [NSString stringWithFormat:@"Crashed with signal=%@, app version=%@, os version=%@, hardware=%@", report.signalInfo.name,
                                     report.applicationInfo.applicationVersion, report.systemInfo.operatingSystemVersion, platform];
                // NSLog(@"%@", self.crashSummary);
                
                self.crashStackData = [crashReporter loadPendingCrashReportDataAndReturnError: &error];
                
                // send crash detect to GAE
                [self performSelectorInBackground:@selector(sendCrashDetect) withObject:nil];
            }
            @catch (NSException *exception) {
                if (self.token == nil) {
                    self.token = @"";
                }
            
                   [GoogleAppEngine sendClientLog:@"rTeamAppDelegate.m - handleCrashReport" logMessage:[exception reason] logLevel:@"exception" exception:exception];
            }
          
         
        }else{
            [crashReporter purgePendingCrashReport];
            return;
        }
        
    }else{
        [crashReporter purgePendingCrashReport];
        return;
    }
    
    
    
    
}

-(void)sendCrashDetect {
  
    @autoreleasepool {
        // send crash detect to GAE

        
        [GoogleAppEngine sendCrashDetect:self.crashSummary theStackData:self.crashStackData theDetectedDate:self.crashDetectDate theUserName:self.crashUserName];
        
        
        PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
        
        [crashReporter purgePendingCrashReport];
        
    }
    
    
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	
    [TraceSession addEventToSession:@"Application Received Remote Notification"];

    
	NSDictionary *aps = [userInfo valueForKey:@"aps"];
	
	NSString *alertMessage;
    
	alertMessage = [aps valueForKey:@"alert"];
    
	
	if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
		//App is running
        
        @try {
            if ([alertMessage isEqualToString:@""] || (alertMessage == nil)) {
                alertMessage = @"To view your message, go to the Activity screen, and swipe to the 'Me' page.";
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Message" message:alertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];

        }
        @catch (NSException *exception) {
            if (self.token == nil) {
                self.token = @"";
            }
        
            
             [GoogleAppEngine sendClientLog:@"rTeamAppDelegate.m - didReceiveRemoteNotification" logMessage:[exception reason] logLevel:@"exception" exception:exception];
        }
        
     		
	}else {
		[self.navController dismissModalViewControllerAnimated:NO];
		[self.navController popToRootViewControllerAnimated:NO];
	}
    
	
	
}

-(void)applicationDidBecomeActive:(UIApplication *)application{
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:@"/app_opened"
                                         withError:&error]) {
        // Handle error here
    }
    
    
    [self performSelectorInBackground:@selector(createEndUser) withObject:nil];
    
}

-(void)createEndUser{
    @autoreleasepool {
        [GoogleAppEngine createEndUser];
    }
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
}


// Delegation methods
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    self.registered = YES;
    //[ServerAPI sendProviderDeviceToken:devToken]; 
	self.pushToken = devToken;
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
}

- (void) applicationWillTerminate:(UIApplication *)application {
	
	NSMutableData *theData;
	NSKeyedArchiver *encoder;
	
	theData = [NSMutableData data];
	encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
	
	[encoder encodeObject:token forKey:@"token"];
	[encoder encodeObject:quickLinkOne forKey:@"quickLinkOne"];
	[encoder encodeObject:quickLinkTwo forKey:@"quickLinkTwo"];
	[encoder encodeObject:quickLinkOneName forKey:@"quickLinkOneName"];
	[encoder encodeObject:quickLinkTwoName forKey:@"quickLinkTwoName"];
	[encoder encodeObject:quickLinkOneImage forKey:@"quickLinkOneImage"];
	[encoder encodeObject:quickLinkTwoImage forKey:@"quickLinkTwoImage"];
    [encoder encodeObject:showSwipeAlert forKey:@"showSwipeAlert"];
    [encoder encodeObject:showCreateAlert forKey:@"showCreateAlert"];

    [encoder encodeObject:lastTwenty forKey:@"lastTwenty"];
    [encoder encodeObject:lastTwentyTime forKey:@"lastTwentyTime"];
    [encoder encodeObject:lastPostTeamId forKey:@"lastPostTeamId"];
    
    
    [encoder encodeObject:firstName forKey:@"firstName"];
    [encoder encodeObject:lastName forKey:@"lastName"];
    [encoder encodeObject:emailAddress forKey:@"emailAddress"];
    [encoder encodeObject:phoneNumber forKey:@"phoneNumber"];






	[encoder finishEncoding];
    
	
	[theData writeToFile:dataFilePath atomically:YES];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	
    [TraceSession addEventToSession:@"User Closed App"];

    
	//Set the badge number as we leave the App
	
	NSDictionary *response = [ServerAPI getMessageThreadCount:self.token :@"" :@"" :@"" :@"true"];
    
	if ([[response valueForKey:@"status"] isEqualToString:@"100"]) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[response valueForKey:@"count"] intValue]];
	}
	
	
	NSMutableData *theData;
	NSKeyedArchiver *encoder;
	
	theData = [NSMutableData data];
	encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
	
	[encoder encodeObject:token forKey:@"token"];
	[encoder encodeObject:quickLinkOne forKey:@"quickLinkOne"];
	[encoder encodeObject:quickLinkTwo forKey:@"quickLinkTwo"];
	[encoder encodeObject:quickLinkOneName forKey:@"quickLinkOneName"];
	[encoder encodeObject:quickLinkTwoName forKey:@"quickLinkTwoName"];
	[encoder encodeObject:quickLinkOneImage forKey:@"quickLinkOneImage"];
	[encoder encodeObject:quickLinkTwoImage forKey:@"quickLinkTwoImage"];
    [encoder encodeObject:showSwipeAlert forKey:@"showSwipeAlert"];
    [encoder encodeObject:showCreateAlert forKey:@"showCreateAlert"];

    [encoder encodeObject:lastTwenty forKey:@"lastTwenty"];
    [encoder encodeObject:lastTwentyTime forKey:@"lastTwentyTime"];
    [encoder encodeObject:lastPostTeamId forKey:@"lastPostTeamId"];

    [encoder encodeObject:firstName forKey:@"firstName"];
    [encoder encodeObject:lastName forKey:@"lastName"];
    [encoder encodeObject:emailAddress forKey:@"emailAddress"];
    [encoder encodeObject:phoneNumber forKey:@"phoneNumber"];

	[encoder finishEncoding];
	
	
	[theData writeToFile:dataFilePath atomically:YES];
	
}


-(void)saveUserInfo{
	
	NSMutableData *theData;
	NSKeyedArchiver *encoder;
	
	theData = [NSMutableData data];
	encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
	
	[encoder encodeObject:token forKey:@"token"];
	[encoder encodeObject:quickLinkOne forKey:@"quickLinkOne"];
	[encoder encodeObject:quickLinkTwo forKey:@"quickLinkTwo"];
	[encoder encodeObject:quickLinkOneName forKey:@"quickLinkOneName"];
	[encoder encodeObject:quickLinkTwoName forKey:@"quickLinkTwoName"];
	[encoder encodeObject:quickLinkOneImage forKey:@"quickLinkOneImage"];
	[encoder encodeObject:quickLinkTwoImage forKey:@"quickLinkTwoImage"];
    [encoder encodeObject:showSwipeAlert forKey:@"showSwipeAlert"];
    [encoder encodeObject:showCreateAlert forKey:@"showCreateAlert"];

    [encoder encodeObject:lastTwenty forKey:@"lastTwenty"];
    [encoder encodeObject:lastTwentyTime forKey:@"lastTwentyTime"];
    [encoder encodeObject:lastPostTeamId forKey:@"lastPostTeamId"];

    [encoder encodeObject:firstName forKey:@"firstName"];
    [encoder encodeObject:lastName forKey:@"lastName"];
    [encoder encodeObject:emailAddress forKey:@"emailAddress"];
    [encoder encodeObject:phoneNumber forKey:@"phoneNumber"];

	[encoder finishEncoding];
	
	
	[theData writeToFile:dataFilePath atomically:YES];
	
}


-(void)applicationWillEnterForeground:(UIApplication *)application {
    
    [TraceSession addEventToSession:@"User Opened App"];

}



//Alert the user if the network is not initally reachable when the app loads, or any time the network changes from
// Reachable to NotReachable.
- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    if(curReach == internetReach)
	{
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        //BOOL connectionRequired= [curReach connectionRequired];
		
		switch (netStatus)
		{
			case NotReachable:
			{
                
                NSString *message = @"An internet connection is required for this app.  Please make sure you are connected to the internet to continue.";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Lost" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
				break;
			}
				
			case ReachableViaWWAN:
			{
                
				break;
			}
			case ReachableViaWiFi:
			{
				
				break;
			}
		}
	}
    
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
    @try {
        Reachability* curReach = [note object];
        NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
        
        [self updateInterfaceWithReachability: curReach];
    }
    @catch (NSException *exception) {
        
    }
 
	
}




//On memory warning, reset the image dictionarys to free up memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
        
    @try {
        self.replyDictionary = [NSMutableDictionary dictionary];
        self.messageImageDictionary = [NSMutableDictionary dictionary];
        //[[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidReceiveMemoryWarningNotification object: [UIApplication sharedApplication]];
    }
    @catch (NSException *exception) {
        if (self.token == nil) {
            self.token = @"";
        }
        
         [GoogleAppEngine sendClientLog:@"rTeamAppDelegate.m - applicationDidReceiveMemoryWarning" logMessage:[exception reason] logLevel:@"exception" exception:exception];

    }
  
    
}

@end