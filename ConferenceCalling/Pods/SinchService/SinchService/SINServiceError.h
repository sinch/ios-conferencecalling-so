#import <Foundation/Foundation.h>

extern NSString* const SINServiceErrorDomain;

typedef NS_ENUM(NSInteger, SINServiceError) {
  SINServiceErrorComponentNotAvailable = 1,
  SINServiceErrorUserIdNotAvailable
};

extern NSError* SINServiceComponentNotAvailableError();
extern NSError* SINServiceCreateError(SINServiceError code, NSString* reason);
