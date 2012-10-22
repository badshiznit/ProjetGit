//
//  OTCGap.m
//  OpenTouch
//
//  Created by David Beilis on 11-10-05.
//  Copyright (c) 2011 Alcatel-lucent. All rights reserved.
//

#import "OTCGap.h"
#import "AppDelegate.h"
#import "SBJsonWriter.h"
#import "PhoneGapWrapper.h"
#import "MainViewController.h"
#import "JSON.h"

static OTCGap *me = nil;

@implementation OTCGap

@synthesize eventData;
@synthesize userLogin;
//@synthesize sipGap;

+ (OTCGap *) getInstance {
    if (me == nil) {
        me = [[OTCGap alloc] init];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        MainViewController *mainViewController = [appDelegate mainViewController];
        PhoneGapWrapper *pg_wrapper = mainViewController.otcLibGapWrapper;
        me = [pg_wrapper getCommandInstance:@"OTCGap"];
    }
    return me;
}

- (id) init {
    isGAPStarted = FALSE;
    
    self = [super init];
    
    if (self == nil) {
    }
    return self;
}

- (void) dealloc {
}

- (void) acsLogin {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().server.logIn(%@, %@)",
                                                            [userDef stringForKey:@"MTWUserName"], [userDef stringForKey:@"MTWPassword"]]];
}

-(void)onAnnotatePressedMain {
    [[self webView] stringByEvaluatingJavaScriptFromString:@"window.OTCGap.getRoot().toggleAnnotations()"];
}

#pragma mark Foncions d'ecoute

