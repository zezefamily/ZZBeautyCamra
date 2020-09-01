//
//  ZZFilterManager.h
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/9/1.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZFilterModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZZFilterManager : NSObject

@property (nonatomic,strong,readonly) NSArray <ZZFilterModel *> *defaultFilters;

@property (nonatomic,strong,readonly) NSArray <ZZFilterModel *> *customFilters;

+ (ZZFilterManager *)shareManager;

- (GPUImageFilter *)filterWithFilterID:(NSString *)filterID;

@end

NS_ASSUME_NONNULL_END
