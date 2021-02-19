//
//  InterviewChallengeUtilities.h
//  interview-keyboard-challenge
//

#import <Foundation/Foundation.h>

@interface InterviewChallengeUtilities : NSObject
+ (NSDictionary *)getUsers:(NSString *)filePath;
+ (NSArray *)getEvents:(NSString *)filePath;
@end

@interface User : NSObject
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *device;

+ (instancetype)userWithDictionary:(NSDictionary *)jsonDictionary;
@end

@interface Event : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger timestamp;
@property (nonatomic, copy) NSString *user_id;

+ (instancetype)eventWithDictionary:(NSDictionary *)jsonDictionary;
@end
