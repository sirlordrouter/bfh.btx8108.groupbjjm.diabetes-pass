//
//  CheckupViewController.m
//  bti8108.groupbjjm.diabetespass
//
//  Created by Johannes Gnägi on 06.11.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import "CheckupViewController.h"


@interface CheckupViewController ()

@end

@implementation CheckupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    //Instantiate all the controllers for page views
    CheckupPageViewController *checkupViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckupPageContentViewController"];
    checkupViewController.pageIndex = 0;
    BlutzuckerPageViewController *blutzuckerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BlutzuckerPageContentViewController"];
    blutzuckerViewController.pageIndex = 1;
    BlutdruckPageViewController *blutdruckViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BlutdruckPageContentViewController"];
    blutdruckViewController.pageIndex = 2;
    PulsPageViewController *pulsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PulsPageContentViewController"];
    pulsViewController.pageIndex = 3;
    GewichtPageViewController *gewichtViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GewichtPageContentViewController"];
    gewichtViewController.pageIndex = 4;

    //collection with controllers
    _controllers = @[checkupViewController,blutzuckerViewController, blutdruckViewController, pulsViewController, gewichtViewController];
    BasePageViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
     
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BasePageViewController *)viewControllerAtIndex:(NSUInteger)index
{
    return [_controllers objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((CheckupPageViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((CheckupPageViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [_controllers count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [_controllers count]; //no titles
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
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
