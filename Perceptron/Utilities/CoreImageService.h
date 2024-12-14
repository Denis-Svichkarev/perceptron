//
//  CoreImageService.h
//  Perceptron
//
//  Created by Denis Svichkarev on 11.05.2020.
//  Copyright © 2020 Denis Svichkarev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoreImageService : NSObject

+ (UIImage *)convertToGreyscale:(UIImage *)i;

@end

NS_ASSUME_NONNULL_END
