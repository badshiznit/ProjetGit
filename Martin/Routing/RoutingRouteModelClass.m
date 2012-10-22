//
//  RoutingRouteModelClass.m
//  OpenTouch
//
//  Created by EffiTIC2 EffiTIC2 on 26/01/12.
//  Copyright (c) 2012 Alcatel-lucent. All rights reserved.
//

#import "RoutingRouteModelClass.h"

@implementation RoutingRouteModelClass

@synthesize overflowType;
@synthesize route;
@synthesize nbOfAcceptable;

+ (OverflowType) getOverflowTypeForString:(NSString *) stringtoconvert
{
    if ([stringtoconvert isEqualToString:(NSString *)ROUTING_OVERFLOW_TYPE_BUSY])
    {
        return OverflowBusy;
    }
    else if ([stringtoconvert isEqualToString:(NSString *)ROUTING_OVERFLOW_TYPE_NO_ANSWER])
    {
        return OverflowNoAnswer;
    }
    else if ([stringtoconvert isEqualToString:(NSString *)ROUTING_OVERFLOW_TYPE_BUSY_NO_ANSWER])
    {
        return OverflowBusyNoAnswer;
    }
    else
    {
        return OverflowBusyNoAnswer;
    }
}

+ (RoutingDestinationModelClass *) getAcceptableDestinationByIndex:(NSInteger)index routingRoute:(RoutingRouteModelClass *)routingRoute
{
    RoutingDestinationModelClass *routingDest = [[RoutingDestinationModelClass alloc] init];
    if (routingRoute != nil) {
    NSInteger acceptableCount = 0;
        for (RoutingDestinationModelClass* routedestItem in routingRoute.route) {
            if (routedestItem.acceptable) {
                if (acceptableCount >= index) {
                routingDest = routedestItem;
                break;
            }
            acceptableCount++;
        }
    }
    }
    return routingDest;
}

- (RoutingRouteModelClass *) init
{
    self = [super init];
    
    route = [[NSMutableArray alloc] init];
    nbOfAcceptable = 0;
    overflowType = OverflowBusy;
    
    return self;
}

#pragma mark - NScopying
- (id)copyWithZone:(NSZone *)zone {
    RoutingRouteModelClass *objectCopy = [[[self class] alloc] init];
    
    if (objectCopy) {
        objectCopy.route = [[NSMutableArray alloc] init];
        for (RoutingDestinationModelClass *item in route) {
            [objectCopy.route addObject:[item copyWithZone:zone]];
        }
        
        // Set primitives
        objectCopy.overflowType = self.overflowType;
        objectCopy.nbOfAcceptable = self.nbOfAcceptable;
    }
    return objectCopy;
}

- (void)resetSettings {
    for (RoutingDestinationModelClass *item in route) {
        [item resetSettings];
    }
}

- (void) printDebug {
    NSLog(@"# \tnbAcceptable:[%d]", self.nbOfAcceptable);
    for (RoutingDestinationModelClass *item in route) {
        [item printDebug];
    }
}
    
+ (RoutingRouteModelClass *)updateRoute:(RoutingRouteModelClass *)route withTable:(UITableView *)tableData {
    RoutingRouteModelClass *newRoute  = [route copy];

    for (NSIndexPath *ip in tableData.indexPathsForVisibleRows) {
        RoutingDestinationModelClass *dest = [RoutingRouteModelClass getAcceptableDestinationByIndex:ip.row routingRoute:newRoute];
        UITableViewCell *cell = [tableData cellForRowAtIndexPath:ip];
        NSString *type = [RoutingDestinationModelClass getLabelForDestinationType:dest.type];

        if ([type isEqualToString:[cell.textLabel text]]) {
            BOOL destIsSelected = [dest selected];
            BOOL cellIsSelected = ![cell.imageView isHidden];
            NSString *destNumber = [dest number];
            NSString *cellNumber = [cell.detailTextLabel text];

            if (destIsSelected != cellIsSelected || ![destNumber isEqualToString:cellNumber]) {
                [dest setSelected:cellIsSelected];
                [dest setNumber:cellNumber];
            }
        }
    }
    return newRoute;
}

@end
