//
//  OpenDownLoadFileViewController.m
//  OpenFile
//
//  Created by chenjie on 17/9/6.
//  Copyright © 2017年 郑文明. All rights reserved.
//

#import "OpenDownLoadFileViewController.h"
#import <QuickLook/QuickLook.h>

@interface OpenDownLoadFileViewController ()<QLPreviewControllerDataSource,QLPreviewControllerDelegate,NSURLConnectionDataDelegate>
{
    long long totaLen;//数据总长度
    long long currentLen;//当前已下载数据长度
}

@property(nonatomic, strong) UIProgressView *progressV;
@property(nonatomic, strong) NSMutableData  *fileData;//音乐数据
@property(nonatomic, strong) NSURL          *fileURL;
@property(nonatomic, strong) NSString       *fileName;
//@property(nonatomic, strong) MBProgressHUD *hud;

@end

@implementation OpenDownLoadFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"下载";
    
    self.fileName = @"";
    if (self.fileURLString.length > 0) {
        NSRange range = [self.fileURLString rangeOfString:@"fileName="];//文件名位于的位置
        //截取文件名字方便存缓存
        self.fileName = [self.fileURLString substringWithRange:NSMakeRange(range.length + range.location, self.fileURLString.length - range.length - range.location)];
        
        if ([self hasFileInApp:self.fileName]) {//存在文件，直接打开
            [self pushPreView:self.fileName];
        }else{//不存在文件名，去下载
            [self.view addSubview:_progressV];
            
            NSURL *targetURL = [NSURL URLWithString:self.fileURLString];
            NSURLRequest *request = [NSURLRequest requestWithURL:targetURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
            [NSURLConnection connectionWithRequest:request delegate:self];
        }
    }
}

//判断在app缓存内是否存在文件
- (BOOL)hasFileInApp:(NSString *)file{
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [docPath stringByAppendingPathComponent:file];
    
    NSFileManager *fileM = [NSFileManager defaultManager];
    if ([fileM fileExistsAtPath:filePath]){
        return YES;
    }else{
        return NO;
    }
}

//打开文档
- (void)pushPreView:(NSString *)file{
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [docPath stringByAppendingPathComponent:file];
    
    self.fileURL = [NSURL fileURLWithPath:filePath];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        QLPreviewController *qlVC = [[QLPreviewController alloc]init];
        qlVC.delegate = self;
        qlVC.dataSource = self;
        [self.navigationController pushViewController:qlVC animated:YES];
    });
}

#pragma mark - 下载
//获取到服务器响应
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    totaLen = response.expectedContentLength;
}

//获取到数据流
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.fileData appendData:data];
    currentLen = self.fileData.length;
    self.progressV.progress = currentLen*1.0/totaLen;
    NSLog(@"%f",currentLen*1.0/totaLen);//在这边可以加个进度条，因为没有导入三方就没有加了
}

//数据请求
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    //第一次下载完存入缓存，并打开文档
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [docPath stringByAppendingPathComponent:self.fileName];
    BOOL success = [fileManager createFileAtPath:filePath contents:self.fileData attributes:nil];
    if (success == YES) {
        self.fileURL = [NSURL fileURLWithPath:filePath];
        
        self.fileData = [NSMutableData new];//清空存储数据，这个很重要
        dispatch_async(dispatch_get_main_queue(), ^{
            QLPreviewController *qlVC = [[QLPreviewController alloc]init];
            qlVC.delegate = self;
            qlVC.dataSource = self;
            [self.navigationController pushViewController:qlVC animated:YES];
        });
    }
}

#pragma mark -
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return self.fileURL;
}

- (void)previewControllerWillDismiss:(QLPreviewController *)controller {
    NSLog(@"previewControllerWillDismiss");
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller {
    NSLog(@"previewControllerDidDismiss");
}

- (BOOL)previewController:(QLPreviewController *)controller shouldOpenURL:(NSURL *)url forPreviewItem:(id <QLPreviewItem>)item{
    return YES;
}

- (CGRect)previewController:(QLPreviewController *)controller frameForPreviewItem:(id <QLPreviewItem>)item inSourceView:(UIView * __nullable * __nonnull)view{
    return CGRectZero;
}

#pragma mark - getter
-(UIProgressView *)progressV{
    if (!_progressV) {
        _progressV=[[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
        _progressV.center = self.view.center;
        //默认初始值
        _progressV.progress=0.0;
    }
    return _progressV;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
