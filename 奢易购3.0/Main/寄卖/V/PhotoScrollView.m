//
//  PhotoScrollView.m
//  WXMovie
//
//  Created by mR yang on 15/10/28.
//  Copyright (c) 2015年 mR yang. All rights reserved.
//

#import "PhotoScrollView.h"
#import "ReportViewController.h"


@implementation PhotoScrollView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        
        photoImageView=[[UIImageView alloc]initWithFrame:self.bounds];
        
        
        [self addSubview:photoImageView];
        
        photoImageView.contentMode=UIViewContentModeScaleAspectFit;
        
        self.maximumZoomScale=2;
        
        self.minimumZoomScale=1;
        
        self.delegate=self;
        
//        创建双击手势
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];

        //点击几次
        tap.numberOfTapsRequired=2;
//        手指个数
        tap.numberOfTouchesRequired=1;
        
        self.showsHorizontalScrollIndicator=NO;
        
        self.showsVerticalScrollIndicator=NO;
        
        [self addGestureRecognizer:tap];
//        self.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        [self addGestureRecognizer:longPress];
    }
    
    return self;
}

-(void)tapAction{
    
//    通过三目运算符来判断当前缩放比例
    float scale=self.zoomScale>1?1:2;
    
    [self setZoomScale:scale animated:YES];
    
}

-(void)setImageUrl:(NSString *)imageUrl{
    
    _imageUrl=imageUrl;
    
//    4.把图片数据显示在photoImageView上面
    [photoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",image_API,_imageUrl]]];
    
}
- (void)setPhotosId:(NSString *)photosId{
    _photosId = photosId;

}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return photoImageView;
    
}

#pragma mark - 视图长按手势
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress
{
    NSLog(@"长按");
    if (longPress.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"保存到相册" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到相册", @"举报",nil];
        [sheet showInView:photoImageView];
    }
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIImageWriteToSavedPhotosAlbum(photoImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }else if (buttonIndex == 1){
        ReportViewController *reportVC = [[ReportViewController alloc]
                                      init];
        reportVC.dic = @{
                         @"type":@"3",
                         @"id":_photosId
                         };
        
        [self.viewController.navigationController pushViewController:reportVC animated:YES];
    }
}

// 图片保存完成
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"保存完成");
}


@end
