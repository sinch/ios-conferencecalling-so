//
//  LoginViewController.m
//  ConferenceCalling
//
//  Created by christian jensen on 9/26/15.
//  Copyright © 2015 christian jensen. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
- (IBAction)login:(id)sender {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.userName.text forKey:@"userName"];
    [defaults synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)viewDidAppear:(BOOL)animated
{
    [self.userName becomeFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.userName.layer.cornerRadius=8.0f;
    self.userName.layer.masksToBounds=YES;
    self.userName.layer.borderColor=[[UIColor whiteColor]CGColor];
    self.userName.layer.borderWidth= 1.0f;
    self.userName.delegate = self;
    // Do any additional setup after loading the view.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self login:nil];
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
