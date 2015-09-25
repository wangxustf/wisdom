//
//  ViewController.m
//  wisdom
//
//  Created by wangxu on 15/9/25.
//  Copyright © 2015年 wangxu. All rights reserved.
//

#import "ViewController.h"
#import "NSDate+Addition.h"

@implementation Promotion

+ (Promotion *)promotionWithString:(NSString *)string
{
    Promotion *promotion = [[Promotion alloc] init];
    NSArray *array = [string componentsSeparatedByString:@"|"];
    promotion.date = [NSDate dateFromString:array[0] dateFormattter:@"yyyy.MM.dd"];
    promotion.rate = [array[1] floatValue];
    promotion.category = [array[2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return promotion;
}

@end

@implementation Good

+ (Good *)goodWithString:(NSString *)string
{
    Good *good = [[Good alloc] init];
    NSArray *array = [string componentsSeparatedByString:@"*"];
    good.nums = [array[0] integerValue];
    NSArray *array1 = [array[1] componentsSeparatedByString:@":"];
    good.name = [array1[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    good.price = [array1[1] floatValue];
    return good;
}

@end

@implementation Privilege

+ (Privilege *)privilegeWithString:(NSString *)string
{
    Privilege *privilege = [[Privilege alloc] init];
    NSArray *array = [string componentsSeparatedByString:@" "];
    privilege.date = [NSDate dateFromString:array[0] dateFormattter:@"yyyy.MM.dd"];
    privilege.full = [array[1] floatValue];
    privilege.reduce = [array[2] floatValue];
    return privilege;
}

@end

@interface ViewController ()

@property (nonatomic, strong) NSArray *promotionArray;
@property (nonatomic, strong) NSArray *goodsArray;
@property (nonatomic, strong) Privilege *privilege;
@property (nonatomic, strong) NSDate *closeDate;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSDictionary *infoDictionary = @{@"电子":@[@"ipad", @"iphone", @"显示器", @"笔记本电脑", @"键盘"],
                                    @"食品":@[@"面包", @"饼干", @"蛋糕", @"牛肉", @"鱼", @"蔬菜"],
                                    @"日用品":@[@"餐巾纸", @"收纳箱", @"咖啡杯", @"雨伞"],
                                     @"酒类":@[@"啤酒", @"白酒", @"伏特加"]};
    
    NSString *contentPath = [[NSBundle mainBundle] pathForResource:@"1" ofType:nil];
    NSString *txtContent = [NSString stringWithContentsOfFile:contentPath encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *infoArray = [txtContent componentsSeparatedByString:@"\n\n"];
    NSString *promotionString = nil;
    NSString *goodsString = nil;
    NSString *dateString = nil;
    BOOL hasPrivilege = NO;
    BOOL hasPromotion = NO;
    if ([infoArray count] == 3) {
        hasPromotion = YES;
        promotionString = infoArray[0];
        goodsString = infoArray[1];
        dateString = infoArray[2];
    } else {
        goodsString = infoArray[0];
        dateString = infoArray[1];
    }
    
    if (hasPromotion) {
        NSMutableArray *array = [NSMutableArray array];
        NSArray *pArray = [promotionString componentsSeparatedByString:@"\n"];
        for (NSString *pString in pArray) {
            [array addObject:[Promotion promotionWithString:pString]];
        }
        self.promotionArray = array;
    }
    
    {
        NSMutableArray *array = [NSMutableArray array];
        NSArray *pArray = [goodsString componentsSeparatedByString:@"\n"];
        for (NSString *pString in pArray) {
            [array addObject:[Good goodWithString:pString]];
        }
        self.goodsArray = array;
    }
    
    {
        NSArray *pArray = [dateString componentsSeparatedByString:@"\n"];
        self.closeDate = [NSDate dateFromString:pArray[0] dateFormattter:@"yyyy.MM.dd"];
        if (pArray.count > 1) {
            self.privilege = [Privilege privilegeWithString:pArray[1]];
            hasPrivilege = YES;
        }
    }
    
    CGFloat totalPrice = 0;
    for (Good *good in self.goodsArray) {
        CGFloat price = good.nums * good.price;
        if (hasPromotion) {
            for (Promotion *promotion in self.promotionArray) {
                if ([infoDictionary[promotion.category] containsObject:good.name] && [self.closeDate isEqualToDate:promotion.date]) {
                    price *= promotion.rate;
                    break;
                }
            }
        }
        totalPrice += price;
    }
    
    if ([self.closeDate compare:self.privilege.date] == NSOrderedAscending) {
        if (totalPrice >= self.privilege.full) {
            totalPrice -= self.privilege.reduce;
        }
    }
    
    NSLog(@"%.2f", totalPrice);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
