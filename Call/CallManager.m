//
//  CallManager.m
//  OpenTouch
//
//  Created by Cecile Talarmain on 13/02/12.
//  Copyright (c) 2012 Alcatel-lucent. All rights reserved.
//

#import "CallManager.h"

/*
#import "LogMgr.h"
#import "SipStackWrapper.h"
#import "Session.h"
#import "ConversationView.h"
#import "NotificationViewController.h"
#import "ContactMgr.h"
#import "Contact.h"
#import "MainView.h"
#import "AppDelegate_iPad.h"
#import "IDCardView.h"
#import "MeetingViewController.h"
#import "DicoMgr.h"
#import "ConferenceMgr.h"
#import "StringUtils.h"     // CTA CR crms00381054

// Maxime part
#import "IMSessionJSONHandler.h"
#import "IMView.h" */

NSString * const EVENT_COMMMG_OBJECT = @"communicationManager";
NSString * const EVENT_COMMMG_ON_CALLMEDIA_OPENED = @"onComMg_callMediaOpened";
NSString * const EVENT_COMMMG_ON_AUDIOMEDIA_INVITATION = @"onComMg_audioMediaInvitation"; // CTA CR crms00381054
NSString * const EVENT_COMMMG_ON_VIDEOMEDIA_INVITATION = @"onComMg_videoMediaInvitation"; // CTA CR crms00381054
NSString * const EVENT_COMMMG_ON_SIPSESSION_CONNECTED = @"onComMg_sipSessionConnected";
NSString * const EVENT_COMMMG_ON_UPDATE_MEDIA_STATE = @"onComMg_updateCallMediaState";
NSString * const EVENT_COMMMG_ON_UPDATE_MEDIA = @"onComMg_updateMedia";
NSString * const EVENT_COMMMG_ON_UPDATE_PARTICIPANT_INFO = @"onComMg_updateParticipantInfo";
NSString * const EVENT_COMMMG_ON_ADD_PARTICIPANT = @"onComMg_addParticipant";
NSString * const EVENT_COMMMG_ON_REMOVE_PARTICIPANT = @"onComMg_removeParticipant";
NSString * const EVENT_COMMMG_ON_CLOSE_COMMUNICATION = @"onComMg_closeCommunication"; // CTA CR crms00381054
NSString * const EVENT_COMMMG_ON_CLOSE_INVITATION = @"onComMg_closeInvitation";
NSString * const EVENT_COMMMG_ON_MEDIA_STATUS = @"onComMg_MediaStatus";
NSString * const EVENT_COMMMG_ON_DIALING_FAILURE = @"onComMg_dialingFailure";
NSString * const EVENT_COMMMG_ON_SIP_CALLID_LINKAGE = @"onComMg_sipCallIdLinkage"; // CTA CR crms00396311
// Maxime part
NSString * const EVENT_COM_IM_SESSION_CREATED = @"onComMg_IMSessionCreated";
NSString * const EVENT_COM_IM_MESSAGE = @"onComMg_IM";
NSString * const EVENT_SHOW_IMMESSAGE = @"showIMMessage";
NSString * const EVENT_SHOW_OLDIMMESSAGE = @"showOldIMMessage";
NSString * const EVENT_COM_IM_ALLMESSAGES = @"onComMg_AllIMs";
NSString * const EVENT_COM_IM_ALLPARTICIPANTS = @"onComMg_AllParticipants";
NSString * const EVENT_SHOW_IMMESSAGE_IN_CALL = @"showIMMessageInCall";

NSString * const EVENT_TOAST_DISPLAY = @"onToastDisplay";

@implementation ToastMessageData


- (ToastMessageData*) initWithUser:(NSDictionary*)_remoteUser andSessionId:(NSString*)_sessionId  andMessage:(NSString*)_messageToShow andTimeMessage:(NSString*)_timeMessage{
/*
    remoteUser = _remoteUser;
    sessionId = _sessionId;
    mediaType = _mediaType;
    messageToShow = _messageToShow;
    timeMessage = _timeMessage;
*/
    return self;
}

@end


@implementation CallManager

@synthesize otcGap;
@synthesize listOfSessions;
@synthesize lastView;

static CallManager* _mgr = nil;

+ (CallManager*) mgr {
    @synchronized(self)	{
		if (_mgr == nil)
			_mgr = [[CallManager alloc] init];

		return _mgr;
	}

	return nil;
}

// CTA CR crms00389103 +
- (id) init {
    self = [super init];

    if (self) {
        listOfSessions = [[NSMutableArray alloc] init];
        hasSubscribed = FALSE; // CTA 30/08/2012 : CR crms00393326 defense due to BAD_FRAMEWORK_SESSION_ID

    }
    return self;

}

