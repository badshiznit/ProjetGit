//
//  OTCGap.h
//  OpenTouch
//
//  Created by David Beilis on 11-10-05.
//  Copyright (c) 2011 Alcatel-lucent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhoneGapCommand.h"
#import "SBJSON.h"
//#import "SipGap.h"
//#import "Session.h"

@interface OTCGap : PhoneGapCommand {
    
    NSDictionary    *eventData;
    BOOL            isGAPStarted;
    NSString        *userLogin;
 //   SipGap * sipGap;
}



@property (nonatomic, retain) NSDictionary  * eventData;
@property (nonatomic, retain) NSString      * userLogin;
//@property(nonatomic, retain) SipGap *sipGap;

+ (OTCGap *) getInstance;


- (void) startOTCUserLogin:(NSString *)otcUser withPass:(NSString *)otcPass
        withDeviceParams:(NSString *) otcDeviceParams;

- (void) subscribe:(NSString *)object forEvent:(NSString *) eventName;

- (void) unsubscribe:(NSString *) eventName;

- (void) dispatcherEvent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

/***
 
 Routing Profiles Management
 
 ***/
-(void) getProfiles;
-(void) applyRoutingProfileRoutes:(NSString *) profileID;
-(void) createRoutingProfile:(NSString *) profileName 
           presentationRoute:(NSString *) setPresentationRoute 
                forwardRoute:(NSString *) setForwardRoute 
             currentDeviceId:(NSString *) setCurrentDeviceId;
-(void) setRoutingProfile:(NSString *) profileId
               profilName:(NSString *) setProfileName 
        presentationRoute:(NSString *) setPresentationRoute 
             forwardRoute:(NSString *) setForwardRoute 
          currentDeviceId:(NSString *) setCurrentDeviceId;

-(void) getRoutingState;
-(void) setRoutingState:(NSString*)_presentationString setForwardRoute:(NSString*)_forwardRoute currentDeviceID:(NSString*)_currentDeviceId;
-(void) deleteProfile:(NSString *)profileId;

// get RequestId
- (NSString *) getRequestId;

/*

//**************************************************
// Communication Manager integration
//***********************
// Called from IOS for telephony actions
//***********************
- (void) publishLocalSipEvent:(long)session_id andUser:(NSString*)otc_user andSignal:(NSString*)event_type andCallUUID:(NSString*)callUUID andMediaType:(int)mediaType  andOldSessionId:(long)oldSessionId;
- (void) sendSipRegisteredEvent;

- (void) makeCall:(NSString*)userId andLogin:(NSString*)login 
          andMail:(NSString*)mail andPhoneNumber:(NSString*)phone
            andLastName:(NSString*)lastname
                andFirstName:(NSString*)firstname 
           andImg:(NSString*)imgSrc 
                        andMediaType:(SessionMediaType)mediaType;
- (void) makeCallByPhone:(NSString*)phoneNumber 
            andMediaType:(SessionMediaType)mediaType;
- (void) answerCall:(NSString*)sessionId;
- (void) delineCall:(NSString*)sessionId;
- (void) releaseCall:(NSString*)sessionId;

- (void) muteCall:(NSString*)sessionId;
- (void) resumeCall:(NSString*)sessionId;

- (void) sendDtmf:(NSString*)sessionId andDigit:(NSString*)digit;

- (void) addParticipantToCall:(NSString*)callId andUserId:(NSString*)userId andLogin:(NSString*)login andMail:(NSString*)mail andPhoneNumber:(NSString*)phone andLastName:(NSString*)lastname andFirstName:(NSString*)firstname andImgName:(NSString*)imgSrc;

// Actions linked to meeting cards
- (void) joinConference:(NSString*)conferenceId;

- (void) switchDevice:(NSString*)sessionId andToDevice:(NSString*)switchTo;
- (void) redirect:(NSString*)sessionId withDevice:(NSString*)switchTo;
- (void) redirectToVoiceMail:(NSString*)sessionId;

// creation JSON with only keys not empty
- (NSString*) buildStringJSonWithoutKeyEmpty:(NSString*)userId andLogin:(NSString*)login andMail:(NSString*)mail andPhoneNumber:(NSString*)phone andLastName:(NSString*)lastname andFirstName:(NSString*)firstname andImgName:(NSString*)imgSrc;
- (NSString*) BuildKeyNotEmpty:(NSString*)stringEnter andkey:(NSString*)key andValue:(NSString*)value andValueIsTab:(BOOL)isValueIsTab;


// Called from middleware for telephony actions
//***********************
- (void) MakeAudioCall:(NSDictionary*)param1 withDict:(NSDictionary*)remoteDatas;
- (void) MakeVideoCall:(NSDictionary*)param1 withDict:(NSDictionary*)remoteDatas;
- (void) AcceptCall:(NSDictionary*)param1 withDict:(NSDictionary*)sessionId;
- (void) RejectCall:(NSDictionary*)param1 withDict:(NSDictionary*)sessionId;
- (void) ReferToAudio:(NSDictionary*)param1 withDict:(NSDictionary*)referDatas;
- (void) ReferToVideo:(NSDictionary*)param1 withDict:(NSDictionary*)referDatas;
- (void) HangupCall :(NSDictionary*)param1 withDict:(NSDictionary*)sessionId;
- (void) HoldCall:(NSDictionary*)param1 withDict:(NSDictionary*)sessionId;
- (void) ResumeCall:(NSDictionary*)param1 withDict:(NSDictionary*)sessionId;
- (void) SendDTMF :(NSDictionary*)param1 withDict:(NSDictionary*)dtmfDatas;
- (void) Mute :(NSDictionary*)param1 withDict:(NSDictionary*)muteDatas;

*/

// Get the currently logged in user's ACS username
- (NSString*) getCurrentUserId;

@end

