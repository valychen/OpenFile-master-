//
//  PDFVC.m
//  OpenFile
//
//  Created by chenjie on 17/2/21.
//  Copyright © 2017年 chenjie. All rights reserved.
//

#import "PDFVC.h"
#import "CollectionViewCell.h"
#import "ReaderPDFView.h"
//#import "SVProgressHUD.h"

@interface PDFVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,CollectionViewCellDelegate>
{
    UICollectionView    *_collectionView; //展示用的CollectionView
    CGPDFDocumentRef    _docRef;//需要获取的PDF资源文件
}
@property(nonatomic,strong)NSMutableArray *dataArray;//存数据的数组
@property(nonatomic,assign)int            totalPage;//一共有多少页
@end

@implementation PDFVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.titleStr;
    self.view.backgroundColor = [UIColor clearColor];
    
    _docRef = test(self.pdfUrl);//通过test函数获取PDF文件资源，test函数的实现为我们最上面的方法，当然下面又写了一遍
    [self getDataArrayValue];//获取需要展示的数据
    
    //初始化
    UICollectionViewFlowLayout*layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = self.view.frame.size;
    //设置滑动方向为水平方向，也可以设置为竖直方向
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    layout.minimumLineSpacing = 0;//设置item之间最下行距
    layout.minimumInteritemSpacing = 0;//设置item之间最小间距
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.pagingEnabled = YES;//设置集合视图一页一页的翻动
    [_collectionView registerClass:[CollectionViewCell class]forCellWithReuseIdentifier:@"test"];
    _collectionView.delegate = self;//设置代理
    _collectionView.dataSource = self;//设置数据源
    [self.view addSubview:_collectionView];
}

//通过地址字符串获取PDF资源
CGPDFDocumentRef test(NSString*urlString) {
    NSURL*url = [NSURL URLWithString:urlString];//将传入的字符串转化为一个NSURL地址
    CFURLRef refURL = (__bridge_retained CFURLRef)url;//将的到的NSURL转化为CFURLRefrefURL备用
    CGPDFDocumentRef document =CGPDFDocumentCreateWithURL(refURL);//通过CFURLRefrefURL获取文件内容
    CFRelease(refURL);//过河拆桥，释放使用完毕的CFURLRefrefURL，这个东西并不接受自动内存管理，所以要手动释放
    if(document) {
//        [SVProgressHUD dismiss];
        return  document;//返回获取到的数据
    }else{
//        [SVProgressHUD dismiss];
        return   NULL; //如果没获取到数据，则返回NULL，当然，你可以在这里添加一些打印日志，方便你发现问题
    }
}

//获取所有需要显示的PDF页面
- (void)getDataArrayValue
{
    size_t totalPages = CGPDFDocumentGetNumberOfPages(_docRef);//获取总页数
    self.totalPage = (int)totalPages;//给全局变量赋值
    NSMutableArray*arr = [NSMutableArray new];
    //通过循环创建需要显示的PDF页面，并把这些页面添加到数组中
    for(int i =1; i <= totalPages; i++) {
        ReaderPDFView *view = [[ReaderPDFView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height) documentRef: _docRef andPageNum:i];
        [arr addObject:view];
    }
    self.dataArray= arr;//给数据数组赋值
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.totalPage;
}

//复用、返回cell
-(UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    CollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"test" forIndexPath:indexPath];
    cell.cellTapDelegate = self;//设置tap事件代理
    cell.showView = self.dataArray[indexPath.row];//赋值，设置每个item中显示的内容
    return cell;
}

//当集合视图的item被点击后触发的事件，根据个人需求写
- (void)collectioncellTaped:(CollectionViewCell*)cell
{
    NSLog(@"我点了咋的？");
}

//集合视图继承自scrollView，所以可以用scrollView 的代理事件，这里的功能是当某个item不在当前视图中显示的时候，将它的缩放比例还原
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    for(UIView *view in _collectionView.subviews) {
        if([view isKindOfClass:[CollectionViewCell class]]) {
            CollectionViewCell*cell = (CollectionViewCell*)view;
            [cell.contentScrollView setZoomScale:1.0];
        }
    }
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
