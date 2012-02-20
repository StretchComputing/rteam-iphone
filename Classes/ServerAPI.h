//
//  ServerAPI.h
//  iCoach
//
//  Created by Nick Wroblewski on 2/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ServerAPI : NSObject {

}


//User APIs
+ (NSDictionary *)createUser:(NSString *)firstName :(NSString *)lastName :(NSString *)email :(NSString *)password :(NSString *)alreadyMember
							:(NSString *)latitude :(NSString *)longitude :(NSString *)phoneNumber :(NSString *)carrierCode :(NSString *)location;

+ (NSDictionary *)getUserInfo:(NSString *)token :(NSString *)includePhoto;

+(NSDictionary *)resetUserPassword:(NSString *)email :(NSString *)resetPasswordAnswer;

+(NSDictionary *)getUserToken:(NSString *)email :(NSString *)password;

+(NSDictionary *)updateUser:(NSString *)token :(NSString *)firstName :(NSString *)lastName :(NSString *)password :(NSString *)alertToken 
						   :(NSString *)passwordResetQuestion :(NSString *)passwordResetAnswer :(NSString *)userIconOneId 
						   :(NSString *)userIconOneAlias :(NSString *)userIconTwoId :(NSString *)userIconTwoAlias :(NSString *)userIconOneImage
						   :(NSString *)userIconTwoImage :(NSString *)autoArchiveDayCount :(NSData *)profileImage :(NSString *)addRemove
                           :(NSString *)orientation :(NSString *)phoneNumber :(NSString *)phoneCarrierCode :(NSString *)confirmationCode :(NSString *)sendConfirmation;

+(NSDictionary *)getUserPasswordResetQuestion:(NSString *)email;


//Team APIs
+ (NSDictionary *)createTeam:(NSString *)teamName :(NSString *)leagueName :(NSString *)description 
							:(NSString *)useTwitter :(NSString *)token :(NSString *)sport; 

+(NSDictionary *)getTeamInfo:(NSString *)teamId :(NSString *)token :(NSString *)includePhoto;

+ (NSDictionary *)getListOfTeams:(NSString *)token;

+(NSDictionary *)updateTeam:(NSString *)token :(NSString *)teamId :(NSString *)teamName :(NSString *)description :(NSString *)leagueName 
						   :(NSString *)useTwitter :(NSString *)sport :(NSData *)teamPicture :(NSString *)orientation;

+(NSDictionary *)deleteTeam:(NSString *)teamId :(NSString *)token;


//Member APIs													
+(NSDictionary *)createMember:(NSString *)firstName :(NSString *)lastName :(NSString *)emailAddress :(NSString *)jerseyNumber 
							 :(NSArray *)roles :(NSArray *)guardianEmails :(NSString *)teamId :(NSString *)token :(NSString *)userRole
							 :(NSString *)phoneNumber;

+(NSDictionary *)createMultipleMembers:(NSString *)token :(NSString *)teamId :(NSArray *)members;

+(NSDictionary *)getListOfTeamMembers:(NSString *)teamId :(NSString *)token :(NSString *)role :(NSString *)removeSelf;
													
+(NSDictionary *)getMemberInfo:(NSString *)teamId :(NSString *)memberId :(NSString *)token :(NSString *)includePhoto;

+(NSDictionary *)deleteMember:(NSString *)memberId :(NSString *)teamId :(NSString *)token;

+(NSDictionary *)updateMember:(NSString *)memberId :(NSString *)teamId :(NSString *)firstName :(NSString *)lastName :(NSString *)jerseyNumber 
						 :(NSArray *)roles :(NSArray *)guardianEmails :(NSString *)token :(NSData *) profileImage :(NSString *)email  
                             :(NSString *)userRole :(NSString *)phoneNumber :(NSString *)orientation;

+(NSDictionary *)getMembershipStatus:(NSString *)email;


//Game APIs
+(NSDictionary *)createGame:(NSString *)teamId :(NSString *)token :(NSString *)startDate :(NSString *)endDate :(NSString *)description 
						   :(NSString *)timeZone :(NSString *)latitude :(NSString *)longitude :(NSString *)opponent;

+(NSDictionary *)createMultipleGames:(NSString *)token :(NSString *)teamId :(NSString *)notificationType :(NSArray *)games;

+(NSDictionary *)getListOfGames:(NSString *)teamId :(NSString *)token;

+(NSDictionary *)getGameInfo:(NSString *)gameId :(NSString *)teamId :(NSString *)token;

+(NSDictionary *)updateGame:(NSString *)token :(NSString *)teamId :(NSString *)gameId :(NSString *)startDate :(NSString *)endDate :(NSString *)timeZone
					   :(NSString *)description :(NSString *)latitude :(NSString *)longitude :(NSString *)opponent :(NSString *)location
						   :(NSString *)scoreUs :(NSString *)scoreThem :(NSString *)interval :(NSString *)notifyTeam :(NSString *)pollStatus 
						   :(NSString *)updateAll;

+(NSDictionary *)deleteGame:(NSString *)token :(NSString *)teamId :(NSString *)gameId;

+(NSDictionary *)castGameVote:(NSString *)token :(NSString *)teamId :(NSString *)gameId :(NSString *)voteType :(NSString *)memberId;

+(NSDictionary *)getGameVoteTallies:(NSString *)token :(NSString *)teamId :(NSString *)gameId :(NSString *)voteType;

