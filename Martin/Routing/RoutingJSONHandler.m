//
//  RoutingJSONHandler.m
//  OpenTouch
//
//  Created by EffiTIC2 EffiTIC2 on 27/01/12.
//  Copyright (c) 2012 Alcatel-lucent. All rights reserved.
//

#import "RoutingJSONHandler.h"

@implementation RoutingJSONHandler


+(RoutingStateModelClass *)getRoutingFromDictionary :(NSDictionary *)eventData{
//    [[LogMgr mgr] log:@"RoutingJSONHandler: getRoutingFromDictionary : Begin de crunching JSON "];
    
   // NSDictionary* eventData = [eventData_ objectForKey];
    RoutingStateModelClass *routingState = [[RoutingStateModelClass alloc] init];
   // NSLog(@"JSOOOOOOON : Event Data = \n%@",eventData);
    if (eventData != nil)
    {
        NSString *currentDeviceId = [eventData valueForKey:(NSString *)ROUTING_JSON_KEY_CURRENT_DEVICE_ID];
        if (currentDeviceId != nil)
        {
            routingState.currentDeviceID = currentDeviceId;
//            [[LogMgr mgr] log:[NSString stringWithFormat:@"RoutingJSONHandler: CurrentID : %@", routingState.currentDeviceID]];
        }

        routingState.appliedProfile = [self getProfilForJSON:[eventData valueForKey:(NSString *)ROUTING_JSON_KEY_APPLIED_PROFILE]];
        
        NSArray         *activableProfile = [eventData valueForKey:(NSString *)ROUTING_JSON_KEY_ACTIVABLE_PROFILE]; // list of profile
        if (activableProfile != nil)
        {
            for (NSDictionary *profilItem in activableProfile)
            {
                [routingState.activableProfile addObject:[self getProfilForJSON:profilItem]];
            }
//            [[LogMgr mgr] log:[NSString stringWithFormat:@"RoutingJSONHandler: Received [%d] activableProfile  ", [routingState.activableProfile count]]];
        }

        NSArray         *advancedRoute = [eventData valueForKey:(NSString *)ROUTING_JSON_KEY_ADVANCED_ROUTE];
        if (advancedRoute != nil)
        {
            for (NSDictionary *routeItem in advancedRoute)
            {
                NSString *routeDescription = [routeItem valueForKey:(NSString *)ROUTING_JSON_KEY_DESCRIPTION];
                
                [routingState.advancedRoute addObject:routeDescription];
            }
//            [[LogMgr mgr] log:[NSString stringWithFormat:@"RoutingJSONHandler: Received [%d] advancedRoute", [routingState.advancedRoute count]]];
        }
        
        routingState.forwardRoute = [self getDestinationRouteListForRoute:eventData routeName:(NSString *)ROUTING_JSON_KEY_FORWARD_ROUTE];
        routingState.overflowRoute = [self getDestinationRouteListForRoute:eventData routeName:(NSString *)ROUTING_JSON_KEY_OVERFLOW_ROUTE];
        routingState.presentationRoute = [self getDestinationRouteListForRoute:eventData routeName:(NSString *)ROUTING_JSON_KEY_PRESENTATION_ROUTE];
    }
    return routingState;
}

+ (RoutingRouteModelClass *)getDestinationRouteListForRoute:(NSDictionary *)eventData routeName:(NSString *)routeName
{
    RoutingRouteModelClass *route = [[RoutingRouteModelClass alloc] init];
    NSArray *routeArray = [eventData valueForKey:routeName];
    
    if (routeArray != nil)
    {
        NSInteger nbAcceptable = 0;
        
        for (NSDictionary *routeItem in routeArray)
        {
            route.overflowType = [RoutingRouteModelClass getOverflowTypeForString:[routeItem valueForKey:(NSString *)ROUTING_JSON_KEY_OVERFLOW_TYPE]];
            
            NSArray *routeDestArray = [routeItem valueForKey:(NSString *)ROUTING_JSON_KEY_DESTINATION];
            
            for (NSDictionary *destItem in routeDestArray)
            {
                RoutingDestinationModelClass *rDest = [self getRouteDestFromJSON:destItem];   
                [route.route addObject:rDest];
                if (rDest.acceptable)
                    nbAcceptable ++;
            }
        }
        route.nbOfAcceptable = nbAcceptable;
        
//        [[LogMgr mgr] log:[NSString stringWithFormat:@"RoutingJSONHandler: Received [%d] route of type : [%@]", [route.route count], routeName]];
    }
    
    return route;
}

