//
//  ResourceLoader.m
//  Pods
//
//  Created by christian jensen on 6/29/15.
//
//

#import "ResourceLoader.h"
NSString *const bundleName = @"SinchCallingUIKit";
@implementation ResourceLoader
+(NSBundle *)loadBundle
{
    NSString *bundlePath             = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    return bundle;
}


@end
