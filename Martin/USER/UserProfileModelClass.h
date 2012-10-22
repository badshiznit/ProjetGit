//
//  UserProfileModelClass.h
//  OpenTouch
//
//  Created by EffiTIC2 EffiTIC2 on 30/01/12.
//  Copyright (c) 2012 Alcatel-lucent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoutingRouteModelClass.h"

@interface UserProfileModelClass : NSObject <NSCopying> {
    NSString *pid;         
    NSString *name;                     // optional [0..1]
    NSString *currentDeviceID;
    BOOL isDefaultp;        
    BOOL activable;       
    BOOL removable;      
    BOOL renameable;     
    BOOL updatable;      

    RoutingRouteModelClass *presentationRoute;  // Mandatory [1..*]
    RoutingRouteModelClass *forwardRoute;       // Optional [0..*]
}

@property (nonatomic, retain) NSString *pid;         
@property (nonatomic, retain) NSString *name;                     // optional [0..1]
@property (nonatomic, retain) NSString *currentDeviceID;
@property (nonatomic, assign) BOOL isDefaultp;        
@property (nonatomic, assign) BOOL activable;       
@property (nonatomic, assign) BOOL removable;      
@property (nonatomic, assign) BOOL renameable;     
@property (nonatomic, assign) BOOL updatable;      

@property (nonatomic, retain) RoutingRouteModelClass *presentationRoute;  // Mandatory [1..*]
@property (nonatomic, retain) RoutingRouteModelClass *forwardRoute;       // Optional [0..*]

- (UserProfileModelClass *)initWithId:(NSString *)newPid name:(NSString *)newName isDefaultp:(BOOL)newIsDefaultp presentationRoute:(RoutingRouteModelClass *)newPresentationRoute forwardRoute:(RoutingRouteModelClass *)newForwardRoute;
- (UserProfileModelClass *)initWithName:(NSString *)newPid name:(NSString *)newName isDefaultp:(BOOL)newIsDefaultp;

- (void) resetSettings;
- (void) printDebug;
@end
