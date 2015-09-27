//
//  ConferenceViewController.h
//  ConferenceCalling
//
//  Created by christian jensen on 9/26/15.
//  Copyright © 2015 christian jensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConferenceViewController : UIViewController<UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *callButton;

@property (weak, nonatomic) IBOutlet UIButton *invite;
@end