//Practice(Event) APIs
+(NSDictionary *)createEvent:(NSString *)teamId :(NSString *)token :(NSString *)startDate :(NSString *)endDate :(NSString *)description 
							:(NSString *)timeZone :(NSString *)latitude :(NSString *)longitude :(NSString *)location :(NSString *)eventType
							:(NSString *)eventName;

+(NSDictionary *)createMultipleEvents:(NSString *)token :(NSString *)teamId :(NSString *)notificationType :(NSArray *)practices;

+(NSDictionary *)getListOfEvents:(NSString *)teamId :(NSString *)token :(NSString *)eventType;

+(NSDictionary *)getEventInfo:(NSString *)eventId :(NSString *)teamId :(NSString *)token;

+(NSDictionary *)updateEvent:(NSString *)token :(NSString *)teamId :(NSString *)eventId :(NSString *)startDate :(NSString *)endDate :(NSString *)timeZone
							:(NSString *)description :(NSString *)latitude :(NSString *)longitude :(NSString *)location :(NSString *)notifyTeam
							:(NSString *)eventName :(NSString *)updateAll :(NSString *)isCanceled;

+(NSDictionary *)deleteEvent:(NSString *)token :(NSString *)teamId :(NSString *)practiceId;

+(NSDictionary *)getListOfEventsNow:(NSString *)token;
+(NSDictionary *)getListOfWhosComingEvents:(NSString *)teamId :(NSString *)token;

//Attendance APIs
+(NSDictionary *)updateAttendees:(NSString *)token :(NSString *)teamId :(NSString *)eventId :(NSString *)eventType :(NSArray *)attList :(NSString *)startDate;

+(NSDictionary *)getAttendeesGame:(NSString *)token :(NSString *)teamId :(NSString *)eventId :(NSString *)eventType;

+(NSDictionary *)getAttendeesMember:(NSString *)token :(NSString *)teamId :(NSString *)memberId :(NSString *)eventType 
	:(NSString *)startDate :(NSString *)endDate;

//Message APIs
+(NSDictionary *)createMessageThread:(NSString *)token teamId:(NSString *)teamId subject:(NSString *)subject body:(NSString *)body type:(NSString *)type eventId:(NSString *)eventId eventType:(NSString *)eventType isAlert:(NSString *)isAlert pollChoices:(NSArray *)pollChoices recipients:(NSArray *)recipients displayResults:(NSString *)displayResults includeFans:(NSString *)includeFans coordinatorsOnly:(NSString *)coordinatorsOnly;

+(NSDictionary *)getMessageThreads:(NSString *)token :(NSString *)teamId :(NSString *)messageGroup :(NSString *)eventId :(NSString *)eventType
							 :(NSString *)pollOrMsg :(NSString *)status;

+(NSDictionary *)getMessageThreadInfo:(NSString *)token :(NSString *)teamId :(NSString *)messageThreadId;

+(NSDictionary *)updateMessageThread:(NSString *)token :(NSString *)teamId :(NSString *)messageThreadId :(NSString *)reply :(NSString *)wasViewed 
									:(NSString *)followupMessage :(NSString *)status :(NSString *)sendReminder;

+(NSDictionary *)updateMessageThreads:(NSString *)token :(NSArray *)threadIds :(NSString *)location;

+(NSDictionary *)getMessageThreadCount:(NSString *)token :(NSString *)teamId :(NSString *)eventId :(NSString *)eventType :(NSString *)resynch;

//Activity APIs
+(NSDictionary *)getActivity:(NSString *)token maxCount:(NSString *)maxCount refreshFirst:(NSString *)refreshFirst newOnly:(NSString *)newOnly
                        mostCurrentDate:(NSString *)mostCurrentDate totalNumberOfDays:(NSString *)totalNumberOfDays includeDetails:(NSString *)includeDetails;

+(NSDictionary *)createActivity:(NSString *)token teamId:(NSString *)teamId statusUpdate:(NSString *)statusUpdate photo:(NSData *)photo video:(NSData *)video orientation:(NSString *)orientation replyToId:(NSString *)replyToId eventId:(NSString *)eventId newGame:(NSString *)gameday;

+(NSDictionary *)updateActivity:(NSString *)token teamId:(NSString *)teamId activityId:(NSString *)activityId likeDislike:(NSString *)likeDislike statusUpdate:(NSString *)statusUpdate photo:(NSData *)photo video:(NSData *)video orientation:(NSString *)orientation cancelAttachment:(NSString *)cancelAttachment;

+(NSDictionary *)getActivityStatus:(NSString *)token :(NSString *)activityIds;

+(NSDictionary *)getActivityImage:(NSString *)token :(NSString *)activityId :(NSString *)teamId;

+(NSDictionary *)getActivityVideo:(NSString *)token :(NSString *)activityId :(NSString *)teamId;

+(NSDictionary *)deleteActivity:(NSString *)token activityId:(NSString *)activityId teamId:(NSString *)teamId;

+(NSDictionary *)getActivityDetails:(NSString *)token activityIds:(NSArray *)activityIds;

//Misc
+(NSDictionary *)getMobileCarrierList;

//Utility methods
+ (NSString *)encodeBase64:(NSString *)stringToEncode;

+ (NSString *)encodeBase64data:(NSData *)encodeData;

+(NSDictionary *)exceptionReturnValue:(NSString *)methodName :(NSException *)e;




@end
