# SinchService 

SinchService is a supplementary component to the Sinch RTC SDK for iOS (http://www.sinch.com/ios/).

# Install via CocoaPods

Add to your `Podfile`:

    pod 'SinchService'
    

# Example Usage

     #import <Sinch/Sinch.h>
     #import <SinchService/SinchService.h>

     id config = [SinchService configWithApplicationKey:@"<APPLICATION KEY>"
                                      applicationSecret:@"<APPLICATION SECRET>"
                                        environmentHost:@"sandbox.sinch.com"];

     [config pushNotificationsWithEnvironment:SINAPSEnvironmentAutomatic];

     id<SINService> sinch = [SinchService serviceWithConfig:config];

     sinch.delegate = self;
     sinch.callClient.delegate = self;
     sinch.messageClient.delegate = self;

     [sinch logInUserWithId:@"<USER ID>"];