- (void)subscribeToEvents {
    //[[LogMgr mgr] log:@"CallManager, in subscribeToEvents"];
     
        if (otcGap == nil) {
            otcGap = [OTCGap getInstance];
        }

        [otcGap subscribe:EVENT_COMMMG_OBJECT forEvent:EVENT_COMMMG_ON_CALLMEDIA_OPENED];
        [otcGap subscribe:EVENT_COMMMG_OBJECT forEvent:EVENT_COMMMG_ON_AUDIOMEDIA_INVITATION];
        [otcGap subscribe:EVENT_COMMMG_OBJECT forEvent:EVENT_COMMMG_ON_VIDEOMEDIA_INVITATION];
        [otcGap subscribe:EVENT_COMMMG_OBJECT forEvent:EVENT_COMMMG_ON_SIPSESSION_CONNECTED];
        [otcGap subscribe:EVENT_COMMMG_OBJECT forEvent:EVENT_COMMMG_ON_UPDATE_MEDIA_STATE];
        [otcGap subscribe:EVENT_COMMMG_OBJECT forEvent:EVENT_COMMMG_ON_UPDATE_PARTICIPANT_INFO];
        [otcGap subscribe:EVENT_COMMMG_OBJECT forEvent:EVENT_COMMMG_ON_ADD_PARTICIPANT];
        [otcGap subscribe:EVENT_COMMMG_OBJECT forEvent:EVENT_COMMMG_ON_REMOVE_PARTICIPANT];
        [otcGap subscribe:EVENT_COMMMG_OBJECT forEvent:EVENT_COMMMG_ON_CLOSE_COMMUNICATION];
        [otcGap subscribe:EVENT_COMMMG_OBJECT forEvent: EVENT_COMMMG_ON_CLOSE_INVITATION]; // CTA CR crms00381054
        [otcGap subscribe:EVENT_COMMMG_OBJECT forEvent:EVENT_COMMMG_ON_MEDIA_STATUS];
        [otcGap subscribe:EVENT_COMMMG_OBJECT forEvent:EVENT_COMMMG_ON_UPDATE_MEDIA];
   
        // Maxime part
        [[OTCGap getInstance] subscribe:EVENT_COMMMG_OBJECT forEvent:EVENT_COM_IM_SESSION_CREATED];
        [[OTCGap getInstance] subscribe:EVENT_COMMMG_OBJECT forEvent:EVENT_COM_IM_MESSAGE];
        [[OTCGap getInstance] subscribe:EVENT_COMMMG_OBJECT forEvent:EVENT_COM_IM_ALLMESSAGES];
        [[OTCGap getInstance] subscribe:EVENT_COMMMG_OBJECT forEvent:EVENT_COM_IM_ALLPARTICIPANTS];
    
        // CTA 08/06/2012 : CR crms00379123
        [otcGap subscribe:EVENT_COMMMG_OBJECT forEvent:EVENT_COMMMG_ON_DIALING_FAILURE];
        [otcGap subscribe:EVENT_COMMMG_OBJECT forEvent:EVENT_COMMMG_ON_SIP_CALLID_LINKAGE]; // CTA CR crms00396311
    
        hasSubscribed = TRUE; // CTA 30/08/2012 : CR crms00393326 defense due to BAD_FRAMEWORK_SESSION_ID
    

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCallMediaOpened:) name:EVENT_COMMMG_ON_CALLMEDIA_OPENED object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAudioMediaInvitation:) name:EVENT_COMMMG_ON_AUDIOMEDIA_INVITATION object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onVideoMediaInvitation:) name:EVENT_COMMMG_ON_VIDEOMEDIA_INVITATION object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSipSessionConnected:) name:EVENT_COMMMG_ON_SIPSESSION_CONNECTED object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUpdateMediaState:) name:EVENT_COMMMG_ON_UPDATE_MEDIA_STATE object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUpdateParticipantInfo:) name:EVENT_COMMMG_ON_UPDATE_PARTICIPANT_INFO object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAddParticipant:) name:EVENT_COMMMG_ON_ADD_PARTICIPANT object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRemoveParticipant:) name:EVENT_COMMMG_ON_REMOVE_PARTICIPANT object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCloseCommunication:) name:EVENT_COMMMG_ON_CLOSE_COMMUNICATION object:nil]; 

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCloseInvitation:) name:EVENT_COMMMG_ON_CLOSE_INVITATION object:nil]; // CTA CR crms00381054

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMediaStatus:) name:EVENT_COMMMG_ON_MEDIA_STATUS object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUpdateMedia:) name:EVENT_COMMMG_ON_UPDATE_MEDIA object:nil];

        // CTA 08/06/2012 : CR crms00379123
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDialingFailure:) name:EVENT_COMMMG_ON_DIALING_FAILURE object:nil];
        // CTA 17/09/2012 : CR crms00396311
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSipCallIdLinkage:) name:EVENT_COMMMG_ON_SIP_CALLID_LINKAGE object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(openedImCommunication:)
                                                     name:EVENT_COM_IM_SESSION_CREATED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onReceivingMessage:)
                                                     name:EVENT_COM_IM_MESSAGE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGettingAllMessages:) name:EVENT_COM_IM_ALLMESSAGES object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onGettingAllParticipants:)
                                                     name:EVENT_COM_IM_ALLPARTICIPANTS object:nil];
    
        // CTA CR crms00389512
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onConferenceLoaded:) name:EVENT_LOCAL_ONCONFERENCE_GET object:nil];

    
}
// CTA CR crms00389103 +

