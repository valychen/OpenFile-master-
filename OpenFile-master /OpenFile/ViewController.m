//
//  ViewController.m
//  OpenFile
//
//  Created by 郑文明 on 15/12/28.
//  Copyright © 2015年 郑文明. All rights reserved.
//

#import "ViewController.h"
#import "QuickLookViewController.h"
#import "DocumentInteractionViewController.h"
#import "OpenRemoteFileViewController.h"
#import "OpenDownLoadFileViewController.h"
#import "PDFVC.h"
#import "PDFHttpViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView * table;
    NSMutableArray *dataSource;
}

@end

@implementation ViewController
-(void)initTable{
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    table.dataSource = self;
    table.delegate =  self;
    table.tableFooterView = [UIView new];
    [self.view addSubview:table];
}
- (void)viewDidLoad {
    self.title = @"OpenFile";
    [super viewDidLoad];
//    http://weixintest.ihk.cn/ihkwx_upload/1.pdf
    dataSource = [NSMutableArray arrayWithObjects:@"UIWebView预览方式",@"UIDocumentInteractionController预览方式",@"QLPreviewController预览方式",@"网络远程文件直接预览方式入口",@"网络远程文件下载预览方式入口",@"CGContextDrawPDFPage﻿入口", nil];
    [self initTable];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = dataSource[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Reader" ofType:@"pdf"];
    NSURL *URL = [NSURL fileURLWithPath:filePath];
    if (indexPath.row == 0) {//本地文件预览方式 UIWebView
        PDFHttpViewController *documentVC = [[PDFHttpViewController alloc]init];
        documentVC.webUrlString = filePath;
        [self.navigationController pushViewController:documentVC animated:YES];
    }else if (indexPath.row == 1) {//本地文件预览方式 UIDocumentInteractionController
        DocumentInteractionViewController *documentVC = [[DocumentInteractionViewController alloc]init];
        [documentVC openFileWithURL:URL];
        [self.navigationController pushViewController:documentVC animated:YES];
    }else if (indexPath.row == 2){//本地文件预览方式 QLPreviewController
        QuickLookViewController *quickLookVC = [[QuickLookViewController alloc]init];
        quickLookVC.fileURL = URL;
        [self.navigationController pushViewController:quickLookVC animated:YES];
    }else if (indexPath.row == 3){//网络远程文件预览方式入口 打开地址直接可以浏览
        OpenRemoteFileViewController *openRemoteFileVC = [[OpenRemoteFileViewController alloc]init];
        openRemoteFileVC.fileURLString = @"http://weixintest.ihk.cn/ihkwx_upload/1.pdf";
        [self.navigationController pushViewController:openRemoteFileVC animated:YES];
    }else if (indexPath.row == 4){//网络远程文件预览方式入口 打开地址下载后浏览
        OpenDownLoadFileViewController *openRemoteFileVC = [[OpenDownLoadFileViewController alloc]init];
        openRemoteFileVC.fileURLString = @"http://";//自己填写地址
        [self.navigationController pushViewController:openRemoteFileVC animated:YES];
    }else{//CGContextDrawPDFPage﻿,目前为左右滑动，若想上下，修改collectionview的滑动方向
        PDFVC *openRemoteFileVC = [[PDFVC alloc]init];
        openRemoteFileVC.pdfUrl = @"http://weixintest.ihk.cn/ihkwx_upload/1.pdf";
        [self.navigationController pushViewController:openRemoteFileVC animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
