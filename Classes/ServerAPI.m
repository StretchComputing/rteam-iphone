//
//  ServerAPI.m
//  iCoach
//
//  Created by Nick Wroblewski on 2/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ServerAPI.h"
#import "JSON/JSON.h"
#import "Encoder.h"
#import "Team.h"
#import "Player.h"
#import "Base64.h"
#import "Game.h"
#import "Practice.h"
#import "MessageThreadInbox.h"
#import "MessageThreadOutbox.h"
#import "Event.h"
#import "CurrentEvent.h"
#import "Activity.h"
#import "Fan.h"
#import "MobileCarrier.h"

static NSString *baseUrl = @"https://rteamtest.appspot.com";
//static NSString *baseUrl = @"http://14.latest.rteamtest.appspot.com";

@implementation ServerAPI

+ (NSDictionary *)createUser:(NSString *)firstName :(NSString *)lastName :(NSString *)email :(NSString *)password :(NSString *)alreadyMember
							:(NSString *)latitude :(NSString *)longitude :(NSString *)phoneNumber :(NSString *)carrierCode{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	NSString *token = @"";
	
	if ((firstName == nil) || (lastName == nil) || (email == nil) || (password == nil) || (alreadyMember == nil)|| (latitude == nil)|| (longitude == nil)
        || (phoneNumber == nil) || (carrierCode == nil)) {
		statusReturn = @"0";
		token = @"";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		[returnDictionary setValue:token forKey:@"token"];
		return returnDictionary;
	}
	
	@try{
		
		NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
		NSDictionary *loginDict = [[NSDictionary alloc] init];
	
		[ tempDictionary setObject:firstName forKey:@"firstName"];
		[ tempDictionary setObject:lastName forKey:@"lastName"];
		[ tempDictionary setObject:email forKey:@"emailAddress"];
		[ tempDictionary setObject:password forKey:@"password"];
	
		if (![latitude isEqualToString:@""]) {
			[ tempDictionary setObject:latitude forKey:@"latitude"];
		}
		
		if (![longitude isEqualToString:@""]) {
			[ tempDictionary setObject:longitude forKey:@"longitude"];
		}
        
        if (![phoneNumber isEqualToString:@""]) {
			[ tempDictionary setObject:phoneNumber forKey:@"phoneNumber"];
		}
        if (![carrierCode isEqualToString:@""]) {
			[ tempDictionary setObject:carrierCode forKey:@"mobileCarrierCode"];
		}
		
		
		if (![alreadyMember isEqualToString:@""]) {
			[ tempDictionary setObject:alreadyMember forKey:@"alreadyMember"];
		}

		loginDict = tempDictionary;
	
		NSString *requestString = [NSString stringWithFormat:@"%@", [loginDict JSONFragment], nil];
	
		[tempDictionary release];
	
		NSString *tmpUrl = [baseUrl stringByAppendingFormat:@"/users"];
		NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:tmpUrl]];
		[request setHTTPMethod: @"POST"];
		[request setHTTPBody: requestData];
	
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		NSString *returnString = [[[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding] autorelease];
		
		SBJSON *jsonParser = [SBJSON new];
        
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
		

		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
		if ([apiStatus isEqualToString:@"100"]) {
			token = [response valueForKey:@"token"];
		}
		
		statusReturn = apiStatus;
		
		[returnDictionary setValue:statusReturn forKey:@"status"];
		[returnDictionary setValue:token forKey:@"token"];
		return returnDictionary;
		
	}
	@catch (NSException *e) {
		statusReturn = @"1";
		token = @"";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		[returnDictionary setValue:token forKey:@"token"];
		return returnDictionary;
	}
	

}

+ (NSDictionary *)getUserInfo:(NSString *)token :(NSString *)includePhoto{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	NSDictionary *userInfo = [NSDictionary dictionary];
	
	if ((token == nil) || (includePhoto == nil)) {
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
	
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
			
		NSString *tmpUrl = @"";
		
		if ([includePhoto isEqualToString:@"true"]) {
			tmpUrl = [NSString stringWithFormat:@"%@/user?includePhoto=true", baseUrl];
	
		}else {
			tmpUrl = [NSString stringWithFormat:@"%@/user", baseUrl];
		}

	
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:tmpUrl]];
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"GET"];
	
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
	
	
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
		SBJSON *jsonParser = [SBJSON new];
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
		if ([apiStatus isEqualToString:@"100"]) {
			userInfo = response;
		}
		
		statusReturn = apiStatus;
		
		[returnDictionary setValue:statusReturn forKey:@"status"];
		[returnDictionary setValue:userInfo forKey:@"userInfo"];
		return returnDictionary;
		
	}
	@catch (NSException *e) {
		statusReturn = @"1";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	
}

+(NSDictionary *)getUserToken:(NSString *)email :(NSString *)password{
	
	//Set up return dictionary
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	NSString *token = @"";
	
	//Do a null check on the parameters (none of these should ever be null)
	if ((email == nil) || (password == nil)) {
		statusReturn = @"0";
		token = @"";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		[returnDictionary setValue:token forKey:@"token"];
		return returnDictionary;
	}
	
	//Attempt the server connect in a try-catch
	@try{
		NSString *tmpUrl = [baseUrl stringByAppendingFormat:@"/user?emailAddress="];
		tmpUrl = [tmpUrl stringByAppendingString:email];
		tmpUrl = [tmpUrl stringByAppendingFormat:@"&password="];
		tmpUrl = [tmpUrl stringByAppendingString:password];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:tmpUrl]];
		[request setHTTPMethod: @"GET"];
	
	
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse:nil error: nil ];
	
		NSString *returnString = [[[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding] autorelease];
	
		SBJSON *jsonParser = [SBJSON new];
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
	
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
		NSString *userIconOneId = @"create";
		NSString *userIconOneAlias = @"";
		NSString *userIconTwoId = @"";
		NSString *userIconTwoAlias = @"";
		NSString *userIconOneImage = @"";
		NSString *userIconTwoImage = @"";
		
		if ([apiStatus isEqualToString:@"100"]) {
			token = [response valueForKey:@"token"];
			userIconOneId = [response valueForKey:@"userIconOneId"];
			userIconOneAlias = [response valueForKey:@"userIconOneAlias"];
			userIconTwoId = [response valueForKey:@"userIconTwoId"];
			userIconTwoAlias = [response valueForKey:@"userIconTwoAlias"];
			userIconOneImage = [response valueForKey:@"userIconOneImage"];
			userIconTwoImage = [response valueForKey:@"userIconTwoImage"];

			[returnDictionary setValue:userIconOneId forKey:@"userIconOneId"];
			[returnDictionary setValue:userIconOneAlias forKey:@"userIconOneAlias"];
			[returnDictionary setValue:userIconTwoId forKey:@"userIconTwoId"];
			[returnDictionary setValue:userIconTwoAlias forKey:@"userIconTwoAlias"];
			[returnDictionary setValue:userIconOneImage forKey:@"userIconOneImage"];
			[returnDictionary setValue:userIconTwoImage forKey:@"userIconTwoImage"];
		}
		
		statusReturn = apiStatus;

		[returnDictionary setValue:statusReturn forKey:@"status"];
		[returnDictionary setValue:token forKey:@"token"];
		return returnDictionary;
		
	}
	@catch (NSException *e){
		
		statusReturn = @"1";
		token = @"";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		[returnDictionary setValue:token forKey:@"token"];
		return returnDictionary;
		
	}
	
	
}

+(NSDictionary *)resetUserPassword:(NSString *)email :(NSString *)resetPasswordAnswer{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	
	if ((email == nil) || (resetPasswordAnswer == nil)){
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		

		NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
		NSDictionary *loginDict = [[NSDictionary alloc] init];
	
		[ tempDictionary setObject:@"" forKey:@"isPasswordReset"];
	
		if (![resetPasswordAnswer isEqualToString:@""]) {
			[tempDictionary setObject:resetPasswordAnswer forKey:@"passwordResetAnswer"];
		}
		
		loginDict = tempDictionary;
	
	
		NSString *requestString = [NSString stringWithFormat:@"%@", [loginDict JSONFragment], nil];
	
		[tempDictionary release];
	
		NSString *tmpUrl = [baseUrl stringByAppendingFormat:@"/user?emailAddress="];
		tmpUrl = [tmpUrl stringByAppendingString:email];
		
		NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:tmpUrl]];
	
		[request setHTTPMethod: @"PUT"];
		[request setHTTPBody: requestData];
	
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
	
		SBJSON *jsonParser = [SBJSON new];
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];

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

+(NSDictionary *)updateUser:(NSString *)token :(NSString *)firstName :(NSString *)lastName :(NSString *)password :(NSString *)alertToken 
						   :(NSString *)resetPasswordQuestion :(NSString *)resetPasswordAnswer :(NSString *)userIconOneId 
						   :(NSString *)userIconOneAlias :(NSString *)userIconTwoId :(NSString *)userIconTwoAlias :(NSString *)userIconOneImage
						   :(NSString *)userIconTwoImage :(NSString *)autoArchiveDayCount :(NSData *)profileImage :(NSString *)addRemove
                           :(NSString *)orientation :(NSString *)phoneNumber :(NSString *)phoneCarrierCode :(NSString *)confirmationCode :(NSString *)sendConfirmation;{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	
	
	if ((token == nil) || (firstName == nil) || (lastName == nil) || (password == nil) || (alertToken == nil) || (userIconOneId == nil)
		|| (userIconOneAlias == nil) || (userIconTwoId == nil) || (userIconTwoAlias == nil) || (userIconOneImage == nil) || 
		(userIconTwoImage == nil) || (autoArchiveDayCount == nil) || (profileImage == nil) || (addRemove == nil) || (orientation == nil)
        || (phoneNumber == nil) || (phoneCarrierCode == nil) || (confirmationCode == nil) || (sendConfirmation == nil)) {
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{

		
		NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
		NSDictionary *loginDict = [[NSDictionary alloc] init];
	
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
	
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
	
		NSString *profile = [ServerAPI encodeBase64data:profileImage];
		
		if ([addRemove isEqualToString:@"remove"]) {
			[tempDictionary setObject:@"" forKey:@"photo"];
		}else {
			if (![profile isEqualToString:@""]) {
				[ tempDictionary setObject:profile forKey:@"photo"];
			}
		}

		
		
        if (![orientation isEqualToString:@""]){
            NSNumber *isPortrait;
            
            if ([orientation isEqualToString:@"portrait"]) {
                isPortrait = [NSNumber numberWithBool:1];
            }else{
                isPortrait = [NSNumber numberWithBool:0];
            }
            [tempDictionary setObject:isPortrait forKey:@"isPortrait"];
        }
        
		[ tempDictionary setObject:password forKey:@"password"];
	
		//Set optional fields
		if (![firstName isEqualToString:@""]){
			[ tempDictionary setObject:firstName forKey:@"firstName"];
		}
		if (![lastName isEqualToString:@""]){
			[ tempDictionary setObject:lastName forKey:@"lastName"];
		}
		if (![alertToken isEqualToString:@""]){
			[ tempDictionary setObject:alertToken forKey:@"alertToken"];
		}
		

		if (![resetPasswordAnswer isEqualToString:@""]){
			[ tempDictionary setObject:resetPasswordAnswer forKey:@"passwordResetAnswer"];
		}
		
		if (![resetPasswordQuestion isEqualToString:@""]){
			[ tempDictionary setObject:resetPasswordQuestion forKey:@"passwordResetQuestion"];
		}
		
		
		if (![userIconOneId isEqualToString:@""]){
			[ tempDictionary setObject:userIconOneId forKey:@"userIconOneId"];
		}
		
		if (![userIconOneAlias isEqualToString:@""]){
			[ tempDictionary setObject:userIconOneAlias forKey:@"userIconOneAlias"];
		}
		
		if (![userIconTwoId isEqualToString:@""]){
			[ tempDictionary setObject:userIconTwoId forKey:@"userIconTwoId"];
		}
		
		if (![userIconTwoAlias isEqualToString:@""]){
			[ tempDictionary setObject:userIconTwoAlias forKey:@"userIconTwoAlias"];
		}
		
		if (![userIconOneImage isEqualToString:@""]){
			[ tempDictionary setObject:userIconOneImage forKey:@"userIconOneImage"];
		}
		
		if (![userIconTwoImage isEqualToString:@""]){
			[ tempDictionary setObject:userIconTwoImage forKey:@"userIconTwoImage"];
		}

		if (![autoArchiveDayCount isEqualToString:@""]){
			//convert it to an int
			
			NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
			[f setNumberStyle:NSNumberFormatterDecimalStyle];
			NSNumber * myNumber = [f numberFromString:autoArchiveDayCount];
			[f release];
			
			[ tempDictionary setObject:myNumber forKey:@"autoArchiveDayCount"];
		}
	
        
        if (![phoneNumber isEqualToString:@""]){
			[ tempDictionary setObject:phoneNumber forKey:@"phoneNumber"];
		}
        if (![phoneCarrierCode isEqualToString:@""]){
			[ tempDictionary setObject:phoneCarrierCode forKey:@"mobileCarrierCode"];
		}
        if (![confirmationCode isEqualToString:@""]){
			[ tempDictionary setObject:confirmationCode forKey:@"confirmationCode"];
		}
        if (![sendConfirmation isEqualToString:@""]){
            
            if ([sendConfirmation isEqualToString:@"true"]){
                
                NSNumber *confirm = [NSNumber numberWithBool:1];
                [tempDictionary setObject:confirm forKey:@"sendConfirmation"];

            }
		}
		
		loginDict = tempDictionary;
	
	
		NSString *requestString = [NSString stringWithFormat:@"%@", [loginDict JSONFragment], nil];
		
		
		[tempDictionary release];
	
		NSString *tmpUrl = [baseUrl stringByAppendingFormat:@"/user"];
		NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:tmpUrl]];
	
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"PUT"];
		[request setHTTPBody: requestData];
	
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
		
		SBJSON *jsonParser = [SBJSON new];
    
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
	
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
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

+ (NSDictionary *)createTeam:(NSString *)teamName :(NSString *)leagueName :(NSString *)description 
							:(NSString *)useTwitter :(NSString *)token :(NSString *)sport{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	NSString *teamIdReturn = @"";
	NSString *teamPageReturn = @"";
	NSString *twitterUrl = @"";
	
	if ((token == nil) || (teamName == nil) || (leagueName == nil) || (description == nil) || (useTwitter == nil)
		|| (sport == nil)) {
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
		NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
		NSDictionary *loginDict = [[NSDictionary alloc] init];
	
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
	
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
	
	
		[ tempDictionary setObject:teamName forKey:@"teamName"];
		[ tempDictionary setObject:description forKey:@"description"];
	
		//Set optional fields
		if (![useTwitter isEqualToString:@""]){
			NSNumber *twitter;
						
			if ([useTwitter isEqualToString:@"true"]) {
				twitter = [NSNumber numberWithBool:1];
			}else {
				twitter = [NSNumber numberWithBool:0];

			}

			[tempDictionary setObject:twitter forKey:@"useTwitter"];
		}
	
		
		if (![leagueName isEqualToString:@""]){
			[ tempDictionary setObject:leagueName forKey:@"leagueName"];
		}
		if (![sport isEqualToString:@""]) {
			[ tempDictionary setObject:sport forKey:@"sport"];
		}
	
		loginDict = tempDictionary;
	
	
		NSString *requestString = [NSString stringWithFormat:@"%@", [loginDict JSONFragment], nil];
	
		
		[tempDictionary release];
	
		NSString *tmpUrl = [baseUrl stringByAppendingFormat:@"/teams"];
		NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: tmpUrl]];
	
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"POST"];
		[request setHTTPBody: requestData];
	

		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];

				
		SBJSON *jsonParser = [SBJSON new];
    
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
	
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
	
		if ([apiStatus isEqualToString:@"100"]) {
			
			teamIdReturn = [response valueForKey:@"teamId"];
			teamPageReturn = [response valueForKey:@"teamPageUrl"];
			if ([useTwitter isEqualToString:@"true"]) {
				twitterUrl = [response valueForKey:@"twitterAuthorizationUrl"];
			}
		}
		
		statusReturn = apiStatus;
	
		[returnDictionary setValue:teamIdReturn forKey:@"teamId"];
		[returnDictionary setValue:teamPageReturn forKey:@"teamPage"];
		[returnDictionary setValue:statusReturn forKey:@"status"];
		if (![twitterUrl isEqualToString:@""]) {
			[returnDictionary setValue:twitterUrl forKey:@"twitterUrl"];
		}
		return returnDictionary;
	
	}
	@catch (NSException *e) {
		statusReturn = @"1";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}

}




