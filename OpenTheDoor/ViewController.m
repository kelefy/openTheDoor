//
//  ViewController.m
//  OpenTheDoor
//
//  Created by KongFanyi on 2017/2/27.
//  Copyright © 2017年 KongFanyi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (copy, nonatomic) NSString *phonenumberKey;

@property (copy, nonatomic) NSString *phoneNumber;

@property (strong, nonatomic) UIImageView *qcImv;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestPhoneNumber) name:@"init" object:nil];
    self.phonenumberKey = @"phonenumber";
    UIImageView *back = [[UIImageView alloc]initWithFrame:self.view.frame];
    back.image = [UIImage imageNamed:@"backgroundimg"];
    [self.view addSubview:back];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, self.view.frame.size.height-80, self.view.frame.size.width, 50);
    [btn addTarget:self action:@selector(showNumberInput) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self requestPhoneNumber];
}

-(void)requestPhoneNumber
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *phone = [userDefault objectForKey:_phonenumberKey];
    if(phone.length>1)
    {
        self.phoneNumber = [userDefault objectForKey:_phonenumberKey];
    }
    
    if(self.phoneNumber.length<1)
    {
        [self showNumberInput];
    }
    else
    {
        [self loadQcImg];
    }
}

-(void)showNumberInput
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入您的手机号码" preferredStyle:UIAlertControllerStyleAlert];
    // 添加按钮
    __weak typeof(alert) weakAlert = alert;
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//        NSLog(@"点击了确定按钮--%@-%@", [weakAlert.textFields.firstObject text], [weakAlert.textFields.lastObject text]);
        if(weakAlert.textFields.firstObject.text.length>0)
        {
            self.phoneNumber = weakAlert.textFields.firstObject.text;
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:self.phoneNumber forKey:_phonenumberKey];
            [self loadQcImg];
        }
    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
////        NSLog(@"点击了取消按钮");
//    }]];
    
    // 添加文本框
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    [self presentViewController:alert animated:YES completion:nil];
}


-(UIImage *)imageWithQrCode:(NSString *)qrCode size:(CGSize)size
{
    // 1.实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复滤镜的默认属性 (因为滤镜有可能保存上一次的属性)
    [filter setDefaults];
    
    // 3.将字符串转换成NSdata
    NSString *urlString = qrCode;
    NSData *data  = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    
    // 4.通过KVO设置滤镜, 传入data, 将来滤镜就知道要通过传入的数据生成二维码
    [filter setValue:data forKey:@"inputMessage"];
    
    // 5.生成二维码
    CIImage *outputImage = filter.outputImage;
    CGFloat scale = size.width / CGRectGetWidth(outputImage.extent);
    CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale); // scale 为放大倍数
    CIImage *transformImage = [outputImage imageByApplyingTransform:transform];
    
    // 保存
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imageRef = [context createCGImage:transformImage fromRect:transformImage.extent];
    UIImage *qrCodeImage = [UIImage imageWithCGImage:imageRef];
    
    return qrCodeImage;
}

-(void)loadQcImg
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    long long timeint = a;
    NSString *timeString = [NSString stringWithFormat:@"%lld",(long long)timeint];
    NSString *replaceStr = [NSString stringWithFormat:@"%@000", [timeString substringToIndex:timeString.length-3]];
    NSString *str = [NSString stringWithFormat:@"8002|%@|%@|440106B008",self.phoneNumber,replaceStr];
    
    if(!_qcImv)
    {
        self.qcImv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*0.43f, self.view.frame.size.width*0.43f)];
        self.qcImv.center = self.view.center;
        [self.view addSubview:self.qcImv];
        self.qcImv.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(requestPhoneNumber)];
        [self.qcImv addGestureRecognizer:singleTap1];
//        self.qcImv.userInteractionEnabled = YES;
        
        UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*0.06f, self.view.frame.size.width*0.06f)];
        logo.image = [UIImage imageNamed:@"logo"];
        [self.view addSubview:logo];
        logo.center = _qcImv.center;
    }
    
    self.qcImv.image = [self imageWithQrCode:str size:self.qcImv.frame.size];
    
}


@end