- (void) startOTCUserLogin:(NSString *)otcUser withPass:(NSString *) otcPass
          withDeviceParams:(NSString *) otcDeviceParams {
    NSLog(@"Attemtping to Login to ACSUserLogin");
    
    //MAK - for now, disable auto-accept before logging in
    [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().buddies.autoAccept = false;"]];
    
    [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().server.enableLog = true;"]];
    
    //OTCGap.enableLibLogging("logger")
    [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().enableLibLogging(\"logger\");"]];
    
    //Javascript to do Login
    NSString *result = [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.startOTCUserLogin('%@', '%@', '%@')", otcUser, otcPass, otcDeviceParams]];
    
    NSLog(@"OTCGap:startOTCUserLogin for %@, %@, %@ - result:%@", otcUser, otcPass, otcDeviceParams, result);
    
    //    otc.server.changeLogger(function(s) { logger.info(logger.Category.init, s)});
    //    [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().server.changeLogger(function(s) { window.OTCGap.logger.info(window.OTCGap.logger.Category.init, s)});"]];
    
    
    //    [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.logger.info(window.OTCGap.logger.Category.init, \"hello ken\");"]];
}

- (void) subscribe:(NSString *)object forEvent:(NSString *) eventName {
    NSString *jsFunc = [NSString stringWithFormat:@"window.OTCGap.subscribe('%@', '%@')", object, eventName];
    NSString *result = [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.subscribe('%@', '%@')", object, eventName]];
    NSLog(@"OTCGap:subscribe for %@ - result:%@ func:%@", eventName, result, jsFunc);
}


- (void) unsubscribe:(NSString *) eventName {
    NSString *result = [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.unsubscribe(OTCGap, '%@')", eventName]];
    NSLog(@"OTCGap:unsubscribe for %@ - %@", eventName, result);
}


- (void) dispatcherEvent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    
    NSString* eventId = [options valueForKey:@"id"];
    NSString* eventName = [options valueForKey:@"name"];
    NSString* eventDataStr = [options valueForKey:@"data"];
    NSNotification *notificationData = nil;
    
    // NSString *eventDataStr = [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getEventStr(%@)", eventId]];
    
    NSLog(@"OTCGap: EventReceived - |%@|, |%@|, |%@|\n\n", eventId, eventName, eventDataStr);
    SBJSON *jsonParser = [SBJSON new];
    
    // Parse the JSON into an Object
    id parsedEvent = [jsonParser objectWithString:eventDataStr error:NULL];
    
    if([eventName isEqualToString:@"onComMg_IM"]
       || [eventName isEqualToString:@"onRoutingProfilesChanged"]
       || [eventName isEqualToString:@"onApplyProfileRoutesSuccess"]
       || [eventName isEqualToString:@"onMessagingComplete"]    // voicemail
       || [eventName isEqualToString:@"onRoutingManagementFailed"]    // routing
       || [eventName isEqualToString:@"onConnectError"]
       ) {
        NSMutableArray *arrayData = [[NSMutableArray alloc]init];
        NSArray *eventDataArray = (NSArray *)parsedEvent;
        int countMax = [eventDataArray count];
        for (int i=0; i<countMax; i++) {
            [arrayData addObject:(NSDictionary *)[eventDataArray objectAtIndex:i]];
        }
        notificationData = [NSNotification notificationWithName:eventName object:arrayData];
    }else
        if([eventName isEqualToString:@"onRoutingStateChanged"] ||
           [eventName isEqualToString:@"onGetRoutingStateSuccess"] ||
           [eventName isEqualToString:@"onGetRoutingProfilesSuccess"]
           )
        {
            // Need to check the format of other events..
          /*  NSArray *eventDataArray = (NSArray *)parsedEvent;
            if (eventDataArray != nil && [eventDataArray count] > 0)
            {
                eventData = (NSDictionary *)[eventDataArray objectAtIndex:0];
                NSLog(@"badshiznit %@", eventData);
            }
            notificationData = [NSNotification notificationWithName:eventName object:eventData];
            */
            
            NSArray *eventDataArray = (NSArray *)parsedEvent;
            
            if (eventDataArray != nil && [eventDataArray count] > 0)
            {
                eventData = (NSDictionary *)[eventDataArray objectAtIndex:0];
                notificationData = [NSNotification notificationWithName:eventName object:eventData];
            }
            else 
            {
                notificationData = [NSNotification notificationWithName:eventName object:nil];
            }
            
        }
        else
        {
            // We need to pass the two objects
            notificationData  = [NSNotification notificationWithName:eventName object:parsedEvent];
        }
    
    //  UIAlertView* alert = [[UIAlertView alloc] initWithTitle:eventName message:eventDataStr delegate:self cancelButtonTitle:@"Fermer" otherButtonTitles:nil];
    //[alert show];
    
    //  [[NSNotificationCenter defaultCenter] performSelector:@selector(postNotification:)
    //                                                       withObject:notificationData];
    
    [[NSNotificationCenter defaultCenter] 
     postNotificationName:eventName 
     object:notificationData];
    
    //[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:)
    //                                                    withObject:notificationData
    //                                               waitUntilDone:YES];
}

#pragma mark - Fonction Call Back OTC Gap

- (void) onPhoneGapInit:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    
    NSLog(@"OTCGap: onPhoneGapInit");
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    MainViewController *mainViewController = (MainViewController*)[appDelegate mainViewController];
    
    [mainViewController onPhoneGapInit];
    
    isGAPStarted = TRUE;
    
    // sipGap = [[SipGap alloc] init];
}

- (void) onLoginSuccess:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    
    NSLog(@"OTCGap: onLoginSuccess");
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    MainViewController *mainViewController = (MainViewController*)[appDelegate mainViewController];
    
    [mainViewController loginCompleted:YES];
}

- (void) onLoginFail:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    
    NSString    *p1 = [options valueForKey:@"p1"];
    NSLog(@"on Login Failed...");
    if (p1 != nil && [p1 isEqualToString:@"contact_not_found"]) {
        NSLog(@"OTCGap: onLoginFail - contact_not_found - ignoring...");
    } else if (p1 != nil && [p1 isEqualToString:@"multiple_login"]) {
        NSLog(@"OTCGap: onLoginFail - Received Errormultiple_login - ignoring...");
    } else {
        NSLog(@"OTCGap: onLoginFail - %@", p1);
        
        //  AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
        //MainViewController *mainViewController = [appDelegate mainViewController];
        
        //        [mainViewController loginCompleted:NO];
    }
    
    [[[UIAlertView alloc] initWithTitle:@"OTCGap"
                                message:[NSString stringWithFormat:@"Error - %@", p1]
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

#pragma mark Routing Profile

-(void) getProfiles{
    NSLog(@"OTCGap - getProfiles");
    
    NSString *result = [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().routingMgr.getRoutingProfiles()"]];
    
    NSLog(@"OTCGap - show result profiles : %@", result);
}

-(void) applyRoutingProfileRoutes:(NSString *) profileID {
    NSLog(@"OTCGap - applyRoutingProfileRoutes");
    
    //bad version  NSString *result = [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().routingMgr.applyProfileRoutes('{profileId:\"%@\"}', '%@')", profileID, [self getRequestId]]];
    NSString *result = [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().routingMgr.applyProfileRoutes('%@', '%@')", profileID, [self getRequestId]]];
    
    NSLog(@"OTCGap - show result applyRoutingProfileRoutes : %@", result);
}

-(void) createRoutingProfile:(NSString *) profileName
           presentationRoute:(NSString *) setPresentationRoute
                forwardRoute:(NSString *) setForwardRoute
             currentDeviceId:(NSString *) setCurrentDeviceId {
    NSLog(@"OTCGap - createRoutingProfile");
    
    NSString *result = [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().routingMgr.createRoutingProfile(\"%@\", {'destination':[%@]},  {'destination':[%@]}, \"%@\")", profileName, setPresentationRoute, setForwardRoute, setCurrentDeviceId]];
    
    NSLog(@"OTCGap - show result createRoutingProfile : %@", result);
}

-(void) setRoutingProfile:(NSString *) profileId
               profilName:(NSString *) setProfileName
        presentationRoute:(NSString *) setPresentationRoute
             forwardRoute:(NSString *) setForwardRoute
          currentDeviceId:(NSString *) setCurrentDeviceId {
    NSLog(@"OTCGap - setRoutingProfile");
    
    NSString *result = [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().routingMgr.setRoutingProfile(\"%@\", \"%@\", {'destination':[%@]},  {'destination':[%@]}, \"%@\")", profileId, setProfileName, setPresentationRoute, setForwardRoute, setCurrentDeviceId]];
    
    NSLog(@"OTCGap - show result setRoutingProfile : %@", result);
}

-(void) deleteProfile:(NSString *)profileId {
    NSLog(@"OTCGap - deleteProfile : %@", profileId);
    
    NSString *result = [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().routingMgr.deleteRoutingProfiles([%@])", profileId]];
    
    NSLog(@"OTCGap - show result deleteProfile : %@", result);
}

-(void) getRoutingState{
    NSLog(@"OTCGap - getRoutingState");
    
    
    NSString *result = [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().routingMgr.getRoutingState()"]];
    
    NSLog(@"OTCGap - show result state : %@", result);
}

- (void) setRoutingState:(NSString*)_presentationString setForwardRoute:(NSString*)_forwardRoute currentDeviceID:(NSString*)_currentDeviceId{
    
    NSLog(@"OTCGap - setRoutingState");
    
    if(!_forwardRoute || [_forwardRoute isEqualToString:@""] || [_forwardRoute isEqualToString:@"(null)"]){
        _forwardRoute = @"null";
    }
    
    NSString *result = [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().routingMgr.setRoutes({'destination':[%@]},  {'destination':[%@]}, '%@', '%@')", _presentationString, _forwardRoute,_currentDeviceId, [self getRequestId]]];
    //NSLog([NSString stringWithFormat:@"window.OTCGap.getRoot().routingMgr.setRoutes({'destination':[%@]},  {'destination':[%@]}, '%@', '%@')", _presentationString, _forwardRoute,_currentDeviceId, [self getRequestId]]);
    
    NSLog(@"OTCGap - result state %@", result);
}

- (NSString *) getRequestId {
    NSDateFormatter *time = [[NSDateFormatter alloc] init];
    [time setDateFormat:@"ddMMyyyyHHmmss"];
    NSString *dateString= [[NSString alloc] initWithFormat:@"%@",[time stringFromDate:[NSDate date]]];
    
    if (dateString == nil || userLogin == nil)
    {
        if (dateString == nil)
            dateString = @"";
        if (userLogin == nil)
            userLogin = @"";
        NSLog(@"OTCGap - WARNING - getRequestId has bad values - time:'%@' - userLogin:'%@'", dateString, userLogin);
    }
    
    return [NSString stringWithFormat:@"OTC_Tablet_%@_%@", userLogin, dateString];
}


#pragma mark    - Communication Manager integration
- (void) publishLocalSipEvent:(long)session_id andUser:(NSString*)otc_user andSignal:(NSString*)event_type andCallUUID:(NSString*)callUUID andMediaType:(int)mediaType andOldSessionId:(long)oldSessionId {
    // [[LogMgr mgr] log:[NSString stringWithFormat:@"onSIPAudioVideo , [sessionId = '%d', callUUID = '%@', otc_user = '%@', event_type = '%@', mediaType = %d, oldSessionId= %d])", session_id, callUUID, otc_user, event_type, mediaType, oldSessionId]];
    [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().localSIP.dispatch('onSIPAudioVideo', ['%d', '%@', '%@', '%@', '%d', '%d'])", session_id, callUUID, otc_user, event_type, mediaType, oldSessionId]];
    
}

- (void) sendSipRegisteredEvent {
    // [[LogMgr mgr] log:@"onSIPRegisterChange"];
    [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().localSIP.dispatch('onSIPRegisterChange', ['connect','success'])"]];
}

- (NSString*) BuildKeyNotEmpty:(NSString*)stringEnter andkey:(NSString*)key andValue:(NSString*)value andValueIsTab:(BOOL)isValueIsTab
{
    NSString *stringJSon = @"";
    if ((value != nil) && ([value isEqualToString:@""] == FALSE) && (NSNull.null != (id)value))  // && (value != [NSNull null])
    {    
        if ([stringEnter isEqualToString:@""] == FALSE)
            stringJSon = [stringEnter stringByAppendingString:@","];
        
        if (isValueIsTab)
            stringJSon = [stringJSon stringByAppendingString:[NSString stringWithFormat:@"%@:['%@']", key, value]];
        else
            stringJSon = [stringJSon stringByAppendingString:[NSString stringWithFormat:@"%@:'%@'", key, value]];
    }
    else
        stringJSon = stringEnter;
    return stringJSon;
}

- (NSString*) buildStringJSonWithoutKeyEmpty:(NSString*)userId andLogin:(NSString*)login andMail:(NSString*)mail andPhoneNumber:(NSString*)phone andLastName:(NSString*)lastname andFirstName:(NSString*)firstname andImgName:(NSString*)imgSrc
{
    /*
     BOOL separator = FALSE;
     NSString *stringJSon = @"{";
     if ((userId != nil) && ([userId isEqualToString:@""] == FALSE))  // && (userId != [NSNull null])
     {
     if (separator == TRUE)
     stringJSon = [stringJSon stringByAppendingString:@","];
     
     stringJSon = [stringJSon stringByAppendingString:[NSString stringWithFormat:@"userId:'%@'",userId]];
     separator = TRUE;
     }
     
     if ((login != nil) && ([login isEqualToString:@""] == FALSE))
     stringJSon = [stringJSon stringByAppendingString:[NSString stringWithFormat:@"login:'%@'",login]];
     if ((mail != nil) && ([mail isEqualToString:@""] == FALSE))
     stringJSon = [stringJSon stringByAppendingString:[NSString stringWithFormat:@"mails:['%@']",mail]];
     if ((phone != nil)  && ([phone isEqualToString:@""] == FALSE))
     stringJSon = [stringJSon stringByAppendingString:[NSString stringWithFormat:@"phoneNumber:['%@']",phone]];
     if ((lastname != nil)  && ([lastname isEqualToString:@""] == FALSE))
     stringJSon = [stringJSon stringByAppendingString:[NSString stringWithFormat:@"lastName:'%@'",lastname]];
     if ((firstname != nil)  && ([firstname isEqualToString:@""] == FALSE))
     stringJSon = [stringJSon stringByAppendingString:[NSString stringWithFormat:@"firstName:'%@'",firstname]];
     if ((firstname != nil)  && ([firstname isEqualToString:@""] == FALSE))
     stringJSon = [stringJSon stringByAppendingString:[NSString stringWithFormat:@"firstName:'%@'",firstname]];
     stringJSon = [stringJSon stringByAppendingString:@"}"];
     */
    /*
     NSString* jsonString= [NSString stringWithFormat:@"{userId:'%@', mails:['%@'], login:'%@', phoneNumber:['%@'], lastName:'%@', firstName:'%@', imgSrc:'%@'}", userId,  mail, login, phone, lastname, firstname, imgSrc];
     SBJsonWriter *jsonWriter = [SBJsonWriter new];
     NSString *stringJSon = [jsonWriter stringWithFragment:self];
     if (stringJSon == nil)
     NSLog(@"-JSONFragment failed. Error trace is: %@", [jsonWriter errorTrace]);
     //[jsonWriter release];
     */
    
    
    
    NSString *stringJSon = [self BuildKeyNotEmpty:@"" andkey:@"userId" andValue:userId andValueIsTab:FALSE];
    
    stringJSon = [self BuildKeyNotEmpty:stringJSon andkey:@"mails" andValue:mail andValueIsTab:TRUE];
    stringJSon = [self BuildKeyNotEmpty:stringJSon andkey:@"login" andValue:login andValueIsTab:FALSE];
    stringJSon = [self BuildKeyNotEmpty:stringJSon andkey:@"phoneNumbers" andValue:phone andValueIsTab:TRUE];
    stringJSon = [self BuildKeyNotEmpty:stringJSon andkey:@"lastName" andValue:lastname andValueIsTab:FALSE];
    stringJSon = [self BuildKeyNotEmpty:stringJSon andkey:@"firstName" andValue:firstname andValueIsTab:FALSE];
    stringJSon = [self BuildKeyNotEmpty:stringJSon andkey:@"imgSrc" andValue:imgSrc andValueIsTab:FALSE];
    if ([stringJSon isEqualToString:@""] == TRUE)
        return [NSString stringWithFormat:@"{imgSrc:'%@'}", imgSrc];
    else
        return [NSString stringWithFormat:@"{%@,imgSrc:'%@'}", stringJSon, imgSrc];
}
/*

- (void) makeCall:(NSString*)userId andLogin:(NSString*)login andMail:(NSString*)mail andPhoneNumber:(NSString*)phone andLastName:(NSString*)lastname andFirstName:(NSString*)firstname andImg:(NSString*)imgSrc andMediaType:(SessionMediaType)mediaType {
    //  [[LogMgr mgr] log:[NSString stringWithFormat:@"makeCall, userId=%@, phoneNumber=%@, media=%i", userId, phone, mediaType]];
    NSString* stringJSon = [self buildStringJSonWithoutKeyEmpty:userId  andLogin:login andMail:mail andPhoneNumber:phone andLastName:lastname andFirstName:firstname andImgName:imgSrc];
    /*  if (mediaType == MT_AUDIO) 
     {
     [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().communicationManager.makeCall(%@, {imgSrc:'%@'})", stringJSon, imgSrc]];
     //[[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().communicationManager.makeCall({userId:'%@', mails:['%@'], login:'%@', phoneNumber:['%@'], lastName:'%@', firstName:'%@', imgSrc:'%@'}, {imgSrc:'%@'})", userId,  mail, login, phone, lastname, firstname, imgSrc, imgSrc]];
     }
     else 
    {
        [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().communicationManager.makeVideoCall1Pcc(%@, {imgSrc:'%@'})", stringJSon, imgSrc]];
        //[[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().communicationManager.makeVideoCall1Pcc({userId:'%@', mails:['%@'], login:'%@', phoneNumber:['%@'], lastName:'%@', firstName:'%@', imgSrc:'%@'}, {imgSrc:'%@'})", userId,  mail, login, phone, lastname, firstname, imgSrc, imgSrc]];
        
    }
    
} */



/*- (void) makeAudioCall1Pcc:(NSString*)userId andLogin:(NSString*)login andMail:(NSString*)mail andPhoneNumber:(NSString*)phone andLastName:(NSString*)lastname andFirstName:(NSString*)firstname andImg:(NSString*)imgSrc andMediaType:(SessionMediaType)mediaType {
 [[LogMgr mgr] log:[NSString stringWithFormat:@"makeCall, userId=%@, phoneNumber=%@, media=%i", userId, phone, mediaType]];
 if (mediaType == S_MT_AUDIO) {
 [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().communicationManager.makeAudioCall1Pcc({userId:'%@', mails:['%@'], login:'%@', phoneNumber:['%@'], lastName:'%@', firstName:'%@', imgSrc:'%@'}, {imgSrc:'%@'})", userId,  mail, login, phone, lastname, firstname, imgSrc, imgSrc]];
 }
 else {
 [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().communicationManager.makeVideoCall1Pcc({userId:'%@', mails:['%@'], login:'%@', phoneNumber:['%@'], lastName:'%@', firstName:'%@', imgSrc:'%@'}, {imgSrc:'%@'})", userId,  mail, login, phone, lastname, firstname, imgSrc, imgSrc]];
 
 }
 
 }
 
 - (void) makeAudioCall3Pcc:(NSString*)userId andLogin:(NSString*)login andMail:(NSString*)mail andPhoneNumber:(NSString*)phone andLastName:(NSString*)lastname andFirstName:(NSString*)firstname andImg:(NSString*)imgSrc andMediaType:(SessionMediaType)mediaType {
 [[LogMgr mgr] log:[NSString stringWithFormat:@"makeCall, userId=%@, phoneNumber=%@, media=%i", userId, phone, mediaType]];
 if (mediaType == S_MT_AUDIO) {
 [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().communicationManager.makeAudioCall3Pcc({userId:'%@', mails:['%@'], login:'%@', phoneNumber:['%@'], lastName:'%@', firstName:'%@', imgSrc:'%@'}, {imgSrc:'%@'})", userId,  mail, login, phone, lastname, firstname, imgSrc, imgSrc]];
 }
 else {
 [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().communicationManager.makeVideoCall3Pcc({userId:'%@', mails:['%@'], login:'%@', phoneNumber:['%@'], lastName:'%@', firstName:'%@', imgSrc:'%@'}, {imgSrc:'%@'})", userId,  mail, login, phone, lastname, firstname, imgSrc, imgSrc]];
 
 }
 
 }*/


/* ----> 
- (void) makeCallByPhone:(NSString*)phoneNumber andMediaType:(SessionMediaType)mediaType {
    // [[LogMgr mgr] log:[NSString stringWithFormat:@"makeCallByPhone, phoneNumber=%@", phoneNumber]];
    [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().communicationManager.makeAudioCallUsingNumber('%@')", phoneNumber]];
}

- (void) releaseCall:(NSString*)sessionId {
    //[[LogMgr mgr] log:[NSString stringWithFormat:@"releaseCall, sessionId=%@", sessionId]];
    [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().communicationManager.releaseCall('%@')", sessionId]];
}

- (void) answerCall:(NSString*)sessionId {
    //[[LogMgr mgr] log:[NSString stringWithFormat:@"answerCall, sessionId=%@", sessionId]];
    [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().communicationManager.answerCall('%@')", sessionId]];
}

- (void) delineCall:(NSString*)sessionId {
    //[[LogMgr mgr] log:[NSString stringWithFormat:@"delineCall, sessionId=%@", sessionId]];
    [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().communicationManager.declineCall('%@')", sessionId]];
    
}

- (void) muteCall:(NSString*)sessionId {
    //[[LogMgr mgr] log:[NSString stringWithFormat:@"muteCall , [sessionId = %@]", sessionId]];
    [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().communicationManager.muteCall('%@', true)", sessionId]];
}

- (void) resumeCall:(NSString *)sessionId {
    //[[LogMgr mgr] log:[NSString stringWithFormat:@"unmuteCall , [sessionId = %@]", sessionId]];
    [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().communicationManager.muteCall('%@', false)", sessionId]];
}

- (void) sendDtmf:(NSString*)sessionId andDigit:(NSString*)digit {
    //[[LogMgr mgr] log:[NSString stringWithFormat:@"sendDtmf , [sessionId = %@], digit=%@", sessionId, digit]];
    [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().communicationManager.sendDTMF('%@', '%@')", sessionId, digit]];
    
}


- (void) joinConference:(NSString*)conferenceId {
    //[[LogMgr mgr] log:[NSString stringWithFormat:@"joinConference , [confId = %@]", conferenceId]];
    [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().communicationManager.joinConference({confId:'%@'})", conferenceId]];
    
}

- (void) switchDevice:(NSString*)sessionId andToDevice:(NSString*)switchTo {
    //   [[LogMgr mgr] log:[NSString stringWithFormat:@"switchDevice , [callId = %@]", sessionId]];
    [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().communicationManager.switchDevice('%@', '%@')", sessionId, switchTo]];
    
}


- (void) redirect:(NSString*)sessionId withDevice:(NSString*)switchTo {
    // [[LogMgr mgr] log:[NSString stringWithFormat:@"redirectDevice , [callId = %@],  deviceId: %@", sessionId, switchTo]];
    [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().communicationManager.redirect('%@', '%@')", sessionId, switchTo]];
	
}

- (void) redirectToVoiceMail:(NSString*)sessionId {
    //[[LogMgr mgr] log:[NSString stringWithFormat:@"redirectToVoiceMail , [callId = %@]", sessionId]];
    [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().communicationManager.redirectToVoiceMail('%@')", sessionId]];
	
}


//***********************
// Called from middleware for telephony actions
//***********************
- (void) MakeAudioCall:(NSDictionary*)param1 withDict:(NSDictionary*)remoteDatas {
    
    // [[LogMgr mgr] log:[NSString stringWithFormat:@"MakeAudioCall"]];
    [sipGap MakeAudioCall:remoteDatas];
}

- (void) MakeVideoCall:(NSDictionary*)param1 withDict:(NSDictionary*)remoteDatas {
    
    //  [[LogMgr mgr] log:[NSString stringWithFormat:@"MakeVideoCall"]];
    //  [sipGap MakeVideoCall:remoteDatas];
}

- (void) AcceptCall:(NSDictionary*)param1 withDict:(NSDictionary*)sipSessionIdDict {
    NSString* sessionIdStr = [sipSessionIdDict objectForKey:@"sessionId"];
    long sessionId = [sessionIdStr longLongValue];
    
    // [[LogMgr mgr] log:[NSString stringWithFormat:@"AcceptCall with id=%@", [NSNumber numberWithLong:sessionId]]];
    [sipGap AcceptCall:sessionId];
}

- (void) RejectCall:(NSDictionary*)param1 withDict:(NSDictionary*)sipSessionIdDict {
    NSString* sessionIdStr = [sipSessionIdDict objectForKey:@"sessionId"];
    long sessionId = [sessionIdStr longLongValue];
    
    //  [[LogMgr mgr] log:[NSString stringWithFormat:@"RejectCall with id=%@", [NSNumber numberWithLong:sessionId]]];
    [sipGap RejectCall:sessionId];
}

- (void) ReferToAudio:(NSDictionary*)param1 withDict:(NSDictionary*)referDatas {
    //PhoneGap.exec(componentName+".ReferToAudio", {'sessionId':sessionId,'referToParty':referToParty});
}

- (void) ReferToVideo:(NSDictionary*)param1 withDict:(NSDictionary*)referDatas {
    //PhoneGap.exec(componentName+".ReferToVideo", {'sessionId':sessionId,'referToParty':referToParty});
}

- (void) HangupCall :(NSDictionary*)param1 withDict:(NSDictionary*)sipSessionIdDict {
    NSString* sessionIdStr = [sipSessionIdDict objectForKey:@"sessionId"];
    long sessionId = [sessionIdStr longLongValue];
    
    //  [[LogMgr mgr] log:[NSString stringWithFormat:@"HangupCall with id=%@", [NSNumber numberWithLong:sessionId]]];
    
    [sipGap HangupCall:sessionId];
}

- (void) HoldCall:(NSDictionary*)param1 withDict:(NSDictionary*)sessionIdDict {
    //PhoneGap.exec(componentName+".HoldCall", {'sessionId':sessionId});
}

- (void) ResumeCall:(NSDictionary*)param1 withDict:(NSDictionary*)sessionIdDict {
    // PhoneGap.exec(componentName+".ResumeCall", {'sessionId':sessionId});
}

- (void) SendDTMF :(NSDictionary*)param1 withDict:(NSDictionary*)digit {
    NSString* sessionIdStr = [digit objectForKey:@"sessionId"];
    long sessionId = [sessionIdStr longLongValue];
    NSString* cdigit = [digit objectForKey:@"digit"];
    
    [sipGap SendDTMF:sessionId andDigit:[cdigit characterAtIndex:0]];
}

- (void) Mute :(NSDictionary*)param1 withDict:(NSDictionary*)muteDatas {
    NSString* sessionIdStr = [muteDatas objectForKey:@"sessionId"];
    long sessionId = [sessionIdStr longLongValue];
    
    BOOL isVideo = [[muteDatas objectForKey:@"video"] boolValue];
    BOOL isMuted = [[muteDatas objectForKey:@"mute"] boolValue];
    
    // [[LogMgr mgr] log:[NSString stringWithFormat:@"Mute with id=%@", [NSNumber numberWithLong:sessionId]]];
    
    [sipGap Mute:sessionId andVideo:isVideo andMuted:isMuted];
}

- (NSString*) getCurrentUserId {
    NSString *result = [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.OTCGap.getRoot().server.settings.username"]];
    return result;
}

*/


@end
