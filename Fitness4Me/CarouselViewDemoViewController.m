//
//  CarouselViewDemoViewController.m
//  CarouselViewDemo
//
//  Created by kastet on 14.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CarouselViewDemoViewController.h"
#import "ASIHTTPRequest.h"


@interface CarouselViewDemoViewController ()

@end
@implementation CarouselViewDemoViewController
@synthesize workout,myQueue;

//@synthesize dataSourceArray = _dataSourceArray;

NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:[Fitness4MeUtils getBundle]];
    if (self) {
        self.dataSourceArray = [[NSMutableArray alloc]init];
        userinfo=[NSUserDefaults standardUserDefaults];
    }
    return self;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.backgroundLabel.layer setCornerRadius:10];
    [self.totalVideoCountLabel setText:[NSString stringWithFormat:@"Number of excersices [%i]",self.videoCount]];
    [self.durationLabel setText:[NSString stringWithFormat:@"Total Time [%@]",[Fitness4MeUtils displayTimeWithSecond:self.totalDuration]]];
    
    self.view.transform = CGAffineTransformConcat(self.view.transform, CGAffineTransformMakeRotation(M_PI_2));
    [self.recoverySegmentControl setSelectedSegmentIndex:-1];
    [self.moveSegmentControl setSelectedSegmentIndex:-1];
    // add continue button
    UIButton *backutton = [UIButton buttonWithType:UIButtonTypeCustom];
    backutton.frame = CGRectMake(0, 0, 58, 30);
    [backutton setBackgroundImage:[UIImage imageNamed:@"back_btn_with_text.png"] forState:UIControlStateNormal];
    [backutton addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:backutton];
    self.navigationBar.leftBarButtonItem = backBtn;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(0, 0, 58, 30);
    [nextButton setBackgroundImage:[UIImage imageNamed:@"next_btn_with_text.png"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(onClickNext:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    self.navigationBar.rightBarButtonItem = nextBtn;
    
    if ([self.operationMode isEqualToString:@"Edit"]) {
        
    }
    else
    {
        [self.addMoreButton removeFromSuperview];
    }

    if([GlobalArray count]>2)
    {
     [self.carousel scrollToItemAtIndex:[GlobalArray count]-2 animated:NO];
    }
}

- (void)viewDidUnload {
    [self setRecoverySegmentControl:nil];
    [self setMoveSegmentControl:nil];
    [self setBackgroundLabel:nil];
    [super viewDidUnload];
}


#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [GlobalArray count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)] autorelease];
        ((UIImageView *)view).image = [self imageForRowAtIndexPath:[GlobalArray objectAtIndex:index] inIndexPath:index];
        view.contentMode = UIViewContentModeTop;
        label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 30)] autorelease];
        label.backgroundColor = [UIColor clearColor];
        label.font = [label.font fontWithSize:12];
        label.tag = 1;
        label.textColor=[UIColor blackColor];
        [view addSubview:label];
        
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
        
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    label.text = [[GlobalArray objectAtIndex:index] name];
    
    return view;
}


- (UIImage *)imageForRowAtIndexPath:(ExcersiceList *)excersiceList inIndexPath:(NSUInteger)indexPath
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    dataPath = [documentsDirectory stringByAppendingPathComponent:@"MyFolder/SelfMadeThumbs"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString  *storeURL= [dataPath stringByAppendingPathComponent :[excersiceList imageName]];
    UIImageView *excersiceImageHolder =[[UIImageView alloc]init];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:storeURL]){
        UIImage *im =[UIImage imageNamed:@"page.png"];
        excersiceImageHolder.image =im;
        [self.myQueue setDelegate:self];
        [self.myQueue setShowAccurateProgress:YES];
        [self.myQueue setRequestDidFinishSelector:@selector(requestFinisheds:)];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[excersiceList imageUrl]]];
        [request setDownloadDestinationPath:storeURL];
        [request setDelegate:self];
        [request startAsynchronous];
        [myQueue addOperation:[request copy]];
        [myQueue go];
    }else {
        UIImage *im =[[UIImage alloc]initWithContentsOfFile:storeURL];
        excersiceImageHolder.image=im;
    }
	
    return excersiceImageHolder.image;
    
}

- (void)requestFinisheds:(ASINetworkQueue *)queue
{
    [self.carousel reloadData];
}


#pragma mark - Carousel DataSource

- (void)carousel: (iCarousel *)_carousel didSelectItemAtIndex:(NSInteger)index
{
    [self.carousel itemViewAtIndex:index].alpha=.8f;
    [self.carousel itemViewAtIndex: self.selectedIndex].alpha=1; 
     self.selectedIndex=index;
}


