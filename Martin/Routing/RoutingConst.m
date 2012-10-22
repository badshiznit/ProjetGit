//
//  RoutingConst.m
//  OpenTouch
//
//  Created by EffiTIC2 EffiTIC2 on 31/01/12.
//  Copyright (c) 2012 Alcatel-lucent. All rights reserved.
//

#import "RoutingConst.h"


NSString * const ROUTING_DESTINATION_TYPE_OFFICE = @"OFFICE";
NSString * const ROUTING_DESTINATION_TYPE_MOBILE = @"MOBILE";
NSString * const ROUTING_DESTINATION_TYPE_PC = @"PC";
NSString * const ROUTING_DESTINATION_TYPE_TABLET = @"TABLET";
NSString * const ROUTING_DESTINATION_TYPE_VIDEO = @"VIDEO";
NSString * const ROUTING_DESTINATION_TYPE_HOME = @"HOME";
NSString * const ROUTING_DESTINATION_TYPE_OTHER = @"OTHER";
NSString * const ROUTING_DESTINATION_TYPE_VOICEMAIL = @"VOICEMAIL";
NSString * const ROUTING_DESTINATION_TYPE_USER = @"USER";
NSString * const ROUTING_DESTINATION_TYPE_UNKNOWN = @"UNKNOWN";

NSString * const ROUTING_OVERFLOW_TYPE_BUSY = @"BUSY";
NSString * const ROUTING_OVERFLOW_TYPE_NO_ANSWER = @"NO_ANSWER";
NSString * const ROUTING_OVERFLOW_TYPE_BUSY_NO_ANSWER = @"BUSY_NO_ANSWER";

// JSON Answer
NSString * const ROUTING_JSON_KEY_CURRENT_DEVICE_ID = @"currentDeviceId";
NSString * const ROUTING_JSON_KEY_APPLIED_PROFILE = @"appliedProfile";
NSString * const ROUTING_JSON_KEY_ACTIVABLE_PROFILE = @"activableProfile";
NSString * const ROUTING_JSON_KEY_ADVANCED_ROUTE = @"advancedRoute";
NSString * const ROUTING_JSON_KEY_DESCRIPTION = @"description";

NSString * const ROUTING_JSON_KEY_FORWARD_ROUTE = @"forwardRoute";
NSString * const ROUTING_JSON_KEY_OVERFLOW_ROUTE = @"overflowRoute";
NSString * const ROUTING_JSON_KEY_PRESENTATION_ROUTE = @"presentationRoute";

// Route
NSString * const ROUTING_JSON_KEY_DESTINATION = @"destination";
NSString * const ROUTING_JSON_KEY_OVERFLOW_TYPE = @"overflowType";

// destination information
NSString * const ROUTING_JSON_KEY_INFORMATION = @"information";
NSString * const ROUTING_JSON_KEY_INFORMATION_LOGIN = @"login";
NSString * const ROUTING_JSON_KEY_INFORMATION_NAME = @"name";
NSString * const ROUTING_JSON_KEY_INFORMATION_FIRSTNAME = @"firstName";
NSString * const ROUTING_JSON_KEY_INFORMATION_EMAIL = @"email";
NSString * const ROUTING_JSON_KEY_INFORMATION_PHONENUMBER = @"phoneNumber";
NSString * const ROUTING_JSON_KEY_INFORAMTION_DEVICEID = @"deviceId";
NSString * const ROUTING_JSON_KEY_INFORMATION_NUMBER = @"number";
NSString * const ROUTING_JSON_KEY_INFORMATION_TYPE = @"type";
NSString * const ROUTING_JSON_KEY_INFORMATION_ACCEPTABLE = @"acceptable";
NSString * const ROUTING_JSON_KEY_INFORMATION_SELECTED = @"selected";

// destination Profil
NSString * const ROUTING_JSON_KEY_PROFIL_ID = @"id";
NSString * const ROUTING_JSON_KEY_PROFIL_NAME = @"name";
NSString * const ROUTING_JSON_KEY_PROFIL_DEFAULTP = @"defaultp";

NSInteger const ROUTING_POPOVER_WIDTH = 275;