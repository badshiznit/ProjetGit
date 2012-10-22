//
//  UserInformationModelClass.m
//  OpenTouch
//
//  Created by EffiTIC2 EffiTIC2 on 25/01/12.
//  Copyright (c) 2012 Alcatel-lucent. All rights reserved.
//

#import "UserInformationModelClass.h"

@implementation UserInformationModelClass

@synthesize login;
@synthesize name;
@synthesize firstName;
@synthesize email;
@synthesize phoneNumber;


- (void)initWithName:(NSString *)newLogin 
                name:(NSString *)newName 
           firstName:(NSString *)newFirstName 
               email:(NSString *)newEmail 
         phoneNumber:(NSString *)newPhoneNumber
{
    self.login = newLogin;
    self.name = newName;
    self.firstName = newFirstName;
    self.email = newEmail;
    self.phoneNumber = newPhoneNumber;
}

- (UserInformationModelClass *) init
{
    self = [super init];
    
    self.login = @"";
    self.name = @"";
    self.firstName = @"";
    self.email = @"";
    self.phoneNumber = @"";

    return self;
}

#pragma mark - NScopying
- (id)copyWithZone:(NSZone *)zone {
    
    UserInformationModelClass *objectCopy = [[[self class] alloc] init];
    
    if (objectCopy) {
        // Set primitives
        objectCopy.login = [self.login copy];
        objectCopy.name = [self.name copy];
        objectCopy.firstName = [self.firstName copy];
        objectCopy.email = [self.email copy];
        objectCopy.phoneNumber = [self.phoneNumber copy];
    }
    return objectCopy;
}

- (void)resetSettings
{
    self.phoneNumber = @"";
}

@end
