/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 * 
 * Copyright (c) 2005-2010, Nitobi Software Inc.
 * Copyright (c) 2010, IBM Corporation
 */

#import <UIKit/UIKit.h>
#import "JSON.h"

#import "DebugConsole.h"

@class InvokedUrlCommand;

@interface PhoneGapWrapper : NSObject <UIWebViewDelegate>
{
	
	UIWebView *webView;
	
	NSURLConnection *conn;		        // added by urbian
	NSMutableData *receivedData;		// added by urbian	

    NSMutableDictionary *commandObjects;
    NSURL *invokedURL;
    
    __unsafe_unretained id <UIWebViewDelegate> delegate;
	
}

@property (nonatomic, retain) NSMutableDictionary *commandObjects;
@property (nonatomic, retain) NSURL *invokedURL;
@property (nonatomic, retain) UIWebView *webView;

@property (assign) id delegate;

- (id)initWithWebView:(UIWebView *)myWebView;

- (id) getCommandInstance:(NSString*)className;
- (void) javascriptAlert:(NSString*)text;
- (BOOL) execute:(InvokedUrlCommand*)command;
- (void)applicationWillTerminate:(UIApplication *)application;
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;


@end