- (void)dealloc {
    [otcGap unsubscribe:EVENT_COMMMG_ON_CALLMEDIA_OPENED];
    [otcGap unsubscribe:EVENT_COMMMG_ON_AUDIOMEDIA_INVITATION];
    [otcGap unsubscribe:EVENT_COMMMG_ON_VIDEOMEDIA_INVITATION];
    [otcGap unsubscribe:EVENT_COMMMG_ON_SIPSESSION_CONNECTED];
    [otcGap unsubscribe:EVENT_COMMMG_ON_UPDATE_MEDIA_STATE];
    [otcGap unsubscribe:EVENT_COMMMG_ON_UPDATE_PARTICIPANT_INFO];
    [otcGap unsubscribe:EVENT_COMMMG_ON_ADD_PARTICIPANT];
    [otcGap unsubscribe:EVENT_COMMMG_ON_REMOVE_PARTICIPANT];
    [otcGap unsubscribe:EVENT_COMMMG_ON_CLOSE_COMMUNICATION];
    [otcGap unsubscribe:EVENT_COMMMG_ON_CLOSE_INVITATION];
    [otcGap unsubscribe:EVENT_COMMMG_ON_MEDIA_STATUS];
    [otcGap unsubscribe:EVENT_COMMMG_ON_UPDATE_MEDIA];
    [otcGap unsubscribe:EVENT_COMMMG_ON_SIP_CALLID_LINKAGE]; // CTA CR crms00396311
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
- (void) makeCallByPhone:(NSString *)phoneNumber andMediaType:(SessionMediaType)mediaType {
    if (hasSubscribed) { // CTA 30/08/2012 : CR crms00393326
        if (![self isThereAlreadyALocalCall]) {
            [[LogMgr mgr] log:@"makeCall, call a phone number"];
            [otcGap makeCallByPhone:phoneNumber andMediaType:mediaType];
        }
    }
}

- (void) makeContactCall:(BasicContact *)participant andMediaType:(SessionMediaType)mediaType {
    if (hasSubscribed) {// CTA 30/08/2012 : CR crms00393326
        if (![self isThereAlreadyALocalCall]) {
            [[LogMgr mgr] log:@"makeCall, call a contact, disableIdleTimer"];
            
            [UIApplication sharedApplication].idleTimerDisabled = YES;
            [UIApplication sharedApplication].idleTimerDisabled = NO;
            [UIApplication sharedApplication].idleTimerDisabled = YES;
            
            if ([participant isSpeedDial]) {
                [otcGap makeCallByPhone:[participant getPhone] andMediaType:mediaType];
                
            }
            else {
                [otcGap makeContactCall:participant andMediaType:mediaType];
            }
        }
    }
}
*/
// CTA CR crms00381054 +
- (void) answerCall:(NSString*)sessionId andSipSessionId:(long)sipSessionId {
    if (sessionId == nil) {
      //  SipGap* sipGap = [[SipGap alloc] init];
        //[sipGap AcceptCall:sipSessionId];
    }
    else if (hasSubscribed) { // CTA 30/08/2012 : CR crms00393326
       // [otcGap answerCall:sessionId];
    }
}


- (void) declineCall:(NSString*)sessionId andSipSessionId:(long)sipSessionId {

    if (sessionId == nil) {
        ///SipGap* sipGap = [[SipGap alloc] init];
       // [sipGap RejectCall:sipSessionId];
    }
    else if (hasSubscribed){ // CTA 30/08/2012 : CR crms00393326
        //[otcGap delineCall:sessionId];
    }
}

//DTMF
-(void) sendDTMF:(NSString*)_sessionId andSipSessionId:(long)_sipSessionId andValue:(NSString*)_selectedValue {
    if (_sessionId == nil) {
        //SipGap* sipGap = [[SipGap alloc] init];
        //[sipGap SendDTMF:_sipSessionId andDigit:[_selectedValue characterAtIndex:0]];
    }
    else if (hasSubscribed) { // CTA 30/08/2012 : CR crms00393326
   //     [otcGap sendDtmf:_sessionId andDigit:_selectedValue];
    }
}

// CTA CR crms00381054 -

-(void) onMiddlewareAVEvent:(NSNotification*)notification
{
    NSLog(@"onMiddlewareAVEvent received");
    
    //[[LogMgr mgr] log:@"onMiddlewareAVEvent received"];

    //av_callback_data* event = [notification object];

    // Send an event for the middleware
  //  NSString* oldSessionIdStr = (NSString*)[event.options valueForKey:@"old-session-id"];
    
   // long oldSessionId = [oldSessionIdStr longLongValue];

    if (hasSubscribed) { // CTA 30/08/2012 : CR crms00393326
      //  [otcGap publishLocalSipEvent:event.session_id andUser:event.remote_party andSignal:[self convertStateToString:event.event_type] andCallUUID:event.otc_call_id andMediaType:event.media_type andOldSessionId:oldSessionId andOtcUser:event.otc_user];
    }
}

- (void) releaseCall:(NSString*)sessionId andSipSessionId:(long)sipSessionId { // CTA CR crms00381054

//    [[LogMgr mgr] log:@"releaseCall before enableIdleTimer"];
    [UIApplication sharedApplication].idleTimerDisabled = NO; //GC: hack found on internet: seems to work better with forced transitions
    [UIApplication sharedApplication].idleTimerDisabled = YES;//GC: hack found on internet: seems to work better with forced transitions
    [UIApplication sharedApplication].idleTimerDisabled = NO;

    // CTA CR crms00381054 +
  //  Session* currentSession = nil;
    if (sessionId == nil) {
    //    SipGap* sipGap = [[SipGap alloc] init];
      //  [sipGap HangupCall:sipSessionId];
       // currentSession = [self getSessionBySipSessionId:sipSessionId];
   } 
    else if (hasSubscribed) { // CTA 30/08/2012 : CR crms00393326
        //currentSession = [self getSessionBySessionId:sessionId];
        //[otcGap releaseCall:sessionId];
    }
    // CTA CR crms00381054 -
//    if (currentSession != nil) {
  //      [currentSession setIsEstablished:NO];
    //}

}

- (void) setCallMute:(NSString*)sessionId andSipSessionId:(long)sipSessionId { // CTA CR crms00381054
    
    // CTA CR crms00381054 +
    //Session* currentSession = nil;
    if (sessionId == nil) {
      //  currentSession = [self getSessionBySipSessionId:sipSessionId];
    }
    // CTA CR crms00381240 +
    else {
        //currentSession = [self getSessionBySessionId:sessionId];
    }
    // CTA CR crms00381054 -
    /*
    if (currentSession != nil) {
        BOOL muted = [currentSession mute];
        // current session is muted, un mute it
        if (muted) {
            // CTA CR crms00381054 +
            if (sessionId == nil) {
                SipGap* sipGap = [[SipGap alloc] init];
                [sipGap Mute:sipSessionId andVideo:FALSE andMuted:FALSE];
            }
            else if (hasSubscribed) { // CTA 30/08/2012 : CR crms00393326
                [otcGap resumeCall:sessionId];
            }
            // CTA CR crms00381054 -
        }
        else {
            // CTA CR crms00381054 +
            if (sessionId == nil) {
                SipGap* sipGap = [[SipGap alloc] init];
                [sipGap Mute:sipSessionId andVideo:FALSE andMuted:TRUE];
            }
            else if (hasSubscribed) { // CTA 30/08/2012 : CR crms00393326
                [otcGap muteCall:sessionId];
            }
            // CTA CR crms00381054 -
        }
        [currentSession setMute:!muted];
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_CHECK_MUTE_ICON object:[NSNumber numberWithBool:!muted]];
    }*/
    // CTA CR crms00381240 -
}

-(void)onCallMediaOpened :(NSNotification*)notification {

    NSLog(@"onCallMediaOpened received");
//    [[LogMgr mgr]log:[NSString stringWithFormat:@"Event onCallMediaOpened : %@", notification]];

    // Extraction of participant info and session id from notification received
    NSDictionary*   dict = [notification object];
    
    NSString*       sessionId = (NSString*)[dict valueForKey:@"callId"];
    NSDictionary*   participant = (NSDictionary*)[dict valueForKey:@"remotePartyInfo"];

    NSString*       localSipStr = (NSString*)[dict valueForKey:@"localSipUsed"];
    BOOL            localSipUsed = [localSipStr boolValue];

    NSString*       callState = (NSString*)[dict valueForKey:@"callState"];

    // Check if session with sessionId exist, if yes open com card
    // else creates it
    /*
    Session* callSession = nil;
    int indexOfSession = [self findSession:sessionId];
    if (indexOfSession == -1) {
        [[LogMgr mgr]log:[NSString stringWithFormat:@"Session %@ not found, creates it", sessionId]];
       // create new session
        callSession = [self createSession:sessionId];
        [listOfSessions addObject:callSession];
        indexOfSession = [listOfSessions count] -1;
    }
    else {
        // register participant in session
        callSession = [listOfSessions objectAtIndex:indexOfSession];
    }
    // Registering participant information in the created session
    [callSession setSessionId:sessionId];
    [callSession setMedia:S_MT_AUDIO]; //may be video to treat
    [callSession addParticipant:participant];
    [callSession setLocalSipUsed:localSipUsed];*/
    
    // search if a conference is associated to this call
    // CTA enhancement on conference + : display in toast and com card the owner of the conference
    /*
    if (callSession != nil && [callSession associatedConference] == nil) {
        Conference* conf = [[ConferenceMgr mgr] getMeetingById:sessionId];
        if (conf != nil && callSession != nil) {
            [callSession setAssociatedConference:conf];
        }
    }
    // CTA enhancement on conference -
    
    // CTA CR crms00381240
    [callSession changeState:callState];

    if (localSipUsed) {

        // CTA CR crms00373315 +
        // remove icon to route calls to iPad
       [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_DIVERT_CALL_NOMOREAVAILABLE object:nil];
        // CTA CR crms00373315 -

    }
    // CTA CR crms00373315 +
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_DIVERT_CALL_AVAILABLE object:nil];

    } 
    // CTA CR crms00373315 -

    if ([callState isEqualToString:@"Conversation"]) {
        [callSession setEstablished:YES];
    } else {
        [callSession setEstablished:NO];
    }

    // Udpate session if found
    [listOfSessions replaceObjectAtIndex:indexOfSession withObject:callSession];

    // Open com card if session is local only
    if (localSipUsed && ![callSession isCallViewOpened]) {
        [ConversationView showCallView:participant andSessionId:sessionId andSipSessionId:[callSession getSipSessionId] andLaunchFrom:nil];
            [[LogMgr mgr] log:@"in CallManager - onCallMediaOpened,  setCallViewIsOpened:YES"];
    }
    [callSession setSessionStartTime:time(0)];
    [callSession registerToastIdentifier:nil];
}

// CTA CR crms00381054 +
-(void)treatInvitationEvent:(NSDictionary*)invitationDatas andMediaType:(SessionMediaType)mediaType {
    
    NSString* sessionId = (NSString*)[invitationDatas valueForKey:@"callId"];
    NSDictionary* callerParticipant = (NSDictionary*)[invitationDatas valueForKey:@"callerInfo"];
    NSDictionary* capabilities = (NSDictionary*)[invitationDatas valueForKey:@"capabilities"];
    NSString* ableToSwitch = (NSString*)[capabilities valueForKey:@"ableToDivert_to_Device"];
    // DEV DOESNT WORK
    NSString* ableToSwitchToVoiceMail = (NSString*)[capabilities valueForKey:@"ableToDivert_to_VoiceMail"];
    // scc crms00373913
    NSArray* otherParticipant = (NSArray*)[invitationDatas valueForKey:@"participants"];
    
    // CTA CR crms00381054 +
    NSString* sipStrSessionId = [invitationDatas valueForKey:@"sipSessionId"];
    long      sipSessionId = [sipStrSessionId longLongValue];
    BOOL      toastAlreadyExists = false;
    
    // CTA CR crms00381054 -
    
    // If a session with this sessionId does not exist, raise a toast for incoming call
    Session* session = nil;
    int indexOfSession = -1;
    if ([StringUtils GetStringNotEmptyOrNilValue:sessionId] != nil) {
        indexOfSession = [self findSession:sessionId];
    }
    else {
        sessionId = nil; // CTA CR crms00381054
    }
    // If not found Searching by SIP session Id
    // CTA CR crms00381054 +
    if (indexOfSession == -1) {
        indexOfSession = [self findSessionBySipSessionId:sipSessionId];
    }
    // CTA CR crms00381054 -
    
    // we create a session only if ther eis not already a local call
    if (indexOfSession == -1) {
        if (![self isThereAlreadyALocalCall]) {
            // Create a session for this incoming call
            session =  [self createSession:sessionId];
            [session registerSipSessionId:sipSessionId]; // CTA CR crms00381054
            [session setMedia:mediaType];
            session.state = S_STATE_RINGING;
            [listOfSessions addObject:session];
        }
    }
    // update existing session
    else {
        session = [listOfSessions  objectAtIndex:indexOfSession];
        [session setSessionId:sessionId];
        [session setMedia:mediaType];
        session.state = S_STATE_RINGING;
    }
    
    if (session != nil)
    {
        // CTA CR crms00381054 +
        NSMutableArray* callerArray = [[NSMutableArray alloc] init];
        [callerArray addObject:callerParticipant];
        if (otherParticipant != nil) {
            for (int i=0; i<[otherParticipant count]; i++) {
                [callerArray addObject:[otherParticipant objectAtIndex:i]];
            }
        }
        [session updateParticipants:callerArray];
        // CTA CR crms00381054 -
    
        if ([StringUtils GetStringNotEmptyOrNilValue:[session getToastIdentifier]] != nil) {
            toastAlreadyExists = true;
        }
        
        if ([ableToSwitch boolValue]) {
            // extract the list of devices
            NSArray* devicesDict = (NSArray*)[capabilities valueForKey:@"devicesInService"];
            for (int i=0; i<[devicesDict count]; i++) {
                NSDictionary* currentDevice = (NSDictionary*)[devicesDict objectAtIndex:i];
                NSString* deviceId = (NSString*)[currentDevice valueForKey:@"id"];
                NSString* type = (NSString*)[currentDevice valueForKey:@"type"]; // CTA CR crms00374089
                NSString* subtype = (NSString*)[currentDevice valueForKey:@"subType"];
                // CTA 03/05/2012 : CR crms373319
                if (![deviceId isEqualToString:[[[ContactMgr mgr] getUserLogged] localDevice]]) {
                    [session storeDevice:deviceId forType:type andSubType:subtype]; // CTA CR crms00374089
                }
            }
        }
        
		[session setAbleToVoiceMail:[ableToSwitchToVoiceMail boolValue]];
        
        if (!toastAlreadyExists) {
            // Show toast
            // scc crms00379334
            [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_TOAST_DISPLAY object:nil];
            NSString* eventKey = [NotificationViewController showIncomingCall:callerParticipant andOtherParticipant:otherParticipant andCapabilities:capabilities andSessionId:sessionId andSipSessionId:sipSessionId andMediaType:mediaType];
            [session registerToastIdentifier:eventKey];
        }
        // Local call alreayd exist, chck if it is an update of th same call
        // If yes, update toast
        else {
            NSLog(@"need to update existing toast");
            [NotificationViewController updateIncomingCall:callerParticipant andOtherParticipant:otherParticipant andCapabilities:capabilities andSessionId:sessionId andSipSessionId:sipSessionId andMediaType:mediaType andEventViewKey:[session getToastIdentifier]];
            
        }
    } */

}

// CTA CR crms00396311 +
-(void)onSipCallIdLinkage:(NSNotification*)notification {
    /*
    NSDictionary* dict = [notification object];

    NSString* sessionId = (NSString*)[dict valueForKey:@"callId"];
    NSString* sipStrSessionId = [dict valueForKey:@"sipSessionId"];
    long      sipSessionId = [sipStrSessionId longLongValue];
    
    Session* currentSession = nil;
    
    // try to find a session with sessionId
    int indexOfSession = [self findSession:sessionId];
    
    // then find a session by sipSessionId
    int indexOfSipSession = [self findSessionBySipSessionId:sipSessionId];
    
    // we need to merge bth sessions
    if (indexOfSession !=-1 && indexOfSipSession != -1 &&
        indexOfSession != indexOfSipSession) {
        currentSession = [listOfSessions objectAtIndex:indexOfSession];
        Session* sipSession = [listOfSessions objectAtIndex:indexOfSipSession];
        
        NSString* toastSipId = [StringUtils GetStringNotEmptyOrNilValue:[sipSession getToastIdentifier]];
        if (toastSipId != nil) {
            [currentSession setToastIdentifier:toastSipId];
        }
            
        [listOfSessions removeObjectAtIndex:indexOfSipSession];
    }
    
    // search if a conference is associated to this call
    Conference* conf = [[ConferenceMgr mgr] getMeetingById:sessionId];
    if (conf != nil && currentSession != nil) {
        [currentSession setAssociatedConference:conf];
    } */
}
// CTA CR crms00396311 -

-(void)onVideoMediaInvitation :(NSNotification*)notification {
    
  //  [[LogMgr mgr]log:[NSString stringWithFormat:@"Event onVideoMediaInvitation : %@", notification]];

    NSDictionary* dict = [notification object];
    
//    [self treatInvitationEvent:dict andMediaType:S_MT_AUDIOVIDEO];
}

// DEV updated with JSON objects
-(void)onAudioMediaInvitation :(NSNotification*)notification {
    
    
    /***NSDate *now = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy hh:mm:ss.sss"];
    NSString *trace = @"|CTA ******* in CallManger reception of event incoming call at : |";
    NSTimeInterval interval = [now timeIntervalSince1970];
    NSLog([trace stringByAppendingString:[NSString stringWithFormat:@"%.3f", interval]]);***/
    
//    [[LogMgr mgr]log:[NSString stringWithFormat:@"Event onAudioMediaInvitation : %@", notification]];

    NSDictionary* dict = [notification object];
    
  //  [self treatInvitationEvent:dict andMediaType:S_MT_AUDIO];
}
// CTA CR crms00381054 -

- (void)onSipSessionConnected: (NSNotification*)notification {

        NSLog(@"onSipSessionConnected received");
    /*
    // extraction of datas from notification
    NSDictionary* dictMedias = [notification object];

    NSString* sessionId = [dictMedias valueForKey:@"callId"];

    NSString* sipStrSessionId = [dictMedias valueForKey:@"sipSessionId"];
    long sipSessionId = [sipStrSessionId longLongValue];

    NSDictionary* medias = [dictMedias valueForKey:@"mediasStatus"];

    // Search of session in listOfSession to update the media involved
    int indexOfSession = [self findSession:sessionId];
    if (indexOfSession != -1) {
        Session* currentSession = [listOfSessions objectAtIndex:indexOfSession];
        [currentSession registerSipSessionId:sipSessionId];
        NSString *mediaOn = [medias valueForKey:@"im"];
        BOOL isMediaOn = [mediaOn intValue];
        if (isMediaOn) {
            [currentSession setMedia:S_MT_IM];
        }
        mediaOn = [medias valueForKey:@"audio"];
        isMediaOn = [mediaOn intValue];
        if (isMediaOn) {
            [currentSession setMedia:S_MT_AUDIO];
        }
        mediaOn = [medias valueForKey:@"video"];
        isMediaOn = [mediaOn intValue];
        if (isMediaOn) {
            [currentSession setMedia:S_MT_AUDIOVIDEO];

            [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_VIDEO_IN_SESSION object:nil];

            // Add of video on the call
            [[LogMgr mgr] log:[NSString stringWithFormat:@"Start video for session %@", sessionId]];
            SipGap *sip = [[SipGap alloc] init];
            [sip StartVideo:[currentSession getSipSessionId]];
            [sip UpdateVideoOrientation:[currentSession getSipSessionId]];

        }
        [currentSession setEstablished:YES];
        
        // CTA 14/08/2012 CR crms00390595 +
        [currentSession changeState:@"Conversation"];
        [currentSession setSessionStartTime:time(0)];
        // CTA 14/08/2012 CR crms00390595 -

        [listOfSessions replaceObjectAtIndex:indexOfSession withObject:currentSession];
    }
*/
}

-(void)onUpdateMediaState :(NSNotification*)notification {/*
    [[LogMgr mgr]log:[NSString stringWithFormat:@"Event onUpdateMediaState : %@", notification]];

    NSDictionary* dict = [notification object];

    NSString*     sessionId = (NSString*)[dict valueForKey:@"callId"];
    NSString*     state = (NSString*)[dict valueForKey:@"callState"];
    NSString*     localSipStrUsed = (NSString*)[dict valueForKey:@"localSipUsed"];
    BOOL          isLocalSipUsed  = [localSipStrUsed boolValue];

    // find session and update it with data received
    int indexOfSession = [self findSession:sessionId];
    if (indexOfSession != -1) {
        Session* currentSession = [listOfSessions objectAtIndex:indexOfSession];

        // CTA CR crms00381240 +
        if ([state isEqualToString:@"Conversation"]) {
            [currentSession setEstablished:YES];
        } else {
            [currentSession setEstablished:NO];
        }
        [currentSession setLocalSipUsed:isLocalSipUsed];
        [currentSession changeState:state];
        // CTA CR crms00381240 -

        if (isLocalSipUsed) {
            // CTA CR crms00373315
            [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_DIVERT_CALL_NOMOREAVAILABLE object:nil];
        }
        // CTA CR crms00373315 +
        else {
            [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_DIVERT_CALL_AVAILABLE object:nil];
        }
        // CTA CR crms00373315 -

    } */

}

-(void)onUpdateMedia :(NSNotification*)notification { /*
    [[LogMgr mgr]log:[NSString stringWithFormat:@"Event onUpdateMedia : %@", notification]];

    // extraction of datas from notification
    NSDictionary* dictMedias = [notification object];

    NSString* sessionId       = (NSString*)[dictMedias valueForKey:@"callId"] ;
    NSString* localSipStrUsed = (NSString*)[dictMedias valueForKey:@"localSipUsed"];
    BOOL  localSipUsed        = [localSipStrUsed boolValue];

    NSDictionary* medias = (NSDictionary*)[dictMedias valueForKey:@"mediasStatus"];
    Session* currentSession = nil;

    // Search of session in listOfSession to update the media involved
    int indexOfSession = [self findSession:sessionId];
    // No session, create it - CTA CR crms00384882
    if (indexOfSession == -1) {
        currentSession = [self createSession:sessionId];
        [listOfSessions addObject:currentSession];
        indexOfSession = [listOfSessions count] - 1;
    }
    else {
        currentSession = [listOfSessions objectAtIndex:indexOfSession];
    }
    BOOL hasMultipleMedias = [currentSession hasMedia:S_MT_IM] && ([currentSession hasMedia:S_MT_AUDIOVIDEO] || [currentSession hasMedia:S_MT_AUDIO]);
    
    // extraction of all the media : audio, video, im
    NSString *mediaOn = [medias valueForKey:@"im"];
    BOOL isMediaOn = [mediaOn intValue];
    if (isMediaOn) {
        [currentSession setMedia:S_MT_IM];
    }
    else {
        [currentSession removeMedia:S_MT_IM];
        if ([currentSession isImViewOpened] && hasMultipleMedias) {
            [currentSession setImViewOpened:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_CLOSE_IM_WINDOW object:sessionId];
        }
    }
    mediaOn = [medias valueForKey:@"audio"];
    isMediaOn = [mediaOn intValue];
    if (isMediaOn) {
        [currentSession setMedia:S_MT_AUDIO];
    }
    else {
        [currentSession removeMedia:S_MT_AUDIO];
    }
    mediaOn = [medias valueForKey:@"video"];
    isMediaOn = [mediaOn intValue];
    if (isMediaOn) {
        [currentSession setMedia:S_MT_AUDIOVIDEO];
    }
    else {
        [currentSession removeMedia:S_MT_AUDIOVIDEO];
    }
    
    // CTA crms00396311 +
    if ( (![currentSession hasMedia:S_MT_AUDIO] && ![currentSession hasMedia:S_MT_AUDIOVIDEO]) &&
        [currentSession isCallViewOpened]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_CLOSE_CONVERSATION_WINDOW object:sessionId];
       
    }
    // CTA CR crms00396311 -
    
    [currentSession setLocalSipUsed:localSipUsed];
    // CTA CR crms00373315 +
    if (localSipUsed) {
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_DIVERT_CALL_NOMOREAVAILABLE object:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_DIVERT_CALL_AVAILABLE object:nil];
    }
    // CTA CR crms00373315 -
    
    [listOfSessions replaceObjectAtIndex:indexOfSession withObject:currentSession]; */
}

// CTA 08/06/2012 : CR crms00379123 +
-(void)onDialingFailure :(NSNotification*)notification { 
    //[[LogMgr mgr]log:[NSString stringWithFormat:@"Event onDialingFailure"]];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:EVENT_CLOSE_CONVERSATION_WINDOW object:EVENT_COMMMG_ON_DIALING_FAILURE];
    //GC+
    NSString* message=@"wrong number";
    NSDictionary* dictMedias = [notification object];
    if (dictMedias != nil){
        NSString* calleeNumber  = (NSString*)[dictMedias valueForKey:@"calleeNumber"] ;
      //  NSString* sformat=[[DicoMgr mgr] getLocalization:@"CALLMGR.DIALING.FAILURE"];
        //message=[NSString stringWithFormat:sformat,calleeNumber];//TODO add in dictionnary
    }
    UIAlertView *messagebox = [[UIAlertView alloc] initWithTitle:@"OpenTouch"
                                                         message:message
                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [messagebox show];

}
// CTA 08/06/2012 : CR crms00379123 -

-(void)onUpdateParticipantInfo :(NSNotification*)notification {
   // [[LogMgr mgr]log:[NSString stringWithFormat:@"Event onUpdateParticipantInfo : %@", notification]];

    // reception of an update participant message
}

-(void)onAddParticipant :(NSNotification*)notification {
   // [[LogMgr mgr]log:[NSString stringWithFormat:@"Event onAddParticipant : %@", notification]];

    // Extraction of participant info and session id from notification received
    
/*    // CTA CR crms00381054 +
    NSDictionary* dict = [notification object];
    
    NSString* sessionId = (NSString*)[dict valueForKey:@"callId"];
    NSDictionary* participant = (NSDictionary*)[dict valueForKey:@"newParticipantInfo"];
    NSString* sipStrSessionId = [dict valueForKey:@"sipSessionId"];
    long      sipSessionId = [sipStrSessionId longLongValue];

    // Creation of the session if it does not exist
    Session* mySession = nil;
    int indexOfSession = [self findSession:sessionId];
    
    if (indexOfSession == -1) {
        indexOfSession = [self findSessionBySipSessionId:sipSessionId];
    }
    // CTA CR crms00381054 -

    if (indexOfSession != -1) {
        mySession = [listOfSessions objectAtIndex:indexOfSession];
        if (mySession != nil) {
             // Registering participant information in the created session
            [mySession addParticipant:participant];

            // Udpate session if found
            [listOfSessions replaceObjectAtIndex:indexOfSession withObject:mySession];

            if ([mySession isImViewOpened]) {
                [self isRequestingAllParticipants:sessionId];
            }

        }
    } else {
        // we get our sessionId from the event
        mySession = [self createSession:sessionId];
        [mySession addParticipant:participant];
        [listOfSessions addObject:mySession];
   } */


}


-(void)onCloseCommunication :(NSNotification*)notification {
    
            NSLog(@"onCloseCommunication received");
    /*
    [[LogMgr mgr]log:[NSString stringWithFormat:@"Event onCloseCommunication : %@", notification]];

    // Extraction of sessionId
    NSDictionary* dict = [notification object];
    NSString* sessionId = [dict valueForKey:@"callId"];
    
    BOOL needToUpdateMuteIcon = FALSE; // CTA CR crms00384306

    // Find the session, remove it from the listOfSessions
    int indexOfSession = [self findSession:sessionId];
    if (indexOfSession != -1) {

        [[LogMgr mgr]log:[NSString stringWithFormat:@"Event onCloseCommunication : removing session %@", sessionId]];

        Session* currentSession = [listOfSessions objectAtIndex:indexOfSession];
        
        // CTA CR crms00384306 +
        if ([currentSession isLocalCall]) {
            needToUpdateMuteIcon = true;
        }
        // CTA CR crms00384306 -
        
        if ([currentSession isImViewOpened]) {
            [currentSession setImViewOpened:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_CLOSE_IM_WINDOW object:sessionId];
        }
        if ([currentSession isCallViewOpened]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_CLOSE_CONVERSATION_WINDOW object:sessionId];
        }
        // close toast
        if (![[currentSession getToastIdentifier] isEqualToString:@""]) {
            [NotificationViewController dismissEvent:[currentSession getToastIdentifier]];
        }
        // Push an event to remove the fact that this call could be taken on iPad
        if (![currentSession isLocalSipUsed]) /* &&
            ([currentSession hasMedia:S_MT_AUDIO] || [currentSession hasMedia:S_MT_AUDIOVIDEO])){
            // CTA CR crms00373315
            [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_DIVERT_DELETECALL object:sessionId];
        }
        [listOfSessions removeObjectAtIndex:indexOfSession];
        
        // CTA CR crms00384306
        if (needToUpdateMuteIcon) {
            [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_CHECK_MUTE_ICON object:nil];
        } 
    }

    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    MainViewController *mainViewController = [appDelegate mainViewController];
    MeetingViewController *mvc=mainViewController.mainView.meetingViewController;
    //if you start a presentation, it starts/stop an IMsession, this should not enable the idletimer since presentation is still running
    [[LogMgr mgr] log:[NSString stringWithFormat:@"in CallManager.onCloseCommunication, [mvc isPresentationActive]= %@",[mvc isPresentationActive] ? @"True" : @"False"]];
    [[LogMgr mgr] log:[NSString stringWithFormat:@"in Callmanager.onCloseCommunication, [self isThereAlreadyALocalCall]= %@", [self isThereAlreadyALocalCall] ? @"True" : @"False"]];
    if ((! [mvc isPresentationActive] ) && (![self isThereAlreadyALocalCall])){
        [[LogMgr mgr] log:@"onCloseCommunication before enableIdleTimer"];
        [UIApplication sharedApplication].idleTimerDisabled = NO;//hack found on internet: seems to work better with forced transitions
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        [UIApplication sharedApplication].idleTimerDisabled = NO;
    }

    // push an event to display route to ipad icon if needed
    // CTA CR crms00373315 +
    if (![self isThereAlreadyALocalCall]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_DIVERT_CALL_AVAILABLE object:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_DIVERT_CALL_NOMOREAVAILABLE object:nil];

    }  */
    // CTA CR crms00373315 -

}

-(void)onCloseInvitation :(NSNotification*)notification {
   // [[LogMgr mgr]log:[NSString stringWithFormat:@"Event onCloseInvitation : %@", notification]];

    // CTA CR crms00381054 +

    // Extraction of participant info and session id from notification received
    NSDictionary*   dict = [notification object];
    
    // Extraction of sessionId
    NSString*       sessionId = (NSString*)[dict valueForKey:@"callId"];

    // Extraction of Sip Session Id
    NSString* sipStrSessionId = [dict valueForKey:@"sipSessionId"];
    long sipSessionId = [sipStrSessionId longLongValue];
    
    // Find the session
}

-(void)onMediaStatus :(NSNotification*)notification {
    //[[LogMgr mgr]log:[NSString stringWithFormat:@"Event onMediaStatus : %@", notification]];
}

// CTA CR crms00381054 +
-(int) findSessionBySipSessionId:(long)sipSessionId {
    
   
    return -1;
}
// CTA CR crms00381054 -

-(int) findSession:(NSString*)sessionId {

    return -1;
}



/*-(void) playSound {
    NSString *path  = [NSString stringWithFormat:@"%@/ringtone.mp3", [[NSBundle mainBundle] resourcePath]];

    if ([[NSFileManager defaultManager] fileExistsAtPath : path])
    {
        NSURL *pathURL = [NSURL fileURLWithPath : path];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
        AudioServicesPlaySystemSound(audioEffect);
    }
    else
    {
        NSLog(@"error, file not found: %@", path);
    }
}

-(void) stopSound{
    // stop playing ring tone
    AudioServicesDisposeSystemSoundID(audioEffect);
}
*/



- (void) addParticipantToCall:(NSString*)callId participantToAdd:(NSDictionary*)participant {
 
}


//- (void) addContactToCall:(NSString*)callId contactToAdd:(BasicContact*)contact {
    
//}

- (void) addPhoneNumberToCall:(NSString*)callId phoneNumberToAdd:(NSString *)phoneNumber {
    if (hasSubscribed) { // CTA 30/08/2012 : CR crms00393326
        //BasicContact* basicContact = [[ContactMgr mgr] findOrCreateContactFromPhoneNumber:phoneNumber];
        //[otcGap addContactParticipantToCall:basicContact toCallId:callId];
    }
}

- (void) updateVideoLayout:(NSString*)sessionId andSipSessionId:(long)sipSessionId{ // CTA CR crms00381054

//    Session* session = [self getSessionBySessionId:sessionId];
    // CTA CR crms00381054 +
    //if (session == nil) {
  //      session = [self getSessionBySipSessionId:sipSessionId];
    }
    // CTA CR crms00381054 -
    //if (session != nil && [session isCallViewOpened]) {
      //  SipGap *sip = [[SipGap alloc] init];
       // [sip UpdateVideoOrientation:[session getSipSessionId]];



- (void) removeParticipantFromCall:(NSString*)sessionId andParticipant:(NSString*)participantUserId {
    if (hasSubscribed) { // CTA 30/08/2012 : CR crms00393326
       // [otcGap removeParticipantFromSession:sessionId withParticipant:participantUserId];
    }
}

// actions that can be performed from UI on meetings
- (void) startPresentation:(NSString*)conferenceId {
    if (hasSubscribed) { // CTA 30/08/2012 : CR crms00393326
        //GC : disable idleTimer
        //[[LogMgr mgr] log:@"in CallManager.startPresentation, disableIdleTimer"];
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        [UIApplication sharedApplication].idleTimerDisabled = NO;
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        
        //[otcGap initPresentation:conferenceId];
    }
}

- (void) joinConference:(NSString*)conferenceId {
    if (hasSubscribed) { // CTA 30/08/2012 : CR crms00393326
    //    [otcGap joinConference:conferenceId];
    }
}

- (void) switchDevice:(NSString*)sessionId {/*
    if (hasSubscribed) { // CTA 30/08/2012 : CR crms00393326
        Session* sessionToSwitch = [self getSessionBySessionId:sessionId];
        if (sessionToSwitch != nil) {
            // CTA 03/05/2012 : CR crms373319 +
            Contact*  userLogged = [[ContactMgr mgr] getUserLogged];
            NSString* switchTo = [userLogged localDevice];
            // CTA 03/05/2012 : CR crms373319 -
            [otcGap switchDevice:sessionId andToDevice:switchTo];
        }
    }*/
}
/*
- (void) routeToDevice:(NSString*)sessionId withDevice:(NSString*) deviceId {
    if (hasSubscribed) { // CTA 30/08/2012 : CR crms00393326
        Session* sessionToRoute = [self getSessionBySessionId:sessionId];
        if (sessionToRoute != nil) {
            // NSString* switchFrom = [sessionToRoute getDeviceInUse]; // CTA to be completed
            NSString* switchTo = deviceId;
            [otcGap redirect:sessionId withDevice:switchTo];
        }
    }
}

- (void) routeToVoiceMail:(NSString*)sessionId {
    if (hasSubscribed) { // CTA 30/08/2012 : CR crms00393326
        Session* sessionToRoute = [self getSessionBySessionId:sessionId];
        if (sessionToRoute != nil) {
            [otcGap redirectToVoiceMail:sessionId];
        }
    }
}

- (BOOL) isThereAlreadyALocalCall {
    for (Session* currentSession in listOfSessions) {
        if ([currentSession isLocalCall]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL) isThereAlreadyAVideoLocalCall {
    for (Session* currentSession in listOfSessions) {
        if (([currentSession isLocalCall]) && ([currentSession hasVideo])) {
            return YES;
        }
    }
    return NO;
}


- (NSString*)convertStateToString:(MWCallStatusEvent_t)state {
    switch(state) {
        case INCOMING :
            return @"incoming";
            break;

        case OUTGOING_CALLBACK :
            return @"outgoing_callback";
            break;

        case INPROGRESS :
            return @"inprogress";
            break;

        case RINGING :
            return @"ringing";
            break;

        case CONNECTED :
            return @"connected";
            break;

        case DISCONNECTING :
            return @"disconnecting";
            break;

        case DISCONNECTED :
            return @"disconnected";
            break;

        case LOCAL_HOLD_OK :
            return @"local_hold_ok";
            break;

        case LOCAL_HOLD_FAILED :
            return @"local_hold_failed";
            break;

        case LOCAL_RESUME_OK :
            return @"local_resume_ok";
            break;

        case LOCAL_RESUME_FAILED :
            return @"local_resume_failed";
            break;

        case REMOTE_HOLD :
            return @"remote_hold";
            break;

        case REMOTE_RESUME :
            return @"remote_resume";
            break;

        case UPDATING :
            return @"updating";
            break;

        case VIDEO_UPGRADE :
            return @"video_upgrade";
            break;

        case VIDEO_DOWNGRADE :
            return @"video_downgrage";
            break;

//        case REMOTE_REFER :
//            return @"remote_refer";
//            break;

        case SESSION_CHANGED :
            return @"session_changed";
            break;

        default :
            return @"unkonwn";
            break;

    }
}

// CTA CR crms00371723 +
-(void) restartVideoIfVideoCallInProgress {
    for (Session* currentSession in listOfSessions) {
        if ([currentSession isLocalCall] && [currentSession hasVideo]) {
            SipGap *sip = [[SipGap alloc] init];
            [sip RestartVideoPreview];
            [sip UpdateVideoOrientation:[currentSession getSipSessionId]];
       }
    }
}
// CTA CR crms00371723 -

// CTA CR crms00389512 +
-(void) onConferenceLoaded:(NSNotification*) notif {
    Conference *selectedConf = nil;
    for (Session* currentSession in listOfSessions) {
        selectedConf = [[ConferenceMgr mgr] getMeetingById:[currentSession sessionId]];
        if (selectedConf != nil) {
            [currentSession setIsPlannedConf:YES];
        }
    }
}*/
// CTA CR crms00389512 -

@end 
