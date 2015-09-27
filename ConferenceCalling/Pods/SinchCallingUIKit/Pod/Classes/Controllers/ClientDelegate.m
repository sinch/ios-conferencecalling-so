//
//  ClientDelegate.m
//  SinchCallingUIKit
//
//  Created by christian jensen on 2/25/15.
//  Copyright (c) 2015 christian jensen. All rights reserved.
//

#import "ClientDelegate.h"
#import "ResourceLoader.h"
#import "CallingManager.h"
@implementation ClientDelegate
{

}

-(id<SINAudioController>)getAudio
{
    return [[CallingManager sharedManager] getAudio];
}

-(void)client:(id<SINCallClient>)client didReceiveIncomingCall:(id<SINCall>)call
{
   
       CallScreenViewController *vc = [[CallScreenViewController alloc] initWithNibName:@"CallScreenViewController" bundle:[ResourceLoader loadBundle]];
        vc.currentCall = call;
        [[CallingManager sharedManager] saveLastCall:call];
        call.delegate = vc;

        vc.audioController = [self getAudio];
        UIWindow* window  = [[[UIApplication sharedApplication] delegate] window];
        [[window rootViewController] presentViewController:vc animated:true completion:^{
            NSLog(@"presented");
        }];
//    }
}

-(SINLocalNotification *)client:(id<SINCallClient>)client localNotificationForIncomingCall:(id<SINCall>)call
{
    NSLog(@"did recieve local notification");
    
    [[CallingManager sharedManager] saveLastCall:call];
          SINLocalNotification *notification = [[SINLocalNotification alloc] init];
        notification.alertAction = @"Answer";
        notification.alertBody = [NSString stringWithFormat:@"Incoming call from %@", [call remoteUserId]];
    notification.soundName = @"incoming.wav";
    return notification;
}


- (NSString *)pathForSound:(NSString *)soundName {
    
    
    return [[[ResourceLoader loadBundle] resourcePath] stringByAppendingPathComponent:soundName];
}

@end
