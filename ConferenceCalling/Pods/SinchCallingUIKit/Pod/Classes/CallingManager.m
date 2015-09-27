//
//  CallingManager.m
//  SinchCallingUIKit
//
//  Created by christian jensen on 2/24/15.
//  Copyright (c) 2015 christian jensen. All rights reserved.
//

#import "CallingManager.h"
#import <Sinch/Sinch.h>
#import "ClientDelegate.h"
#import "CallScreenViewController.h"
#import "ResourceLoader.h"

@interface CallingManager() <SINServiceDelegate>
{
    id<SINService> service;
    id<SINCall> currentCall;
    id<SINCallClientDelegate> callClientDelegate;
}

@end

@implementation CallingManager
+ (CallingManager*)sharedManager {
    static CallingManager *sharedManagerInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManagerInstance = [[self alloc] init];
        
        //        sharedManagerInstance.logLevel = SINLogSeverityCritical;
    });
    return sharedManagerInstance;
}

-(void)showCallController
{
    CallScreenViewController *vc = [[CallScreenViewController alloc] initWithNibName:@"CallScreenViewController" bundle:[ResourceLoader loadBundle]];
    currentCall.delegate = vc;
    
    vc.currentCall = currentCall;
    vc.audioController = [service audioController];

    UIWindow* window  = [[[UIApplication sharedApplication] delegate] window];
    [[window rootViewController] presentViewController:vc animated:true completion:^{
        NSLog(@"presented");
    }];
    
    
}

-(NSString*)lastIncomingPhoneCall;
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:@"sin_lastCall"];
}
-(void)saveLastCall:(id<SINCall>)call
{

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* stringData= call.remoteUserId;
    [defaults setValue:stringData  forKey:@"sin_lastCall"];
    [defaults synchronize];
    
    
}
-(void)callUser:(NSString*)userName
{
    currentCall = [[service callClient] callUserWithId:userName];
    [self saveLastCall:currentCall];
    [self showCallController];
}
-(id<SINAudioController>)getAudio
{
    return [service audioController];
}
-(void)callNumber:(NSString *)phoneNumber
{
    currentCall = [[service callClient] callPhoneNumber:phoneNumber];
    [self saveLastCall:currentCall];
    [self showCallController];
    
}

-(void)callConference:(NSString *)conferenceId
{
    currentCall = [[service callClient] callConferenceWithId:conferenceId];
    [self saveLastCall:currentCall];
    [self showCallController];
}

- (void)service:(id<SINService>)service didFailWithError:(NSError *)error
{
    NSLog(@"service did fail %@", error);
}
-(void)onClientDidStart:(id<SINClient>)client{
    self.isStarted = YES;
}
- (void)service:(id<SINService>)service
     logMessage:(NSString *)message
           area:(NSString *)area
       severity:(SINLogSeverity)severity
      timestamp:(NSDate *)timestamp;
{
    if (self.debugLog || severity == SINLogSeverityCritical)
        NSLog(@"%@", message);
}

/// public Methods
-(void)startClientWithKey:(NSString*)appKey secret:(NSString*)secret userName:(NSString*)userName sandbox:(bool)sandbox launchOptions:(NSDictionary*)launchOptions
{
    if (self.isStarted)
        return;
    NSString* url = sandbox ? @"sandbox.sinch.com" : @"clientapi.sinch.com";
    id config = [[SinchService configWithApplicationKey:appKey
                                      applicationSecret:secret
                                        environmentHost:url]
                 pushNotificationsWithEnvironment:SINAPSEnvironmentAutomatic];
    service = [SinchService serviceWithConfig:config];
    service.delegate = self;
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(onClientDidStart:) name:SINClientDidStartNotification object:nil];
    callClientDelegate= [[ClientDelegate alloc] init];
    service.callClient.delegate = callClientDelegate;
    [service logInUserWithId:userName];
    [service.push registerUserNotificationSettings];

    
}


@end
