//
//  ProfileMgr.m
//  OpenTouch
//
//  Created by EffiTIC2 EffiTIC2 on 01/02/12.
//  Copyright (c) 2012 Alcatel-lucent. All rights reserved.
//

#import "ProfileMgr.h"
#import "RoutingMgr.h"
//#import "DicoMgr.h"

NSString * const EVENT_GET_PROFILES_ERROR = @"onGetRoutingProfilesError";
NSString * const EVENT_GET_PROFILES_SUCCESS = @"onGetRoutingProfilesSuccess";
NSString * const EVENT_CREATE_PROFILE_SUCCESS = @"onCreateRoutingProfileSuccess";
NSString * const EVENT_CREATE_PROFILE_ERROR = @"onCreateRoutingProfileError";
NSString * const EVENT_DELETE_PROFILES_SUCCESS           = @"onDeleteRoutingProfilesSuccess";
NSString * const EVENT_DELETE_PROFILES_ERROR             = @"onDeleteRoutingProfilesError";
NSString * const EVENT_ON_APPLY_PROFILE_ROUTES_SUCCESS = @"onApplyProfileRoutesSuccess";
NSString * const EVENT_ON_APPLY_PROFILE_ROUTES_ERROR = @"onApplyProfileRoutesError";
NSString * const EVENT_ON_ROUTING_PROFILES_CHANGED      = @"onRoutingProfilesChanged";
NSString * const EVENT_ON_SET_ROUTING_PROFILE_ERROR      = @"onSetRoutingProfileError";

// Notification publsihed for GUI
NSString * const EVENT_UPDATE_PROFILE_LIST = @"onUpdateProfileList";

@interface ProfileMgr ()

- (void)popErrorAlertWithDict:(NSDictionary *)dict;
- (void)popErrorAlertWithString:(NSString *)errorMessage;

@end

@implementation ProfileMgr

@synthesize otcGap;
@synthesize profileList;
//@synthesize hasNewValue;

#pragma mark - Manager functions

static ProfileMgr *_mgr = nil;

+ (ProfileMgr*) mgr {
    @synchronized(self)	{
		if (_mgr == nil)
			_mgr = [[ProfileMgr alloc] init];
		return _mgr;
	}
	return nil;
}

- (id) init {
    self = [super init];

    if (self) {
//        hasNewValue = NO;
        // getters
        [[OTCGap getInstance] subscribe:EVENT_GET_ROUTING_OBJECT forEvent:EVENT_GET_PROFILES_SUCCESS];
        [[OTCGap getInstance] subscribe:EVENT_GET_ROUTING_OBJECT forEvent:EVENT_GET_PROFILES_ERROR];
        [[OTCGap getInstance] subscribe:EVENT_GET_ROUTING_OBJECT forEvent:EVENT_ON_APPLY_PROFILE_ROUTES_SUCCESS];
        [[OTCGap getInstance] subscribe:EVENT_GET_ROUTING_OBJECT forEvent:EVENT_ON_APPLY_PROFILE_ROUTES_ERROR];
        [[OTCGap getInstance] subscribe:EVENT_GET_ROUTING_OBJECT forEvent:EVENT_ON_ROUTING_PROFILES_CHANGED];
        [[OTCGap getInstance] subscribe:EVENT_GET_ROUTING_OBJECT forEvent:EVENT_CREATE_PROFILE_SUCCESS];
        [[OTCGap getInstance] subscribe:EVENT_GET_ROUTING_OBJECT forEvent:EVENT_CREATE_PROFILE_ERROR];
        [[OTCGap getInstance] subscribe:EVENT_GET_ROUTING_OBJECT forEvent:EVENT_DELETE_PROFILES_SUCCESS];
        [[OTCGap getInstance] subscribe:EVENT_GET_ROUTING_OBJECT forEvent:EVENT_DELETE_PROFILES_ERROR];
        [[OTCGap getInstance] subscribe:EVENT_GET_ROUTING_OBJECT forEvent:EVENT_ON_SET_ROUTING_PROFILE_ERROR];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onGettingProfile:)
                                                     name:EVENT_GET_PROFILES_SUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onGettingProfileError:)
                                                     name:EVENT_GET_PROFILES_ERROR object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onApplyProfileSuccess:)
                                                     name:EVENT_ON_APPLY_PROFILE_ROUTES_SUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onApplyProfileError:)
                                                     name:EVENT_ON_APPLY_PROFILE_ROUTES_ERROR object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onRoutingProfilesChanged:)
                                                     name:EVENT_ON_ROUTING_PROFILES_CHANGED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onCreateRoutingProfile:)
                                                     name:EVENT_CREATE_PROFILE_SUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onCreateRoutingProfileError:)
                                                     name:EVENT_CREATE_PROFILE_ERROR object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onDeleteProfiles:)
                                                     name:EVENT_DELETE_PROFILES_SUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onDeleteProfilesError:)
                                                     name:EVENT_DELETE_PROFILES_ERROR object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onSetRoutingProfileError:)
                                                     name:EVENT_ON_SET_ROUTING_PROFILE_ERROR object:nil];

    }
    return self;
}

