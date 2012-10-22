//
//  UserProfileJSONHandler.m
//  OpenTouch
//
//  Created by EffiTIC2 EffiTIC2 on 30/01/12.
//  Copyright (c) 2012 Alcatel-lucent. All rights reserved.
//

#import "UserProfileJSONHandler.h"

@implementation UserProfileJSONHandler

+ (NSMutableArray *) getProfilesFromArray :(NSMutableArray *) eventData {
    NSMutableArray *profileList = [[NSMutableArray alloc] init];
    
    for (NSDictionary *profileItem in eventData) {
        UserProfileModelClass *newProfile = [self getProfileFromDictionary:profileItem];
        [profileList addObject:newProfile];
    }
    return profileList;
}


+ (UserProfileModelClass *) getProfileFromDictionary :(NSDictionary *) eventData {
   NSLog(@"ProfileJSONHandler: getProfileFromDictionary : Begin de crunching JSON ");
    
    UserProfileModelClass *userProfile = [[UserProfileModelClass alloc] init];
    
    if (eventData != nil)
    {
        NSString *currentDeviceId = [eventData valueForKey:(NSString*)ROUTING_JSON_KEY_CURRENT_DEVICE_ID];
        if (currentDeviceId != nil)
        {
            userProfile.currentDeviceID = currentDeviceId;            
            NSLog(@"UserProfileJSONHandler: CurrentDeviceID : %@", userProfile.currentDeviceID);
        }
        NSString *pid = [eventData valueForKey:@"id"];
        if (pid != nil)
        {
            userProfile.pid = pid;
            
            NSLog(@"UserProfileJSONHandler: ID : %@", userProfile.pid);
        }
        NSString *name = [eventData valueForKey:@"name"];
        if (name != nil)
        {
            userProfile.name = name;
            
            NSLog(@"UserProfileJSONHandler: name : %@", userProfile.name);
        }
        BOOL isDefault = [[eventData valueForKey:@"defaultp"] boolValue];
        userProfile.isDefaultp = isDefault;
//        [[LogMgr mgr] log:[NSString stringWithFormat:@"UserProfileJSONHandler: isDefault : %@", userProfile.isDefaultp?@"YES":@"NO"]];
        BOOL isActivable = [[eventData valueForKey:@"activable"] boolValue];
        userProfile.activable = isActivable;
//        [[LogMgr mgr] log:[NSString stringWithFormat:@"UserProfileJSONHandler: isActivable : %@", userProfile.activable?@"YES":@"NO"]];
        BOOL isRemovable = [[eventData valueForKey:@"removable"] boolValue];
        userProfile.removable = isRemovable;
//        [[LogMgr mgr] log:[NSString stringWithFormat:@"UserProfileJSONHandler: isRemovable : %@", userProfile.removable?@"YES":@"NO"]];
        BOOL isRenameable = [[eventData valueForKey:@"renameable"] boolValue];
        userProfile.renameable = isRenameable;
//        [[LogMgr mgr] log:[NSString stringWithFormat:@"UserProfileJSONHandler: isRenameable : %@", userProfile.renameable?@"YES":@"NO"]];
        BOOL isUpdatable = [[eventData valueForKey:@"updatable"] boolValue];
        userProfile.updatable = isUpdatable;
//        [[LogMgr mgr] log:[NSString stringWithFormat:@"UserProfileJSONHandler: isUpdatable : %@", userProfile.updatable?@"YES":@"NO"]];

        userProfile.forwardRoute = [RoutingJSONHandler getDestinationRouteListForRoute:eventData routeName:(NSString *)ROUTING_JSON_KEY_FORWARD_ROUTE];
        userProfile.presentationRoute = [RoutingJSONHandler getDestinationRouteListForRoute:eventData routeName:(NSString *)ROUTING_JSON_KEY_PRESENTATION_ROUTE];
        
        NSLog([NSString stringWithFormat:@"profile %@ received : removable=%@, updatable=%@, activable=%@", userProfile.name, (userProfile.removable ? @"YES": @"NO"), (userProfile.updatable ? @"YES": @"NO"), (userProfile.activable ? @"YES": @"NO")]);

    }
    else
        NSLog(@"Event data profile received = NIL ");
    return userProfile;
}

@end