+ (RoutingDestinationModelClass *)getRouteDestFromJSON:(NSDictionary *)routeItem
{                
    UserInformationModelClass *userInfo = [[UserInformationModelClass alloc] init];
    NSDictionary    *userInfoDict = [routeItem valueForKey:(NSString *)ROUTING_JSON_KEY_INFORMATION];
    
    if (userInfoDict != nil)
    {
        [userInfo initWithName:[userInfoDict valueForKey:(NSString *)ROUTING_JSON_KEY_INFORMATION_LOGIN]
                          name:[userInfoDict valueForKey:(NSString *)ROUTING_JSON_KEY_INFORMATION_NAME]
                     firstName:[userInfoDict valueForKey:(NSString *)ROUTING_JSON_KEY_INFORMATION_FIRSTNAME]
                         email:[userInfoDict valueForKey:(NSString *)ROUTING_JSON_KEY_INFORMATION_EMAIL]
                   phoneNumber:[userInfoDict valueForKey:(NSString *)ROUTING_JSON_KEY_INFORMATION_PHONENUMBER]];
        
//        [[LogMgr mgr] log:[NSString stringWithFormat:@"RoutingJSONHandler: getRouteDestFromJSON\n login=[%@] name=[%@] firstName=[%@] email=[%@] phone=[%@]", userInfo.login, userInfo.name, userInfo.firstName, userInfo.email, userInfo.phoneNumber]];
    }
    
    RoutingDestinationModelClass *routedest = [[RoutingDestinationModelClass alloc] init];
    
    [routedest initWithName:[routeItem valueForKey:(NSString *)ROUTING_JSON_KEY_INFORAMTION_DEVICEID]
                     number:[routeItem valueForKey:(NSString *)ROUTING_JSON_KEY_INFORMATION_NUMBER]
                       type:[RoutingDestinationModelClass getDestinationTypeForString:[routeItem valueForKey:(NSString *)ROUTING_JSON_KEY_INFORMATION_TYPE]]
                 acceptable:[[routeItem valueForKey:(NSString *)ROUTING_JSON_KEY_INFORMATION_ACCEPTABLE] boolValue]
                   selected:[[routeItem valueForKey:(NSString *)ROUTING_JSON_KEY_INFORMATION_SELECTED] boolValue]
            userInformation:userInfo];
    
//    [[LogMgr mgr] log:[NSString stringWithFormat:@"RoutingJSONHandler: getRouteDestFromJSON]\n name=[%@] number=[%@] type=[%@] acceptable=[%d] selected=[%d]", routedest.deviceId, routedest.number, [RoutingDestinationModelClass getStringForDestinationType:routedest.type], routedest.acceptable, routedest.selected]];
    
    return routedest;
}

+ (UserProfileModelClass *)getProfilForJSON:(NSDictionary *)profileDict
{
    if (profileDict != nil)
    {
        UserProfileModelClass *routeProfil = [[UserProfileModelClass alloc] 
                                              initWithName:[profileDict valueForKey:(NSString *)ROUTING_JSON_KEY_PROFIL_ID]
                             name:[profileDict valueForKey:(NSString *)ROUTING_JSON_KEY_PROFIL_NAME]
                       isDefaultp:[[profileDict valueForKey:(NSString *)ROUTING_JSON_KEY_PROFIL_DEFAULTP] boolValue]];
        return routeProfil;   
        
//        [[LogMgr mgr] log:[NSString stringWithFormat:@"RoutingJSONHandler: profil id:[%@] name:[%@] isDefaut:[%d] ", routeProfil.pid, routeProfil.name, routeProfil.isDefaultp]];
    }
    return nil;
}

+ (NSString *) getJSONForRoutingDestination:(RoutingDestinationModelClass *)routingDestination {
   
    if (routingDestination.type == DestinationTypeHome 
        || routingDestination.type == DestinationTypeMobile 
        || routingDestination.type == DestinationTypeOther
        // TODO : verify if User.number is set here or in User.UserInformation.number
        //  change UI setter if not
        || routingDestination.type == DestinationTypeUser) {
        
       //CTA NSString *valuesToJSON = [NSString stringWithFormat:@"destination:[{\"type\":\"%@\", \"acceptable\":\"%d\", \"selected\":\"%d\", \"number\":\"%@\", \"deviceId\":\"%@\"}]", [RoutingDestinationModelClass getStringForDestinationType:routingDestination.type], routingDestination.acceptable, routingDestination.selected, routingDestination.number,routingDestination.deviceId];
        NSString *valuesToJSON = [NSString stringWithFormat:@"{\"type\":\"%@\", \"acceptable\":%d, \"selected\":%d, \"number\":\"%@\", \"deviceId\":\"%@\"}", [RoutingDestinationModelClass getStringForDestinationType:routingDestination.type], routingDestination.acceptable, routingDestination.selected, routingDestination.number,routingDestination.deviceId];

        return valuesToJSON;
    }else{
        
       // NSString *valuesToJSON = [NSString stringWithFormat:@"destination:[{\"type\":\"%@\", \"acceptable\":\"%d\", \"selected\":\"%d\", \"deviceId\":\"%@\"}]", [RoutingDestinationModelClass getStringForDestinationType:routingDestination.type], routingDestination.acceptable, routingDestination.selected, routingDestination.deviceId];
        NSString *valuesToJSON = [NSString stringWithFormat:@"{\"type\":\"%@\", \"acceptable\":%d, \"selected\":%d, \"deviceId\":\"%@\"}", [RoutingDestinationModelClass getStringForDestinationType:routingDestination.type], routingDestination.acceptable, routingDestination.selected, routingDestination.deviceId];
        
        return valuesToJSON;
    }
}

+ (NSString *) getJSONForRoutingRoute:(RoutingRouteModelClass *)routingRoute {
    NSString *valuesToJSON = @"";
    if (routingRoute != nil && routingRoute.route != nil) {
        NSInteger i = 0;
        NSInteger nbElements = [routingRoute.route count] - 1;
   
        valuesToJSON = [NSString stringWithFormat:@"%@", valuesToJSON];
    
        for (RoutingDestinationModelClass *destItem in routingRoute.route) {
            valuesToJSON = [NSString stringWithFormat:@"%@%@", valuesToJSON, [self getJSONForRoutingDestination:destItem]];
        
            if (i < nbElements)
                valuesToJSON = [NSString stringWithFormat:@"%@, ", valuesToJSON];
            i++;
    }
    
    valuesToJSON = [NSString stringWithFormat:@"%@", valuesToJSON];
    }
    return valuesToJSON;
}
@end