+ (NSDictionary *)getListOfTeams:(NSString *)token{
		
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	NSMutableArray *teams = [NSMutableArray array];
	
	if (token == nil) {
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{

		
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
	
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
	
		NSString *tmpUrl = [baseUrl stringByAppendingFormat:@"/teams"];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: tmpUrl]];
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
	
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		NSString *responseString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	    
		SBJSON *jsonParser = [SBJSON new];
    
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:responseString error:NULL];
	
		[responseString release];
		[request release];
	
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
		if ([apiStatus isEqualToString:@"100"]) {
		
			statusReturn = apiStatus;
			
			NSArray *teamsJsonObjects = [response valueForKey:@"teams"];
	
			int size = [teamsJsonObjects count];
	
			for (int i = 0; i < size; i++){
		
				Team *tmpTeam = [[Team alloc] init];
			
				NSDictionary *thisTeam = [teamsJsonObjects objectAtIndex:i];
		
				tmpTeam.name = [thisTeam valueForKey:@"teamName"];
		
				tmpTeam.teamId = [thisTeam valueForKey:@"teamId"];
		
				tmpTeam.userRole = [thisTeam valueForKey:@"participantRole"];
		
				tmpTeam.sport = [thisTeam valueForKey:@"sport"];
				tmpTeam.useTwitter = [[thisTeam valueForKey:@"useTwitter"] boolValue];
				tmpTeam.teamUrl = [thisTeam valueForKey:@"teamSiteUrl"];
				//tmpTeam.teamUrl = @"http://www.google.com";
		
				[teams addObject:tmpTeam];
		
				[tmpTeam release];

			}
			
			[returnDictionary setValue:teams forKey:@"teams"];
			[returnDictionary setValue:statusReturn forKey:@"status"];
			return returnDictionary;
		}else {
			statusReturn = apiStatus;
			[returnDictionary setValue:statusReturn forKey:@"status"];
			return returnDictionary;
		}

	
	}
	@catch (NSException *e) {
		statusReturn = @"1";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}	
}



+ (NSDictionary *)getTeamInfo:(NSString *)teamId :(NSString *)token :(NSString *)includePhoto{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	NSDictionary *teamInfo = [NSDictionary dictionary];
	
	if ((token == nil) || (teamId == nil) || (includePhoto == nil)) {
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
			
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
	
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
		
		NSString *tmpUrl = @"";
		
		if ([includePhoto isEqualToString:@"true"]) {
			tmpUrl = [NSString stringWithFormat:@"%@/team/%@?includePhoto=true", baseUrl, teamId];
		}else{
			tmpUrl = [NSString stringWithFormat:@"%@/team/%@?includePhoto=false", baseUrl, teamId];
			
		}
		
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:tmpUrl]];
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"GET"];
	
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
	
	
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];

		
		SBJSON *jsonParser = [SBJSON new];
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
		if ([apiStatus isEqualToString:@"100"]) {
			teamInfo = response;
		}
		
		statusReturn = apiStatus;
		
		[returnDictionary setValue:statusReturn forKey:@"status"];
		[returnDictionary setValue:teamInfo forKey:@"teamInfo"];
		return returnDictionary;
		
	}
	@catch (NSException *e) {
		statusReturn = @"1";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
}

+(NSDictionary *)updateTeam:(NSString *)token :(NSString *)teamId :(NSString *)teamName :(NSString *)description :(NSString *)leagueName 
						   :(NSString *)useTwitter  :(NSString *)sport :(NSData *)teamPicture :(NSString *)orientation{
	
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	
	if ((token == nil) || (teamId == nil) || (teamName == nil) || (description == nil) || (leagueName == nil) 
		|| (useTwitter == nil) || (sport == nil) || (teamPicture == nil) || (orientation == nil)) {
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
		NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
		NSDictionary *loginDict = [[NSDictionary alloc] init];
	
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
	
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
	
		NSString *profile = [ServerAPI encodeBase64data:teamPicture];
		
	
		if (![profile isEqualToString:@""]) {
			[ tempDictionary setObject:profile forKey:@"photo"];
		}
		
		
		if (![teamName isEqualToString:@""]) {
			[ tempDictionary setObject:teamName forKey:@"teamName"];
		}
		if (![description isEqualToString:@""]) {
			[ tempDictionary setObject:description forKey:@"description"];
		}
		if (![leagueName isEqualToString:@""]) {
			[ tempDictionary setObject:leagueName forKey:@"leagueName"];
		}
		if (![useTwitter isEqualToString:@""]) {
			
			NSNumber *twitter;
			
			if ([useTwitter isEqualToString:@"true"]) {
				twitter = [NSNumber numberWithBool:1];
			}else {
				twitter = [NSNumber numberWithBool:0];
				
			}
			
			[tempDictionary setObject:twitter forKey:@"useTwitter"];
			
		}

		
		
		if (![sport isEqualToString:@""]) {
			[ tempDictionary setObject:sport forKey:@"sport"];
		}
		
	
        if (![orientation isEqualToString:@""]){
            NSNumber *isPortrait;
            
            if ([orientation isEqualToString:@"portrait"]) {
                isPortrait = [NSNumber numberWithBool:1];
            }else{
                isPortrait = [NSNumber numberWithBool:0];
            }
            [tempDictionary setObject:isPortrait forKey:@"isPortrait"];
        }
        
		loginDict = tempDictionary;
	
	
		NSString *requestString = [NSString stringWithFormat:@"%@", [loginDict JSONFragment], nil];
	
	
		[tempDictionary release];
	
		NSString *tmpUrl = [baseUrl stringByAppendingFormat:@"/team/"];
		tmpUrl = [tmpUrl stringByAppendingString:teamId];
	
	
		NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: tmpUrl]];
	
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"PUT"];
		[request setHTTPBody: requestData];
	
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
	
		
		SBJSON *jsonParser = [SBJSON new];
        
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
	
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
	
		statusReturn = apiStatus;
	
		[returnDictionary setValue:statusReturn forKey:@"status"];
		if ([response valueForKey:@"twitterAuthorizationUrl"] != nil) {
			[returnDictionary setValue:[response valueForKey:@"twitterAuthorizationUrl"] forKey:@"twitterUrl"];
		}
		return returnDictionary;
	
	}
	@catch (NSException *e) {
		statusReturn = @"1";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
}

+ (NSDictionary *)deleteTeam:(NSString *)teamId :(NSString *)token{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	
	
	if ((token == nil) || (teamId == nil)) {
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
	
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
	
		NSString *tmpUrl = [[baseUrl stringByAppendingFormat:@"/team/"] stringByAppendingString:teamId];
	
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:tmpUrl]];
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"DELETE"];
	
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
	
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
		
		SBJSON *jsonParser = [SBJSON new];
    
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
	
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
	
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


+(NSDictionary *)createMember:(NSString *)firstName :(NSString *)lastName :(NSString *)emailAddress 
							 :(NSString *)jerseyNumber :(NSArray *)roles :(NSArray *)guardianEmails
							 :(NSString *)teamId :(NSString *)token :(NSString *)userRole :(NSString *)phoneNumber{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	NSString *memberId = @"";
	
	
	if ((token == nil) || (firstName == nil) || (lastName == nil) || (emailAddress == nil) || (jerseyNumber == nil) 
		|| (roles == nil) || (guardianEmails == nil) || (teamId == nil) || (userRole == nil) || (phoneNumber == nil)) {
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
	
		NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
		NSDictionary *loginDict = [[NSDictionary alloc] init];
	
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
	
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
	
	
		[ tempDictionary setObject:firstName forKey:@"firstName"];
		[ tempDictionary setObject:lastName forKey:@"lastName"];
	
		//Handle optional fields
	
		if (![emailAddress isEqualToString:@""]){
			[ tempDictionary setObject:emailAddress forKey:@"emailAddress"];
		}
		if (![jerseyNumber isEqualToString:@""]){
			[ tempDictionary setObject:jerseyNumber forKey:@"jerseyNumber"];
		}
		if (![roles count] > 0){
			[ tempDictionary setObject:roles forKey:@"roles"];
		}
		if ([guardianEmails count] > 0){
			[ tempDictionary setObject:guardianEmails forKey:@"guardians"];
		}

		if ([userRole isEqualToString:@""]) {
			[ tempDictionary setObject:@"member" forKey:@"participantRole"];
		}else {
			[ tempDictionary setObject:userRole forKey:@"participantRole"];
		}
		
		if (![phoneNumber isEqualToString:@""]) {
			[ tempDictionary setObject:phoneNumber forKey:@"phoneNumber"];
		}

		loginDict = tempDictionary;
	
	
		NSString *requestString = [NSString stringWithFormat:@"%@", [loginDict JSONFragment], nil];
	
		
		[tempDictionary release];
	
		NSString *tmpUrl = [baseUrl stringByAppendingFormat:@"/team/"];
		tmpUrl = [tmpUrl stringByAppendingString:teamId];
		tmpUrl = [tmpUrl stringByAppendingFormat:@"/members"];
	
		NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: tmpUrl]];
	
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"POST"];
		[request setHTTPBody: requestData];
	
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
			
		SBJSON *jsonParser = [SBJSON new];

        
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
		if ([apiStatus isEqualToString:@"100"]) {
			memberId = [response valueForKey:@"memberId"];
		}
		
		statusReturn = apiStatus;
		
		[returnDictionary setValue:memberId forKey:@"memberId"];
		[returnDictionary setValue:statusReturn forKey:@"status"];
		
		return returnDictionary;
		
	}
	@catch (NSException *e) {
		statusReturn = @"1";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
}

+(NSDictionary *)createMultipleMembers:(NSString *)token :(NSString *)teamId :(NSArray *)members{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	
	
	if ((token == nil) || (teamId == nil) || (members == nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
		
		NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
		NSDictionary *loginDict = [[NSDictionary alloc] init];
		
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
		
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
		
		[tempDictionary setObject:members forKey:@"members"];

		loginDict = tempDictionary;
		
		
		NSString *requestString = [NSString stringWithFormat:@"%@", [loginDict JSONFragment], nil];
		
		
		[tempDictionary release];
		
		NSString *tmpUrl = [NSString stringWithFormat:@"%@/team/%@/members/multiple", baseUrl, teamId];
		
		NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: tmpUrl]];
		
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"POST"];
		[request setHTTPBody: requestData];
		        
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
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


+(NSDictionary *)getListOfTeamMembers:(NSString *)teamId :(NSString *)token :(NSString *)role :(NSString *)removeSelf{
	
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	NSMutableArray *members = [NSMutableArray array];

	
	if ((token == nil) || (teamId == nil) || (role == nil) || (removeSelf == nil)) {
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
	
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
	
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
	
		NSString *tmpUrl = [[baseUrl stringByAppendingFormat:@"/team/"] stringByAppendingString:teamId];
		tmpUrl = [tmpUrl stringByAppendingFormat:@"/members?includeFans=true"];
	
		
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:tmpUrl]];
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
	
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
	
		NSString *responseString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
			
		SBJSON *jsonParser = [SBJSON new];
        
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:responseString error:NULL];
	
		[responseString release];
		[request release];
	
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
		if ([apiStatus isEqualToString:@"100"]) {
		
			NSArray *memberJsonObjects = [response valueForKey:@"members"];
	
			int size = [memberJsonObjects count];
		
			for (int i = 0; i < size; i++){
		
				NSDictionary *thisMember = [memberJsonObjects objectAtIndex:i];
				NSString *currentRole = [thisMember valueForKey:@"participantRole"];
				
				if ([currentRole isEqualToString:@"fan"]) {
					Fan *tmpPlayer = [[Fan alloc] init];
										
					tmpPlayer.firstName = [thisMember valueForKey:@"memberName"];
					tmpPlayer.memberId = [thisMember valueForKey:@"memberId"];
					tmpPlayer.userRole = [thisMember valueForKey:@"participantRole"];  //creator, coordinator, member, or fan
					tmpPlayer.teamId = teamId;
					
					if ([thisMember valueForKey:@"emailAddress"] != nil) {
						tmpPlayer.email = [thisMember valueForKey:@"emailAddress"];
					}else {
						tmpPlayer.email = @"";
					}
					
					if ([thisMember valueForKey:@"phoneNumber"] != nil) {
						tmpPlayer.phone = [thisMember valueForKey:@"phoneNumber"];
					}else {
						tmpPlayer.phone = @"";
					}
					
					
					
					if ([thisMember valueForKey:@"isUser"] != nil) {
						tmpPlayer.isUser = [[thisMember valueForKey:@"isUser"] boolValue];
					}
                    
                    if ([thisMember valueForKey:@"isCurrentUser"] != nil) {
						tmpPlayer.isCurrentUser = [[thisMember valueForKey:@"isCurrentUser"] boolValue];
					}
                    
					if ([thisMember valueForKey:@"isNetworkAuthenticated"] != nil) {
						tmpPlayer.isNetworkAuthenticated = [[thisMember valueForKey:@"isNetworkAuthenticated"] boolValue];
					}
                    
                    if ([thisMember valueForKey:@"isSmsConfirmed"] != nil) {
						tmpPlayer.isSmsConfirmed = [[thisMember valueForKey:@"isSmsConfirmed"] boolValue];
					}
                    
                    if ([thisMember valueForKey:@"isEmailConfirmed"] != nil) {
						tmpPlayer.isEmailConfirmed = [[thisMember valueForKey:@"isEmailConfirmed"] boolValue];
					}
					
					if ([role isEqualToString:@"fan"]) {
						if ([tmpPlayer.userRole isEqualToString:@"fan"]) {
							if ([removeSelf isEqualToString:@"true"]) {
								if (![[thisMember valueForKey:@"isCurrentUser"] boolValue]) {
									[members addObject:tmpPlayer];
								}
								
							}else {
								[members addObject:tmpPlayer];
							}
						}
					}else if ([role isEqualToString:@"member"]) {
						if (![tmpPlayer.userRole isEqualToString:@"fan"]) {
							if ([removeSelf isEqualToString:@"true"]) {
								if (![[thisMember valueForKey:@"isCurrentUser"] boolValue]) {
									[members addObject:tmpPlayer];
								}
								
							}else {
								[members addObject:tmpPlayer];
							}
						}
					}else {
						if ([removeSelf isEqualToString:@"true"]) {
							if (![[thisMember valueForKey:@"isCurrentUser"] boolValue]) {
								[members addObject:tmpPlayer];
							}
							
						}else {
							[members addObject:tmpPlayer];
						}
					}
					[tmpPlayer release];

				}else {
					Player *tmpPlayer = [[Player alloc] init];
										
					tmpPlayer.firstName = [thisMember valueForKey:@"memberName"];
					tmpPlayer.memberId = [thisMember valueForKey:@"memberId"];
					tmpPlayer.userRole = [thisMember valueForKey:@"participantRole"];  //creator, coordinator, member, or fan
					tmpPlayer.teamId = teamId;
					
                    
                    //Guardian Info
                    
                    tmpPlayer.guard1First = @"";
                    tmpPlayer.guard1Last = @"";
                    tmpPlayer.guard1Email = @"";
                    tmpPlayer.guard1Phone = @"";
                    
                    tmpPlayer.guard2First = @"";
                    tmpPlayer.guard2Last = @"";
                    tmpPlayer.guard2Email = @"";
                    tmpPlayer.guard2Phone = @"";
                    
                    if ([thisMember valueForKey:@"guardians"] != nil) {
                        
                        NSArray *guardArray = [thisMember valueForKey:@"guardians"];
                        
                        if ([guardArray count] > 0){
                            
                            NSDictionary *tmp1 = [guardArray objectAtIndex:0];
                            
                            
                            if ([tmp1 valueForKey:@"emailAddress"] != nil) {
                                tmpPlayer.guard1Email = [tmp1 valueForKey:@"emailAddress"];
                            }
                            if ([tmp1 valueForKey:@"phoneNumber"] != nil) {
                                tmpPlayer.guard1Phone = [tmp1 valueForKey:@"phoneNumber"];
                            }
                            if ([tmp1 valueForKey:@"firstName"] != nil) {
                                tmpPlayer.guard1First = [tmp1 valueForKey:@"firstName"];
                            }
                            if ([tmp1 valueForKey:@"lastName"] != nil) {
                                tmpPlayer.guard1Last = [tmp1 valueForKey:@"lastName"];
                            }
                            if ([tmp1 valueForKey:@"isNetworkAuthenticated"] != nil) {
                                tmpPlayer.guard1NA = [[tmp1 valueForKey:@"isNetworkAuthenticated"] boolValue];
                            }
                            if ([tmp1 valueForKey:@"isSmsConfirmed"] != nil) {
                                tmpPlayer.guard1SmsConfirmed = [[tmp1 valueForKey:@"isSmsConfirmed"] boolValue];
                            }
                            
                            if ([tmp1 valueForKey:@"isEmailConfirmed"] != nil) {
                                tmpPlayer.guard1EmailConfirmed = [[tmp1 valueForKey:@"isEmailConfirmed"] boolValue];
                            }
                            
                            
                            
                            
                            if ([tmp1 valueForKey:@"isUser"] != nil) {
                                tmpPlayer.guard1isUser = [[tmp1 valueForKey:@"isUser"] boolValue];
                            }

                        }
                                               
                        
                        if ([guardArray count] > 1) {
                            NSDictionary *tmp2 = [guardArray objectAtIndex:1];
                            
                            if ([tmp2 valueForKey:@"emailAddress"] != nil) {
                                tmpPlayer.guard2Email = [tmp2 valueForKey:@"emailAddress"];
                            }
                            if ([tmp2 valueForKey:@"phoneNumber"] != nil) {
                                tmpPlayer.guard2Phone = [tmp2 valueForKey:@"phoneNumber"];
                            }
                            if ([tmp2 valueForKey:@"firstName"] != nil) {
                                tmpPlayer.guard2First = [tmp2 valueForKey:@"firstName"];
                            }
                            if ([tmp2 valueForKey:@"lastName"] != nil) {
                                tmpPlayer.guard2Last = [tmp2 valueForKey:@"lastName"];
                            }
                            if ([tmp2 valueForKey:@"isNetworkAuthenticated"] != nil) {
                                tmpPlayer.guard2NA = [[tmp2 valueForKey:@"isNetworkAuthenticated"] boolValue];
                            }
                            if ([tmp2 valueForKey:@"isSmsConfirmed"] != nil) {
                                tmpPlayer.guard2SmsConfirmed = [[tmp2 valueForKey:@"isSmsConfirmed"] boolValue];
                            }
                            
                            if ([tmp2 valueForKey:@"isEmailConfirmed"] != nil) {
                                tmpPlayer.guard2EmailConfirmed = [[tmp2 valueForKey:@"isEmailConfirmed"] boolValue];
                            }
                            
                            if ([tmp2 valueForKey:@"isUser"] != nil) {
                                tmpPlayer.guard2isUser = [[tmp2 valueForKey:@"isUser"] boolValue];
                            }
                            
                        }
                    }
                    
                    
                    
                    
                    
					if ([thisMember valueForKey:@"emailAddress"] != nil) {
						tmpPlayer.email = [thisMember valueForKey:@"emailAddress"];
					}else {
						tmpPlayer.email = @"";
					}


					if ([thisMember valueForKey:@"phoneNumber"] != nil) {
						tmpPlayer.phone = [thisMember valueForKey:@"phoneNumber"];
					}else {
						tmpPlayer.phone = @"";
					}
					
					
					if ([thisMember valueForKey:@"isUser"] != nil) {
						tmpPlayer.isUser = [[thisMember valueForKey:@"isUser"] boolValue];
					}
					if ([thisMember valueForKey:@"isNetworkAuthenticated"] != nil) {
						tmpPlayer.isNetworkAuthenticated = [[thisMember valueForKey:@"isNetworkAuthenticated"] boolValue];
					}
                    
                    if ([thisMember valueForKey:@"isSmsConfirmed"] != nil) {
						tmpPlayer.isSmsConfirmed = [[thisMember valueForKey:@"isSmsConfirmed"] boolValue];
					}
                    
                    if ([thisMember valueForKey:@"isEmailConfirmed"] != nil) {
                        tmpPlayer.isEmailConfirmed = [[thisMember valueForKey:@"isEmailConfirmed"] boolValue];
                    }
					
                    if ([thisMember valueForKey:@"isCurrentUser"] != nil) {
						tmpPlayer.isCurrentUser = [[thisMember valueForKey:@"isCurrentUser"] boolValue];
					}
                    
					if ([role isEqualToString:@"fan"]) {
						if ([tmpPlayer.userRole isEqualToString:@"fan"]) {
							
							if ([removeSelf isEqualToString:@"true"]) {
								if (![[thisMember valueForKey:@"isCurrentUser"] boolValue]) {
									[members addObject:tmpPlayer];
								}

							}else {
								[members addObject:tmpPlayer];
							}

						}
					}else if ([role isEqualToString:@"member"]) {
						if (![tmpPlayer.userRole isEqualToString:@"fan"]) {
							if ([removeSelf isEqualToString:@"true"]) {
								if (![[thisMember valueForKey:@"isCurrentUser"] boolValue]) {
									[members addObject:tmpPlayer];
								}
								
							}else {
								[members addObject:tmpPlayer];
							}
						}
					}else {
						if ([removeSelf isEqualToString:@"true"]) {
							if (![[thisMember valueForKey:@"isCurrentUser"] boolValue]) {
								[members addObject:tmpPlayer];
							}
							
						}else {
							[members addObject:tmpPlayer];
						}
					}
					[tmpPlayer release];

				}

		
			}
	
			//Sort list of players alphabetically (right now by first name)
			NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
			[members sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
			
			statusReturn = apiStatus;
			[returnDictionary setValue:statusReturn forKey:@"status"];
			[returnDictionary setValue:members forKey:@"members"];
			return returnDictionary;
	
		}else {
			statusReturn = apiStatus;
			[returnDictionary setValue:statusReturn forKey:@"status"];
			return returnDictionary;
		}

	}
	@catch (NSException *e) {
		statusReturn = @"1";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}	
	
}


