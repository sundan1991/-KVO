//
//  NSObject+KVO.h
//  自定义KVO
//
//  Created by suapri on 2017/9/28.
//  Copyright © 2017年 SD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KVO)

- (void)sd_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;


@end
