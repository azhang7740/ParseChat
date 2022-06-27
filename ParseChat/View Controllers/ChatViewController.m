//
//  ChatViewController.m
//  ParseChat
//
//  Created by Angelina Zhang on 6/27/22.
//

#import "ChatViewController.h"
#import "ChatView.h"
#import <Parse/Parse.h>
#import "ChatCell.h"

@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet ChatView *chatView;
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (nonatomic, strong) NSArray<NSString *> *posts;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.chatTableView.dataSource = self;
    self.chatView.chatTextField.placeholder = @"Type your message here...";
}

- (IBAction)onTapSend:(id)sender {
    PFObject *chatMessage = [PFObject objectWithClassName:@"Message_FBU2021"];
    [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (succeeded) {
            self.chatView.chatTextField.text = @"";
        } else {
            [self displayAlert:@"Unable to send message."];
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

- (void)queryParse {
    PFQuery *query = [PFQuery queryWithClassName:@"Message_FBU2021"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;

    [query findObjectsInBackgroundWithBlock:^(NSArray<NSString *> *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            [self.chatTableView reloadData];
        } else {
            [self displayAlert:@"Error loading chat."];
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell"
                                                     forIndexPath:indexPath];
    if (indexPath.row < self.posts.count) {
        cell.chatLabel.text = self.posts[indexPath.row];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

@end
