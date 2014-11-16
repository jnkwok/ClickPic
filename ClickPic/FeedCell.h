//
//  FeedCell.h
//  ClickPic
//
//  Created by Jon on 11/16/14.
//  Copyright (c) 2014 ClickPic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *caption;
@property (weak, nonatomic) IBOutlet UILabel *votes;

@end
