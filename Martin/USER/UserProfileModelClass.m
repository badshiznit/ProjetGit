//
//  UserProfileModelClass.m
//  OpenTouch
//
//  Created by EffiTIC2 EffiTIC2 on 30/01/12.
//  Copyright (c) 2012 Alcatel-lucent. All rights reserved.
//

#import "UserProfileModelClass.h"

@implementation UserProfileModelClass

@synthesize pid;         
@synthesize name;
@synthesize currentDeviceID;
@synthesize isDefaultp;        
@synthesize activable;       
@synthesize removable;      
@synthesize renameable;     
@synthesize updatable;      
@synthesize forwardRoute;
@synthesize presentationRoute;

- (UserProfileModelClass *)init
{
    self = [super init];
    
    self.forwardRoute = [[RoutingRouteModelClass alloc] init];
    self.presentationRoute = [[RoutingRouteModelClass alloc] init]; 
    
    pid = @"";
    name = @"";                     // optional [0..1]
    currentDeviceID = @"";
    isDefaultp = NO;
    activable = NO;
    removable = NO;
    renameable = NO;
    updatable = NO;
    
    return self;
}


- (UserProfileModelClass *)initWithId:(NSString *)newPid name:(NSString *)newName isDefaultp:(BOOL)newIsDefaultp presentationRoute:(RoutingRouteModelClass *)newPresentationRoute forwardRoute:(RoutingRouteModelClass *)newForwardRoute
{
    self = [super init];
    
    self.isDefaultp = newIsDefaultp;
    self.pid = newPid;
    self.name = newName;
    self.forwardRoute = newForwardRoute;
    self.presentationRoute = newPresentationRoute;
    
    return self;
}

- (UserProfileModelClass *)initWithName:(NSString *)newPid name:(NSString *)newName isDefaultp:(BOOL)newIsDefaultp
{
    self = [super init];
    
    self.isDefaultp = newIsDefaultp;
    self.pid = newPid;
    self.name = newName;
    
    return self;
}

#pragma mark - NScopying
- (id)copyWithZone:(NSZone *)zone {

    UserProfileModelClass *objectCopy = [[[self class] alloc] init];
    
    if (objectCopy) {
        // Copy NSObject subclasses
        objectCopy.presentationRoute = [self.presentationRoute copyWithZone:zone];
        objectCopy.forwardRoute = [self.forwardRoute copyWithZone:zone];
        
        // Set primitives
        objectCopy.pid = [self.pid copy];
        objectCopy.name = [self.name copy];
        objectCopy.currentDeviceID = [self.currentDeviceID copy];
        objectCopy.isDefaultp = self.isDefaultp;
        objectCopy.activable = self.activable;
        objectCopy.removable = self.removable;
        objectCopy.renameable = self.renameable;
        objectCopy.updatable = self.updatable;
    }
    return objectCopy;
}

- (void) resetSettings
{
    [self.forwardRoute resetSettings];
    [self.presentationRoute resetSettings]; 
    
    pid = @"";
    name = @"";                     // optional [0..1]
//    currentDeviceID = @"";
    isDefaultp = NO;
    activable = YES;
    removable = YES;
    renameable = YES;
    updatable = YES;
}

- (void) printDebug
{
    NSLog(@"#### Profile : %@ - %@  ####", pid, name);
    NSLog(@"- currentDeviceID:%@", currentDeviceID);
    NSLog(@"- isDefaultp:%d", isDefaultp);
    NSLog(@"- activable:%d", activable);
    NSLog(@"- removable:%d", removable);
    NSLog(@"- renameable:%d", renameable);
    NSLog(@"- updatable:%d", updatable);

    NSLog(@"#### Presentation Route ####");
    [presentationRoute printDebug];
    NSLog(@"#### Forward Route      ####");
    [forwardRoute printDebug];
    NSLog(@"#### ### #### #### ### #####");
}
@end
