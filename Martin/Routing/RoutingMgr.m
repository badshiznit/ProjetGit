//
//  RoutingMgr.m
//  OpenTouch
//
//  Created by Effitic1 Effitic1 on 24/01/12.
//  Copyright (c) 2012 Alcatel-lucent. All rights reserved.
//

#import "RoutingMgr.h"
//#import "LogMgr.h"
#import "ProfileMgr.h"
//#import "DicoMgr.h"

NSString * const EVENT_GET_ROUTING_OBJECT = @"routingMgr";
NSString * const EVENT_GET_ROUTING_STATE_ERROR = @"onGetRoutingStateError";
NSString * const EVENT_GET_ROUTING_STATE_SUCCESS = @"onGetRoutingStateSuccess";
NSString * const EVENT_ROUTING_CHANGED = @"onRoutingStateChanged";
NSString * const EVENT_ROUTING_FAILED = @"onRoutingManagementFailed";
NSString * const EVENT_ROUTING_CHANGE = @"onRoutingChange";
NSString * const EVENT_ON_SET_ROUTES_ERROR = @"onSetRoutesError";

NSString * const EVENT_LOCAL_POPOVER_DISPLAY_ROUTE = @"onLocalPopoverDisplayRoute";
NSString * const EVENT_LOCAL_POPOVER_DISPLAY_ACTIVE_ROUTE = @"onLocalPopoverDisplayActiveRoute";

@interface RoutingMgr ()

- (void)popErrorAlertWithDict:(NSDictionary *)dict;
- (void)popErrorAlertWithString:(NSString *)errorMessage;
- (void)popErrorAlertWithArray:(NSArray *)array;

@end

@implementation RoutingMgr

@synthesize otcGap;
@synthesize routingState;
@synthesize isChangedIntoSession;

static RoutingMgr *_mgr = nil;

+ (RoutingMgr*) mgr {
    @synchronized(self)	{
		if (_mgr == nil)
			_mgr = [[RoutingMgr alloc] init];
        
		return _mgr;
	}
    
	return nil;
}


- (id)init {
    self = [super init];
    
    if (self) {        
        [[OTCGap getInstance] subscribe:EVENT_GET_ROUTING_OBJECT forEvent:EVENT_GET_ROUTING_STATE_ERROR];
        [[OTCGap getInstance] subscribe:EVENT_GET_ROUTING_OBJECT forEvent:EVENT_GET_ROUTING_STATE_SUCCESS];
        [[OTCGap getInstance] subscribe:EVENT_GET_ROUTING_OBJECT forEvent:EVENT_ROUTING_CHANGED];
        [[OTCGap getInstance] subscribe:EVENT_GET_ROUTING_OBJECT forEvent:EVENT_ROUTING_FAILED];
        [[OTCGap getInstance] subscribe:EVENT_GET_ROUTING_OBJECT forEvent:EVENT_ON_SET_ROUTES_ERROR];
        //routingMgr = [RoutingMgr mgr]; 
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onGettingRoutingStateError:)
                                                     name:EVENT_GET_ROUTING_STATE_ERROR object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onGettingRoutingState:)
                                                     name:EVENT_GET_ROUTING_STATE_SUCCESS object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onChangedState:)
                                                     name:EVENT_ROUTING_CHANGED object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onChangedStateFailed:)
                                                     name:EVENT_ROUTING_FAILED object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onSetRoutesError:)
                                                     name:EVENT_ON_SET_ROUTES_ERROR object:nil];
    }
    return self;
}


-(void)loadRoutingDatas {
    NSLog(@"RoutingMgr: loadRoutingDatas");
    if (otcGap == nil) {
        otcGap = [OTCGap getInstance];
    }
    isChangedIntoSession = NO;
    [otcGap getRoutingState];
}


- (void) sendActiveRoutingDatas:(RoutingRouteModelClass *)presentationRoute
               withForwardRoute:(RoutingRouteModelClass *)forwardRoute
           withCurrentDeviceId:(NSString *)_currentDevice {
    NSLog(@"RoutingMgr: SendActiveRoutingDatas");
    // Update local database
//    routingState.presentationRoute = presentationString;
//    routingState.forwardRoute = forwardRoute;

    // Update OTCGap
    NSString *presentationJSON = [RoutingJSONHandler getJSONForRoutingRoute:presentationRoute];
    NSString *forwardJSON = [RoutingJSONHandler getJSONForRoutingRoute:forwardRoute];
    
    if (!otcGap) {
        otcGap = [OTCGap getInstance];
    }
    if (otcGap)
    [otcGap setRoutingState:presentationJSON setForwardRoute:forwardJSON currentDeviceID:_currentDevice];
}

