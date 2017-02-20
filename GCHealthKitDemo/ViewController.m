//
//  ViewController.m
//  GCHealthKitDemo
//
//  Created by APPLE on 2017/2/20.
//  Copyright © 2017年 Gibson. All rights reserved.
//

#import "ViewController.h"
#import "GCHealthManager.h"

@interface ViewController ()

@property (strong, nonatomic) UILabel *stepCountLable;
@property (strong, nonatomic) UILabel *walkingRunningLable;
@property (strong, nonatomic) UILabel *distanceCycling;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initSubViews];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initSubViews {
    
    UILabel *stepCount = [[UILabel alloc] initWithFrame: CGRectMake(20, 100, 80, 30)];
    stepCount.text = @"步数:";
    stepCount.textColor = [UIColor lightGrayColor];
    stepCount.textAlignment = NSTextAlignmentRight;
    [self.view addSubview: stepCount];
    
    self.stepCountLable = [[UILabel alloc] initWithFrame: CGRectMake(105, 100, 200, 30)];
    self.stepCountLable.textAlignment = NSTextAlignmentLeft;
    self.stepCountLable.textColor = [UIColor redColor];
    [self.view addSubview: self.stepCountLable];
    
    UILabel *distance = [[UILabel alloc] initWithFrame: CGRectMake(20, 150, 150, 30)];
    distance.text = @"步行+跑步距离:";
    distance.textColor = [UIColor lightGrayColor];
    distance.textAlignment = NSTextAlignmentRight;
    [self.view addSubview: distance];
    
    self.walkingRunningLable = [[UILabel alloc] initWithFrame: CGRectMake(175, 150, 200, 30)];
    self.walkingRunningLable.textAlignment = NSTextAlignmentLeft;
    self.walkingRunningLable.textColor = [UIColor redColor];
    [self.view addSubview: self.walkingRunningLable];
    
    UILabel *cycleDistance = [[UILabel alloc] initWithFrame: CGRectMake(20, 190, 80, 30)];
    cycleDistance.text = @"骑车:";
    cycleDistance.textColor = [UIColor lightGrayColor];
    cycleDistance.textAlignment = NSTextAlignmentRight;
    [self.view addSubview: cycleDistance];
    
    self.distanceCycling = [[UILabel alloc] initWithFrame: CGRectMake(105, 190, 200, 30)];
    self.distanceCycling.textAlignment = NSTextAlignmentLeft;
    self.distanceCycling.textColor = [UIColor redColor];
    [self.view addSubview: self.distanceCycling];
    
//    UITextField *distanceTectfield = [[UITextField alloc] initWithFrame: CGRectMake(20, 200, 120, 30)];
//    distanceTectfield.textColor = [UIColor redColor];
//    distanceTectfield.font = [UIFont systemFontOfSize: 16];
//    distanceTectfield.
    
    
    
    
    UIButton *btnRead = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 100, 40)];
    [btnRead setTitle: @"读取数据" forState: UIControlStateNormal];
    [btnRead setTitleColor: [UIColor lightGrayColor] forState: UIControlStateNormal];
    [btnRead addTarget: self action: @selector(readAction) forControlEvents: UIControlEventTouchUpInside];
    [btnRead setBackgroundColor: [UIColor blueColor]];
    btnRead.layer.cornerRadius = 15;
    btnRead.clipsToBounds = YES;
    btnRead.center = CGPointMake(self.view.center.x, CGRectGetHeight(self.view.frame) - 100);
    [self.view addSubview: btnRead];
    
    
    UIButton *btnWrite = [[UIButton alloc] initWithFrame: CGRectMake(0, CGRectGetMinY(btnRead.frame) - 120, 100, 40)];
    [btnWrite setTitle: @"写入数据" forState: UIControlStateNormal];
    [btnWrite setTitleColor: [UIColor lightGrayColor] forState: UIControlStateNormal];
    [btnWrite addTarget: self action: @selector(witeAction) forControlEvents: UIControlEventTouchUpInside];
    [btnWrite setBackgroundColor: [UIColor blueColor]];
    btnWrite.layer.cornerRadius = 15;
    btnWrite.clipsToBounds = YES;
    btnWrite.center = CGPointMake(self.view.center.x, btnWrite.center.y);
    [self.view addSubview: btnWrite];
    
    UIButton *btndeleteCycling = [[UIButton alloc] initWithFrame: CGRectMake(0, CGRectGetMinY(btnWrite.frame) - 120, 150, 40)];
    [btndeleteCycling setTitle: @"清除骑行数据" forState: UIControlStateNormal];
    [btndeleteCycling setTitleColor: [UIColor lightGrayColor] forState: UIControlStateNormal];
    [btndeleteCycling addTarget: self action: @selector(deleteAction) forControlEvents: UIControlEventTouchUpInside];
    [btndeleteCycling setBackgroundColor: [UIColor blueColor]];
    btndeleteCycling.layer.cornerRadius = 15;
    btndeleteCycling.clipsToBounds = YES;
    btndeleteCycling.center = CGPointMake(self.view.center.x, btndeleteCycling.center.y);
    [self.view addSubview: btndeleteCycling];
}


