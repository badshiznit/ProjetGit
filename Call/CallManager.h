//
//  CallManager.h
//  OpenTouch
//
//  Created by Jean-Christophe Ferelloc on 13/02/12.
//  Copyright (c) 2012 Alcatel-lucent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTCGap.h"
//#import "IMSessionModelClass.h"
//#import <AudioToolbox/AudioToolbox.h>
#import "OTCGap.h"
//#import "Contact.h"
//#import "Session.h"
//#import "IAudioVideoServiceAgent.h"

extern NSString * const EVENT_COM_IM_MESSAGE;
extern NSString * const EVENT_SHOW_IMMESSAGE;
extern NSString * const EVENT_SHOW_OLDIMMESSAGE;
extern NSString * const EVENT_COM_IM_ALLPARTICIPANTS;
extern NSString * const EVENT_SHOW_IMMESSAGE_IN_CALL;
extern NSString * const EVENT_TOAST_DISPLAY;

extern NSString * const EVENT_COMMMG_ON_DIALING_FAILURE;

@interface ToastMessageData : NSObject {
@private
    NSDictionary *remoteUser;
    NSString *sessionId;
   // SessionMediaType mediaType;
    NSString *messageToShow;
    NSString *timeMessage;
}

@property(nonatomic,retain) NSDictionary *remoteUser;
@property(nonatomic,retain) NSString *sessionId;
//@property(nonatomic,assign) SessionMediaType mediaType;
@property(nonatomic,retain) NSString *messageToShow;
@property(nonatomic,retain) NSString *timeMessage;
- (ToastMessageData*) initWithUser:(NSDictionary*)_remoteUser andSessionId:(NSString*)_sessionId
                       // andMediaType:(SessionMediaType)_mediaType
                        andMessage:(NSString*)_messageToShow
                        andTimeMessage:(NSString*)_timeMessage;

@end




@interface CallManager : NSObject {
    OTCGap          *otcGap;
    NSMutableArray  *listOfSessions;
    
    BOOL            hasSubscribed; // CTA 30/08/2012 : CR crms00393326 defense due to BAD_FRAMEWORK_SESSION_ID
}

@property(nonatomic, retain) OTCGap* otcGap;
@property(nonatomic,retain) UIView *lastView;
@property(nonatomic, retain) NSMutableArray* listOfSessions;

+ (CallManager*) mgr;

- (void)subscribeToEvents; // CTA CR crms00389103

// global data
//- (NSString*)convertStateToString:(MWCallStatusEvent_t)state;

// actions that can be performed from UI on call
//- (void) makeCallByPhone:(NSString *)phoneNumber andMediaType:(SessionMediaType)mediaType;
//- (void) makeContactCall:(BasicContact*)participant andMediaType:(SessionMediaType)mediaType;
- (void) answerCall:(NSString*)sessionId andSipSessionId:(long)sipSessionId;    // CTA CR crms00381054
- (void) declineCall:(NSString*)sessionId andSipSessionId:(long)sipSessionId;   // CTA CR crms00381054
- (void) releaseCall:(NSString*)sessionId andSipSessionId:(long)sipSessionId;   // CTA CR crms00381054
- (void) setCallMute:(NSString*)sessionId andSipSessionId:(long)sipSessionId;   // CTA CR crms00381240     // CTA CR crms00381054
- (void) addParticipantToCall:(NSString*)callId participantToAdd:(NSDictionary*)participant;
//- (void) addContactToCall:(NSString*)callId contactToAdd:(BasicContact*)contact;
- (void) addPhoneNumberToCall:(NSString*)callId phoneNumberToAdd:(NSString *)phoneNumber;
- (void) switchDevice:(NSString*)sessionId;
- (void) routeToDevice:(NSString*)sessionId withDevice:(NSString*) deviceId;
- (void) routeToVoiceMail:(NSString*)sessionId;
- (void) updateVideoLayout:(NSString*)sessionId  andSipSessionId:(long)sipSessionId;     // CTA CR crms00381054
- (void) removeParticipantFromCall:(NSString*)sessionId andParticipant:(NSString*)participantUserId;

// actions that can be performed from UI on meetings
- (void) startPresentation:(NSString*)conferenceId;
- (void) joinConference:(NSString*)conferenceId;

// Management of session
-(int) findSession:(NSString*)sessionId;
-(int) findSessionBySipSessionId:(long)sipSessionId; // CTA CR crms00381054
//-(Session *) getSessionBySessionId:(NSString*)sessionId;
////-(Session*) createSession:(NSString*)sessionId;
//-(Session*) createAndRegisterSession:(NSString*)sessionId andMediaType:(SessionMediaType)mediaType;
- (void) setImViewOpened:(BOOL)opened forSession:(NSString*)sessionId;
- (BOOL) isThereAlreadyALocalCall;
- (BOOL) isThereAlreadyAVideoLocalCall;

// Notifications received from middleware
-(void)onCallMediaOpened :(NSNotification*)notification;
-(void)onAudioMediaInvitation:(NSNotification*)notification;
-(void)onVideoMediaInvitation:(NSNotification*)notification;
-(void)onUpdateMediaState:(NSNotification*)notification;
-(void)onUpdateParticipantInfo:(NSNotification*)notification;
-(void)onAddParticipant:(NSNotification*)notification;
-(void)onRemoveParticipant:(NSNotification*)notification;
-(void)onCloseCommunication:(NSNotification*)notification;
-(void)onCloseInvitation:(NSNotification*)notification;
-(void)onMediaStatus:(NSNotification*)notification;
-(void)onUpdateMedia :(NSNotification*)notification;
-(void)onSipSessionConnected: (NSNotification*)notification;
-(void)onDialingFailure :(NSNotification*)notification;
//-(void)treatInvitationEvent:(NSDictionary*)invitationDatas andMediaType:(SessionMediaType)mediaType;     // CTA CR crms00389627

// actions that can be performed from UI on IM sessions
- (void)isClosingIMCommunication:(NSString*)sessionIdToClose;
- (void)isSendingMessage :(NSString *) _lastMessage andSessionId:(NSString*)sessionId;
- (void)isRequestingAllIMMessages:(NSString*)sessionId;
- (void)onGettingAllMessages:(NSNotification *) notification;

- (void)startIMSession:(NSString*)_participantUserId
            withConfId:(NSString*)confId
         andLaunchFrom:(UIView *)_lastView;

- (void)startIMSessionMultipleUsers:(NSArray*)participantsUserId
                         withConfId:(NSString *)confId
                      andLaunchFrom:(UIView *)_lastView;

- (void)openedImCommunication :(NSNotification *) notification;
- (void)onReceivingMessage :(NSNotification *) notification;


- (void)addParticipantToSession:(NSString *)contactId andSessionId:(NSString *)sessionId;
- (void)addParticipantToIMSession:(NSString *)contactId andSessionId:(NSString *)sessionId;

- (void)isRequestingAllParticipants:(NSString*)sessionId;
- (void)onGettingAllParticipants:(NSNotification*) notification;

-(void) onMiddlewareAVEvent:(NSNotification*)notification;

-(void) sendDTMF:(NSString*)_sessionId andSipSessionId:(long)_dipSessionId andValue:(NSString*)_selectedValue;     // CTA CR crms00381054

-(void) restartVideoIfVideoCallInProgress; // CTA CR crms00371723

// CTA CR crms00389512  
-(void) onConferenceLoaded:(NSNotification*) notif;

// CTA CR crms00396311
-(void) onSipCallIdLinkage:(NSNotification*)notification;

@end
