//
//  RoutingStateModelClass.m
//  OpenTouch
//
//  Created by EffiTIC2 EffiTIC2 on 25/01/12.
//  Copyright (c) 2012 Alcatel-lucent. All rights reserved.
//

#import "RoutingStateModelClass.h"
//#import "DicoMgr.h"

@implementation RoutingStateModelClass

@synthesize activableProfile;
@synthesize appliedProfile;
@synthesize advancedRoute;
@synthesize currentDeviceID;
@synthesize forwardRoute;
@synthesize overflowRoute;
@synthesize presentationRoute;

- (void)initWithName:(NSMutableArray *)newActivableProfile 
      appliedProfile:(UserProfileModelClass *)newAppliedProfile 
     currentDeviceID:(NSString *)newCurrentDeviceID
       advancedRoute:(NSMutableArray *)newAdvancedRoute
        forwardRoute:(RoutingRouteModelClass *)newForwardRoute 
       overflowRoute:(RoutingRouteModelClass *)newOverflowRoute
   presentationRoute:(RoutingRouteModelClass *)newPresentationRoute;
{
    self.activableProfile = newActivableProfile;
    self.appliedProfile = newAppliedProfile;
    self.advancedRoute = newAdvancedRoute;
    self.currentDeviceID = newCurrentDeviceID;
    self.forwardRoute = newForwardRoute;
    self.overflowRoute = newOverflowRoute;
    self.presentationRoute = newPresentationRoute;
}

- (RoutingStateModelClass *)init
{
    self = [super init];
    
    self.activableProfile = [[NSMutableArray alloc] init];
    self.advancedRoute = [[NSMutableArray alloc] init];
    self.forwardRoute = [[RoutingRouteModelClass alloc] init];
    self.overflowRoute = [[RoutingRouteModelClass alloc] init];
    self.presentationRoute = [[RoutingRouteModelClass alloc] init];
    self.currentDeviceID = @"";
    
    [self initLabel];
 //   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initStringFromDico:) name:EVENT_DICOINITIALIZED object:nil];

    return self;
}

- (void) initStringFromDico :(NSNotification*)notification {
    [self initLabel];
}

- (void) initLabel{/*
    routing_destination_label_office = [[DicoMgr mgr] getLocalization:@"ROUTING.LABEL.OFFICE"]; //NSLocalizedString(@"OTC.routing.label.office", @"");
    routing_destination_label_mobile = [[DicoMgr mgr] getLocalization:@"ROUTING.LABEL.MOBILE"]; //NSLocalizedString(@"OTC.routing.label.mobile", @"");
    routing_destination_label_pc = [[DicoMgr mgr] getLocalization:@"ROUTING.LABEL.PC"]; //NSLocalizedString(@"OTC.routing.label.pc", @"");
    routing_destination_label_tablet = [[DicoMgr mgr] getLocalization:@"ROUTING.LABEL.TABLET"]; //NSLocalizedString(@"OTC.routing.label.tablet", @"");
    routing_destination_label_video = [[DicoMgr mgr] getLocalization:@"ROUTING.LABEL.VIDEO"]; //NSLocalizedString(@"OTC.routing.label.video", @"");
    routing_destination_label_home = [[DicoMgr mgr] getLocalization:@"ROUTING.LABEL.HOME"]; //NSLocalizedString(@"OTC.routing.label.home", @"");
    routing_destination_label_other = [[DicoMgr mgr] getLocalization:@"ROUTING.LABEL.OTHER"]; //NSLocalizedString(@"OTC.routing.label.other", @"");
    routing_destination_label_voicemail = [[DicoMgr mgr] getLocalization:@"ROUTING.LABEL.VOICEMAIL"]; //NSLocalizedString(@"OTC.routing.label.voicemail", @"");
    routing_destination_label_user = [[DicoMgr mgr] getLocalization:@"ROUTING.LABEL.USER"]; //NSLocalizedString(@"OTC.routing.label.user", @"");
    routing_destination_label_unknown = [[DicoMgr mgr] getLocalization:@"ROUTING.LABEL.UNKNOWN"]; //NSLocalizedString(@"OTC.routing.label.unknown", @"");
*/}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NScopying
- (id)copyWithZone:(NSZone *)zone {
    
    RoutingStateModelClass *objectCopy = [[[self class] alloc] init];
    
    if (objectCopy) {
        // Copy NSObject subclasses
        objectCopy.activableProfile = [self.activableProfile copyWithZone:zone];
        objectCopy.appliedProfile = [self.appliedProfile copyWithZone:zone];
        
        objectCopy.advancedRoute = [self.advancedRoute copyWithZone:zone];
        objectCopy.forwardRoute = [self.forwardRoute copyWithZone:zone];
        objectCopy.overflowRoute = [self.overflowRoute copyWithZone:zone];
        objectCopy.presentationRoute = [self.presentationRoute copyWithZone:zone];
        
        // Set primitives
        objectCopy.currentDeviceID = self.currentDeviceID;
    }
    return objectCopy;
}

@end
