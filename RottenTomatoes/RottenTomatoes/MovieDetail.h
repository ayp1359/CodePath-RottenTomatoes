//
//  MovieDetail.h
//  RottenTomatoes
//
//  Created by Ali YAZDAN PANAH on 10/16/14.
//  Copyright (c) 2014 Ali YAZDAN PANAH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetail : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *movieDetailPoster;
@property (weak,nonatomic) NSString *posterURL;
@property (weak, nonatomic) IBOutlet UILabel *movieSynopsisLabel;
@property (weak,nonatomic) NSString *movieSynopsisString;
@property (weak, nonatomic) IBOutlet UIScrollView *movieScrollView;

@end
