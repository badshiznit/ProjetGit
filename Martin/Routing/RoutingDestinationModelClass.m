//
//  RoutingDestinationModelClass.m
//  OpenTouch
//
//  Created by EffiTIC2 EffiTIC2 on 25/01/12.
//  Copyright (c) 2012 Alcatel-lucent. All rights reserved.
//

#import "RoutingDestinationModelClass.h"

@implementation RoutingDestinationModelClass

@synthesize deviceId;
@synthesize number;
@synthesize type;
@synthesize acceptable;
@synthesize selected;
@synthesize userInformation;

- (void)initWithName:(NSString *)newDeviceId number:(NSString *)newNumber type:(DestinationType)newType acceptable:(BOOL)newAcceptable selected:(BOOL)newSelected userInformation:(UserInformationModelClass *)newUserInformation
{
    self.deviceId = newDeviceId;
    self.number = newNumber;
    self.type = newType;
    self.acceptable = newAcceptable;
    self.selected = newSelected;
    self.userInformation = newUserInformation;
}

- (RoutingDestinationModelClass *) init
{
    self = [super init];
    
    self.deviceId = @"";
    self.number = @"";
    self.type = DestinationTypeUnknown;
    self.acceptable = NO;
    self.selected = NO;
    self.userInformation = nil;
    
    return self;
}

+ (DestinationType) getDestinationTypeForString:(NSString *) stringtoconvert
{
    if ([stringtoconvert isEqualToString:ROUTING_DESTINATION_TYPE_OFFICE])
    {
        return DestinationTypeOffice;
    }
    else if ([stringtoconvert isEqualToString:(NSString *)ROUTING_DESTINATION_TYPE_MOBILE])
    {
        return DestinationTypeMobile;
    }
    else if ([stringtoconvert isEqualToString:(NSString *)ROUTING_DESTINATION_TYPE_PC])
    {
        return DestinationTypePc;
    }
    else if ([stringtoconvert isEqualToString:(NSString *)ROUTING_DESTINATION_TYPE_TABLET])
    {
        return DestinationTypeTablet;
    }
    else if ([stringtoconvert isEqualToString:(NSString *)ROUTING_DESTINATION_TYPE_VIDEO])
    {
        return DestinationTypeVideo;
    }
    else if ([stringtoconvert isEqualToString:(NSString *)ROUTING_DESTINATION_TYPE_HOME])
    {
        return DestinationTypeHome;
    }
    else if ([stringtoconvert isEqualToString:(NSString *)ROUTING_DESTINATION_TYPE_OTHER])
    {
        return DestinationTypeOther;
    }
    else if ([stringtoconvert isEqualToString:(NSString *)ROUTING_DESTINATION_TYPE_VOICEMAIL])
    {
        return DestinationTypeVoicemail;
    }
    else if ([stringtoconvert isEqualToString:(NSString *)ROUTING_DESTINATION_TYPE_USER])
    {
        return DestinationTypeUser;
    }
    else
    {
        return DestinationTypeUnknown;
    }
}

+(NSString *)getStringForDestinationType:(DestinationType) destination
{
    NSString * destTypeStr = [[NSString alloc]init];
    
    if(destination == DestinationTypeOffice){
        destTypeStr = ROUTING_DESTINATION_TYPE_OFFICE;
    }else if(destination == DestinationTypeMobile){
        destTypeStr = ROUTING_DESTINATION_TYPE_MOBILE;
    }else if(destination == DestinationTypePc){
        destTypeStr = ROUTING_DESTINATION_TYPE_PC;
    }else if(destination == DestinationTypeTablet){
        destTypeStr = ROUTING_DESTINATION_TYPE_TABLET;
    }else if(destination == DestinationTypeVideo){
        destTypeStr = ROUTING_DESTINATION_TYPE_VIDEO;
    }else if(destination == DestinationTypeHome){
        destTypeStr = ROUTING_DESTINATION_TYPE_HOME;
    }else if(destination == DestinationTypeOther){
        destTypeStr = ROUTING_DESTINATION_TYPE_OTHER;
    }else if(destination == DestinationTypeVoicemail){
        destTypeStr = ROUTING_DESTINATION_TYPE_VOICEMAIL;
    }else if(destination == DestinationTypeUser){
        destTypeStr = ROUTING_DESTINATION_TYPE_USER;
    }else if(destination == DestinationTypeUnknown){
        destTypeStr = ROUTING_DESTINATION_TYPE_UNKNOWN;
    }
    return destTypeStr;
}

+ (NSString *) getLabelForDestinationType:(DestinationType) destination
{
    NSString * destTypeStr = [[NSString alloc]init];
    
    if(destination == DestinationTypeOffice){
        destTypeStr = routing_destination_label_office;
    }else if(destination == DestinationTypeMobile){
        destTypeStr = routing_destination_label_mobile;
    }else if(destination == DestinationTypePc){
        destTypeStr = routing_destination_label_pc;
    }else if(destination == DestinationTypeTablet){
        destTypeStr = routing_destination_label_tablet;
    }else if(destination == DestinationTypeVideo){
        destTypeStr = routing_destination_label_video;
    }else if(destination == DestinationTypeHome){
        destTypeStr = routing_destination_label_home;
    }else if(destination == DestinationTypeOther){
        destTypeStr = routing_destination_label_other;
    }else if(destination == DestinationTypeVoicemail){
        destTypeStr = routing_destination_label_voicemail;
    }else if(destination == DestinationTypeUser){
        destTypeStr = routing_destination_label_user;
    }else if(destination == DestinationTypeUnknown){
        destTypeStr = routing_destination_label_unknown;
    }
    return destTypeStr;
}

#pragma mark - NScopying
- (id)copyWithZone:(NSZone *)zone {
    
    RoutingDestinationModelClass *objectCopy = [[[self class] alloc] init];
    
    if (objectCopy) {
        // Copy NSObject subclasses
        objectCopy.userInformation = [self.userInformation copyWithZone:zone];
        
        // Set primitives
        objectCopy.deviceId = [self.deviceId copy];
        objectCopy.number = [self.number copy];
        objectCopy.type = self.type;
        objectCopy.acceptable = self.acceptable;
        objectCopy.selected = self.selected;
    }
    //NSLog([NSString stringWithFormat:@"object copy : deviceId=%@, number=%@, type=%@, acceptable=%@, selected=%@", objectCopy.deviceId , objectCopy.number, [RoutingDestinationModelClass getLabelForDestinationType:objectCopy.type], (objectCopy.acceptable ? @"YES" : @"NO"), (objectCopy.selected ? @"YES" : @"NO")]);
    //NSLog([NSString stringWithFormat:@"object self : deviceId=%@, number=%@, type=%@, acceptable=%@, selected=%@", self.deviceId , self.number, [RoutingDestinationModelClass getLabelForDestinationType:self.type], (self.acceptable ? @"YES" : @"NO"), (self.selected ? @"YES" : @"NO")]);
    return objectCopy;
}

- (void)resetSettings
{
    if (self.type == DestinationTypeOther || self.type == DestinationTypeUser) {
        self.number = @"";
    }
//    self.acceptable = NO;
    self.selected = NO;
    [self.userInformation resetSettings];
}

- (void) printDebug
{
    NSLog(@"\t# Destination");
    NSLog(@"- deviceId:\t%@\t- number:\t%@\t- type:\t%@\t- acceptable:\t%d\t- selected:\t%d\t", 
          deviceId, number, [RoutingDestinationModelClass getStringForDestinationType:type], acceptable, selected);
}

@end
