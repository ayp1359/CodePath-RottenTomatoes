//
//  MovieDetail.m
//  RottenTomatoes
//
//  Created by Ali YAZDAN PANAH on 10/16/14.
//  Copyright (c) 2014 Ali YAZDAN PANAH. All rights reserved.
//

#import "MovieDetail.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetail ()

@end

@implementation MovieDetail

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.movieDetailPoster setImageWithURL:[NSURL URLWithString:self.posterURL]];
  self.movieSynopsisLabel.text = self.movieSynopsisString;
  [self.movieSynopsisLabel sizeToFit];
  self.movieTitleLabel.text = self.title;
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  [self.movieScrollView layoutIfNeeded];
  self.movieScrollView.contentSize = CGSizeMake(self.view.frame.size.width,1.5*self.movieSynopsisLabel.frame.size.height);
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
