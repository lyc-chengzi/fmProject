//
//  ApplyMain_OLViewController.m
//  FamilyManagerApp
//
//  Created by ESI on 15/6/23.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "ApplyMain_OLViewController.h"
#import "AppConfiguration.h"

@interface ApplyMain_OLViewController ()

@end

@implementation ApplyMain_OLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData
{
    if (!cQueue) {
        //创建一个队列
        //cQueue = dispatch_queue_create("bxqueue", DISPATCH_QUEUE_CONCURRENT);
    }
    NSString *serverIP = __fm_userDefaults_serverIP;
    NSURL *url = [NSURL URLWithString:[serverIP stringByAppendingString:__fm_apiPath_queryApplyMain]];
    
    
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:30];
        request.HTTPMethod = @"POST";
        NSString *values = [NSString stringWithFormat:@"userID=%d&startTime=%@&endTime=%@",13,@"2015-06-01",@"2015-06-30"];
        request.HTTPBody = [values dataUsingEncoding:NSUTF8StringEncoding];
        NSOperationQueue *q = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request queue:q completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            LYCLog(@"data--------%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        }];
   
    LYCLog(@"come here");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.applyMainList.count;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
