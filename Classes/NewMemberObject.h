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
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) NSString *guardianOneName;
@property (nonatomic, strong) NSString *guardianOneEmail;
@property (nonatomic, strong) NSString *guardianOnePhone;
@property (nonatomic, strong) NSString *guardianTwoName;
@property (nonatomic, strong) NSString *guardianTwoEmail;
@property (nonatomic, strong) NSString *guardianTwoPhone;
@end