+(NSDictionary *)getMemberInfo:(NSString *)teamId :(NSString *)memberId :(NSString *)token :(NSString *)includePhoto{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	NSDictionary *memberInfo = [NSDictionary dictionary];
	
	
	if ((token == nil) || (memberId == nil) || (teamId == nil)) {
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{

		
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
	
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];

		NSString *tmpUrl = @"";
		
		if ([includePhoto isEqualToString:@"true"]) {
			tmpUrl = [NSString stringWithFormat:@"%@/team/%@/member/%@?includePhoto=true", baseUrl, teamId, memberId];
		}else{
			tmpUrl = [NSString stringWithFormat:@"%@/team/%@/member/%@?includePhoto=false", baseUrl, teamId, memberId];

		}


	
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:tmpUrl]];
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"GET"];
	
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
	
	
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
		SBJSON *jsonParser = [SBJSON new];        
        
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
	
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
	
		if ([apiStatus isEqualToString:@"100"]) {
			memberInfo = response;
		}
	
		statusReturn = apiStatus;
	
		[returnDictionary setValue:memberInfo forKey:@"memberInfo"];
		[returnDictionary setValue:statusReturn forKey:@"status"];
	
		return returnDictionary;
	
	}
	@catch (NSException *e) {
		statusReturn = @"1";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
}

+(NSDictionary *)deleteMember:(NSString *)memberId :(NSString *)teamId :(NSString *)token{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	
	
	if ((token == nil) || (memberId == nil) || (teamId == nil)) {
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
	
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
	
		NSString *tmpUrl = [[baseUrl stringByAppendingFormat:@"/team/"] stringByAppendingString:teamId];
		tmpUrl = [tmpUrl stringByAppendingFormat:@"/member/"];
		tmpUrl = [tmpUrl stringByAppendingString:memberId];
	
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:tmpUrl]];
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"DELETE"];
	
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
	
	
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
		SBJSON *jsonParser = [SBJSON new];
	
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
	
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
	
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

+(NSDictionary *)updateMember:(NSString *)memberId :(NSString *)teamId :(NSString *)firstName :(NSString *)lastName 
						 :(NSString *)jerseyNumber :(NSArray *)roles :(NSArray *)guardianEmails :(NSString *)token :(NSData *)profileImage 
                             :(NSString *)email :(NSString *)userRole :(NSString *)phoneNumber :(NSString *)orientation{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	
	
	if ((token == nil) || (memberId == nil) || (teamId == nil) || (firstName == nil) || (lastName == nil) 
		|| (jerseyNumber == nil) || (roles == nil) || (guardianEmails == nil) || (email == nil)
		|| (userRole == nil) || (phoneNumber== nil) || (orientation == nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
		NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
		NSDictionary *loginDict = [[NSDictionary alloc] init];
	
		
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
		
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
				
		
		NSString *profile = [ServerAPI encodeBase64data:profileImage];
		
        if (![firstName isEqualToString:@""]) {
            [ tempDictionary setObject:firstName forKey:@"firstName"];
        }
        
        if (![lastName isEqualToString:@""]) {
            [ tempDictionary setObject:lastName forKey:@"lastName"];
        }
        
        if (![jerseyNumber isEqualToString:@""]) {
            [ tempDictionary setObject:jerseyNumber forKey:@"jerseyNumber"];

        }
		
        if ([roles count] > 0){
            [ tempDictionary setObject:roles forKey:@"roles"];
		}

		if ([guardianEmails count] > 0){
            
            if ([guardianEmails count] > 2) {
                [tempDictionary setObject:[NSArray array] forKey:@"guardians"];
            }else{
                [ tempDictionary setObject:guardianEmails forKey:@"guardians"];

            }
		}
		
		if (![profile isEqualToString:@""]) {
			[ tempDictionary setObject:profile forKey:@"photo"];
		}
	
	
		
		if (![email isEqualToString:@""]) {
			if ([email isEqualToString:@"remove"]) {
                [tempDictionary setObject:@"" forKey:@"emailAddress"];
            }else{
                [ tempDictionary setObject:email forKey:@"emailAddress"];
                
            }
		}
		if (![userRole isEqualToString:@""]) {
			[ tempDictionary setObject:userRole forKey:@"participantRole"];
		}
        
		if (![phoneNumber isEqualToString:@""]) {
            if ([phoneNumber isEqualToString:@"remove"]) {
                [tempDictionary setObject:@"" forKey:@"phoneNumber"];
            }else{
                [ tempDictionary setObject:phoneNumber forKey:@"phoneNumber"];

            }
		}
	
        if (![orientation isEqualToString:@""]){
            NSNumber *isPortrait;
            
            if ([orientation isEqualToString:@"portrait"]) {
                isPortrait = [NSNumber numberWithBool:1];
            }else{
                isPortrait = [NSNumber numberWithBool:0];
            }
            [tempDictionary setObject:isPortrait forKey:@"isPortrait"];
        }
        
		loginDict = tempDictionary;
	
	
		NSString *requestString = [NSString stringWithFormat:@"%@", [loginDict JSONFragment], nil];
	
	
		[tempDictionary release];

		NSString *tmpUrl = [baseUrl stringByAppendingFormat:@"/team/"];
		tmpUrl = [tmpUrl stringByAppendingString:teamId];
		tmpUrl = [tmpUrl stringByAppendingFormat:@"/member/"];
		tmpUrl = [tmpUrl stringByAppendingString:memberId];
	
		NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: tmpUrl]];
	
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"PUT"];
		[request setHTTPBody: requestData];
	                
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
		
		SBJSON *jsonParser = [SBJSON new];
        
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
	
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
	
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

+(NSDictionary *)getMembershipStatus:(NSString *)email{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	NSString *numberOfTeams = @"";
	
	
	if (email == nil) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
	
		NSString *tmpUrl = [baseUrl stringByAppendingFormat:@"/member?emailAddress="];
		tmpUrl = [tmpUrl stringByAppendingString:email];
	
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:tmpUrl]];
		[request setHTTPMethod: @"GET"];
	
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		NSString *returnString = [[[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding] autorelease];
		
		SBJSON *jsonParser = [SBJSON new];
		
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
		bool first = false;
		bool last = false;
		NSString *firstName = @"";
		NSString *lastName = @"";
		
		if ([apiStatus isEqualToString:@"100"]) {
			numberOfTeams = [response valueForKey:@"numberOfTeams"];
			
			
			if ([response valueForKey:@"firstName"] != nil) {
				first = true;
				firstName = [response valueForKey:@"firstName"];
			}
			
			if ([response valueForKey:@"lastName"] != nil) {
				last = true;
				lastName = [response valueForKey:@"lastName"];
			}
		}
		
		statusReturn = apiStatus;
		
		[returnDictionary setValue:numberOfTeams forKey:@"numberOfTeams"];
		[returnDictionary setValue:statusReturn forKey:@"status"];
		if (first) {
			[returnDictionary setValue:firstName forKey:@"firstName"];
		}
		if (last) {
			[returnDictionary setValue:lastName forKey:@"lastName"];
		}
		
		return returnDictionary;
		
	}
	@catch (NSException *e) {
		statusReturn = @"1";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
}

+(NSDictionary *)createGame:(NSString *)teamId :(NSString *)token :(NSString *)startDate :(NSString *)endDate :(NSString *)description 
						   :(NSString *)timeZone :(NSString *)latitude :(NSString *)longitude :(NSString *)opponent{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	NSString *gameId = @"";
	
	
	if ((token == nil) || (teamId == nil) || (startDate == nil) || (endDate == nil) || (description == nil) 
		|| (timeZone == nil) || (latitude == nil) || (longitude == nil) || (opponent == nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
		
		NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
		NSDictionary *loginDict = [[NSDictionary alloc] init];
	
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
	
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
	
	
		[ tempDictionary setObject:startDate forKey:@"startDate"];
		[ tempDictionary setObject:timeZone forKey:@"timeZone"];
		[ tempDictionary setObject:description forKey:@"description"];

	
		if (![endDate isEqualToString:@""]){
			[ tempDictionary setObject:endDate forKey:@"endDate"];
		}
		if (![opponent isEqualToString:@""]){
			[ tempDictionary setObject:opponent forKey:@"opponent"];
		}
		if (![latitude isEqualToString:@""]){
			[ tempDictionary setObject:latitude forKey:@"latitude"];
		}
		if (![longitude isEqualToString:@""]){
			[ tempDictionary setObject:longitude forKey:@"longitude"];
		}
	
	
		loginDict = tempDictionary;
	
	
		NSString *requestString = [NSString stringWithFormat:@"%@", [loginDict JSONFragment], nil];
	
	
		[tempDictionary release];

		NSString *tmpUrl = [baseUrl stringByAppendingFormat:@"/team/"];
		tmpUrl = [tmpUrl stringByAppendingString:teamId];
		tmpUrl = [tmpUrl stringByAppendingFormat:@"/games"];
	
		NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: tmpUrl]];
	
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"POST"];
		[request setHTTPBody: requestData];
	
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
	
		SBJSON *jsonParser = [SBJSON new];
		
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
		if ([apiStatus isEqualToString:@"100"]) {
			gameId = [response valueForKey:@"gameId"];
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

+(NSDictionary *)createMultipleGames:(NSString *)token	:(NSString *)teamId :(NSString *)notificationType :(NSArray *)games{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	
	
	if ((token == nil) || (teamId == nil) || (notificationType == nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
		
		NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
		NSDictionary *loginDict = [[NSDictionary alloc] init];
		
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
		
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
		
		NSTimeZone *tmp1 = [NSTimeZone systemTimeZone];
		NSString *timeZone = [tmp1 name];
		
		[tempDictionary setObject:timeZone forKey:@"timeZone"];
		[tempDictionary setObject:notificationType forKey:@"notificationType"];
		[tempDictionary setObject:games forKey:@"games"];
		
		
		
		loginDict = tempDictionary;
		
		
		NSString *requestString = [NSString stringWithFormat:@"%@", [loginDict JSONFragment], nil];
		
		
		[tempDictionary release];
		
		NSString *tmpUrl = [NSString stringWithFormat:@"%@/team/%@/games/recurring/multiple", baseUrl, teamId];
									
		NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: tmpUrl]];
		
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"POST"];
		[request setHTTPBody: requestData];
		
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
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

+(NSDictionary *)getListOfGames:(NSString *)teamId :(NSString *)token{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	NSMutableArray *games = [NSMutableArray array];
	
	
	if ((token == nil) || (teamId == nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
	
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
	
		NSTimeZone *tmp1 = [NSTimeZone systemTimeZone];
		NSString *timeZone = [tmp1 name];
	
		timeZone = [timeZone stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
	

		NSString *tmpUrl = baseUrl;
		if (![teamId isEqualToString:@""]) {
			tmpUrl = [[tmpUrl stringByAppendingFormat:@"/team/"] stringByAppendingString:teamId];
			tmpUrl = [tmpUrl stringByAppendingFormat:@"/games/"];
			tmpUrl = [tmpUrl stringByAppendingString:timeZone];
		}else {
			tmpUrl = [[tmpUrl stringByAppendingFormat:@"/games/"] stringByAppendingString:timeZone];
		}



		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:tmpUrl]];
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
	
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
	
	
		NSString *responseString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];

		SBJSON *jsonParser = [SBJSON new];
    		        
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:responseString error:NULL];
		
		//[responseString release];
		//[request release];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
		if ([apiStatus isEqualToString:@"100"]) {

			NSDictionary *gameArray = (NSDictionary *) [jsonParser objectWithString:responseString error:NULL];
	
			NSArray *gameJsonObjects = [gameArray valueForKey:@"games"];
	
			int size = [gameJsonObjects count];
	
	
	
			for (int i = 0; i < size; i++){
				
				Game *tmpGame = [[Game alloc] init];
		
				NSDictionary *thisGame = [gameJsonObjects objectAtIndex:i];
		
				tmpGame.description = [thisGame valueForKey:@"description"];
				tmpGame.startDate = [thisGame valueForKey:@"startDate"];
				tmpGame.gameId = [thisGame valueForKey:@"gameId"];
				tmpGame.opponent = [thisGame valueForKey:@"opponent"];
				tmpGame.teamName = [thisGame valueForKey:@"teamName"];
				
				if ([thisGame valueForKey:@"mvpDisplayName"] != nil) {
					tmpGame.mvp = [thisGame valueForKey:@"mvpDisplayName"];
					tmpGame.hasMvp = true;
				}else {
					tmpGame.hasMvp = false;
					tmpGame.mvp = @"";
				}

				
				if ([thisGame valueForKey:@"location"] != nil) {
					tmpGame.location = [thisGame valueForKey:@"location"];
				}
				if ([thisGame valueForKey:@"sport"]) {
					tmpGame.sport = [thisGame valueForKey:@"sport"];
				}
				
				if ([teamId isEqualToString:@""]) {
					tmpGame.teamId = [thisGame valueForKey:@"teamId"];
					tmpGame.userRole = [thisGame valueForKey:@"participantRole"];
				}else {
					tmpGame.teamId = [teamId copy];
				}

				
				if ([thisGame valueForKey:@"latitude"] != nil) {
					tmpGame.latitude = [thisGame valueForKey:@"latitude"];
				}
				if ([thisGame valueForKey:@"longitude"] != nil) {
					tmpGame.longitude = [thisGame valueForKey:@"longitude"];
				}
				
				if ([thisGame valueForKey:@"interval"] != nil) {
					tmpGame.interval = [[thisGame valueForKey:@"interval"] stringValue];
					tmpGame.scoreUs = [[thisGame valueForKey:@"scoreUs"] stringValue];
					tmpGame.scoreThem = [[thisGame valueForKey:@"scoreThem"] stringValue];
				}
		
		
				[games addObject:tmpGame];
		
				[tmpGame release];
		
			}
	
			//Sort games by date
			//Sort list of players alphabetically (right now by first name)
			NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
			[games sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
		
			statusReturn = apiStatus;
			[returnDictionary setValue:statusReturn forKey:@"status"];
			[returnDictionary setValue:games forKey:@"games"];
			return returnDictionary;
		
		}else {
			statusReturn = apiStatus;
			[returnDictionary setValue:statusReturn forKey:@"status"];
			return returnDictionary;
		}
	
	}

	@catch (NSException *e) {
		statusReturn = @"1";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}	

	
}

