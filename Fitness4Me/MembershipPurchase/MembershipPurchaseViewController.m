//
//  MembershipPurchaseViewController.m
//  Fitness4Me
//
//  Created by Ciby  on 11/12/12.
//
//

#import "MembershipPurchaseViewController.h"
#import "CustomWorkoutsViewController.h"

@interface MembershipPurchaseViewController ()

@end

@implementation MembershipPurchaseViewController
@synthesize workout;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:[Fitness4MeUtils getBundle]];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickQuit:(id)sender {
    if ([self.navigateTo isEqualToString:@"List"]) {
        CustomWorkoutsViewController *viewController;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            viewController =[[CustomWorkoutsViewController alloc]initWithNibName:@"CustomWorkoutsViewController" bundle:nil];
        }else {
            //viewController =[[HintsViewController alloc]initWithNibName:@"CustomizedWorkoutListViewController_iPad" bundle:nil];
        }
        [self.navigationController pushViewController:viewController animated:YES];
        
        
    }
    else
    {
        ShareFitness4MeViewController *viewController;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            viewController = [[ShareFitness4MeViewController alloc]initWithNibName:@"ShareFitness4MeViewController" bundle:nil];
        }
        else {
            viewController = [[ShareFitness4MeViewController alloc]initWithNibName:@"ShareFitness4MeViewController_iPad" bundle:nil];
        }
        viewController.imageUrl =[self.workout ImageUrl];
        viewController.imageName =[self.workout ImageName];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
@end