//
//  ViewController.h
//  wisdom
//
//  Created by wangxu on 15/9/25.
//  Copyright © 2015年 wangxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Promotion : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) CGFloat rate;
@property (nonatomic, strong) NSString *category;

+ (Promotion *)promotionWithString:(NSString *)string;

@end

@interface Good : NSObject

@property (nonatomic, assign) NSInteger nums;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, strong) NSString *name;

+ (Good *)goodWithString:(NSString *)string;

@end

@interface Privilege : NSObject

@property (nonatomic, assign) CGFloat full;
@property (nonatomic, assign) CGFloat reduce;
@property (nonatomic, strong) NSDate *date;

+ (Privilege *)privilegeWithString:(NSString *)string;

@end

@interface ViewController : UIViewController


@end