+(NSDictionary *)getGameInfo:(NSString *)gameId :(NSString *)teamId :(NSString *)token{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	NSDictionary *gameInfo = [NSDictionary dictionary];
	
	
	if ((token == nil) || (teamId == nil) || (gameId == nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
	
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
	
		NSTimeZone *tmp1 = [NSTimeZone systemTimeZone];
		NSString *timeZone = [tmp1 name];
	
		timeZone = [timeZone stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
	
		NSString *tmpUrl = [[baseUrl stringByAppendingFormat:@"/team/"] stringByAppendingString:teamId];
		tmpUrl = [tmpUrl stringByAppendingFormat:@"/game/"];
		tmpUrl = [tmpUrl stringByAppendingString:gameId];
		tmpUrl = [tmpUrl stringByAppendingFormat:@"/"];
		tmpUrl = [tmpUrl stringByAppendingString:timeZone];
	
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:tmpUrl]];
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"GET"];
	
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
	
	
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
			
		SBJSON *jsonParser = [SBJSON new];
		
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
		if ([apiStatus isEqualToString:@"100"]) {
			gameInfo = response;
		}
		
		statusReturn = apiStatus;
		
		[returnDictionary setValue:gameInfo forKey:@"gameInfo"];
		[returnDictionary setValue:statusReturn forKey:@"status"];
		
		return returnDictionary;
		
	}
	@catch (NSException *e) {
		statusReturn = @"1";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
}

+(NSDictionary *)updateGame:(NSString *)token :(NSString *)teamId :(NSString *)gameId :(NSString *)startDate :(NSString *)endDate :(NSString *)timeZone
						   :(NSString *)description :(NSString *)latitude :(NSString *)longitude :(NSString *)opponent :(NSString *)location 
						   :(NSString *)scoreUs :(NSString *)scoreThem :(NSString *)interval :(NSString *)notifyTeam :(NSString *)pollStatus
						   :(NSString *)updateAll{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	
	
	if ((token == nil) || (teamId == nil) || (gameId == nil) || (startDate == nil) || (endDate == nil) || (timeZone == nil) || (description == nil)
		|| (latitude == nil) || (longitude == nil) || (opponent == nil) || (location == nil) || (notifyTeam == nil) || (updateAll == nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
		NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
		NSDictionary *loginDict = [[NSDictionary alloc] init];
	
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
	
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
		
		if (![startDate isEqualToString:@""]){
			[ tempDictionary setObject:startDate forKey:@"startDate"];
		}
		if (![endDate isEqualToString:@""]){
			[ tempDictionary setObject:endDate forKey:@"endDate"];
		}
		if (![timeZone isEqualToString:@""]){
			[ tempDictionary setObject:timeZone forKey:@"timeZone"];
		}
		if (![description isEqualToString:@""]){
			[ tempDictionary setObject:description forKey:@"description"];
		}
		if (![latitude isEqualToString:@""]){
			[ tempDictionary setObject:latitude forKey:@"latitude"];
		}
		if (![longitude isEqualToString:@""]){
			[ tempDictionary setObject:longitude forKey:@"longitude"];
		}
		if (![opponent isEqualToString:@""]){
			[ tempDictionary setObject:opponent forKey:@"opponent"];
		}
		if (![location isEqualToString:@""]){
			[ tempDictionary setObject:location forKey:@"location"];
		}
		
		if (![scoreUs isEqualToString:@""]) {
			[ tempDictionary setObject:scoreUs forKey:@"scoreUs"];
		}
		
		if (![scoreThem isEqualToString:@""]) {
			[ tempDictionary setObject:scoreThem forKey:@"scoreThem"];
		}
		
		if (![interval isEqualToString:@""]) {
			[ tempDictionary setObject:interval forKey:@"interval"];
		}
		
		if (![notifyTeam isEqualToString:@""]) {
			
			if ([notifyTeam isEqualToString:@"true"]) {
				[tempDictionary setObject:@"plain" forKey:@"notificationType"];
			}else {
				[tempDictionary setObject:@"none" forKey:@"notificationType"];

			}

		}
		
		//if (![updateAll isEqualToString:@""]) {
			
			NSNumber *upAll;
			
			if ([updateAll isEqualToString:@"true"]) {
				upAll = [NSNumber numberWithBool:1];
				[tempDictionary setObject:upAll forKey:@"updateAll"];
			}else {
				upAll = [NSNumber numberWithBool:0];
				[tempDictionary setObject:upAll forKey:@"updateAll"];
			}

		//}

	
		if (![pollStatus isEqualToString:@""]) {
			[ tempDictionary setObject:pollStatus forKey:@"pollStatus"];
		}
		
		loginDict = tempDictionary;
	
	
		NSString *requestString = [NSString stringWithFormat:@"%@", [loginDict JSONFragment], nil];
	
		
		[loginDict release];
	
		NSString *tmpUrl = [baseUrl stringByAppendingFormat:@"/team/"];
		tmpUrl = [tmpUrl stringByAppendingString:teamId];
		tmpUrl = [tmpUrl stringByAppendingFormat:@"/game/"];
		tmpUrl = [tmpUrl stringByAppendingString:gameId];
	
		NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: tmpUrl]];
	
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"PUT"];
		[request setHTTPBody: requestData];
	
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];


		SBJSON *jsonParser = [SBJSON new];
		
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
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


+(NSDictionary *)castGameVote:(NSString *)token :(NSString *)teamId :(NSString *)gameId :(NSString *)voteType :(NSString *)memberId{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	
	
	if ((token == nil) || (teamId == nil) || (gameId == nil) || (voteType == nil) || (memberId == nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
		NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
		NSDictionary *loginDict = [[NSDictionary alloc] init];
		
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
		
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
		
		if (![memberId isEqualToString:@""]){
			[ tempDictionary setObject:memberId forKey:@"memberId"];
		}
		
		
		loginDict = tempDictionary;
		
		
		NSString *requestString = [NSString stringWithFormat:@"%@", [loginDict JSONFragment], nil];
		
		
		[loginDict release];
		
	
		NSString *tmpUrl = [NSString stringWithFormat:@"%@/team/%@/game/%@/vote/%@", baseUrl, teamId, gameId, voteType];

		NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: tmpUrl]];
		
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"PUT"];
		[request setHTTPBody: requestData];
		
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		
		
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
		
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

+(NSDictionary *)getGameVoteTallies:(NSString *)token :(NSString *)teamId :(NSString *)gameId :(NSString *)voteType{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	
	
	if ((token == nil) || (teamId == nil) || (gameId == nil) || (voteType == nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
		
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];		
		
		NSString *tmpUrl = [NSString stringWithFormat:@"%@/team/%@/game/%@/vote/%@/tallies", baseUrl, teamId, gameId, voteType];
		
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: tmpUrl]];
		
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"GET"];
		
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		
		
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
		
		SBJSON *jsonParser = [SBJSON new];
		
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
		NSString *votedFor = @"";
		NSArray *memberTallies = [NSArray array];
		
		if ([apiStatus isEqualToString:@"100"]) {
			
			votedFor = [response valueForKey:@"vote"];
			memberTallies = [response valueForKey:@"members"];
		}
		
		statusReturn = apiStatus;
		
		[returnDictionary setValue:statusReturn forKey:@"status"];
		[returnDictionary setValue:votedFor forKey:@"votedFor"];
		[returnDictionary setValue:memberTallies forKey:@"memberTallies"];
		
		return returnDictionary;
		
	}
	@catch (NSException *e) {
		statusReturn = @"1";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	
}



+(NSDictionary *)createEvent:(NSString *)teamId :(NSString *)token :(NSString *)startDate :(NSString *)endDate :(NSString *)description 
							:(NSString *)timeZone :(NSString *)latitude :(NSString *)longitude :(NSString *)location :(NSString *)eventType
							:(NSString *)eventName{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	NSString *practiceId = @"";
	
	
	if ((token == nil) || (teamId == nil) || (startDate == nil) || (endDate == nil) || (description == nil) || (timeZone == nil) 
		|| (latitude == nil) || (longitude == nil) || (location == nil) || (eventType == nil) || (eventName == nil)) {
		
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{

		
		NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
		NSDictionary *loginDict = [[NSDictionary alloc] init];
	
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
	
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
	
	
		[tempDictionary setObject:startDate forKey:@"startDate"];
		[tempDictionary setObject:timeZone forKey:@"timeZone"];
		[tempDictionary setObject:description forKey:@"description"];
		[tempDictionary setValue:eventType forKey:@"eventType"];
	
		
		if (![endDate isEqualToString:@""]){
			[ tempDictionary setObject:endDate forKey:@"endDate"];
		}
		if (![location isEqualToString:@""]){
		[ tempDictionary setObject:location forKey:@"opponent"];
		}
		if (![latitude isEqualToString:@""]){
			[ tempDictionary setObject:latitude forKey:@"latitude"];
		}
		if (![longitude isEqualToString:@""]){
			[ tempDictionary setObject:longitude forKey:@"longitude"];
		}
		
		if (![eventName isEqualToString:@""]) {
			[tempDictionary setObject:eventName forKey:@"eventName"];
		}
		
	
		loginDict = tempDictionary;
	
		
		NSString *requestString = [NSString stringWithFormat:@"%@", [loginDict JSONFragment], nil];
	
	
		[tempDictionary release];
	
		NSString *tmpUrl = [baseUrl stringByAppendingFormat:@"/team/"];
		tmpUrl = [tmpUrl stringByAppendingString:teamId];
		tmpUrl = [tmpUrl stringByAppendingFormat:@"/practices"];
	
		NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: tmpUrl]];
	
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"POST"];
		[request setHTTPBody: requestData];
	
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
	
		
		
		SBJSON *jsonParser = [SBJSON new];
		
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
		if ([apiStatus isEqualToString:@"100"]) {
			practiceId = [response valueForKey:@"practiceId"];
		}
		statusReturn = apiStatus;
		
		[returnDictionary setValue:practiceId forKey:@"practiceId"];
		[returnDictionary setValue:statusReturn forKey:@"status"];
		
		return returnDictionary;
		
	}
	@catch (NSException *e) {
		statusReturn = @"1";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
}

+(NSDictionary *)createMultipleEvents:(NSString *)token	:(NSString *)teamId :(NSString *)notificationType :(NSArray *)events{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	
	
	if ((token == nil) || (teamId == nil) || (notificationType == nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
		
		NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
		NSDictionary *loginDict = [[NSDictionary alloc] init];
		
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
		
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
		
		NSTimeZone *tmp1 = [NSTimeZone systemTimeZone];
		NSString *timeZone = [tmp1 name];
		
		[tempDictionary setObject:timeZone forKey:@"timeZone"];
		[tempDictionary setObject:notificationType forKey:@"notificationType"];
		[tempDictionary setObject:events forKey:@"practices"];
		
		
		
		loginDict = tempDictionary;
		
		
		NSString *requestString = [NSString stringWithFormat:@"%@", [loginDict JSONFragment], nil];
		
		
		[tempDictionary release];
		
		NSString *tmpUrl = [NSString stringWithFormat:@"%@/team/%@/practices/recurring/multiple", baseUrl, teamId];
		
		NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: tmpUrl]];
		
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"POST"];
		[request setHTTPBody: requestData];
		
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
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


