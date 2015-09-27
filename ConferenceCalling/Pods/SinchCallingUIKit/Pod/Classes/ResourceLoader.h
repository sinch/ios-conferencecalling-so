//
//  ResourceLoader.h
//  Pods
//
//  Created by christian jensen on 6/29/15.
//
//

#import <Foundation/Foundation.h>
FOUNDATION_EXPORT NSString *const bundleName;

@interface ResourceLoader : NSObject
+(NSBundle*)loadBundle;

@end
