//
//  URLParser.h
//  ios-app
//
//  Created by Shannon Phu on 8/31/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLParser : NSObject

+ (NSString *)URLForPostID:(int)ID;
+ (NSString *)URLForRecentPosts;
+ (NSString *)URLForPostWithTag:(NSString *)tagSlug;
+ (NSString *)URLForCategory:(NSString *)categorySlug;
+ (NSString *)URLForFeaturedPosts;
+ (NSString *)URLForSearchTerm:(NSString *)query;
+ (NSString *)URLForPostsWithAuthorID:(int)ID;
+ (NSString *)URLForPostsInYear:(int)year;
+ (NSString *)URLForPostsInMonth:(int)month andYear:(int)year;
+ (NSString *)URLForIndexPosts;
+ (NSString *)URLForIndexNavigation;
+ (NSString *)URLForQuery:(NSString *)OLD_URL WithCountLimit:(int)count;
+ (NSString *)URLForQuery:(NSString *)OLD_URL WithOrdering:(NSString *)orderParam;

@end
