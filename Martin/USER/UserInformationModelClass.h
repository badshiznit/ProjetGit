//
//  UserInformationModelClass.h
//  OpenTouch
//
//  Created by EffiTIC2 EffiTIC2 on 25/01/12.
//  Copyright (c) 2012 Alcatel-lucent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInformationModelClass : NSObject <NSCopying> {
    NSString *login;            // optional
    NSString *name;             // optional
    NSString *firstName;        // optional
    NSString *email;            // optional
    NSString *phoneNumber;      // optional
}

@property (nonatomic, retain) NSString   *login;
@property (nonatomic, retain) NSString   *name;
@property (nonatomic, retain) NSString   *firstName;
@property (nonatomic, retain) NSString   *email;
@property (nonatomic, retain) NSString   *phoneNumber;

- (void)initWithName:(NSString *)login 
                name:(NSString *)newName 
           firstName:(NSString *)newFirstName 
               email:(NSString *)newEmail 
         phoneNumber:(NSString *)newPhoneNumber;
- (void)resetSettings;
@end
