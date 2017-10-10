//
//  ViewController.m
//  自定义KVO
//
//  Created by suapri on 2017/9/27.
//  Copyright © 2017年 SD. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "NSObject+KVO.h"

@interface ViewController ()

@property (nonatomic,strong) Person *p;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Person *p = [[Person alloc] init];
    p.name = @"111";
//    [p addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionNew) context:nil];
    //改变P对象的isa指针，生成一个新类NSKVONotifying_Person
    [p sd_addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionNew) context:nil];
    _p = p;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"change====%@",change);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _p.name = @"suapri";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self removeObserver:self forKeyPath:@"name" context:nil];
}

@end
