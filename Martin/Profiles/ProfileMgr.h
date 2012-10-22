//
//  ProfileMgr.h
//  OpenTouch
//
//  Created by EffiTIC2 EffiTIC2 on 01/02/12.
//  Copyright (c) 2012 Alcatel-lucent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserProfileModelClass.h"
#import "OTCGap.h"
//#import "LogMgr.h"
#import "UserProfileJSONHandler.h"

extern NSString * const EVENT_GET_PROFILES_ERROR;
extern NSString * const EVENT_GET_PROFILES_SUCCESS;
extern NSString * const EVENT_UPDATE_PROFILE_LIST;
extern NSString * const EVENT_ON_SET_ROUTING_PROFILE_ERROR;

@interface ProfileMgr : NSObject {
    OTCGap              *otcGap;
    NSMutableArray      *profileList;   // object type UserProfileModelClass
}

@property(nonatomic,retain) OTCGap *otcGap;
@property(nonatomic,retain) NSMutableArray *profileList;

+ (ProfileMgr *) mgr;
- (UserProfileModelClass *) getDefaultProfile;
- (UserProfileModelClass *) getProfile:(NSString *)userProfileId;
    
- (void) loadProfileDatas;
- (void) applyProfileRoutes:(NSString *)profileID;
- (void) deleteProfileRoutes:(NSString *)profileID;
- (void) createRoutingProfile:(NSString *) profileName 
            presentationRoute:(RoutingRouteModelClass *) setPresentationRoute 
                 forwardRoute:(RoutingRouteModelClass *) setForwardRoute 
              currentDeviceId:(NSString *) setCurrentDeviceId;
-(void) setRoutingProfile:(NSString *) profileId
               profilName:(NSString *) setProfileName 
        presentationRoute:(RoutingRouteModelClass *) setPresentationRoute 
             forwardRoute:(RoutingRouteModelClass *) setForwardRoute 
          currentDeviceId:(NSString *) setCurrentDeviceId;

- (void) onGettingProfile :(NSNotification *)notification;
- (void) onGettingProfileError:(NSNotification *)notification;
- (void) onRoutingProfilesChanged:(NSNotification *)notification;
- (void) onApplyProfileSuccess:(NSNotification *)notification;
- (void) onApplyProfileError:(NSNotification *)notification;
- (void) onCreateRoutingProfile:(NSNotification *)notification;
- (void) onCreateRoutingProfileError:(NSNotification *)notification;
- (void) onDeleteProfiles:(NSNotification *)notification;
- (void) onDeleteProfilesError:(NSNotification *)notification;
- (void)onSetRoutingProfileError:(NSNotification *)notification;

+ (BOOL)isCustomProfile:(RoutingStateModelClass *)routeState;
+ (NSString *)getProfileLabelNameForRouteState:(RoutingStateModelClass *)routeState;

@end