+(NSDictionary *)getListOfEvents:(NSString *)teamId :(NSString *)token :(NSString *)eventType{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	NSMutableArray *events = [NSMutableArray array];
	
	
	if ((token == nil) || (teamId == nil) || (eventType == nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
	
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
		
		NSTimeZone *tmp1 = [NSTimeZone systemTimeZone];
		NSString *timeZone = [tmp1 name];
	
		timeZone = [timeZone stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
	
	
		NSString *tmpUrl = baseUrl;
		if (![teamId isEqualToString:@""]) {
			tmpUrl = [[tmpUrl stringByAppendingFormat:@"/team/"] stringByAppendingString:teamId];
			tmpUrl = [tmpUrl stringByAppendingFormat:@"/practices/"];
			tmpUrl = [tmpUrl stringByAppendingString:timeZone];
		}else {
			tmpUrl = [[tmpUrl stringByAppendingFormat:@"/practices/"] stringByAppendingString:timeZone];
		}
	
	
		if (![eventType isEqualToString:@""]) {
			tmpUrl = [tmpUrl stringByAppendingFormat:@"?eventType=%@", eventType];
		}
		
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:tmpUrl]];
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
	
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
	
	
		NSString *responseString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
		
		SBJSON *jsonParser = [SBJSON new];
		
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:responseString error:NULL];
		
		[responseString release];
		[request release];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
		//NOT necessarily going to be practice objects
		if ([apiStatus isEqualToString:@"100"]) {

			NSArray *eventJsonObjects = [response valueForKey:@"practices"];
	
			int size = [eventJsonObjects count];
	
			for (int i = 0; i < size; i++){
		
					NSDictionary *thisEvent = [eventJsonObjects objectAtIndex:i];
					
					if ([[thisEvent valueForKey:@"eventType"] isEqualToString:@"practice"]) {
						
						Practice *tmpPractice = [[Practice alloc] init];
						
						NSDictionary *thisPractice = [eventJsonObjects objectAtIndex:i];
						
						tmpPractice.description = [thisPractice valueForKey:@"description"];
						tmpPractice.startDate = [thisPractice valueForKey:@"startDate"];
						tmpPractice.practiceId = [thisPractice valueForKey:@"practiceId"];
						tmpPractice.location = [thisPractice valueForKey:@"opponent"];
						
						if ([thisPractice valueForKey:@"latitude"] != nil) {
							tmpPractice.latitude = [thisPractice valueForKey:@"latitude"];
						}
						if ([thisPractice valueForKey:@"longitude"] != nil) {
							tmpPractice.longitude = [thisPractice valueForKey:@"longitude"];
						}
						
						if ([teamId isEqualToString:@""]) {
							tmpPractice.ppteamId = [thisPractice valueForKey:@"teamId"];
							tmpPractice.userRole = [thisPractice valueForKey:@"participantRole"];
						}else {
							tmpPractice.ppteamId = [teamId copy];
						}
						
						if ([thisPractice valueForKey:@"teamName"] != nil) {
							tmpPractice.teamName = [thisPractice valueForKey:@"teamName"];
						}
						
						if ([thisPractice valueForKey:@"isCanceled"] != nil) {
							tmpPractice.isCanceled = [[thisPractice valueForKey:@"isCanceled"] boolValue];
						}
						
						[events addObject:tmpPractice];
						
						[tmpPractice release];
						
						
					}else if ([[thisEvent valueForKey:@"eventType"] isEqualToString:@"generic"]){
						
						Event *tmpEvent = [[Event alloc] init];
						tmpEvent.description = [thisEvent valueForKey:@"description"];
						tmpEvent.startDate = [thisEvent valueForKey:@"startDate"];
						tmpEvent.eventId = [thisEvent valueForKey:@"practiceId"];
						tmpEvent.location = [thisEvent valueForKey:@"opponent"];
						
						if ([thisEvent valueForKey:@"eventName"] != nil) {
							tmpEvent.eventName = [thisEvent valueForKey:@"eventName"];
						}
						if ([teamId isEqualToString:@""]) {
							tmpEvent.teamId = [thisEvent valueForKey:@"teamId"];
							tmpEvent.userRole = [thisEvent valueForKey:@"participantRole"];
						}else {
							tmpEvent.teamId = [teamId copy];
						}
						
						if ([thisEvent valueForKey:@"teamName"] != nil) {
							tmpEvent.teamName = [thisEvent valueForKey:@"teamName"];
						}
						
						if ([thisEvent valueForKey:@"latitude"] != nil) {
							tmpEvent.latitude = [thisEvent valueForKey:@"latitude"];
						}
						if ([thisEvent valueForKey:@"longitude"] != nil) {
							tmpEvent.longitude = [thisEvent valueForKey:@"longitude"];
						}
						
						if ([thisEvent valueForKey:@"isCanceled"] != nil) {
							tmpEvent.isCanceled = [[thisEvent valueForKey:@"isCanceled"] boolValue];
						}
						
						[events addObject:tmpEvent];
						
						[tmpEvent release];

					}
						
					
				
			}
	
			NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
			[events sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
	
			statusReturn = apiStatus;
			[returnDictionary setValue:statusReturn forKey:@"status"];
			[returnDictionary setValue:events forKey:@"events"];
			return returnDictionary;
	
		}else {
			statusReturn = apiStatus;
			[returnDictionary setValue:statusReturn forKey:@"status"];
			return returnDictionary;
		}

	}

	@catch (NSException *e) {
		statusReturn = @"1";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}	
	
}


+(NSDictionary *)getListOfEventsNow:(NSString *)token{
		
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	NSMutableArray *eventsToday = [NSMutableArray array];
	NSMutableArray *eventsTomorrow = [NSMutableArray array];
	
	
	if (token == nil) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
		
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
		
		NSTimeZone *tmp1 = [NSTimeZone systemTimeZone];
		NSString *timeZone = [tmp1 name];
		
		timeZone = [timeZone stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
		
		
		NSString *tmpUrl = baseUrl;
	
		tmpUrl = [tmpUrl stringByAppendingFormat:@"/practices/%@?happening=now", timeZone];
		
	
		
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:tmpUrl]];
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		
		
		NSString *responseString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
				
		SBJSON *jsonParser = [SBJSON new];
		        
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:responseString error:NULL];
		
		[responseString release];
		[request release];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
		//NOT necessarily going to be practice objects
		if ([apiStatus isEqualToString:@"100"]) {
		
			if ([response valueForKey:@"today"] != nil) {
				//if there are any events today
				NSArray *today = [response valueForKey:@"today"];
				
				for (int i = 0; i < [today count]; i++) {
					
					NSDictionary *todaysEvent = [today objectAtIndex:i];
					
					CurrentEvent *tmpEvent = [[CurrentEvent alloc] init];
					
					tmpEvent.eventType = [todaysEvent valueForKey:@"eventType"];
					tmpEvent.eventName = [todaysEvent valueForKey:@"eventName"];
					tmpEvent.eventId = [todaysEvent valueForKey:@"eventId"];
					tmpEvent.eventDescription = [todaysEvent valueForKey:@"description"];
					tmpEvent.eventDate = [todaysEvent valueForKey:@"startDate"];
					
					tmpEvent.teamName = [todaysEvent valueForKey:@"teamName"];
					tmpEvent.teamId = [todaysEvent valueForKey:@"teamId"];
					tmpEvent.participantRole = [todaysEvent valueForKey:@"participantRole"];
					
					tmpEvent.gameInterval = [[todaysEvent valueForKey:@"interval"] stringValue];
					tmpEvent.sport = [todaysEvent valueForKey:@"sport"];
					tmpEvent.scoreUs = [[todaysEvent valueForKey:@"scoreUs"] stringValue];
					tmpEvent.scoreThem = [[todaysEvent valueForKey:@"scoreThem"] stringValue];
					tmpEvent.opponent = [todaysEvent valueForKey:@"opponent"];
					
					if ([todaysEvent valueForKey:@"isCanceled"] != nil) {
						tmpEvent.isCanceled = [[todaysEvent valueForKey:@"isCanceled"] boolValue];
					}else {
						tmpEvent.isCanceled = false;
					}

					if ([todaysEvent valueForKey:@"latitude"] != nil) {
						tmpEvent.latitude = [todaysEvent valueForKey:@"latitude"];
						tmpEvent.longitude = [todaysEvent valueForKey:@"longitude"];
					}
										
					[eventsToday addObject:tmpEvent];
					[tmpEvent release];
					
				}
				
			}
			
			if ([response valueForKey:@"tomorrow"] != nil) {
				//if there are any events today
				NSArray *tomorrow = [response valueForKey:@"tomorrow"];
								
				for (int i = 0; i < [tomorrow count]; i++) {
					
					NSDictionary *tomorrowsEvent = [tomorrow objectAtIndex:i];
					
					CurrentEvent *tmpEvent = [[CurrentEvent alloc] init];
					
					tmpEvent.eventType = [tomorrowsEvent valueForKey:@"eventType"];
					tmpEvent.eventName = [tomorrowsEvent valueForKey:@"eventName"];
					tmpEvent.eventId = [tomorrowsEvent valueForKey:@"eventId"];
					tmpEvent.eventDescription = [tomorrowsEvent valueForKey:@"description"];
					tmpEvent.eventDate = [tomorrowsEvent valueForKey:@"startDate"];
					
					tmpEvent.teamName = [tomorrowsEvent valueForKey:@"teamName"];
					tmpEvent.teamId = [tomorrowsEvent valueForKey:@"teamId"];
					tmpEvent.participantRole = [tomorrowsEvent valueForKey:@"participantRole"];
					
					tmpEvent.gameInterval = [[tomorrowsEvent valueForKey:@"interval"] stringValue];
					tmpEvent.sport = [tomorrowsEvent valueForKey:@"sport"];
					tmpEvent.scoreUs = [[tomorrowsEvent valueForKey:@"scoreUs"] stringValue];
					tmpEvent.scoreThem = [[tomorrowsEvent valueForKey:@"scoreThem"] stringValue];
					tmpEvent.opponent = [tomorrowsEvent valueForKey:@"opponent"];
					
					if ([tomorrowsEvent valueForKey:@"isCanceled"] != nil) {
						tmpEvent.isCanceled = [[tomorrowsEvent valueForKey:@"isCanceled"] boolValue];
					}else {
						tmpEvent.isCanceled = false;
					}
					
					if ([tomorrowsEvent valueForKey:@"latitude"] != nil) {
						tmpEvent.latitude = [tomorrowsEvent valueForKey:@"latitude"];
						tmpEvent.longitude = [tomorrowsEvent valueForKey:@"longitude"];
					}
					
					[eventsTomorrow addObject:tmpEvent];
					[tmpEvent release];
					
				}
				
				
			}
			
			
			NSSortDescriptor *dateSorter = [[NSSortDescriptor alloc] initWithKey:@"eventDate" ascending:YES];
			[eventsToday sortUsingDescriptors:[NSArray arrayWithObject:dateSorter]];
			[eventsTomorrow sortUsingDescriptors:[NSArray arrayWithObject:dateSorter]];
			
			statusReturn = apiStatus;
		
			
			[returnDictionary setValue:statusReturn forKey:@"status"];
			[returnDictionary setValue:eventsToday forKey:@"eventsToday"];
			[returnDictionary setValue:eventsTomorrow forKey:@"eventsTomorrow"];
			return returnDictionary; 
			
		}else {
			statusReturn = apiStatus;
			[returnDictionary setValue:statusReturn forKey:@"status"];
			return returnDictionary;
		}
		
	}
	
	@catch (NSException *e) {
		statusReturn = @"1";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}	
	
}
+(NSDictionary *)getEventInfo:(NSString *)eventId :(NSString *)teamId :(NSString *)token{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	NSDictionary *eventInfo = [NSDictionary dictionary];
	
	
	if ((token == nil) || (teamId == nil) || (eventId == nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
		
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
		
		NSTimeZone *tmp1 = [NSTimeZone systemTimeZone];
		NSString *timeZone = [tmp1 name];
		
		timeZone = [timeZone stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
		
		NSString *tmpUrl = [[baseUrl stringByAppendingFormat:@"/team/"] stringByAppendingString:teamId];
		tmpUrl = [tmpUrl stringByAppendingFormat:@"/practice/"];
		tmpUrl = [tmpUrl stringByAppendingString:eventId];
		tmpUrl = [tmpUrl stringByAppendingFormat:@"/"];
		tmpUrl = [tmpUrl stringByAppendingString:timeZone];
		
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:tmpUrl]];
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"GET"];
		
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		
		
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
		
		SBJSON *jsonParser = [SBJSON new];
		
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
		if ([apiStatus isEqualToString:@"100"]) {
			eventInfo = response;
		}
		
		statusReturn = apiStatus;
		
		[returnDictionary setValue:eventInfo forKey:@"eventInfo"];
		[returnDictionary setValue:statusReturn forKey:@"status"];
		
		return returnDictionary;
		
	}
	@catch (NSException *e) {
		statusReturn = @"1";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
}

+(NSDictionary *)updateEvent:(NSString *)token :(NSString *)teamId :(NSString *)eventId :(NSString *)startDate :(NSString *)endDate :(NSString *)timeZone
							:(NSString *)description :(NSString *)latitude :(NSString *)longitude :(NSString *)location :(NSString *)notifyTeam
							:(NSString *)eventName :(NSString *)updateAll :(NSString *)isCanceled{
	
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	
	
	if ((token == nil) || (teamId == nil) || (eventId == nil) || (startDate == nil) || (endDate == nil) || (timeZone == nil) || (description == nil)
		|| (latitude == nil) || (longitude == nil) || (location == nil) || (notifyTeam == nil) || (eventName == nil) || (updateAll == nil) || (isCanceled == nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{

		
		NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
		NSDictionary *loginDict = [[NSDictionary alloc] init];
	
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
	
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
	
		if (![startDate isEqualToString:@""]){
			[ tempDictionary setObject:startDate forKey:@"startDate"];
		}
		if (![endDate isEqualToString:@""]){
			[ tempDictionary setObject:endDate forKey:@"endDate"];
		}
		if (![timeZone isEqualToString:@""]){
			[ tempDictionary setObject:timeZone forKey:@"timeZone"];
		}
		if (![description isEqualToString:@""]){
			[ tempDictionary setObject:description forKey:@"description"];
		}
		if (![latitude isEqualToString:@""]){
			[ tempDictionary setObject:latitude forKey:@"latitude"];
		}
		if (![longitude isEqualToString:@""]){
			[ tempDictionary setObject:longitude forKey:@"longitude"];
		}
		if (![location isEqualToString:@""]){
			[ tempDictionary setObject:location forKey:@"opponent"];
		}
	
		if (![eventName isEqualToString:@""]){
			[ tempDictionary setObject:eventName forKey:@"eventName"];
		}
		
		if (![notifyTeam isEqualToString:@""]) {
			
			if ([notifyTeam isEqualToString:@"true"]) {
				[tempDictionary setObject:@"plain" forKey:@"notificationType"];
			}else {
				[tempDictionary setObject:@"none" forKey:@"notificationType"];
				
			}
			
		}
	
		NSNumber *cancel;
		
		if ([isCanceled isEqualToString:@"true"]) {
			cancel = [NSNumber numberWithBool:1];
			[tempDictionary setObject:cancel forKey:@"isCanceled"];
		}else {
			cancel = [NSNumber numberWithBool:0];
			[tempDictionary setObject:cancel forKey:@"isCanceled"];
		}
		
		NSNumber *upAll;
		
		if ([updateAll isEqualToString:@"true"]) {
			upAll = [NSNumber numberWithBool:1];
			[tempDictionary setObject:upAll forKey:@"updateAll"];
		}else {
			upAll = [NSNumber numberWithBool:0];
			[tempDictionary setObject:upAll forKey:@"updateAll"];
		}
		
		loginDict = tempDictionary;
	
	
		NSString *requestString = [NSString stringWithFormat:@"%@", [loginDict JSONFragment], nil];
		
		[loginDict release];
	
		NSString *tmpUrl = [baseUrl stringByAppendingFormat:@"/team/"];
		tmpUrl = [tmpUrl stringByAppendingString:teamId];
		tmpUrl = [tmpUrl stringByAppendingFormat:@"/practice/"];
		tmpUrl = [tmpUrl stringByAppendingString:eventId];
	
		NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: tmpUrl]];
	
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"PUT"];
		[request setHTTPBody: requestData];
	
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];

		
		SBJSON *jsonParser = [SBJSON new];
		
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
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

+(NSDictionary *)updateAttendees:(NSString *)token :(NSString *)teamId :(NSString *)eventId :(NSString *)eventType :(NSArray *)attList 
								:(NSString *)startDate{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	
	
	if ((token == nil) || (teamId == nil) || (eventId == nil) || (eventType	== nil) || (attList == nil) || (startDate == nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
		NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
		NSDictionary *loginDict = [[NSDictionary alloc] init];
	
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
	
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
	
		[ tempDictionary setObject:teamId forKey:@"teamId"];
		[ tempDictionary setObject:eventId forKey:@"eventId"];
		[ tempDictionary setObject:eventType forKey:@"eventType"];
		[ tempDictionary setObject:attList forKey:@"attendees"];
		[ tempDictionary setObject:startDate forKey:@"eventDate"];
	
		loginDict = tempDictionary;
	
	
		NSString *requestString = [NSString stringWithFormat:@"%@", [loginDict JSONFragment], nil];
		
		[loginDict release];
	
		NSString *tmpUrl = [baseUrl stringByAppendingFormat:@"/attendees"];
	
		NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: tmpUrl]];
	
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"PUT"];
		[request setHTTPBody: requestData];
	
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
	
		SBJSON *jsonParser = [SBJSON new];
		        
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
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