-(void)readAction {
    [[GCHealthManager shareManager] requestAuthorized:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDate *now = [NSDate date];
            NSDate *startDate = [calendar startOfDayForDate:now];
            NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
            [[GCHealthManager shareManager] getStepCountWithstartDate: startDate andEndDate: endDate completeHandle:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
                if (!error && results) {
                    double count = 0;
                    for (NSInteger i = 0; i < results.count; i++) {
                        HKQuantitySample *sample = results[i];
                        double tmp = [sample.quantity doubleValueForUnit: [HKUnit countUnit]];
                        count += tmp;
//                         NSLog(@"%@ ~ %@ stepCount: %g", sample.startDate, sample.endDate, count);
//                        NSInteger isUserAdded = [[sample.metadata objectForKey: @"HKWasUserEntered"] integerValue];
//                        if (1 == isUserAdded) {
//                            NSLog(@"isUserAdded == 1 用户添加的步数:%g", tmp);
//                        } else {
//                            NSLog(@"isUserAdded == %zd 系统添加的步数:%g", isUserAdded, tmp);
//                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.stepCountLable.text = [NSString stringWithFormat: @"%g 步", count];
                    });
                    
                    
                } else {
                    NSLog(@"samplequery error: %@", error);
                }
            }];
            
            
            [[GCHealthManager shareManager] getDistanceWalkingRunningWithstartDate: startDate andEndDate: endDate completeHandle:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
                if (!error && results) {
                    double count = 0;
                    for (NSInteger i = 0; i < results.count; i++) {
                        HKQuantitySample *sample = results[i];
                        double tmp = [sample.quantity doubleValueForUnit: [HKUnit meterUnit]];
                        count += tmp;
                        //                         NSLog(@"%@ ~ %@ stepCount: %g", sample.startDate, sample.endDate, count);
//                        NSInteger isUserAdded = [[sample.metadata objectForKey: @"HKWasUserEntered"] integerValue];
//                        if (1 == isUserAdded) {
//                            NSLog(@"isUserAdded == 1 用户添加的步数:%g", tmp);
//                        } else {
//                            NSLog(@"isUserAdded == %zd 系统添加的步数:%g", isUserAdded, tmp);
//                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.walkingRunningLable.text = [NSString stringWithFormat: @"%g m", count];
                    });
                    
                    
                } else {
                    NSLog(@"samplequery error: %@", error);
                }
            }];
            
            
            [[GCHealthManager shareManager] getDistanceCyclingWithstartDate: startDate andEndDate: endDate completeHandle:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
                if (!error && results) {
                    double count = 0;
                    for (NSInteger i = 0; i < results.count; i++) {
                        HKQuantitySample *sample = results[i];
                        double tmp = [sample.quantity doubleValueForUnit: [HKUnit meterUnit]];
                        count += tmp;
                        //                         NSLog(@"%@ ~ %@ stepCount: %g", sample.startDate, sample.endDate, count);
//                        NSInteger isUserAdded = [[sample.metadata objectForKey: @"HKWasUserEntered"] integerValue];
//                        if (1 == isUserAdded) {
//                            NSLog(@"isUserAdded == 1 用户添加的骑行公里:%g", tmp);
//                        } else {
//                            NSLog(@"isUserAdded == %zd 系统添加的骑行公里:%g", isUserAdded, tmp);
//                        }
//                        NSLog(@"%@ ~ %@ DistanceCycling: %g", sample.startDate, sample.endDate, count);
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.distanceCycling.text = [NSString stringWithFormat: @"%g m", count];
                    });
            }
            
            }];
            
        }
    }];
    
}

-(void)witeAction {
    [[GCHealthManager shareManager] requestAuthorized:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            double distance = 1000.0;
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDate *now = [NSDate date];
            NSDate *startDate = [calendar startOfDayForDate:now];
            NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
            [[GCHealthManager shareManager] addDistanceCyclingData: distance withStartDate: startDate andEndDate: endDate];
            
            [[GCHealthManager shareManager] insertStepCount: 1000.0 withStartDate: startDate endDate: endDate];
            
        } else {
            
        }
    }];
}

-(void)deleteAction {
    [[GCHealthManager shareManager] requestAuthorized:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            [[GCHealthManager shareManager] deleteDistanceCycling];
        }
    }];
}

@end
