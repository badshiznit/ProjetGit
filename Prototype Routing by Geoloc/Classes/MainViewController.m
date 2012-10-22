/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

//
//  MainViewController.h
//  Prototype Routing by Geoloc
//
//  Created by amadou diallo on 9/28/12.
//  Copyright amadou diallo 2012. All rights reserved.
//

#import "MainViewController.h"
#import "OTCGap.h"
#import "CallManager.h"
#import "RoutingMgr.h"

@implementation MainViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

/* Comment out the block below to over-ride */
/*
- (CDVCordovaView*) newCordovaViewWithFrame:(CGRect)bounds
{
    return[super newCordovaViewWithFrame:bounds];
}
*/

/* Comment out the block below to over-ride */
/*
#pragma CDVCommandDelegate implementation

- (id) getCommandInstance:(NSString*)className
{
	return [super getCommandInstance:className];
}

- (BOOL) execute:(CDVInvokedUrlCommand*)command
{
	return [super execute:command];
}

- (NSString*) pathForResource:(NSString*)resourcepath;
{
	return [super pathForResource:resourcepath];
}
 
- (void) registerPlugin:(CDVPlugin*)plugin withClassName:(NSString*)className
{
    return [super registerPlugin:plugin withClassName:className];
}
*/

#pragma UIWebDelegate implementation
/*
- (void) webViewDidFinishLoad:(UIWebView*) theWebView
{
    NSLog(@"UI webViewDidFinishLoad");
     // only valid if ___PROJECTNAME__-Info.plist specifies a protocol to handle
     if (self.invokeString)
     {
        // this is passed before the deviceready event is fired, so you can access it in js when you receive deviceready
        NSString* jsString = [NSString stringWithFormat:@"var invokeString = \"%@\";", self.invokeString];
        [theWebView stringByEvaluatingJavaScriptFromString:jsString];
     }
     
     // Black base color for background matches the native apps
     theWebView.backgroundColor = [UIColor blackColor];

	return [super webViewDidFinishLoad:theWebView];
} */

/* Comment out the block below to over-ride */
/*

- (void) webViewDidStartLoad:(UIWebView*)theWebView 
{
	return [super webViewDidStartLoad:theWebView];
}

- (void) webView:(UIWebView*)theWebView didFailLoadWithError:(NSError*)error 
{
	return [super webView:theWebView didFailLoadWithError:error];
}

- (BOOL) webView:(UIWebView*)theWebView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
	return [super webView:theWebView shouldStartLoadWithRequest:request navigationType:navigationType];
}
*/

#pragma mark - Fonctions utiles

- (NSDictionary*) deviceProperties
{
	UIDevice *device = [UIDevice currentDevice];
    NSMutableDictionary *devProps = [NSMutableDictionary dictionaryWithCapacity:4];
    [devProps setObject:[device model] forKey:@"platform"];
    [devProps setObject:[device systemVersion] forKey:@"version"];
    [devProps setObject:[device uniqueIdentifier] forKey:@"uuid"];
    [devProps setObject:[device name] forKey:@"name"];
	
    NSDictionary *devReturn = [NSDictionary dictionaryWithDictionary:devProps];
    return devReturn;
}

- (NSString*) getDeviceParamString
{
	UIDevice *device = [UIDevice currentDevice];
    
    NSString *devString = [NSString stringWithFormat:@"device_type=%@;", [device model]];
    devString = [devString stringByAppendingFormat:@"device_system_name=%@;",[device systemName]];
    devString = [devString stringByAppendingFormat:@"device_os=%@;", [device systemVersion]];
    
    return devString;
}

- (void)execGapCommand:(NSURL *)url theWebView:(UIWebView *)theWebView
{
    NSLog(@"Gap request with url : %@",url);
    if(_otcLibGapWrapper == nil)
        _otcLibGapWrapper  = [[PhoneGapWrapper alloc] initWithWebView:theWebView];
    
    InvokedUrlCommand* iuc = [InvokedUrlCommand newFromUrl:url];
    // Tell the JS code that we've gotten this command, and we're ready for another
    [theWebView stringByEvaluatingJavaScriptFromString:@"PhoneGap.queue.ready = true;"];
    
    NSString* fullMethodName = [[NSString alloc] initWithFormat:@"%@:withDict:", iuc.methodName];
    if(![iuc.className isEqualToString:@"DebugConsole"])
        NSLog(@"SELECTOOOOOOOOR : %@ added for Class : %@",fullMethodName,iuc.className);
    [_otcLibGapWrapper execute:iuc];
}


#pragma mark -- Fonctions utiles by Badshiznit

- (void) onPhoneGapInit
{
    NSLog(@"MainVC on Phone Gap init");
    NSString* otcUser = @"mcordebard";
    NSString* otcPass = @"123456";
    NSString* otcParams = [self getDeviceParamString];
    [[OTCGap getInstance] startOTCUserLogin:otcUser withPass:otcPass withDeviceParams:otcParams];
    NSLog(@"Main View controller : Login request sent - %@, %@: %@", otcUser, otcPass, otcParams);
}


- (void) loginCompleted:(BOOL) isSuccess
{
    self.isConnected = isSuccess;
    
    if(isSuccess)
    {
        NSLog(@"MainVC login succeeeeeed");
        
        [[CallManager mgr] subscribeToEvents];
        RoutingMgr *routingMgr = [RoutingMgr mgr];

        [routingMgr loadRoutingDatas];
    }
    else
        NSLog(@"MainVC login failed");
}


-(void) sendLogin:(NSString*) login AndPassword:(NSString*)password
{
    NSLog(@"Send Login...");
    if(!self.isConnected)
    {
        NSString* otcParams = [self getDeviceParamString];
        [[OTCGap getInstance] startOTCUserLogin:login withPass:password withDeviceParams:otcParams];
        NSLog(@"LoginHandler: Login request sent - %@, %@: %@", login, password, otcParams);
    }
}


#pragma mark - UIWebDelegate implementation

- (void) webViewDidStartLoad:(UIWebView*)theWebView
{
    NSLog(@"webViewDidStartLoad");
	return [super webViewDidStartLoad:theWebView];
}

- (void) webView:(UIWebView*)theWebView didFailLoadWithError:(NSError*)error
{
    NSLog(@"didFailLoadWithError");
	return [super webView:theWebView didFailLoadWithError:error];
}

- (BOOL) webView:(UIWebView*)theWebView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    NSLog(@"shouldStartLoadWithRequest with : %@",url.description);
    
    if ([[url scheme] isEqualToString:@"gap"]) //execute a gap command
    {
        NSLog(@"Exécution d'une commande GAP à travers l'URL : %@", url);
        [self execGapCommand:url theWebView:theWebView];
    }
    [theWebView stringByEvaluatingJavaScriptFromString:@"PhoneGap.queue.ready = true;"];
	return [super webView:theWebView shouldStartLoadWithRequest:request navigationType:navigationType];
}

- (void) webViewDidFinishLoad:(UIWebView*) theWebView
{
    NSLog(@"webViewDidFinishLoad");
    
    NSDictionary *deviceProperties = [ self deviceProperties];
    NSMutableString *result = [[NSMutableString alloc] initWithFormat:@"DeviceInfo = %@;", [deviceProperties JSONFragment]];
    NSLog(@"Device initialization: %@", result);
    
    [theWebView stringByEvaluatingJavaScriptFromString:result];
  
	
    return [super webViewDidFinishLoad:theWebView];
}



@end