+(NSDictionary *)getAttendeesGame:(NSString *)token :(NSString *)teamId :(NSString *)eventId :(NSString *)eventType{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	NSDictionary *attendance = [NSDictionary dictionary];
	
	if ((token == nil) || (teamId == nil) || (eventId == nil) || (eventType	== nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
	
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
	
		NSString *tmpUrl = [[baseUrl stringByAppendingFormat:@"/attendees?teamId="] stringByAppendingString:teamId];
		tmpUrl = [tmpUrl stringByAppendingFormat:@"&"];
		tmpUrl = [tmpUrl stringByAppendingFormat:@"eventId="];
		tmpUrl = [tmpUrl stringByAppendingString:eventId];
		tmpUrl = [tmpUrl stringByAppendingFormat:@"&"];
		tmpUrl = [tmpUrl stringByAppendingFormat:@"eventType="];
		tmpUrl = [tmpUrl stringByAppendingString:eventType];
	
	
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:tmpUrl]];
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"GET"];
	
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
	
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
		
		SBJSON *jsonParser = [SBJSON new];
		
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
		if ([apiStatus isEqualToString:@"100"]) {
			attendance = [response valueForKey:@"attendees"];
		}
		statusReturn = apiStatus;
		
		[returnDictionary setValue:attendance forKey:@"attendance"];
		[returnDictionary setValue:statusReturn forKey:@"status"];
		
		return returnDictionary;
		
	}
	@catch (NSException *e) {
		statusReturn = @"1";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
}

+(NSDictionary *)getAttendeesMember:(NSString *)token :(NSString *)teamId :(NSString *)memberId :(NSString *)eventType 
								   :(NSString *)startDate :(NSString *)endDate{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	NSDictionary *attendance = [NSDictionary dictionary];
	
	if ((token == nil) || (teamId == nil) || (memberId == nil) || (eventType == nil) || (startDate == nil) || (endDate == nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
	
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
	
		NSTimeZone *tmp1 = [NSTimeZone systemTimeZone];
		NSString *timeZone = [tmp1 name];
		timeZone = [timeZone stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
	
		NSString *tmpUrl = [[baseUrl stringByAppendingFormat:@"/attendees?teamId="] stringByAppendingString:teamId];
	
		tmpUrl = [tmpUrl stringByAppendingFormat:@"&memberId="];
		tmpUrl = [tmpUrl stringByAppendingString:memberId];
	
		tmpUrl = [tmpUrl stringByAppendingFormat:@"&timeZone="];
		tmpUrl = [tmpUrl stringByAppendingString:timeZone];
	
		if (![eventType isEqualToString:@""]) {
			tmpUrl = [tmpUrl stringByAppendingFormat:@"&eventType="];
			tmpUrl = [tmpUrl stringByAppendingString:eventType];
		}
	
		if (![startDate isEqualToString:@""]){
			tmpUrl = [tmpUrl stringByAppendingFormat:@"&startDate="];
			tmpUrl = [tmpUrl stringByAppendingString:startDate];
		}
	
		if (![endDate isEqualToString:@""]) {
			tmpUrl = [tmpUrl stringByAppendingFormat:@"&endDate="];
			tmpUrl = [tmpUrl stringByAppendingString:endDate];
		}
	
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:tmpUrl]];
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"GET"];
	
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
	
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
		SBJSON *jsonParser = [SBJSON new];
	
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
	
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
	
		if ([apiStatus isEqualToString:@"100"]) {
			attendance = [response valueForKey:@"attendees"];
		}
		statusReturn = apiStatus;
	
		[returnDictionary setValue:attendance forKey:@"attendance"];
		[returnDictionary setValue:statusReturn forKey:@"status"];
	
		return returnDictionary;
	
	}
	@catch (NSException *e) {
		statusReturn = @"1";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
}

+(NSDictionary *)deleteGame:(NSString *)token :(NSString *)teamId :(NSString *)gameId{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	
	
	if ((token == nil) || (teamId == nil) || (gameId == nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
	
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
	
		NSString *tmpUrl = [[baseUrl stringByAppendingFormat:@"/team/"] stringByAppendingString:teamId];
		tmpUrl = [tmpUrl stringByAppendingFormat:@"/game/"];
		tmpUrl = [tmpUrl stringByAppendingString:gameId];
	
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:tmpUrl]];
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"DELETE"];
	
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
	
	
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
		SBJSON *jsonParser = [SBJSON new];
	
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
	
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
	
	
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

+(NSDictionary *)deleteEvent:(NSString *)token :(NSString *)teamId :(NSString *)practiceId{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	
	
	if ((token == nil) || (teamId == nil) || (practiceId == nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
		
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
		
		NSString *tmpUrl = [[baseUrl stringByAppendingFormat:@"/team/"] stringByAppendingString:teamId];
		tmpUrl = [tmpUrl stringByAppendingFormat:@"/practice/"];
		tmpUrl = [tmpUrl stringByAppendingString:practiceId];
		
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:tmpUrl]];
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"DELETE"];
		
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		
		
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
		
		SBJSON *jsonParser = [SBJSON new];
		
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
		
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


+(NSDictionary *)createMessageThread:(NSString *)token :(NSString *)teamId :(NSString *)subject :(NSString *)body :(NSString *)type :(NSString *)eventId 
									:(NSString *)eventType :(NSString *)isAlert :(NSArray *)pollChoices :(NSArray *)recipients :(NSString *)displayResults
									:(NSString *)includeFans :(NSString *)coordinatorsOnly {
	
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	NSString *messageThreadId = @"";
	
	
	if ((token == nil) || (teamId == nil) || (subject == nil) || (body == nil) || (type == nil) || (eventId == nil) || (eventType == nil)
		|| (isAlert == nil) || (pollChoices == nil) || (recipients == nil) || (displayResults == nil) || (includeFans == nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{

		
		NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
		NSDictionary *loginDict = [[NSDictionary alloc] init];
	
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
	
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
	
	
		[ tempDictionary setObject:subject forKey:@"subject"];
		[ tempDictionary setObject:body forKey:@"body"];
		[ tempDictionary setObject:type forKey:@"type"];
	
	
		if (![eventId isEqualToString:@""]){
			[ tempDictionary setObject:eventId forKey:@"eventId"];
			[ tempDictionary setObject:eventType forKey:@"eventType"];

		}
		if ([pollChoices count] > 0){
			[ tempDictionary setObject:pollChoices forKey:@"pollChoices"];
		}
		if ([recipients count] > 0){
			[ tempDictionary setObject:recipients forKey:@"recipients"];
		}
		if (![isAlert isEqualToString:@""]){
			[ tempDictionary setObject:isAlert forKey:@"isAlert"];
		}
		if (![displayResults isEqualToString:@""]){
			[ tempDictionary setObject:displayResults forKey:@"isPublic"];
		}
		
		if (![includeFans isEqualToString:@""]){
			[ tempDictionary setObject:includeFans forKey:@"includeFans"];
		}
	
		
		if (![coordinatorsOnly isEqualToString:@""]) {
			
			NSNumber *coordOnly;
			
			if ([coordinatorsOnly isEqualToString:@"true"]) {
				coordOnly = [NSNumber numberWithBool:1];
				[tempDictionary setObject:coordOnly forKey:@"coordinatorsOnly"];
			}
		}
	
		loginDict = tempDictionary;
	
	
		NSString *requestString = [NSString stringWithFormat:@"%@", [loginDict JSONFragment], nil];

		[tempDictionary release];
	
		NSString *tmpUrl = [baseUrl stringByAppendingFormat:@"/team/"];
		tmpUrl = [tmpUrl stringByAppendingString:teamId];
		tmpUrl = [tmpUrl stringByAppendingFormat:@"/messageThreads"];
	
		NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: tmpUrl]];
	
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"POST"];
		[request setHTTPBody: requestData];
	
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
	
		SBJSON *jsonParser = [SBJSON new];

		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
		
		if ([apiStatus isEqualToString:@"100"]) {
			messageThreadId = [response valueForKey:@"messageThreadId"];
		}
		statusReturn = apiStatus;
		
		[returnDictionary setValue:statusReturn forKey:@"status"];
		[returnDictionary setValue:messageThreadId forKey:@"messageThreadId"];
		return returnDictionary;
		
	}
	@catch (NSException *e) {
		statusReturn = @"1";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
}

+(NSDictionary *)getMessageThreadInfo:(NSString *)token :(NSString *)teamId :(NSString *)messageThreadId{

	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	NSDictionary *messageThreadInfo = [NSDictionary dictionary];
	
	
	if ((token == nil) || (teamId == nil) || (messageThreadId == nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{

		
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
	
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
		
		NSString *timeZone = [[NSTimeZone systemTimeZone] name];
		timeZone = [timeZone stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];

		NSString *tmpUrl = [baseUrl stringByAppendingFormat:@"/team/"];
		tmpUrl = [tmpUrl stringByAppendingString:teamId];
		tmpUrl = [tmpUrl stringByAppendingFormat:@"/messageThread/"];
		tmpUrl = [tmpUrl stringByAppendingString:messageThreadId];
		tmpUrl = [tmpUrl stringByAppendingFormat:@"/"];
		tmpUrl = [tmpUrl stringByAppendingString:timeZone];
		tmpUrl = [tmpUrl stringByAppendingFormat:@"?includeMemberInfo=true"];
	
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: tmpUrl]];
	
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"GET"];
	
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
	
		SBJSON *jsonParser = [SBJSON new];
		
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
		if ([apiStatus isEqualToString:@"100"]) {
			messageThreadInfo = response;
		}
		statusReturn = apiStatus;
		
		[returnDictionary setValue:statusReturn forKey:@"status"];
		[returnDictionary setValue:messageThreadInfo forKey:@"messageThreadInfo"];
		return returnDictionary;
		
	}
	@catch (NSException *e) {
		statusReturn = @"1";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
}

