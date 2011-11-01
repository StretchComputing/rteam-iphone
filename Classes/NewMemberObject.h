//
//  NewMemberObject.h
//  rTeam
//
//  Created by Nick Wroblewski on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NewMemberObject : NSObject {

    
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
