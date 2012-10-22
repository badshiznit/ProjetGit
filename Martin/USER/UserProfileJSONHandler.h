//
//  UserProfileJSONHandler.h
//  OpenTouch
//
//  Created by EffiTIC2 EffiTIC2 on 30/01/12.
//  Copyright (c) 2012 Alcatel-lucent. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "LogMgr.h"
#import "UserProfileModelClass.h"
#import "RoutingJSONHandler.h"

@interface UserProfileJSONHandler : NSObject

/*
 * function to load data from a JSON or dictionary to local ModelClass
 */
+(UserProfileModelClass *)getProfileFromDictionary :(NSDictionary *)eventData;

+ (NSMutableArray *) getProfilesFromArray :(NSMutableArray *) eventData;

@end
