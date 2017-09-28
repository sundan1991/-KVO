//
//  NSObject+KVO.m
//  自定义KVO
//
//  Created by suapri on 2017/9/28.
//  Copyright © 2017年 SD. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSObject (KVO)

//1.动态创建一个类
//2.改变类对象的isa指针
//3.重写set方法
- (void)sd_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context {
    //类名
    const char *clsName = object_getClassName(self);
    //新类的名
    NSString *newClsName = [@"NSKVONotifying_" stringByAppendingString:[NSString stringWithUTF8String:clsName]];
    //创建一个新类
    Class cls = objc_allocateClassPair([self class], [newClsName UTF8String], 0);
    //注册类
    objc_registerClassPair(cls);
    //改变isa指针,让P对象指向新类
    object_setClass(self, cls);
    //关联对象,将观察者保存到当前对象中
    objc_setAssociatedObject(self, @"key", observer, 0);
    //为这个类，添加set方法
    //v->void; @->参数 ; :->SEL?
    class_addMethod(cls, @selector(setName:),(IMP)setName, "v@:@");//这个方法无法直接调用，必须使用perform调用
    //下面这句代码跟自定义KVO没有关系
    //因为是在运行时添加的方法，编译的时候并没有添加，而performSelector方法是运行时查找方法的方法
//    [self performSelector:@selector(setName:) withObject:nil];
    
}

//id self, SEL _cmd 是class_addMethod的两个隐式参数
void setName(id self, SEL _cmd, NSString *newName) {
    //重写set方法
    //观察newName的值，改变，则调用observeValueForKeyPath方法
    //保存子类
    Class cls = [self class];
    //把子类设置成父类，方便调用set方法
    object_setClass(self, class_getSuperclass(cls));
    //调用set方法
    objc_msgSend(self, @selector(setName:),newName);
    //把观察者对象取出来
    id observer = objc_getAssociatedObject(self, @"key");
    //发消息，把值传回去
    objc_msgSend(observer, @selector(observeValueForKeyPath: ofObject: change: context:),@"name",self,newName,nil);
    //重新设置回子类
    object_setClass(self, cls);
    
}

@end
