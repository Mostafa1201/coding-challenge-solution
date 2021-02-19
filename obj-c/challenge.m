#import <Foundation/Foundation.h>
#import "InterviewChallengeUtilities.h"

@interface Challenge : NSObject
+ (nonnull NSString *)solution;
@end

@implementation Challenge
+ (nonnull NSString *)solution {
  NSDictionary<NSString *, User *> *users = [InterviewChallengeUtilities getUsers:@"../data/users.json"];
  NSArray<Event *> *events = [InterviewChallengeUtilities getEvents:@"../data/events.json"];
  return @"The solution is ___";
}
@end

int main(int argc, char **argv) {
  printf("%s\n", [[Challenge solution] UTF8String]);
  return 0;
}