+(NSDictionary *)getMessageThreads:(NSString *)token :(NSString *)teamId :(NSString *)messageGroup :(NSString *)eventId :(NSString *)eventType 
							 :(NSString *)pollOrMsg :(NSString *)status{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	NSArray *messageArray = [NSArray array];
	
	
	if ((token == nil) || (teamId == nil) || (messageGroup == nil) || (eventId == nil) || (eventType == nil)
		|| (pollOrMsg == nil) || (status == nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
		bool isPoll = false;
		if ([pollOrMsg isEqualToString:@"poll"]) {
			isPoll = true;
		}
	
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
	
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
	
		NSString *timeZone = [[NSTimeZone systemTimeZone] name];
		timeZone = [timeZone stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
	
	
		NSString *tmpUrl = baseUrl;
	
		if (![teamId isEqualToString:@""]) {
			tmpUrl = [tmpUrl stringByAppendingFormat:@"/team/"];
			tmpUrl = [tmpUrl stringByAppendingString:teamId];
		}
	
		tmpUrl = [tmpUrl stringByAppendingFormat:@"/messageThreads/"];
		tmpUrl = [tmpUrl stringByAppendingString:timeZone];
	
		bool param = false;
	
		if (![messageGroup isEqualToString:@""]) {
			tmpUrl = [tmpUrl stringByAppendingFormat:@"?messageGroup="];
			tmpUrl = [tmpUrl stringByAppendingString:messageGroup];
			param = true;
		}
	
		if (![status isEqualToString:@""]) {
		
			if (param) {
				tmpUrl = [tmpUrl stringByAppendingFormat:@"&"];
			}else {
				tmpUrl = [tmpUrl stringByAppendingFormat:@"?"];
			}
			tmpUrl = [tmpUrl stringByAppendingFormat:@"status="];
			tmpUrl = [tmpUrl stringByAppendingString:status];
			param = true;
		}
	
	
		if (![eventId isEqualToString:@""]) {
			if (param) {
				tmpUrl = [tmpUrl stringByAppendingFormat:@"&"];
			}else {
				tmpUrl = [tmpUrl stringByAppendingFormat:@"?"];
			}
		
			tmpUrl = [tmpUrl stringByAppendingFormat:@"eventId="];
			tmpUrl = [tmpUrl stringByAppendingString:eventId];
			tmpUrl = [tmpUrl stringByAppendingFormat:@"&eventType="];
			tmpUrl = [tmpUrl stringByAppendingString:eventType];
		

		}
		
		if (param) {
			tmpUrl = [tmpUrl stringByAppendingFormat:@"&"];
		}else {
			tmpUrl = [tmpUrl stringByAppendingFormat:@"?"];
		}
		
		tmpUrl = [tmpUrl stringByAppendingFormat:@"useThreads=true"];
		

	
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: tmpUrl]];

		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"GET"];
	
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
					
		SBJSON *jsonParser = [SBJSON new];
                
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
	    if ([apiStatus isEqualToString:@"100"]) {
			
		
			NSMutableArray *returnThreads = [NSMutableArray array];
	
			if (![messageGroup isEqualToString:@"outbox"]) {
		
				NSArray *inbox = [response valueForKey:@"inbox"];
						
				for (int i = 0; i < [inbox count]; i++) {
					NSDictionary *message = [inbox objectAtIndex:i];
			
					if (([message valueForKey:@"gameId"] == nil) && ([message valueForKey:@"practiceId"] == nil)) {
						
						MessageThreadInbox *tmp = [[MessageThreadInbox alloc] init];
						
						tmp.threadingUsed = false;
						tmp.threadId = [message valueForKey:@"messageThreadId"];
						tmp.subject = [message valueForKey:@"subject"];
						tmp.body = [message valueForKey:@"body"];
						tmp.messageType = [message valueForKey:@"type"];
						tmp.status = [message valueForKey:@"status"];
						tmp.receivedDate = [message valueForKey:@"receivedDate"];
						tmp.isReminder = [message valueForKey:@"isReminder"];
					
						tmp.wasViewed = [[message valueForKey:@"wasViewed"] boolValue];


                        if ([message valueForKey:@"participantRole"] != nil) {
                            tmp.participantRole = [message valueForKey:@"participantRole"];
                        }else{
                            tmp.participantRole = @"";
                        }
						tmp.pollChoices = [message valueForKey:@"pollChoices"];
						tmp.followUp = [message valueForKey:@"followUpMessage"];
						tmp.senderName = [message valueForKey:@"senderName"];
						tmp.senderId = [message valueForKey:@"senderMemberId"];
						tmp.teamId = [message valueForKey:@"teamId"];
						tmp.teamName = [message valueForKey:@"teamName"];

			
						if (isPoll) {
							if ([tmp.messageType isEqualToString:@"poll"]) {
								[returnThreads addObject:tmp];
							}
						}else {
							if (![tmp.messageType isEqualToString:@"poll"]) {
								[returnThreads addObject:tmp];
							}else if ([pollOrMsg isEqualToString:@"both"]) {
								[returnThreads addObject:tmp];
							}
						}
						
						[tmp release];

					}else if ([message valueForKey:@"practiceId"] == nil) {
						//Handle the gameId threads
						MessageThreadInbox *tmp = [[MessageThreadInbox alloc] init];
						tmp.threadingUsed = true;
						tmp.eventType = @"game";
						NSArray *messages = [message valueForKey:@"messages"];
						
						tmp.eventId = [message valueForKey:@"gameId"];
						tmp.numberOfMessages = [messages count];
						tmp.subject = [NSString stringWithFormat:@"Game Thread (%d)", [messages count]];
					

						NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
						[dateFormat setDateFormat:@"YYYY-MM-dd HH:mm"];
						
						NSDate *finalDate = [dateFormat dateFromString:@"2000-01-01 11:00"];
						
						tmp.wasViewed = true;
						
						NSMutableArray *subIds = [NSMutableArray array];
						
						for (int j = 0; j < [messages count]; j++) {
							
							NSDictionary *tmpDictionary = [messages objectAtIndex:j];
							
							NSString *tmpDateString = [tmpDictionary valueForKey:@"receivedDate"];
							
							bool tmpBool = [[tmpDictionary valueForKey:@"wasViewed"] boolValue];
							
							if (!tmpBool) {
								tmp.wasViewed = false;
							}

							tmp.teamName = [tmpDictionary valueForKey:@"teamName"];
							tmp.teamId = [tmpDictionary valueForKey:@"teamId"];
														
							NSDate *tmpDate = [dateFormat dateFromString:tmpDateString];
							
							if ([finalDate isEqualToDate:[finalDate earlierDate:tmpDate]]) {
								
								finalDate = tmpDate;
							}
							
							NSString *tmpThreadId = [tmpDictionary valueForKey:@"messageThreadId"];
							[subIds addObject:tmpThreadId];
							
							
						}
						
						tmp.subThreadIds = subIds;
						NSString *finalStringDate = [dateFormat stringFromDate:finalDate];
						NSDate *tmpBodyDate = [dateFormat dateFromString:[message valueForKey:@"date"]];
						tmp.eventDate = [message valueForKey:@"date"];
						[dateFormat setDateFormat:@"MM/dd"];
						tmp.body = [NSString stringWithFormat:@"Messages for Game on %@", [dateFormat stringFromDate:tmpBodyDate]];
						[dateFormat release];
												
						tmp.receivedDate = finalStringDate;
						
						if (isPoll) {
							if ([tmp.messageType isEqualToString:@"poll"]) {
								[returnThreads addObject:tmp];
							}
						}else {
							if (![tmp.messageType isEqualToString:@"poll"]) {
								[returnThreads addObject:tmp];
							}else if ([pollOrMsg isEqualToString:@"both"]) {
								[returnThreads addObject:tmp];
							}
						}
						
						[tmp release];
						
					}else {
						//Handle the practiceId threads
						MessageThreadInbox *tmp = [[MessageThreadInbox alloc] init];
						tmp.threadingUsed = true;
						tmp.eventType = @"practice";
						NSArray *messages = [message valueForKey:@"messages"];
						
						tmp.eventId = [message valueForKey:@"practiceId"];
						tmp.numberOfMessages = [messages count];
						tmp.subject = [NSString stringWithFormat:@"Event Thread (%d)", [messages count]];
						
						
						NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
						[dateFormat setDateFormat:@"YYYY-MM-dd HH:mm"];
						
						NSDate *finalDate = [dateFormat dateFromString:@"2000-01-01 11:00"];
						
						tmp.wasViewed = false;
						
						NSMutableArray *subIds = [NSMutableArray array];
						for (int j = 0; j < [messages count]; j++) {
							
							NSDictionary *tmpDictionary = [messages objectAtIndex:j];
							
							NSString *tmpDateString = [tmpDictionary valueForKey:@"receivedDate"];
							
							bool tmpBool = [[tmpDictionary valueForKey:@"wasViewed"] boolValue];
							
							if (tmpBool) {
								tmp.wasViewed = true;
							}
							
							tmp.teamId = [tmpDictionary valueForKey:@"teamId"];
							tmp.teamName = [tmpDictionary valueForKey:@"teamName"];

							NSDate *tmpDate = [dateFormat dateFromString:tmpDateString];
							
							if ([finalDate isEqualToDate:[finalDate earlierDate:tmpDate]]) {
								
								finalDate = tmpDate;
							}
							
							NSString *tmpThreadId = [tmpDictionary valueForKey:@"messageThreadId"];
							[subIds addObject:tmpThreadId];

						}
						
						tmp.subThreadIds = subIds;
						
						NSString *finalStringDate = [dateFormat stringFromDate:finalDate];
						NSDate *tmpBodyDate = [dateFormat dateFromString:[message valueForKey:@"date"]];
						tmp.eventDate = [message valueForKey:@"date"];

						[dateFormat setDateFormat:@"MM/dd"];
						tmp.body = [NSString stringWithFormat:@"Messages for Event on %@", [dateFormat stringFromDate:tmpBodyDate]];
						
						[dateFormat release];
						
						tmp.receivedDate = finalStringDate;
						
						if (isPoll) {
							if ([tmp.messageType isEqualToString:@"poll"]) {
								[returnThreads addObject:tmp];
							}
						}else {
							if (![tmp.messageType isEqualToString:@"poll"]) {
								[returnThreads addObject:tmp];
							}else if ([pollOrMsg isEqualToString:@"both"]) {
								[returnThreads addObject:tmp];
							}
						}
						
						[tmp release];
						
						
						
					}


				}
			}
	
			if (![messageGroup isEqualToString:@"inbox"]) {
		
				NSArray *outbox = [response valueForKey:@"outbox"];
		
				for (int i = 0; i < [outbox count]; i++) {
					NSDictionary *message = [outbox objectAtIndex:i];
			
					if (([message valueForKey:@"gameId"] == nil) && ([message valueForKey:@"practiceId"] == nil)) {

						MessageThreadOutbox *tmp = [[MessageThreadOutbox alloc] init];
			
						tmp.threadId = [message valueForKey:@"messageThreadId"];
						tmp.subject = [message valueForKey:@"subject"];
						tmp.body = [message valueForKey:@"body"];
						tmp.messageType = [message valueForKey:@"type"];
						tmp.status = [message valueForKey:@"status"];
						tmp.createdDate = [message valueForKey:@"createdDate"];
						tmp.numRecipients = [[message valueForKey:@"numOfRecipients"] stringValue];
						tmp.numReplies = [[message valueForKey:@"numOfReplies"] stringValue];
						tmp.teamId = [message valueForKey:@"teamId"];
						tmp.teamName = [message valueForKey:@"teamName"];

					
						if ([message valueForKey:@"followUpMessage"] != nil) {
								tmp.followUp = [message valueForKey:@"followUpMessage"];
						}
			
						if (isPoll) {
							if ([tmp.messageType isEqualToString:@"poll"]) {
								[returnThreads addObject:tmp];
							}
						}else {
							if (![tmp.messageType isEqualToString:@"poll"]) {
								[returnThreads addObject:tmp];
							}else if ([pollOrMsg isEqualToString:@"both"]) {
								[returnThreads addObject:tmp];
							}
						}

						[tmp release];
						
					}else if ([message valueForKey:@"practiceId"] == nil) {
						//Handle the gameId threads
						
						MessageThreadOutbox *tmp = [[MessageThreadOutbox alloc] init];
						tmp.threadingUsed = true;
						tmp.eventType = @"game";
						NSArray *messages = [message valueForKey:@"messages"];
						
						tmp.eventId = [message valueForKey:@"gameId"];
						tmp.numberOfMessages = [messages count];
						tmp.subject = [NSString stringWithFormat:@"Game Thread (%d)", [messages count]];
						
						
						NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
						[dateFormat setDateFormat:@"YYYY-MM-dd HH:mm"];
						
						NSDate *finalDate = [dateFormat dateFromString:@"2000-01-01 11:00"];
						
						NSMutableArray *subIds = [NSMutableArray array];
						for (int j = 0; j < [messages count]; j++) {
							
							NSDictionary *tmpDictionary = [messages objectAtIndex:j];
							
							NSString *tmpDateString = [tmpDictionary valueForKey:@"createdDate"];
							
							tmp.teamId = [tmpDictionary valueForKey:@"teamId"];
							tmp.teamName = [tmpDictionary valueForKey:@"teamName"];

							NSDate *tmpDate = [dateFormat dateFromString:tmpDateString];
							
							if ([finalDate isEqualToDate:[finalDate earlierDate:tmpDate]]) {
								
								finalDate = tmpDate;
							}
							
							NSString *tmpThreadId = [tmpDictionary valueForKey:@"messageThreadId"];
							[subIds addObject:tmpThreadId];

						}
						
						tmp.subThreadIds = subIds;
						
						NSString *finalStringDate = [dateFormat stringFromDate:finalDate];
						NSDate *tmpBodyDate = [dateFormat dateFromString:[message valueForKey:@"date"]];
						tmp.eventDate = [message valueForKey:@"date"];

						[dateFormat setDateFormat:@"MM/dd"];
						tmp.body = [NSString stringWithFormat:@"Messages for Game on %@", [dateFormat stringFromDate:tmpBodyDate]];
						
						[dateFormat release];
						
						tmp.createdDate = finalStringDate;
						
						if (isPoll) {
							if ([tmp.messageType isEqualToString:@"poll"]) {
								[returnThreads addObject:tmp];
							}
						}else {
							if (![tmp.messageType isEqualToString:@"poll"]) {
								[returnThreads addObject:tmp];
							}else if ([pollOrMsg isEqualToString:@"both"]) {
								[returnThreads addObject:tmp];
							}
						}
						
						[tmp release];
						
					}else {
						//Handle the practiceId threads
						MessageThreadOutbox *tmp = [[MessageThreadOutbox alloc] init];
						tmp.threadingUsed = true;
						tmp.eventType = @"practice";
						NSArray *messages = [message valueForKey:@"messages"];
						
						tmp.eventId = [message valueForKey:@"practiceId"];
						tmp.numberOfMessages = [messages count];
						tmp.subject = [NSString stringWithFormat:@"Event Thread (%d)", [messages count]];
						
						
						NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
						[dateFormat setDateFormat:@"YYYY-MM-dd HH:mm"];
						
						NSDate *finalDate = [dateFormat dateFromString:@"2000-01-01 11:00"];
								
						NSMutableArray *subIds = [NSMutableArray array];
						for (int j = 0; j < [messages count]; j++) {
							
							NSDictionary *tmpDictionary = [messages objectAtIndex:j];
							
							NSString *tmpDateString = [tmpDictionary valueForKey:@"createdDate"];
							
							tmp.teamId = [tmpDictionary valueForKey:@"teamId"];
							tmp.teamName = [tmpDictionary valueForKey:@"teamName"];

							NSDate *tmpDate = [dateFormat dateFromString:tmpDateString];
							
							if ([finalDate isEqualToDate:[finalDate earlierDate:tmpDate]]) {
								
								finalDate = tmpDate;
							}
							
							NSString *tmpThreadId = [tmpDictionary valueForKey:@"messageThreadId"];
							[subIds addObject:tmpThreadId];

							
						}
						
						tmp.subThreadIds = subIds;
						NSString *finalStringDate = [dateFormat stringFromDate:finalDate];
						NSDate *tmpBodyDate = [dateFormat dateFromString:[message valueForKey:@"date"]];
						tmp.eventDate = [message valueForKey:@"date"];

						[dateFormat setDateFormat:@"MM/dd"];
						tmp.body = [NSString stringWithFormat:@"Messages for Event on %@", [dateFormat stringFromDate:tmpBodyDate]];
						
						[dateFormat release];
						
						tmp.createdDate = finalStringDate;
						
						if (isPoll) {
							if ([tmp.messageType isEqualToString:@"poll"]) {
								[returnThreads addObject:tmp];
							}
						}else {
							if (![tmp.messageType isEqualToString:@"poll"]) {
								[returnThreads addObject:tmp];
							}else if ([pollOrMsg isEqualToString:@"both"]) {
								[returnThreads addObject:tmp];
							}
						}
						
						[tmp release];
						
						
						
					}
					


				}
			}
	
			[returnString release];
			[request release];
	
			messageArray = returnThreads;
			
		
			[returnDictionary setValue:apiStatus forKey:@"status"];
			[returnDictionary setValue:messageArray forKey:@"messages"];
			return returnDictionary;
		}else {
			
			[returnDictionary setValue:apiStatus forKey:@"status"];
			return returnDictionary;
		}

	
	}
	@catch (NSException *e) {
		statusReturn = @"1";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	
	
}


