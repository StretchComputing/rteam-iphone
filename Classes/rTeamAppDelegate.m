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

@implementation rTeamAppDelegate

@synthesize window;
@synthesize navController, dataFilePath, token, registered, pushToken, startNew, quickLinkOne, quickLinkTwo, quickLinkOneName, quickLinkTwoName, quickLinkOneImage, quickLinkTwoImage, displayedConnectionError, returnHome, displayName, phoneOnlyArray, justAddName, showSwipeAlert, crashSummary, crashUserName, crashDetectDate, crashStackData;

- (id) init {
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"teams.dat"];
    [self setDataFilePath:path];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
    self.showSwipeAlert = @"true";
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

        
		[self setQuickLinkOne:tempLinkOne];
		[self setQuickLinkTwo:tempLinkTwo];
		[self setQuickLinkOneName:tempLinkOneName];
		[self setQuickLinkTwoName:tempLinkTwoName];
		[self setQuickLinkOneImage:tempLinkOneImage];
		[self setQuickLinkTwoImage:tempLinkTwoImage];
		[self setToken:tempToken];
        [self setShowSwipeAlert:tmpSwipeAlert];
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
		}
	} else {
		self.token = @"";
	}
    
	displayedConnectionError = NO;
    
	initChange = false;
	return self;
	
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
	
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
	
	
	// Override point for customization after application launch
	[window addSubview: navController.view];
	[window makeKeyAndVisible];
    
	
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge
                                                                           | UIRemoteNotificationTypeSound)];
    
    /////////////////////////
    // Test Code for rSkyBox
    /////////////////////////
//    self.crashSummary = @"Joe is testing the crash data being sent to GAE";
//    self.crashDetectDate = [NSDate date];
//    self.crashUserName = @"wrobjx2";
//    
//    NSString *myString = @"0123456789ABCDEF";
//    const char *utfString = [myString UTF8String];
//    self.crashStackData = [NSData dataWithBytes:utfString length:strlen(utfString)];
//    
//    [self performSelectorInBackground:@selector(sendCrashDetect) withObject:nil];
    //////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////

    
	return YES;
    
	
}

-(void)sendCrashDetect {
    
    @autoreleasepool {
        // send crash detect to GAE
        [GoogleAppEngine sendCrashDetect:self.crashSummary theStackData:self.crashStackData theDetectedDate:self.crashDetectDate theUserName:self.crashUserName];
        
    }
    
    
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	
	NSDictionary *aps = [userInfo valueForKey:@"aps"];
	
	NSString *alertMessage;
    
	alertMessage = [aps valueForKey:@"alert"];
    
	
	if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
		//App is running
		
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Message" message:alertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
		
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

	[encoder finishEncoding];
    
	
	[theData writeToFile:dataFilePath atomically:YES];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	
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

	[encoder finishEncoding];
	
	
	[theData writeToFile:dataFilePath atomically:YES];
	
}


-(void)applicationWillEnterForeground:(UIApplication *)application {
    
    
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
	
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	
	[self updateInterfaceWithReachability: curReach];
	
}





@end