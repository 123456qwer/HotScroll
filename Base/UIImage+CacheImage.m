//
//  UIImage+CacheImage.m
//  begin
//
//  Created by Mac on 2019/4/10.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "UIImage+CacheImage.h"
#import <objc/runtime.h>
@implementation UIImage (CacheImage)

+ (void)load {
    
    Method imageNamed = class_getClassMethod(self,@selector(imageNamed:));
    Method mkeImageNamed =class_getClassMethod(self,@selector(mke_imageNamed:));
    method_exchangeImplementations(imageNamed, mkeImageNamed);
    
}
+ (instancetype)mke_imageNamed:(NSString*)name{
    NSString *path;
    if ([name rangeOfString:@"jpg"].location == NSNotFound) {
        path = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
    }else{
        NSArray *nameArr = [name componentsSeparatedByString:@"."];
        path = [[NSBundle mainBundle] pathForResource:nameArr[0] ofType:@"jpg"];
    }

    UIImage * image =  [self imageWithContentsOfFile:path];
    if (image != nil) {
        return image;
    }else {
        image = [self mke_imageNamed:name];
//        NSLog(@"加载到内存中的东西:     %@",name);
//        WDTextureManager *manager = [WDTextureManager shareManager];
//        manager.mb = manager.mb + image.size.width * image.size.height * 4.0 / 1024.f / 1024.f;
        
        return image;
    }
}

@end