#pragma mark -  OTCGap functions

- (void) loadProfileDatas {
    NSLog(@"ProfileMgr: loadProfileDatas");
    if (otcGap == nil) {
        otcGap = [OTCGap getInstance];
    }

    [otcGap getProfiles];
}

- (void) applyProfileRoutes:(NSString *)profileID {
    NSLog(@"ProfileMgr: applyProfileRoutes");
    
    if (otcGap == nil)
        otcGap = [OTCGap getInstance];
    [otcGap applyRoutingProfileRoutes:profileID];
}

- (void) deleteProfileRoutes:(NSString *)profileID {
    NSLog(@"ProfileMgr: deleteProfileRoutes");

    if (otcGap == nil) {
        otcGap = [OTCGap getInstance];
    }
    [otcGap deleteProfile:profileID];
}

- (void) createRoutingProfile:(NSString *) profileName 
            presentationRoute:(RoutingRouteModelClass *) setPresentationRoute 
                 forwardRoute:(RoutingRouteModelClass *) setForwardRoute 
              currentDeviceId:(NSString *) setCurrentDeviceId {
    NSLog(@"ProfileMgr: createRoutingProfile");

    if (otcGap == nil) {
        otcGap = [OTCGap getInstance];
    }
    
    NSString *presentationJSON = [RoutingJSONHandler getJSONForRoutingRoute:setPresentationRoute];
    NSString *forwardJSON = [RoutingJSONHandler getJSONForRoutingRoute:setForwardRoute];
    
    [otcGap createRoutingProfile:profileName presentationRoute:presentationJSON forwardRoute:forwardJSON currentDeviceId:setCurrentDeviceId];
}

-(void) setRoutingProfile:(NSString *) profileId
               profilName:(NSString *) setProfileName 
        presentationRoute:(RoutingRouteModelClass *) setPresentationRoute 
             forwardRoute:(RoutingRouteModelClass *) setForwardRoute 
          currentDeviceId:(NSString *) setCurrentDeviceId {
    NSLog(@"ProfileMgr: applyProfileRoutes");
    
    if (otcGap == nil) {
        otcGap = [OTCGap getInstance];
    }
    NSString *presentationJSON = [RoutingJSONHandler getJSONForRoutingRoute:setPresentationRoute];
    NSString *forwardJSON = [RoutingJSONHandler getJSONForRoutingRoute:setForwardRoute];
    
    [otcGap setRoutingProfile:profileId profilName:setProfileName presentationRoute:presentationJSON forwardRoute:forwardJSON currentDeviceId:setCurrentDeviceId];
}

- (UserProfileModelClass *) getDefaultProfile {
    if (profileList != nil) {
        for (UserProfileModelClass *profileItem in profileList) {
            if (profileItem.isDefaultp)
                return profileItem;
        }
    }
    return nil;
}

- (UserProfileModelClass *) getProfile:(NSString *)userProfileId {
    if (profileList != nil) {
        for (UserProfileModelClass *profileItem in profileList) {
            if ([profileItem.pid isEqualToString:userProfileId])
                return profileItem;
        }
    }
    return nil;
}

#pragma mark - Notifications handlers

- (void) onGettingProfile:(NSNotification *)notification {
    NSLog(@"ProfileMgr: Received notification onGetRoutingProfiles");

    NSMutableArray *eventData = [notification object];

    self.profileList = [UserProfileJSONHandler getProfilesFromArray:eventData];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_UPDATE_PROFILE_LIST object:nil];
}

- (void) onGettingProfileError:(NSNotification *)notification {
    NSLog(@"ProfileMgr: Error notification onGetRoutingProfiles not received");
    
    NSDictionary *eventData = [notification object];
    
    [self popErrorAlertWithDict:eventData];
}

