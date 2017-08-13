//
//  ONEPersistentTool.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/13.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeItem+CoreDataClass.h"
#import "CommentItem+CoreDataClass.h"

@class NSPersistentContainer;

@interface ONEPersistentTool : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;

+ (instancetype)sharedInstance;

- (void)saveContext;


/* ********************************************* HomeItem实体的增删改查 ********************************************* */
- (void)insertHomeItemWithTypeName:(NSString *)typeName itemID:(NSString *)itemID isLike:(BOOL)isLike;

- (HomeItem *)fetchHomeItemWithTypeName:(NSString *)typeName itemID:(NSString *)itemID;

- (void)updateHomeItemWithTypeName:(NSString *)typeName itemID:(NSString *)itemID isLike:(BOOL)isLike;

/* ********************************************* CommentItem实体的增删改查 ********************************************* */
- (void)insertCommentItemWithTypeName:(NSString *)typeName commentID:(NSString *)commentID isLike:(BOOL)isLike;

- (CommentItem *)fetchCommentItemWithTypeName:(NSString *)typeName commentID:(NSString *)commentID;

- (void)updateCommentItemWithType:(NSString *)typeName commentID:(NSString *)commentID isLike:(BOOL)isLike;
@end
