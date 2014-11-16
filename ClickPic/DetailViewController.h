//
//  DetailViewController.h
//  ClickPic
//
//  Created by Jon on 11/15/14.
//  Copyright (c) 2014 ClickPic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

