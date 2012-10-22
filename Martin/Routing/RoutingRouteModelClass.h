//
//  RoutingRouteModelClass.h
//  OpenTouch
//
//  Created by EffiTIC2 EffiTIC2 on 26/01/12.
//  Copyright (c) 2012 Alcatel-lucent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoutingDestinationModelClass.h"
#import "RoutingConst.h"

typedef enum {
    OverflowBusy,
    OverflowNoAnswer,
    OverflowBusyNoAnswer
} OverflowType;

@interface RoutingRouteModelClass : NSObject <NSCopying> {
    NSMutableArray  *route; // array of RoutingDestinationModelClass
    OverflowType    overflowType;       // only used in overflow route
    NSInteger nbOfAcceptable;
}

@property (nonatomic, assign) OverflowType      overflowType;
@property (nonatomic, retain) NSMutableArray    *route;
@property (nonatomic, assign) NSInteger         nbOfAcceptable;

+ (OverflowType) getOverflowTypeForString:(NSString *) stringtoconvert;
+ (RoutingDestinationModelClass *) getAcceptableDestinationByIndex:(NSInteger)index routingRoute:(RoutingRouteModelClass *)routingRoute;
+ (RoutingRouteModelClass *)updateRoute:(RoutingRouteModelClass *)route withTable:(UITableView *)tableData;

- (RoutingRouteModelClass *) init;
- (void)resetSettings;
- (void) printDebug;

@end
