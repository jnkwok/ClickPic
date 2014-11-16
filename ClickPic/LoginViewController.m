//
//  LoginViewController.m
//  ClickPic
//
//  Created by Jon on 11/15/14.
//  Copyright (c) 2014 ClickPic. All rights reserved.
//

#import "LoginViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
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

- (IBAction)login:(id)sender {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
    [policy setAllowInvalidCertificates:YES];
    [manager setSecurityPolicy:policy];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *auth = @{@"username" : self.usernameField.text,
        @"password" : self.passwordField.text};
    [manager POST:@"" parameters:auth success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject objectForKey:@"userid"]) {
            [self goToFeed];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Incorrect username or password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

- (IBAction)signup:(id)sender {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
    [policy setAllowInvalidCertificates:YES];
    [manager setSecurityPolicy:policy];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *auth = @{@"username" : self.usernameField.text,
                           @"password" : self.passwordField.text};
    [manager POST:@"" parameters:auth success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject objectForKey:@"userid"]) {
            [self goToFeed];
        } else {
            NSString *message;
            if ([[responseObject objectForKey:@""] isEqualToString:@""]) {
                message = @"Username taken";
            } else {
                message = @"Issued occured. Please try again";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Signup Failed" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)goToFeed {
    UIViewController *fvc = [self.storyboard instantiateViewControllerWithIdentifier:@"feed"];
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.navigationController pushViewController:fvc animated:YES];
}

@end
