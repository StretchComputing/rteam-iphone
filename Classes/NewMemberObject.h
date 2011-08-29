//
//  NewMemberObject.h
//  rTeam
//
//  Created by Nick Wroblewski on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NewMemberObject : NSObject {

	NSString *firstName;
	NSString *lastName;
	NSString *email;
	NSString *phone;
	NSString *role;
    
    //Guardian Info
    NSString *guardianOneName;
    NSString *guardianOneEmail;
    NSString *guardianOnePhone;
    NSString *guardianTwoName;
    NSString *guardianTwoEmail;
    NSString *guardianTwoPhone;
    
}
@property (nonatomic, retain) NSString *role;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *phone;

@property (nonatomic, retain) NSString *guardianOneName;
@property (nonatomic, retain) NSString *guardianOneEmail;
@property (nonatomic, retain) NSString *guardianOnePhone;
@property (nonatomic, retain) NSString *guardianTwoName;
@property (nonatomic, retain) NSString *guardianTwoEmail;
@property (nonatomic, retain) NSString *guardianTwoPhone;
@end
