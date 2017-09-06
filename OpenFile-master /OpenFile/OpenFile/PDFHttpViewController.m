//
//  PDFHttpV.m
//  HealthFemale
//
//  Created by chenjie on 17/2/22.
//  Copyright © 2017年 chenjie. All rights reserved.
//

#import "PDFHttpViewController.h"
//#import "SVProgressHUD.h"

@interface PDFHttpViewController ()<UIWebViewDelegate>
{
    UIWebView *webview;
}

@end

@implementation PDFHttpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =@"文章";
    
    webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    webview.delegate = self;
    [self.view addSubview:webview];
    
    NSURL *url = [NSURL URLWithString:self.webUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    if (self.webUrlString) {
        webview.scalesPageToFit = YES;//使文档的显示范围适合UIWebView的bounds
        NSString *urlstr = [NSString stringWithFormat:@"%@",self.webUrlString];
        NSURL *url= [NSURL URLWithString:urlstr];
        NSURLRequest *request= [NSURLRequest requestWithURL:url];
        //加载网络请求
        [webview loadRequest:request];
//        [SVProgressHUD showWithStatus:@"正在加载"];
    }
    [webview loadRequest:request];
}

#pragma mark - 代理
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
//    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError");
//    [SVProgressHUD dismiss];
    //    [SVProgressHUD showErrorWithStatus:@"连接失败,请重试"];
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
