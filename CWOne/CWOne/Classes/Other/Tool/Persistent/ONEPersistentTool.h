//
//  ONEPersistentTool.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/13.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSPersistentContainer;

@interface ONEPersistentTool : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

@end