- (void) onRoutingProfilesChanged:(NSNotification *)notification {
    NSLog(@"ProfileMgr: Received notification onRoutingProfilesChanged");
    
    NSMutableArray *eventData = [notification object];
    if (eventData != nil)
    {
        // only level 0 is set with datas
        NSMutableArray *eventData2 = [eventData objectAtIndex:0];
        if (eventData2 != nil) {
            NSLog( @"ProfileMgr: success");
            self.profileList = [UserProfileJSONHandler getProfilesFromArray:eventData2];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_UPDATE_PROFILE_LIST object:nil];
        }
    }    
}

- (void) onApplyProfileError:(NSNotification *)notification {
    NSLog(@"ProfileMgr: Received notification onApplyProfileError");
    // undo apply profile
    
    NSString *profileName = [notification object];
    NSLog( @"onApplyProfileError: name:%@ ",
                       profileName);
    
    // Redisplay correct data in popover
    [otcGap getProfiles];
    [self popErrorAlertWithString:profileName];
}
    
// just retrieve the requestID -> but also lauch 'onRoutingStateChanged'
- (void) onApplyProfileSuccess:(NSNotification *)notification {
    NSLog(@"ProfileMgr: Received notification onApplyProfile success");
    
    // Redisplay correct data in popover
    [otcGap getProfiles];
}
    
- (void) onCreateRoutingProfile:(NSNotification *)notification {
    NSLog(@"ProfileMgr: Received notification onCreateRoutingProfile");
        
    NSDictionary *eventData = [notification object];
    if (eventData != nil) // the added destination
    {
        // Update local database
        UserProfileModelClass *newProfile = [UserProfileJSONHandler getProfileFromDictionary:eventData];
        [profileList addObject:newProfile];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_UPDATE_PROFILE_LIST object:nil];
}
}

- (void) onCreateRoutingProfileError:(NSNotification *)notification {
    NSLog(@"ProfileMgr: Received notification onCreateRoutingProfileError");
    
    NSDictionary *eventData = [notification object];
    
    [self popErrorAlertWithDict:eventData];
}

- (void) onDeleteProfiles:(NSNotification *)notification {
    NSLog(@"ProfileMgr: Received notification onDeleteProfiles");
    // Reload profile list
    [self loadProfileDatas];
}

- (void) onDeleteProfilesError:(NSNotification *)notification {
    NSLog(@"ProfileMgr: Received notification onDeleteProfilesError");
    
    NSDictionary *eventData = [notification object];
    [self popErrorAlertWithDict:eventData];
}

- (void)onSetRoutingProfileError:(NSNotification *)notification {
    NSLog(@"ProfileMgr: Received notification onSetRoutingProfileError");
    
    NSDictionary *eventData = [notification object];
    [self popErrorAlertWithDict:eventData];
}

- (void)popErrorAlertWithDict:(NSDictionary *)dict {
   // NSString *errorMessage =  [NSString stringWithFormat:@"%@", [[DicoMgr mgr] getLocalization:@"SETTINGS.ROUTINGPROFILEMESSAGE.ROUTINGPROBLEM"]];
    for (NSString *aKey in dict) {
        NSString *aMessage = (NSString *)[dict objectForKey:aKey];
     //   errorMessage =  [NSString stringWithFormat:@"%@\n\t%@ : %@", errorMessage, aKey, aMessage];
    }
    
 //   [self popErrorAlertWithString:errorMessage];
}

- (void)popErrorAlertWithString:(NSString *)errorMessage {
    NSLog( @"popErrorAlertWithString | %@ |", errorMessage);

   // UIAlertView *saveContentAlert = [[UIAlertView alloc] initWithTitle:@"" message:errorMessage delegate:self cancelButtonTitle:[[DicoMgr mgr] getLocalization:@"SETTINGS.ROUTINGPROFILE.OK"]otherButtonTitles:nil];
    //[saveContentAlert show];
}

+ (BOOL)isCustomProfile:(RoutingStateModelClass *)routeState {
    return (!routeState
            || !routeState.appliedProfile
            || !routeState.appliedProfile.name
            || [routeState.appliedProfile.name isEqualToString:@""]);
}

+ (NSString *)getProfileLabelNameForRouteState:(RoutingStateModelClass *)routeState {
    NSString *res = @"";
/*
    if ([ProfileMgr isCustomProfile:routeState])
        res = [[DicoMgr mgr] getLocalization:@"SETTINGS.INFOVIEW.CURRENTPROFILE"]; //@"Current Profile";
    else
        if (routeState.appliedProfile.isDefaultp)
            res = [[DicoMgr mgr] getLocalization:@"SETTINGS.ROUTINGPROFILEINFO.DEFAULT"];
        else
            res = routeState.appliedProfile.name;*/
    return res;
}

@end
