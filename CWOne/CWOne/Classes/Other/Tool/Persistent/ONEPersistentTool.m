//
//  ONEPersistentTool.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/13.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEPersistentTool.h"
#import <CoreData/CoreData.h>


static ONEPersistentTool *_instance;
static NSString *const homeItemEntityName = @"HomeItem";
static NSString *const commentItemEntityName = @"CommentItem";

@implementation ONEPersistentTool

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (NSPersistentContainer *)persistentContainer {
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"ONEPersistent"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

#pragma mark - 公有方法
- (void)insertHomeItemWithTypeName:(NSString *)typeName itemID:(NSString *)itemID isLike:(BOOL)isLike {
    HomeItem *homeItem = [NSEntityDescription insertNewObjectForEntityForName:homeItemEntityName inManagedObjectContext:self.persistentContainer.viewContext];
    homeItem.typeName = typeName;
    homeItem.itemId = itemID;
    homeItem.isLike = isLike;
    
    [self saveContext];
}

- (HomeItem *)fetchHomeItemWithTypeName:(NSString *)typeName itemID:(NSString *)itemID {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:homeItemEntityName];
    [request setPredicate:[NSPredicate predicateWithFormat:@"typeName == %@ AND itemId == %@",typeName,itemID]];
    NSError *error = nil;
    NSArray *results = [self.persistentContainer.viewContext executeFetchRequest:request error:&error];
    
    if (results.count == 0) {
        return nil;
    } else {
        return results.firstObject;
    }
}

- (void)updateHomeItemWithTypeName:(NSString *)typeName itemID:(NSString *)itemID isLike:(BOOL)isLike {
    HomeItem *homeItem = [self fetchHomeItemWithTypeName:typeName itemID:itemID];
    if (homeItem == nil) {
        [self insertHomeItemWithTypeName:typeName itemID:itemID isLike:isLike];
    } else {
        homeItem.isLike = isLike;
    }
    [self saveContext];
}


- (void)insertCommentItemWithTypeName:(NSString *)typeName commentID:(NSString *)commentID isLike:(BOOL)isLike {
    CommentItem *commentItem = [NSEntityDescription insertNewObjectForEntityForName:commentItemEntityName inManagedObjectContext:self.persistentContainer.viewContext];
    commentItem.typeName = typeName;
    commentItem.commentId = commentID;
    commentItem.isLike = isLike;
    
    [self saveContext];
}

- (CommentItem *)fetchCommentItemWithTypeName:(NSString *)typeName commentID:(NSString *)commentID {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:commentItemEntityName];
    [request setPredicate:[NSPredicate predicateWithFormat:@"typeName == %@ AND commentId == %@",typeName,commentID]];
    NSError *error = nil;
    NSArray *results = [self.persistentContainer.viewContext executeFetchRequest:request error:&error];
    
    if (results.count == 0) {
        return nil;
    } else {
        return results.firstObject;
    }
}

- (void)updateCommentItemWithType:(NSString *)typeName commentID:(NSString *)commentID isLike:(BOOL)isLike {
    CommentItem *commentItem = [self fetchCommentItemWithTypeName:typeName commentID:commentID];
    if (commentItem == nil) {
        [self insertCommentItemWithTypeName:typeName commentID:commentID isLike:isLike];
    } else {
        commentItem.isLike = isLike;
    }
    [self saveContext];
}

@end
