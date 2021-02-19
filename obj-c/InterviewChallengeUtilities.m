//
//  InterviewChallengeUtilities.m
//  interview-keyboard-challenge
//

#import "InterviewChallengeUtilities.h"

@implementation InterviewChallengeUtilities
+ (NSDictionary *)getUsers:(NSString *)filePath{
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSDictionary *users = json[@"users"];
    
    NSMutableDictionary *usersDictionary = [NSMutableDictionary dictionaryWithCapacity:users.count];
    [users enumerateKeysAndObjectsUsingBlock:^(NSString *user_id, NSDictionary *userDictionary, BOOL *stop) {
        usersDictionary[user_id] = [User userWithDictionary:userDictionary];
    }];
    
    return [usersDictionary copy];
}

+ (NSArray *)getEvents:(NSString *)filePath{
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSArray *events = json[@"events"];
    
    NSMutableArray *eventsArray = [NSMutableArray arrayWithCapacity:events.count];
    [events enumerateObjectsUsingBlock:^(NSDictionary *eventDictionary, NSUInteger idx, BOOL *stop) {
        [eventsArray addObject:[Event eventWithDictionary:eventDictionary]];
    }];
    
    return [eventsArray copy];
}

@end

@implementation User
- (instancetype)initWithDictionary:(NSDictionary *)jsonDictionary
{
    self = [super init];
    if (self) {
        _age = [jsonDictionary[@"age"] integerValue];
        _gender = jsonDictionary[@"gender"];
        _device = jsonDictionary[@"device"];
    }
    return self;
}

+ (instancetype)userWithDictionary:(NSDictionary *)jsonDictionary
{
    return [[self alloc]initWithDictionary:jsonDictionary];
}
@end

@implementation Event
- (instancetype)initWithDictionary:(NSDictionary *)jsonDictionary
{
    self = [super init];
    if (self) {
        _name = jsonDictionary[@"name"];
        _timestamp = [jsonDictionary[@"timestamp"] integerValue];
        _user_id = jsonDictionary[@"user_id"];
    }
    return self;
}

+ (instancetype)eventWithDictionary:(NSDictionary *)jsonDictionary
{
    return [[self alloc]initWithDictionary:jsonDictionary];
}
@end