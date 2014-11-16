//
//  TakePicViewController.m
//  ClickPic
//
//  Created by Jon on 11/16/14.
//  Copyright (c) 2014 ClickPic. All rights reserved.
//

#import "TakePicViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AFHTTPRequestOperationManager.h"

@import CoreLocation;

@interface TakePicViewController () <UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *selectedImage;
@property (nonatomic, assign) BOOL hasNewImage;
@property (weak, nonatomic) IBOutlet UITextField *caption;

@end

@implementation TakePicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.caption.delegate = self;
    self.caption.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [self.selectedImage addGestureRecognizer:tap];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self; //ignore this warning
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    // Do any additional setup after loading the view.
}

-(void)tapped {
    self.caption.hidden = NO;
    [self.caption becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *) Picker {
    //[[Picker parentViewController] dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    //[Picker release];
} //uhhh does not work

- (void)imagePickerController:(UIImagePickerController *) Picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.selectedImage.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //[[Picker parentViewController] dismissModalViewControllerAnimated:YES];

    _hasNewImage = YES;
    //[Picker release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
    [policy setAllowInvalidCertificates:YES];
    [manager setSecurityPolicy:policy];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
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
