//
//  RoutingStateModelClass.h
//  OpenTouch
//
//  Created by EffiTIC2 EffiTIC2 on 25/01/12.
//  Copyright (c) 2012 Alcatel-lucent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoutingRouteModelClass.h"
#import "UserProfileModelClass.h"

@interface RoutingStateModelClass : NSObject <NSCopying> {
    NSMutableArray          *activableProfile;  // Array of RoutingProfils
    UserProfileModelClass   *appliedProfile;    // optional
    
    NSString    *currentDeviceID;
    
    NSMutableArray  *advancedRoute;     // list of strings descriptions of route
    
    RoutingRouteModelClass  *forwardRoute;      // array of RoutingDestinationModelClass
    RoutingRouteModelClass  *overflowRoute;     // array of RoutingDestinationModelClass + overflowtype
    RoutingRouteModelClass  *presentationRoute; // array of RoutingDestinationModelClass
}

@property (nonatomic, retain) NSMutableArray    *activableProfile;
@property (nonatomic, retain) UserProfileModelClass    *appliedProfile;

@property (nonatomic, retain) NSString        *currentDeviceID;
@property (nonatomic, retain) NSMutableArray  *advancedRoute;

@property (nonatomic, retain) RoutingRouteModelClass     *forwardRoute;
@property (nonatomic, retain) RoutingRouteModelClass     *overflowRoute;
@property (nonatomic, retain) RoutingRouteModelClass     *presentationRoute;


- (void)initWithName:(NSMutableArray *)newActivableProfile 
      appliedProfile:(UserProfileModelClass *)newAppliedProfile 
     currentDeviceID:(NSString *)newCurrentDeviceID
       advancedRoute:(NSMutableArray *)newAdvancedRoute
        forwardRoute:(RoutingRouteModelClass *)newForwardRoute 
       overflowRoute:(RoutingRouteModelClass *)newOverflowRoute
   presentationRoute:(RoutingRouteModelClass *)newPresentationRoute;

- (void) initLabel;
- (void) initStringFromDico :(NSNotification*)notification;

@end