- (void) onGettingRoutingStateError :(NSNotification *)notification {
    NSLog(@"RoutingMgr: Received notification onGettingRoutingStateError");
    
    NSDictionary *eventData = [notification object];
    [self popErrorAlertWithDict:eventData];
}

- (void) onGettingRoutingState :(NSNotification *)notification {
    NSLog(@"RoutingMgr: Received notification onGettingRoutingState");
   // NSLog(@"Notifffff : \n%@",notification);
    NSNotification* notif2 = notification.object;
    NSDictionary *eventData = notif2.object;
   // NSLog(@"Dataaaaaaa : \n%@",eventData);
    
   // NSMutableArray* ARR = [notification  valueForKey:@"object"];

  //  NSLog(@"OBJEt 0 = %d",ARR.count);
    self.routingState = [RoutingJSONHandler getRoutingFromDictionary:eventData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_ROUTING_CHANGE object:nil];
}

- (void) onChangedState :(NSNotification *)notification {
    NSLog(@"RoutingProfilViewController: Received notification changestate success");
    
    NSDictionary *eventData = [notification object];
    
    self.routingState = [RoutingJSONHandler getRoutingFromDictionary:eventData];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_ROUTING_CHANGE object:nil];
}


- (void) onChangedStateFailed :(NSNotification *)notification {
    NSLog(@"RoutingProfilViewController: Received notification changestate failed");
    
    NSArray *eventDataArray = [notification object];
    if (eventDataArray && [eventDataArray isKindOfClass:[NSArray class]]) {
    
        [self popErrorAlertWithArray:eventDataArray];
    
        if ([eventDataArray count] > 0) {
            NSDictionary *eventData = [eventDataArray objectAtIndex:0];
            if ([eventData isKindOfClass:[NSDictionary class]]) {
                self.routingState = [RoutingJSONHandler getRoutingFromDictionary:eventData];
            }
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_UPDATE_PROFILE_LIST object:nil];
}

-(NSString*)getAppliedProfile {
    if (routingState.appliedProfile != nil) {
        if (routingState.appliedProfile.name != nil) {
            return routingState.appliedProfile.name;
        }
    }
    return @"Default";
}

- (void)onSetRoutesError:(NSNotification *)notification {
    NSLog(@"RoutingMgr: Received notification onSetRoutesError");
    
    NSDictionary *eventData = [notification object];
    [self popErrorAlertWithDict:eventData];
}

- (void)popErrorAlertWithArray:(NSArray *)array {
   // NSString *errorMessage = [NSString stringWithFormat:@"%@", [[DicoMgr mgr] getLocalization:@"SETTINGS.ROUTINGPROFILEMESSAGE.ROUTINGPROBLEM"]];
    for (NSString *item in array) {
     //   errorMessage = [NSString stringWithFormat:@"%@\n\t. %@", errorMessage, item];
    }
    
   // [self popErrorAlertWithString:errorMessage];
}

- (void)popErrorAlertWithDict:(NSDictionary *)dict {
  //  NSString *errorMessage = [NSString stringWithFormat:@"%@", [[DicoMgr mgr] getLocalization:@"SETTINGS.ROUTINGPROFILEMESSAGE.ROUTINGPROBLEM"]];
    for (NSString *aKey in dict) {
        NSString *aMessage = (NSString *)[dict objectForKey:aKey];
    //    errorMessage = [NSString stringWithFormat:@"%@\n\t%@ : %@", errorMessage, aKey, aMessage];
    }
    
  //  [self popErrorAlertWithString:errorMessage];
}

- (void)popErrorAlertWithString:(NSString *)errorMessage {
    NSLog([NSString stringWithFormat:@"popErrorAlertWithString | %@ |", errorMessage]);
    
  //  UIAlertView *saveContentAlert = [[UIAlertView alloc] initWithTitle:@"" message:errorMessage delegate:self cancelButtonTitle:[[DicoMgr mgr] getLocalization:@"SETTINGS.ROUTINGPROFILE.OK"]otherButtonTitles:nil];
    //[saveContentAlert show];
}
@end
