//
//  ConferenceViewController.m
//  ConferenceCalling
//
//  Created by christian jensen on 9/26/15.
//  Copyright © 2015 christian jensen. All rights reserved.
//

#import "ConferenceViewController.h"
#import "LoginViewController.h"
#import <SinchCallingUIKit/SinchCallingUIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ConferenceViewController ()

@end

@implementation ConferenceViewController
- (IBAction)CreateConference:(id)sender {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults stringForKey:@"conferenceId"] == nil)
    {
        NSString* conferenceId = [NSString stringWithFormat:@"%d", arc4random_uniform(9000000) + 1000000];
        ;
        [defaults setObject:[NSString stringWithFormat:@"%@%@", @"soapp://", conferenceId] forKey:@"conferenceURL"];
        [defaults setObject:conferenceId forKey:@"conferenceId"];
        [defaults synchronize];
        [self inviteFriends];
        self.invite.hidden = NO;
    }
    else
    {
        [[CallingManager sharedManager] callConference:[defaults stringForKey:@"conferenceId"]];
    }
}
- (IBAction)invite:(id)sender {
    [self inviteFriends];
}


-(void)inviteFriends{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* url = [defaults stringForKey:@"conferenceURL"];
    NSURL *appurl = [NSURL URLWithString:url];
    NSString *textToShare = [NSString stringWithFormat:@"Hey, So... whats up, join %@ here\n/%@", appurl, [defaults stringForKey:@"userName"]];
    NSArray *objectsToShare = @[textToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    activityVC.excludedActivityTypes = excludeActivities;
    [activityVC setCompletionWithItemsHandler:^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        [[CallingManager sharedManager] callConference:[defaults stringForKey:@"conferenceId"]];
    }];   [self presentViewController:activityVC animated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"conferenceId"] == nil){
        self.invite.hidden = YES;
    }
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)startClient {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [[CallingManager sharedManager] startClientWithKey:@"0457e812-dd79-4a43-85e8-3c6264c5512c" secret:@"IDFepS98ZUGDWOC65MqJ0Q==" userName:[defaults stringForKey:@"userName"] sandbox:NO launchOptions:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.callButton.layer.cornerRadius = 104;
    self.callButton.layer.borderWidth = 1;
    self.callButton.layer.borderColor = [UIColor whiteColor].CGColor;
}
-(void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults stringForKey:@"userName"] == nil)
    {
        [self performSegueWithIdentifier:@"login" sender:nil];
        
    }
    else
    {
        [self startClient];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"popOver"]) {
        UIViewController* popoverViewController = segue.destinationViewController;
        popoverViewController.modalPresentationStyle = UIModalPresentationPopover;
        popoverViewController.popoverPresentationController.delegate = self;
    }
    //popOver
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 
 */

@end
