# Building a one button app for conference calling
I have been thinking about building a one button app for some time that does something stupid just like YO! And when we released conferee calling I thought of the awesome video conferencing sites that are just an URL and wanted to make that kind of app for Conference calling on Mobile. So here come SO!, its like YO! but for having out in a audio conference. You create the conference once and then send a link to your friends for this app they the built in Share activity in iOS. And whenever you feel like it you can open SO! and see if anyone is having out there (remember the telephone hotlines back in the 80s)
![](images/product_small.png), as always the full source code is available on github, click to [download](https://github.com/sinch/ios-conferencecalling-so)

## Setup 
If you haven’t already, go to [sinch.com](https://www.sinch.com/signup) and sign up for free. Then, go to your dashboard and go to your apps. Create a new sandbox app. Take note of your app’s unique key and secret. 

Open up XCode and create a new project using the Single-View Application template. 
Set up CocoaPods to work with our app, in this tutorial we are going to use a small UIFramework I made. Open the directory for the project you just created in Terminal and type:
```
pod init
```

Then open the file named Podfile and add the following line:

```
pod 'SinchCallingUIKit',:git=>'https://github.com/spacedsweden/SinchCallingUIKit.git'
```

After saving the file, install the pod by typing:

```
pod install
```

After this, you’ll see an XCode workspace file with the extension “**.xcworkspace**”. We’ll need to work out of that file from now on instead of our project file. That way, all of our app’s components will work together.

sinch ui view controller


## Story board UI
Create a story board with three view controllers, one Conference Controller, a LoginController. 
### ConferenceController
in the conference controller Create two buttons, one is for calling and one invite button.  
### LoginController
Add a TextField and a Button to login

Set the ConferenceController scene as the initial ViewController if its not already set.
Create a Modal segue to the login controller from the conference controller and call it login.

## First use Scenario
Create new ViewController and name it **ConferenceController** and assign it to the ConferenceController view in the story board. The next thing you want to do is to check if this is a first use scenario, we are going to use NSUserDefault to store such info. 

```objectivec
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
```
So if the user has not entered his name, we will show the login screen. Now, create a LoginController and assign it to the LoginView in the story board. Create an action for the loginbutton and and an outlet for the username text field. 

**LoginViewController.h**
```objectivec
@property (weak, nonatomic) IBOutlet UITextField *userName;
- (IBAction)login:(id)sender;
```
When the user clicks, we are going to set the username
**LoginViewController.m**
```objectivec
- (IBAction)login:(id)sender {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.userName.text forKey:@"userName"];
    [defaults synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}
```
Sweet, so now we are logged in and as soon as the controller dismisses it self it will call the viewDidAppear and call `startClient`, lets implement that in  **ConferenceController.m** 
```objectivec
-(void)startClient {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [[CallingManager sharedManager] startClientWithKey:yourkey secret:yoursecret userName:[defaults stringForKey:@"userName"] sandbox:NO launchOptions:nil];
}
```
This simply call the shared manager, and starts the client with the username you saved to NSUserDefaults. Now its time to implement conference calling feature, in your **Main.storyboard** create IBActions to the Call and Invite button. Since this a almost a one button app, lets hide the invite people button in view did load first. 
```objectivec
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"conferenceId"] == nil){
        self.invite.hidden = YES;
    }
    // Do any additional setup after loading the view.
}
```

## Call button
Ok, making a call is actually a one liner, but in this method we are going to take care of a bunch of stuff since its a one button app. In your action for the call add the following to create a conference id, store it to defaults etc.

```objectivec
- (IBAction)CreateConference:(id)sender {
  //First time use
  if ([defaults stringForKey:@"conferenceId"] == nil)
    {
    ///create a random number that will be the conferenceId
        NSString* conferenceId = [NSString stringWithFormat:@"%d", arc4random_uniform(9000000) + 1000000];
        ;
        //set the share URL that will be sent to friends (make sure you create your own prefix, more about that later in the tutorial)
        [defaults setObject:[NSString stringWithFormat:@"%@%@", @"soapp://", conferenceId] forKey:@"conferenceURL"];
        [defaults setObject:conferenceId forKey:@"conferenceId"];
        [defaults synchronize];
        //invite your friends and make the invite more people visible
        [self inviteFriends];
        self.invite.hidden = NO;
    }
    else
    {//Not first use, just connect to the conference
        [[CallingManager sharedManager] callConference:[defaults stringForKey:@"conferenceId"]];
    }
}
```

## Invite friends
iOS as you probably know have this wonderful share functionality that enables any to be part of the share menu and apps like this to enable super easy sharing to any social network that is available on that phone. To read more about [here](http://www.codingexplorer.com/add-sharing-to-your-app-via-uiactivityviewcontroller/). 

```objectivec
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
```

What we do in the code above is to create a special link and composing a person message that can be sent to anyone, this link is something your can register in your info.plist and whenever someone clicks the link they will either be sent to the app or the App Store to download your app. And when they return from sharing we are connecting the user to the conference. 

## Listen to URLTypes
Open the info tab of you target to edit the plist 
![](images/project.png)
and add an URLtype to match the one you choose above. In my case its soap:// now when ever someone clicks on an link witt soap:// the iPhone will try and find an app that listen to this.

## Reacting to a clicked URLTypes
Now when we have a url type defined we can react to when someone clicks on link instead of just launching the app  **AppDelegate.m** add the below:

```objectivc
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSString *text = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[CallingManager sharedManager] callConference:text];
    return YES;
}
```
Pretty straight forward, look hat the host passed to the app and connect to the conference immediately. 

Thats it, you can also download the app on itunes to try it out here