#pragma mark - IBActions


-(IBAction) segmentedControlIndexChanged{
    
    
    ExcersiceList *list= [[ExcersiceList alloc]init];
    
    if (self.selectedIndex >0) {
        
        
        switch (self.recoverySegmentControl.selectedSegmentIndex) {
            case 0:
                
                list.name=@"recovery 15";
                list.imageName= @"page.png";
                list.excersiceID=@"rec15";
                list.time=@"900";
                list.repetitions=@"1";
                [GlobalArray insertObject:list atIndex: self.selectedIndex];
                self.videoCount++;
                self.totalDuration=self.totalDuration+ 900;
                
                
                break;
            case 1:
                list.name=@"recovery 30";
                list.imageName= @"page.png";
                list.excersiceID=@"rec30";
                list.time=@"1800";
                list.repetitions=@"1";
                [GlobalArray insertObject:list atIndex: self.selectedIndex];
                self.videoCount++;
                self.totalDuration=self.totalDuration+ 1800;
                break;
                
            default:
                break;
        }
    }
    
    [self.carousel reloadData];
    [self.durationLabel setText:[NSString stringWithFormat:@"Total Time [%@]",[Fitness4MeUtils displayTimeWithSecond:self.totalDuration]]];
    [self.recoverySegmentControl setSelectedSegmentIndex:-1];
    
}

- (IBAction)onClickMove:(id)sender {
    switch (self.moveSegmentControl.selectedSegmentIndex) {
        case 0:
            if ( self.selectedIndex>0) {
                [GlobalArray exchangeObjectAtIndex: self.selectedIndex withObjectAtIndex: self.selectedIndex-1];
            }
            
            break;
        case 1:
            
            if (self.selectedIndex<[GlobalArray count]-1) {
                
                [GlobalArray exchangeObjectAtIndex:self.selectedIndex withObjectAtIndex:self.selectedIndex+1];
                
            }
            break;
            
            
        case 2:
            [self removeSelectedColumn];
            break;
        default:
            break;
    }
    [self.carousel reloadData];
    [self.moveSegmentControl setSelectedSegmentIndex:-1];
}

-(IBAction)onClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)onClickNext:(id)sender{
    
    NSString *str= [[NSString alloc]init];
    for (ExcersiceList *excerlist in GlobalArray) {
        
        if ([str length]==0) {
            str =[str stringByAppendingString:[excerlist excersiceID]];
        }
        else{
            str=[str stringByAppendingString:@","];
            str =[str stringByAppendingString:[excerlist excersiceID]];
        }
    }
    
    [userinfo setObject:str forKey:@"SelectedWorkouts"];
    
    NameViewController *viewController =[[NameViewController alloc]initWithNibName:@"NameViewController" bundle:nil];
    viewController.workout= [[Workout alloc]init];
    viewController.workout =self.workout;
    [viewController setCollectionString:str];
    [viewController setEquipments:self.equipments];
    
    [viewController setFocusList:self.focusList];
    
    [self.navigationController pushViewController:viewController animated:YES];
}


- (IBAction)removeSelectedColumn {
    if ([GlobalArray count]>1) {
        self.videoCount--;
        self.totalDuration=self.totalDuration- ([[[GlobalArray objectAtIndex:self.selectedIndex] time]intValue]*[[[GlobalArray objectAtIndex:self.selectedIndex] repetitions]intValue]);
        [GlobalArray removeObjectAtIndex:self.selectedIndex];
        [self.totalVideoCountLabel setText:[NSString stringWithFormat:@"Number of excersices [%i]",self.videoCount]];
        [self.durationLabel setText:[NSString stringWithFormat:@"Total Time [%@]",[Fitness4MeUtils displayTimeWithSecond:self.totalDuration]]];
        
        
        NSString *str= [[NSString alloc]init];
        for (ExcersiceList *excerlist in GlobalArray) {
            if ([str length]==0) {
                str =[str stringByAppendingString:[excerlist excersiceID]];
            }
            else{
                str=[str stringByAppendingString:@","];
                str =[str stringByAppendingString:[excerlist excersiceID]];
            }
        }
        
        [userinfo setObject:str forKey:@"SelectedWorkouts"];
    }
    
    
}



- (IBAction)addMoreExcersices:(id)sender {
    FocusViewController *viewController =[[FocusViewController alloc]initWithNibName:@"FocusViewController" bundle:nil];
    viewController.workout =[[Workout alloc]init];
    viewController .workout=self.workout;
    [self.navigationController pushViewController:viewController animated:YES];
    
}


#pragma mark - view orientation Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate {
    return YES;
}


@end