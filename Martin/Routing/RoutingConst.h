//
//  RoutingConst.h
//  OpenTouch
//
//  Created by EffiTIC2 EffiTIC2 on 27/01/12.
//  Copyright (c) 2012 Alcatel-lucent. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const ROUTING_DESTINATION_TYPE_OFFICE;
extern NSString * const ROUTING_DESTINATION_TYPE_MOBILE;
extern NSString * const ROUTING_DESTINATION_TYPE_PC;
extern NSString * const ROUTING_DESTINATION_TYPE_TABLET;
extern NSString * const ROUTING_DESTINATION_TYPE_VIDEO;
extern NSString * const ROUTING_DESTINATION_TYPE_HOME;
extern NSString * const ROUTING_DESTINATION_TYPE_OTHER;
extern NSString * const ROUTING_DESTINATION_TYPE_VOICEMAIL;
extern NSString * const ROUTING_DESTINATION_TYPE_USER;
extern NSString * const ROUTING_DESTINATION_TYPE_UNKNOWN;

NSString * routing_destination_label_office;
NSString * routing_destination_label_mobile;
NSString * routing_destination_label_pc;
NSString * routing_destination_label_tablet;
NSString * routing_destination_label_video;
NSString * routing_destination_label_home;
NSString * routing_destination_label_other;
NSString * routing_destination_label_voicemail;
NSString * routing_destination_label_user;
NSString * routing_destination_label_unknown;

extern NSString * const ROUTING_OVERFLOW_TYPE_BUSY;
extern NSString * const ROUTING_OVERFLOW_TYPE_NO_ANSWER;
extern NSString * const ROUTING_OVERFLOW_TYPE_BUSY_NO_ANSWER;

//
// JSON Parsing const
// documentation :
// Types    - wsdl_doc/types/2011/10/03/ics/routing/RoutingState.html
// ICS      - wsdl_doc/IcsRoutingManagement.html

// JSON Answer
extern NSString * const ROUTING_JSON_KEY_CURRENT_DEVICE_ID;
extern NSString * const ROUTING_JSON_KEY_APPLIED_PROFILE;
extern NSString * const ROUTING_JSON_KEY_ACTIVABLE_PROFILE;
extern NSString * const ROUTING_JSON_KEY_ADVANCED_ROUTE;
extern NSString * const ROUTING_JSON_KEY_DESCRIPTION;

extern NSString * const ROUTING_JSON_KEY_FORWARD_ROUTE;
extern NSString * const ROUTING_JSON_KEY_OVERFLOW_ROUTE;
extern NSString * const ROUTING_JSON_KEY_PRESENTATION_ROUTE;

// Route
extern NSString * const ROUTING_JSON_KEY_DESTINATION;
extern NSString * const ROUTING_JSON_KEY_OVERFLOW_TYPE;

// destination information
extern NSString * const ROUTING_JSON_KEY_INFORMATION;
extern NSString * const ROUTING_JSON_KEY_INFORMATION_LOGIN;
extern NSString * const ROUTING_JSON_KEY_INFORMATION_NAME;
extern NSString * const ROUTING_JSON_KEY_INFORMATION_FIRSTNAME;
extern NSString * const ROUTING_JSON_KEY_INFORMATION_EMAIL;
extern NSString * const ROUTING_JSON_KEY_INFORMATION_PHONENUMBER;
extern NSString * const ROUTING_JSON_KEY_INFORAMTION_DEVICEID;
extern NSString * const ROUTING_JSON_KEY_INFORMATION_NUMBER;
extern NSString * const ROUTING_JSON_KEY_INFORMATION_TYPE;
extern NSString * const ROUTING_JSON_KEY_INFORMATION_ACCEPTABLE;
extern NSString * const ROUTING_JSON_KEY_INFORMATION_SELECTED;

// destination Profil
extern NSString * const ROUTING_JSON_KEY_PROFIL_ID;
extern NSString * const ROUTING_JSON_KEY_PROFIL_NAME;
extern NSString * const ROUTING_JSON_KEY_PROFIL_DEFAULTP;

extern NSInteger const ROUTING_POPOVER_WIDTH;