+(NSDictionary *)updateMessageThread:(NSString *)token :(NSString *)teamId :(NSString *)messageThreadId :(NSString *)reply :(NSString *)wasViewed 
									:(NSString *)followUpMessage :(NSString *)status{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	
	
	if ((token == nil) || (teamId == nil) || (messageThreadId == nil) || (reply == nil) || (wasViewed == nil) || (followUpMessage == nil)
		|| (status == nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{

		
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
	
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
	
		NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
		NSDictionary *loginDict = [[NSDictionary alloc] init];

	
		if (![reply isEqualToString:@""]) {
			[ tempDictionary setObject:reply forKey:@"reply"];
		}
		if (![wasViewed isEqualToString:@""]) {
			[ tempDictionary setObject:wasViewed forKey:@"wasViewed"];
		}
		if (![followUpMessage isEqualToString:@""]) {
			[ tempDictionary setObject:followUpMessage forKey:@"followupMessage"];
		}
		if (![status isEqualToString:@""]) {
			[ tempDictionary setObject:status forKey:@"status"];
		}

		loginDict = tempDictionary;
	
		
		NSString *requestString = [NSString stringWithFormat:@"%@", [loginDict JSONFragment], nil];
		
		[tempDictionary release];
	
		NSString *tmpUrl = [baseUrl stringByAppendingFormat:@"/team/"];
		tmpUrl = [tmpUrl stringByAppendingString:teamId];
		tmpUrl = [tmpUrl stringByAppendingFormat:@"/messageThread/"];
		tmpUrl = [tmpUrl stringByAppendingString:messageThreadId];
	
		NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: tmpUrl]];
	
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"PUT"];
		[request setHTTPBody: requestData];
	
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
	
		SBJSON *jsonParser = [SBJSON new];
		
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
	
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

+(NSDictionary *)updateMessageThreads:(NSString *)token :(NSArray *)threadIds :(NSString *)location{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	
	
	if ((token == nil) || (threadIds == nil) || (location == nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{

		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
		
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
		
		NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
		NSDictionary *loginDict = [[NSDictionary alloc] init];
		
		
		if ([threadIds count] > 0) {
			[ tempDictionary setObject:threadIds forKey:@"messageThreadIds"];
		}
		if (![location isEqualToString:@""]) {
			[tempDictionary setObject:location forKey:@"messageLocation"];
		}
		[tempDictionary setObject:@"archived" forKey:@"status"];
		
		loginDict = tempDictionary;
		
		
		NSString *requestString = [NSString stringWithFormat:@"%@", [loginDict JSONFragment], nil];
		
		
		[tempDictionary release];
		
		NSString *tmpUrl = [baseUrl stringByAppendingFormat:@"/messageThreads"];
	
		
		NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: tmpUrl]];
		
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"PUT"];
		[request setHTTPBody: requestData];
		
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
		
		
		SBJSON *jsonParser = [SBJSON new];
		
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
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

+(NSDictionary *)getMessageThreadCount:(NSString *)token :(NSString *)teamId :(NSString *)eventId :(NSString *)eventType :(NSString *)resynch{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	
	
	if ((token == nil) || (teamId == nil) || (eventId == nil) || (eventType == nil) || (resynch == nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
		
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
				
		NSString *tmpUrl = [baseUrl stringByAppendingFormat:@"/messageThreads/count/new"];
		
		bool param = false;
		
		if (![teamId isEqualToString:@""]) {
			param = true;
			tmpUrl = [tmpUrl stringByAppendingFormat:@"?teamId=%@", teamId];
			
			if (![eventId isEqualToString:@""]) {
				tmpUrl = [tmpUrl stringByAppendingFormat:@"&eventId=%@&eventType=%@", eventId, eventType];
			}
		}
		
		if (![resynch isEqualToString:@""]) {
			if (param) {
				tmpUrl = [tmpUrl stringByAppendingString:@"&resynchCounter=true"];

			}else {
				tmpUrl = [tmpUrl stringByAppendingString:@"?resynchCounter=true"];

			}
			param = true;


		}
		
		
		if (param){
			tmpUrl = [tmpUrl stringByAppendingString:@"&includeNewActivity=true"];

		}else {
			tmpUrl = [tmpUrl stringByAppendingString:@"?includeNewActivity=true"];

		}

		
		
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: tmpUrl]];
		
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"GET"];
		
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
		
		SBJSON *jsonParser = [SBJSON new];
		
        
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
		if ([apiStatus isEqualToString:@"100"]) {
			[returnDictionary setValue:[response valueForKey:@"count"] forKey:@"count"];
			[returnDictionary setValue:[response valueForKey:@"newActivity"] forKey:@"newActivity"];
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

+(NSDictionary *)getUserPasswordResetQuestion:(NSString *)email{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	
	
	if (email == nil){
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
		
		//email = [email stringByReplacingOccurrencesOfString:@"@" withString:@"%40"];
		NSString *tmpUrl = [baseUrl stringByAppendingFormat:@"/user/passwordResetQuestion?emailAddress=%@", email];
		
		
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: tmpUrl]];
		
		[request setHTTPMethod: @"GET"];
		
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
		
		
		SBJSON *jsonParser = [SBJSON new];
		
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
		if ([apiStatus isEqualToString:@"100"]) {
			[returnDictionary setValue:[response valueForKey:@"passwordResetQuestion"] forKey:@"passwordResetQuestion"];
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

+(NSDictionary *)getActivity:(NSString *)token :(NSString *)maxCount :(NSString *)refreshFirst :(NSString *)newOnly
							:(NSString *)mostCurrentDate :(NSString *)totalNumberOfDays{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	NSMutableArray *activities = [NSMutableArray array];
	
	
	if ((token == nil) || (mostCurrentDate == nil) || (maxCount == nil) || (refreshFirst == nil) || (newOnly == nil) || (totalNumberOfDays == nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		

		
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
		
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
		
		NSTimeZone *tmp1 = [NSTimeZone systemTimeZone];
		NSString *timeZone = [tmp1 name];
		
		timeZone = [timeZone stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
		
		NSString *tmpUrl = @"";
		
		
		tmpUrl = [NSString stringWithFormat:@"%@/activities/%@", baseUrl, timeZone];
		
		bool firstParam = false;
		
		if (![maxCount isEqualToString:@""]){
			
			tmpUrl = [tmpUrl stringByAppendingFormat:@"?maxCount=%@", maxCount];
			firstParam = true;
		}
		
		if (![refreshFirst isEqualToString:@""]){
			
			NSString *symbol;
			if (firstParam) {
				symbol = @"&";
			}else {
				symbol = @"?";
			}
			
			tmpUrl = [tmpUrl stringByAppendingFormat:@"%@refreshFirst=%@", symbol, refreshFirst];
			firstParam = true;
			if ([refreshFirst isEqualToString:@"true"] && ![newOnly isEqualToString:@""]) {
				tmpUrl = [tmpUrl stringByAppendingFormat:@"&newOnly=%@", newOnly];
			}
			
		}
		
		
		if (![mostCurrentDate isEqualToString:@""]){
			
				
				NSString *symbol;
				if (firstParam) {
					symbol = @"&";
				}else {
					symbol = @"?";
				}
			firstParam = true;
				tmpUrl = [tmpUrl stringByAppendingFormat:@"%@mostCurrentDate=%@", symbol, mostCurrentDate];
				
			
			
		}
		
		if (![totalNumberOfDays isEqualToString:@""]){
			
			
			NSString *symbol;
			if (firstParam) {
				symbol = @"&";
			}else {
				symbol = @"?";
			}
			
			tmpUrl = [tmpUrl stringByAppendingFormat:@"%@totalNumberOfDays=%@", symbol, totalNumberOfDays];
			
			
			
		}
		
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: tmpUrl]];
		
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"GET"];
		
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
				
		SBJSON *jsonParser = [SBJSON new];
        
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
		if ([apiStatus isEqualToString:@"100"]) {
			NSArray *returnActivites = [response valueForKey:@"activities"];
		
			for (int i = 0; i < [returnActivites count]; i++) {
				NSDictionary *tmpDict = [returnActivites objectAtIndex:i];
				Activity *tmpActivity = [[Activity alloc] init];
				
				tmpActivity.activityText = [tmpDict valueForKey:@"text"];
				tmpActivity.createdDate = [tmpDict valueForKey:@"createdDate"];
				tmpActivity.cacheId = [tmpDict valueForKey:@"cacheId"];
				
					
				tmpActivity.teamId = [tmpDict valueForKey:@"teamId"];
				tmpActivity.teamName = [tmpDict valueForKey:@"teamName"];
				
				tmpActivity.activityId = [tmpDict valueForKey:@"activityId"];

				tmpActivity.numLikes = [[tmpDict valueForKey:@"numberOfLikeVotes"] intValue];
				tmpActivity.numDislikes = [[tmpDict valueForKey:@"numberOfDislikeVotes"] intValue];
				
				tmpActivity.isVideo = [[tmpDict valueForKey:@"isVideo"] boolValue];
				
				if ([tmpDict valueForKey:@"thumbNail"] != nil) {
					tmpActivity.thumbnail = [tmpDict valueForKey:@"thumbNail"];
				}else {
					tmpActivity.thumbnail = @"";
				}

				
				[activities addObject:tmpActivity];

				
				
				[tmpActivity release];
				
			}
		}
		statusReturn = apiStatus;
		
		
		[returnDictionary setValue:statusReturn forKey:@"status"];
		[returnDictionary setValue:activities forKey:@"activities"];
		//[activities release];
		return returnDictionary;
		
	}
	@catch (NSException *e) {
		statusReturn = @"1";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	
}

	

+(NSDictionary *)getActivityTeam:(NSString *)token :(NSString *)teamId :(NSString *)maxCount :(NSString *)refreshFirst :(NSString *)newOnly
							:(NSString *)maxCacheId{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	NSMutableArray *activities = [NSMutableArray array];

	
	if ((token == nil) || (teamId == nil) || (maxCount == nil) || (refreshFirst == nil) || (newOnly == nil) || (maxCacheId == nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
		
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
		
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
	
		
		NSTimeZone *tmp1 = [NSTimeZone systemTimeZone];
		NSString *timeZone = [tmp1 name];
		
		timeZone = [timeZone stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
		
		NSString *tmpUrl = @"";
		

		tmpUrl = [NSString stringWithFormat:@"%@/team/%@/activities/%@", baseUrl, teamId, timeZone];
		
		bool firstParam = false;
		
		if (![maxCount isEqualToString:@""]){
			
			tmpUrl = [tmpUrl stringByAppendingFormat:@"?maxCount=%@", maxCount];
			firstParam = true;
		}
		
		if (![refreshFirst isEqualToString:@""]){
			
			NSString *symbol;
			if (firstParam) {
				symbol = @"&";
			}else {
				symbol = @"?";
			}
			
			tmpUrl = [tmpUrl stringByAppendingFormat:@"%@refreshFirst=%@", symbol, refreshFirst];
			firstParam = true;
			if ([refreshFirst isEqualToString:@"true"] && ![newOnly isEqualToString:@""]) {
				tmpUrl = [tmpUrl stringByAppendingFormat:@"&newOnly=%@", newOnly];
			}

		}
	
		
		if (![maxCacheId isEqualToString:@""]){
			
			if (![refreshFirst isEqualToString:@"true"]) {
				
				NSString *symbol;
				if (firstParam) {
					symbol = @"&";
				}else {
					symbol = @"?";
				}
				
				tmpUrl = [tmpUrl stringByAppendingFormat:@"%@maxCacheId=%@", symbol, maxCacheId];
				
			}
			
		}

		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: tmpUrl]];
		
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"GET"];
		
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
		
	
		SBJSON *jsonParser = [SBJSON new];
        
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
		if ([apiStatus isEqualToString:@"100"]) {
			NSArray *returnActivites = [response valueForKey:@"activities"];
			
			for (int i = 0; i < [returnActivites count]; i++) {
				NSDictionary *tmpDict = [returnActivites objectAtIndex:i];
				Activity *tmpActivity = [[Activity alloc] init];
				
				tmpActivity.activityText = [tmpDict valueForKey:@"text"];
				tmpActivity.createdDate = [tmpDict valueForKey:@"createdDate"];
				tmpActivity.cacheId = [tmpDict valueForKey:@"cacheId"];
				
				if ([teamId isEqualToString:@""]) {
					
					tmpActivity.teamId = [tmpDict valueForKey:@"teamId"];
					tmpActivity.teamName = [tmpDict valueForKey:@"teamName"];
					
				}else {
					tmpActivity.teamId = [teamId copy];
				}
				
				tmpActivity.activityId = [tmpDict valueForKey:@"activityId"];
				
				tmpActivity.numLikes = [[tmpDict valueForKey:@"numberOfLikeVotes"] intValue];
				tmpActivity.numDislikes = [[tmpDict valueForKey:@"numberOfDislikeVotes"] intValue];
				
				tmpActivity.isVideo = [[tmpDict valueForKey:@"isVideo"] intValue];
				
				if ([tmpDict valueForKey:@"thumbNail"] != nil) {
					tmpActivity.thumbnail = [tmpDict valueForKey:@"thumbNail"];
				}else {
					tmpActivity.thumbnail = @"";
				}
				
				[activities addObject:tmpActivity];

			}
		}
		statusReturn = apiStatus;
		
		
		[returnDictionary setValue:statusReturn forKey:@"status"];
		[returnDictionary setValue:activities forKey:@"activities"];
		return returnDictionary;
		
	}
	@catch (NSException *e) {
		statusReturn = @"1";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	
}

+(NSDictionary *)createActivity:(NSString *)token :(NSString *)teamId :(NSString *)statusUpdate :(NSData *)photo :(NSData *)video :(NSString *)orientation{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	
	if ((token == nil) || (teamId == nil) || (statusUpdate == nil) || (photo == nil) || (video == nil) || (orientation == nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
				
		NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
		NSDictionary *loginDict = [[NSDictionary alloc] init];
		
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
		
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
		
		
		NSString *photoString = [ServerAPI encodeBase64data:photo];
		NSString *videoString = [Base64 encode:video];
		
		if (![statusUpdate isEqualToString:@""]) {
			[ tempDictionary setObject:statusUpdate forKey:@"statusUpdate"];
		}

		if (![photoString isEqualToString:@""]) {
			[tempDictionary setObject:photoString forKey:@"photo"];
		}
		
		if (![videoString isEqualToString:@""]) {
			[tempDictionary setObject:videoString forKey:@"video"];
		}
        
        if (![orientation isEqualToString:@""]){
            NSNumber *isPortrait;
            
            if ([orientation isEqualToString:@"portrait"]) {
                isPortrait = [NSNumber numberWithBool:1];
            }else{
                isPortrait = [NSNumber numberWithBool:0];
            }
            [tempDictionary setObject:isPortrait forKey:@"isPortrait"];
        }
		
		loginDict = tempDictionary;
		
		
		NSString *requestString = [NSString stringWithFormat:@"%@", [loginDict JSONFragment], nil];
		
		
		[tempDictionary release];
		
		NSString *tmpUrl = [baseUrl stringByAppendingFormat:@"/team/"];
		tmpUrl = [tmpUrl stringByAppendingString:teamId];
		tmpUrl = [tmpUrl stringByAppendingFormat:@"/activities"];
		
		NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: tmpUrl]];
		
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"POST"];
		[request setHTTPBody: requestData];
		
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
		
		SBJSON *jsonParser = [SBJSON new];
        
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];

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

+(NSDictionary *)updateActivity:(NSString *)token :(NSString *)teamId :(NSString *)activityId :(NSString *)likeDislike{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	
	if ((token == nil) || (teamId == nil) || (activityId == nil) || (likeDislike == nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		

		NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
		NSDictionary *loginDict = [[NSDictionary alloc] init];
		
		
		[tempDictionary setObject:likeDislike forKey:@"vote"];
		
		
		loginDict = tempDictionary;
		
		
		NSString *requestString = [NSString stringWithFormat:@"%@", [loginDict JSONFragment], nil];
		
		
		[tempDictionary release];
		
		
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
		
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];

		
		NSString *tmpUrl = [NSString stringWithFormat:@"%@/team/%@/activity/%@", baseUrl, teamId, activityId];
		
		NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];

		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: tmpUrl]];
		
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"PUT"];
		[request setHTTPBody: requestData];

		
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
						
		SBJSON *jsonParser = [SBJSON new];
		
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
		if ([apiStatus isEqualToString:@"100"]) {
			
			[returnDictionary setValue:[response valueForKey:@"numberOfLikeVotes"] forKey:@"likes"];
			[returnDictionary setValue:[response valueForKey:@"numberOfDislikeVotes"] forKey:@"dislikes"];
			
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


+(NSDictionary *)getActivityStatus:(NSString *)token :(NSString *)activityIds{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	//NSMutableArray *activities = [NSMutableArray array];
	
	
	if ((token == nil) || (activityIds == nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
		
		
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
		
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
		
		NSString *tmpUrl = @"";
		
		
		tmpUrl = [NSString stringWithFormat:@"%@/activities/status/userVote", baseUrl];
		
		
		
		NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
		NSDictionary *loginDict = [[NSDictionary alloc] init];
		NSMutableArray *finalActivityArray = [NSMutableArray array];
		
		if ([activityIds length] > 0) {
			NSArray *activityIdArray = [activityIds componentsSeparatedByString:@","];
			
			for (int i = 0; i < [activityIdArray count]; i++) {
				
				NSMutableDictionary *tmpDictionary1 = [[NSMutableDictionary alloc] init];
				
				[tmpDictionary1 setValue:[activityIdArray objectAtIndex:i] forKey:@"activityId"];
				
				[finalActivityArray addObject:tmpDictionary1];
				
				[tmpDictionary1 release];
			}
			
			[ tempDictionary setObject:finalActivityArray forKey:@"activities"];
		}
	

		loginDict = tempDictionary;
		
		NSString *requestString = [NSString stringWithFormat:@"%@", [loginDict JSONFragment], nil];
		
		[tempDictionary release];
		
		NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:tmpUrl]];
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"POST"];
		[request setHTTPBody: requestData];

		
		
		
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
				
		SBJSON *jsonParser = [SBJSON new];

		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
		if ([apiStatus isEqualToString:@"100"]) {
			NSArray *returnActivites = [response valueForKey:@"activities"];
			[returnDictionary setValue:returnActivites forKey:@"activities"];

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

+(NSDictionary *)getActivityImage:(NSString *)token :(NSString *)activityId :(NSString *)teamId{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	
	
	if ((token == nil) || (activityId == nil) || (teamId == nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
		
		
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
		
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
		
		NSString *tmpUrl = @"";
		
		
		tmpUrl = [NSString stringWithFormat:@"%@/team/%@/activity/%@/photo", baseUrl, teamId, activityId];
		
		
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: tmpUrl]];
		
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"GET"];
		
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
	
		SBJSON *jsonParser = [SBJSON new];
		
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
		if ([apiStatus isEqualToString:@"100"]) {
			NSString *photo = [response valueForKey:@"photo"];
			[returnDictionary setValue:photo forKey:@"photo"];
			
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

+(NSDictionary *)getActivityVideo:(NSString *)token :(NSString *)activityId :(NSString *)teamId{
	
	NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	
	
	if ((token == nil) || (activityId == nil) || (teamId == nil)) {
		
		statusReturn = @"0";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}
	
	@try{
		
		
		
		NSString *stringToEncode = [@"login:" stringByAppendingString:token];
		
		NSString *authentication = [ServerAPI encodeBase64:stringToEncode];
		
		NSString *tmpUrl = @"";
		
		
		tmpUrl = [NSString stringWithFormat:@"%@/team/%@/activity/%@/video", baseUrl, teamId, activityId];
		
		
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: tmpUrl]];
		
		[request setValue:authentication forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod: @"GET"];
		
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
		
		SBJSON *jsonParser = [SBJSON new];
		
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
		
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		
		if ([apiStatus isEqualToString:@"100"]) {
			NSString *photo = [response valueForKey:@"video"];
			[returnDictionary setValue:photo forKey:@"video"];
			
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

+(NSDictionary *)getMobileCarrierList{
    
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
	NSString *statusReturn = @"";
	NSMutableArray *teams = [NSMutableArray array];
	
	@try{
        
		
		NSString *tmpUrl = [baseUrl stringByAppendingFormat:@"/mobileCarriers"];
        
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: tmpUrl]];
        
		NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
		NSString *responseString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	    
		SBJSON *jsonParser = [SBJSON new];
                
		NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:responseString error:NULL];
        
		[responseString release];
		[request release];
        
		NSString *apiStatus = [response valueForKey:@"apiStatus"];
		        
		if ([apiStatus isEqualToString:@"100"]) {
            
			statusReturn = apiStatus;
			
			NSArray *teamsJsonObjects = [response valueForKey:@"mobileCarriers"];
            
			int size = [teamsJsonObjects count];
            
			for (int i = 0; i < size; i++){
                
				MobileCarrier *tmpTeam = [[MobileCarrier alloc] init];
                
				NSDictionary *thisTeam = [teamsJsonObjects objectAtIndex:i];
                
				tmpTeam.name = [thisTeam valueForKey:@"name"];
                
				tmpTeam.code = [thisTeam valueForKey:@"code"];
              

				[teams addObject:tmpTeam];
                
				[tmpTeam release];
                
			}
			
			[returnDictionary setValue:teams forKey:@"mobileCarriers"];
			[returnDictionary setValue:statusReturn forKey:@"status"];
			return returnDictionary;
		}else {
			statusReturn = apiStatus;
			[returnDictionary setValue:statusReturn forKey:@"status"];
			return returnDictionary;
		}
        
        
	}
	@catch (NSException *e) {
		statusReturn = @"1";
		[returnDictionary setValue:statusReturn forKey:@"status"];
		return returnDictionary;
	}	

    
    
    
}

+ (NSString *)encodeBase64:(NSString *)stringToEncode{
	
	NSData *encodeData = [stringToEncode dataUsingEncoding:NSUTF8StringEncoding];
	char encodeArray[512];
	
	memset(encodeArray, '\0', sizeof(encodeArray));
	
	// Base64 Encode username and password
	encode([encodeData length], (char *)[encodeData bytes], sizeof(encodeArray), encodeArray);
	
	NSString *dataStr = [NSString stringWithCString:encodeArray length:strlen(encodeArray)];
	
	NSString *encodedString =[@"" stringByAppendingFormat:@"Basic %@", dataStr];
	
	return encodedString;
}

+ (NSString *)encodeBase64data:(NSData *)encodeData{
	
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



@end
