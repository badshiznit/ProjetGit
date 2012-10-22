//
//  RoutingDestinationModelClass.h
//  OpenTouch
//
//  Created by EffiTIC2 EffiTIC2 on 25/01/12.
//  Copyright (c) 2012 Alcatel-lucent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInformationModelClass.h"
#import "RoutingConst.h"

typedef enum {
    DestinationTypeOffice = 0,
    DestinationTypeMobile,
    DestinationTypePc,
    DestinationTypeTablet,
    DestinationTypeVideo,
    DestinationTypeHome,    //5
    DestinationTypeOther,   //6
    DestinationTypeVoicemail,   //7
    DestinationTypeUser,    //8
    DestinationTypeUnknown  //9
} DestinationType;

@interface RoutingDestinationModelClass : NSObject <NSCopying> {
    NSString        *deviceId;      // optional
    NSString        *number;        // optional    
    DestinationType type;
    BOOL            acceptable;    // optional
    BOOL            selected;      // optional
    UserInformationModelClass   *userInformation;   // optional
}

@property (nonatomic, retain) NSString    *deviceId;
@property (nonatomic, retain) NSString    *number;
@property (nonatomic, assign) BOOL      acceptable;
@property (nonatomic, assign) BOOL      selected;
@property (nonatomic, assign) DestinationType              type;
@property (nonatomic, retain) UserInformationModelClass    *userInformation;

- (void)initWithName:(NSString *)newDeviceId 
              number:(NSString *)newNumber 
                type:(DestinationType)newType 
          acceptable:(BOOL)newAcceptable 
            selected:(BOOL)newSelected
     userInformation:(UserInformationModelClass *)newUserInformation;

+ (DestinationType) getDestinationTypeForString:(NSString *) stringtoconvert;
+(NSString *)getStringForDestinationType:(DestinationType) destination;
+ (NSString *) getLabelForDestinationType:(DestinationType) destination;

- (void)resetSettings;
- (void) printDebug;

@end
