//
//  ViewController.m
//  CBTooth
//
//  Created by mopucheng on 2018/5/3.
//  Copyright © 2018年 mopucheng. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
@interface ViewController () <CBPeripheralDelegate,CBCentralManagerDelegate,CBPeripheralManagerDelegate>
@property (nonatomic, strong)CBCentralManager *mager;
@property (nonatomic, strong)CBPeripheral *peripheral;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case 0:
            NSLog(@"设备类型位置");
            break;
        case 1:
            NSLog(@"设备初始化");
            break;
        case 2:
            NSLog(@"不支持蓝牙");
            break;
        case 3:
            NSLog(@"设备未授权");
            break;
        case 4:
        {
            NSLog(@"蓝牙未开启");
        }
            break;
        case 5:
        {
            NSLog(@"蓝牙已开启");
        }
            break;
        default:
            break;
    }
}

-(void)searchDevice
{
    if (_mager != nil && _mager.state == 5) {
        [self.mager scanForPeripheralsWithServices:nil options:nil];
    }
}

// 中心管理者didDiscoverPeripheral:(CBPeripheral *)peripheral
// 外设advertisementData:(NSDictionary *)advertisementData
// 外设携带的数据
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    if ([peripheral.name hasPrefix:@"HT"]) {
        NSLog(@"%@",peripheral.name);//能够进来的 都是我们想要的设备了
        //我们的逻辑是，搜索到一个设备（peripheral）放到一个集合，然后给用户进行选择
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
