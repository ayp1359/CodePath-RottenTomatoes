//
//  MovieDetail.h
//  RottenTomatoes
//
//  Created by Ali YAZDAN PANAH on 10/16/14.
//  Copyright (c) 2014 Ali YAZDAN PANAH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetail : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *movieDetailPoster;
@property (weak,nonatomic) NSString *posterURL;

@end
