//
//  ReaderPDFView.h
//  OpenFile
//
//  Created by chenjie on 17/2/21.
//  Copyright © 2017年 chenjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReaderPDFView : UIView
- (instancetype)initWithFrame:(CGRect)frame documentRef:(CGPDFDocumentRef)docRef andPageNum:(int)page;
@end
