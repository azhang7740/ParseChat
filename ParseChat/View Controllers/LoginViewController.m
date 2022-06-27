//
//  LoginViewController.m
//  ParseChat
//
//  Created by Angelina Zhang on 6/27/22.
//

#import "LoginViewController.h"
#import "loginView.h"
#import <Parse/Parse.h>
#import "ChatViewController.h"

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet LoginView *loginView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginView.userNameTextField.text = nil;
    self.loginView.passwordTextField.text = nil;
    self.loginView.userNameTextField.placeholder = @"username";
    self.loginView.passwordTextField.placeholder = @"password";
}

- (void)registerUser {
    PFUser *newUser = [PFUser user];
    
    newUser.username = self.loginView.userNameTextField.text;
    newUser.password = self.loginView.passwordTextField.text;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error == nil) {
            UINavigationController *navigationController = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ChatNavigation"];
           [self presentViewController:navigationController animated:YES completion:nil];
        } else {
            [self displayAlert:@"Error signing in."];
        }
    }];
}

- (void)loginUser {
    NSString *username = self.loginView.userNameTextField.text;
    NSString *password = self.loginView.passwordTextField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error == nil) {
            UINavigationController *navigationController = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ChatNavigation"];
           [self presentViewController:navigationController animated:YES completion:nil];
        } else {
            [self displayAlert:@"Error logging in."];
        }
    }];
}

- (void)displayAlert:(NSString *) alertMessage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops!" message:alertMessage preferredStyle:(UIAlertControllerStyleAlert)];
    [self presentViewController:alert animated: YES completion: nil];
    UIAlertAction * closeAction = [UIAlertAction actionWithTitle:@"Try again." style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        }];
    [alert addAction:closeAction];
}

- (IBAction)onTapSignUp:(id)sender {
    BOOL isEmpty = ([self.loginView.userNameTextField.text isEqual:@""]) || ([self.loginView.passwordTextField.text isEqual:@""]);
    if (isEmpty) {
        [self displayAlert:@"Username and/or password field is empty."];
    } else {
        [self registerUser];
    }
}

- (IBAction)onTapLogin:(id)sender {
    BOOL isEmpty = ([self.loginView.userNameTextField.text isEqual:@""]) || ([self.loginView.passwordTextField.text isEqual:@""]);
    
    if (isEmpty) {
        [self displayAlert:@"Username and/or password field is empty."];
    } else {
        [self loginUser];
    }
}

@end
