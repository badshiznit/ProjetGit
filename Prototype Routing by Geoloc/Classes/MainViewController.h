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


#import "PhoneGapWrapper.h"
#import "JSON.h"
#import "InvokedUrlCommand.h"

#ifdef CORDOVA_FRAMEWORK
    #import <Cordova/CDVViewController.h>
#else
    #import "CDVViewController.h"
#endif

@interface MainViewController : CDVViewController
{
    
}

@property (retain, nonatomic) PhoneGapWrapper* otcLibGapWrapper;
//@property(retain,nonatomic) id<LoginViewcontrollerDelegate> delegate;
@property(nonatomic,assign) BOOL isConnected;


- (void) onPhoneGapInit;
- (void) loginCompleted:(BOOL) isSuccess;
-(void) sendLogin:(NSString*) login AndPassword:(NSString*)password;

@end
