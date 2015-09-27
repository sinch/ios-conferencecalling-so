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
        NSString *textToShare = @"Hey join me for a quick conference!";
        NSString* conferenceId = [NSString stringWithFormat:@"%d", arc4random_uniform(900000) + 100000];
        
        NSString* url = [NSString stringWithFormat:@"%@%@", @"so://", conferenceId];
    }
    
    NSURL *appurl = [NSURL URLWithString:url];
    
    NSArray *objectsToShare = @[textToShare, appurl];
    
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
        NSLog(@"completed: %@, \n%d, \n%@, \n%@,", activityType, completed, returnedItems, activityError);
        [[CallingManager sharedManager] callConference:conferenceId];
    }];
    [self presentViewController:activityVC animated:YES completion:nil];
   

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)startClient {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
     [[CallingManager sharedManager] startClientWithKey:@"key" secret:@"secret" userName:[defaults stringForKey:@"userName"] sandbox:NO launchOptions:nil];
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
