//
//  ReaderPDFView.m
//  HealthFemale
//
//  Created by chenjie on 17/2/21.
//  Copyright © 2017年 chenjie. All rights reserved.
//

#import "ReaderPDFView.h"

@interface ReaderPDFView ()
{
    CGPDFDocumentRef  documentRef;//用它来记录传递进来的PDF资源数据
    int  pageNum;//记录需要显示页码
}
@end

@implementation ReaderPDFView

- (instancetype)initWithFrame:(CGRect)frame documentRef:(CGPDFDocumentRef)docRef andPageNum:(int)page
{
    if (self=[super initWithFrame:frame])
    {
        documentRef = docRef;
        pageNum = page;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self drawPDFIncontext:UIGraphicsGetCurrentContext()];//将当前的上下文环境传递到方法中，用于绘图
}

- (void)drawPDFIncontext:(CGContextRef)context
{
    CGContextTranslateCTM(context,0.0,self.frame.size.height);
    CGContextScaleCTM(context,1.0, -1.0);
    //上面两句是对环境做一个仿射变换，如果不执行上面两句那么绘制出来的PDF文件会呈倒置效果，第二句的作用是使图形呈正立显示，第一句是调整图形的位置，如不执行绘制的图形会不在视图可见范围内
    CGPDFPageRef  pageRef = CGPDFDocumentGetPage(documentRef,pageNum);//获取需要绘制的页码的数据。两个参数，第一个数传递进来的PDF资源数据，第二个是传递进来的需要显示的页码
    CGContextSaveGState(context);//记录当前绘制环境，防止多次绘画
    CGAffineTransform  pdfTransForm = CGPDFPageGetDrawingTransform(pageRef,kCGPDFCropBox,self.bounds,0,true);//创建一个仿射变换的参数给函数。第一个参数是对应页数据；第二个参数是个枚举值，我每个都试了一下，貌似没什么区别……但是网上看的资料都用的我当前这个，所以就用这个了；第三个参数，是图形绘制的区域，我设置的是当前视图整个区域，如果有需要，自然是可以修改的；第四个是旋转的度数，这里不需要旋转了，所以设置为0；第5个，传递true，会保持长宽比
    CGContextConcatCTM(context, pdfTransForm);//把创建的仿射变换参数和上下文环境联系起来
    CGContextDrawPDFPage(context, pageRef);//把得到的指定页的PDF数据绘制到视图上
    CGContextRestoreGState(context);//恢复图形状态
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
