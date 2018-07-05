//
//  ViewController.m
//  CoreBluetoothDemo
//
//  Created by mopucheng on 2018/7/4.
//  Copyright © 2018年 mopucheng. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
@interface ViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>

//中心设备
@property (nonatomic, strong)CBCentralManager *centralManager;

//存储设备
@property (nonatomic, strong)NSMutableArray *peripherals;

//扫描到的设备
@property (nonatomic, strong)CBPeripheral *cbPeripheral;

//文本
@property (nonatomic, strong)UITextField *peripheralTF;

//外设状态
@property (nonatomic, assign)CBManagerState peripheralState;

@property (nonatomic, strong)UIButton *scanForBtn;

@end

// 蓝牙4.0设备名
static NSString * const kBlePeripheralName = @"公司硬件蓝牙名称";
// 通知服务
static NSString * const kNotifyServerUUID = @"FFE0";
// 写服务
static NSString * const kWriteServerUUID = @"FFE1";
// 通知特征值
static NSString * const kNotifyCharacteristicUUID = @"FFE2";
// 写特征值
static NSString * const kWriteCharacteristicUUID = @"FFE3";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.peripheralTF];
    [self.view addSubview:self.scanForBtn];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.scanForBtn.frame = CGRectMake(100, 230, 100, 50);
}

-(UITextField *)peripheralTF
{
    if (!_peripheralTF) {
        _peripheralTF = [[UITextField alloc] initWithFrame:CGRectMake(100, 150, 100, 50)];
        _peripheralTF.layer.borderWidth = 1;
        _peripheralTF.layer.borderColor = [UIColor blackColor].CGColor;
        _peripheralTF.layer.cornerRadius = 3;
    }
    return _peripheralTF;
}

-(UIButton *)scanForBtn
{
    if (!_scanForBtn) {
        _scanForBtn = [UIButton new];
        [_scanForBtn setTitle:@"开始扫描" forState:UIControlStateNormal];
        [_scanForBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _scanForBtn.layer.cornerRadius = 3;
        _scanForBtn.layer.borderWidth = 1;
        _scanForBtn.layer.borderColor = [UIColor blackColor].CGColor;
        [_scanForBtn addTarget:self action:@selector(scanForPeripherals) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanForBtn;
}

-(CBCentralManager *)centralManager
{
    if (!_centralManager) {
        _centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    }
    return _centralManager;
}

-(NSMutableArray *)peripherals
{
    if (!_peripherals) {
        _peripherals = [NSMutableArray array];
    }
    return _peripherals;
}

//扫描设备
-(void)scanForPeripherals
{
    [self.centralManager stopScan];
    NSLog(@"扫描设备");
    
    if (self.peripheralState == CBManagerStatePoweredOn) {
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    }
}


#pragma mark corBluetoothDelegate

//当状态更新时调用（不实现会奔溃）
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBManagerStateUnknown:{
            NSLog(@"未知状态");
            self.peripheralState = central.state;
        }
            break;
        case CBManagerStateResetting:
        {
            NSLog(@"重置状态");
            self.peripheralState = central.state;
        }
            break;
        case CBManagerStateUnsupported:
        {
            NSLog(@"不支持的状态");
            self.peripheralState = central.state;
        }
            break;
        case CBManagerStateUnauthorized:
        {
            NSLog(@"未授权的状态");
            self.peripheralState = central.state;
        }
            break;
        case CBManagerStatePoweredOff:
        {
            NSLog(@"关闭状态");
            self.peripheralState = central.state;
        }
            break;
        case CBManagerStatePoweredOn:
        {
            NSLog(@"开启状态－可用状态");
            self.peripheralState = central.state;
        }
            break;
        default:
            break;
    }
}

//扫描到设备并开始连接
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"发现设备，设备名:%@",peripheral.name);
    if (![self.peripherals containsObject:peripheral]) {
        [self.peripherals addObject:peripheral];
        NSLog(@"%@",peripheral);
        if ([peripheral.name isEqualToString:kBlePeripheralName]) {
            //这里连接设备
        }
    }
}

//连接失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"连接失败");
    if ([peripheral.name isEqualToString:kBlePeripheralName]) {
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}

//连接成功
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"连接成功");
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}

//扫描到服务
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"扫描到服务");
    for (CBService *service in peripheral.services) {
        NSLog(@"服务:%@",service.UUID.UUIDString);
    }
}

//根据特征读取数据
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
