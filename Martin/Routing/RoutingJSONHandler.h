//
//  RoutingJSONHandler.h
//  OpenTouch
//
//  Created by EffiTIC2 EffiTIC2 on 27/01/12.
//  Copyright (c) 2012 Alcatel-lucent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoutingStateModelClass.h"
//#import "LogMgr.h"
#import "RoutingConst.h"
#import "UserProfileModelClass.h"


@interface RoutingJSONHandler : NSObject

/*
 * function to load data from a JSON or dictionary to local ModelClass
 */
+(RoutingStateModelClass *)getRoutingFromDictionary :(NSDictionary *)eventData;

/*
 * atomic function to help in retrieving datas from JSON
 */
+(RoutingDestinationModelClass *)getRouteDestFromJSON:(NSDictionary *)routeItem;
+(RoutingRouteModelClass *)getDestinationRouteListForRoute:(NSDictionary *)eventData routeName:(NSString *)routeName;
+(UserProfileModelClass *)getProfilForJSON:(NSDictionary *)profileDict;

/*
 * JSON data transcribe to push to server
 */
+ (NSString *) getJSONForRoutingDestination:(RoutingDestinationModelClass *)routingDestination;
+ (NSString *) getJSONForRoutingRoute:(RoutingRouteModelClass *)routingRoute;


@end
