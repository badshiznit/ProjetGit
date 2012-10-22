//
//  RoutingMgr.h
//  OpenTouch
//
//  Created by Effitic1 Effitic1 on 24/01/12.
//  Copyright (c) 2012 Alcatel-lucent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhoneGapWrapper.h"
#import "OTCGap.h"
#import "RoutingStateModelClass.h"
#import "RoutingJSONHandler.h"


extern NSString * const EVENT_GET_ROUTING_OBJECT;
extern NSString * const EVENT_GET_ROUTING_STATE_ERROR;
extern NSString * const EVENT_GET_ROUTING_STATE_SUCCESS;
extern NSString * const EVENT_ROUTING_CHANGED;
extern NSString * const EVENT_ROUTING_FAILED;
extern NSString * const EVENT_ROUTING_CHANGE;
extern NSString * const EVENT_ON_SET_ROUTES_ERROR;
extern NSString * const EVENT_LOCAL_POPOVER_DISPLAY_ROUTE;
extern NSString * const EVENT_LOCAL_POPOVER_DISPLAY_ACTIVE_ROUTE;

typedef enum {
	AlertMessageSaveRoutingChanges,
	AlertMessageProfileDeletion,
	AlertMessageNoRouteSelected
} AlertMessageNumber;

@interface RoutingMgr : NSObject<UIAlertViewDelegate> {
    OTCGap          *otcGap;
    RoutingStateModelClass *routingState;
    
    // ipad flag : set custom profile
    BOOL isChangedIntoSession;
}

@property(nonatomic,retain) OTCGap *otcGap;
@property(nonatomic,retain) RoutingStateModelClass *routingState;
@property (nonatomic, assign) BOOL isChangedIntoSession;

+ (RoutingMgr*) mgr;
-(void)loadRoutingDatas;
- (void)sendActiveRoutingDatas:(RoutingRouteModelClass *)presentationRoute 
               withForwardRoute:(RoutingRouteModelClass *)forwardRoute 
           withCurrentDeviceId:(NSString *)_currentDevice;

- (void) onGettingRoutingState :(NSNotification *)notification;
- (void) onGettingRoutingStateError :(NSNotification *)notification;
- (void) onChangedState :(NSNotification *)notification;
- (void) onChangedStateFailed :(NSNotification *)notification;
- (void)onSetRoutesError:(NSNotification *)notification;

-(NSString*)getAppliedProfile;
@end
