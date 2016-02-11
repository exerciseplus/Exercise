//
//  HomeRunCollectionViewController.m
//  Exercise+
//
//  Created by wzy on 16/2/3.
//  Copyright © 2016年 王振宇. All rights reserved.
//

#import "HomeRunCollectionViewController.h"
#import <CSStickyHeaderFlowLayout/CSStickyHeaderFlowLayout.h>
#import "SectionHeader.h"
#import "HomeRunCell.h"
#import "MapHeaderCell.h"
#import "RunController.h"
#import "Run.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface HomeRunCollectionViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) UINib *headerNib;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic,strong)MKMapView *mapView;
@end

@implementation HomeRunCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
//@{@"Twitter":@"http://twitter.com"},

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.sections = @[
                          @{@"Facebook":@"http://facebook.com"},
                          @{@"Tumblr":@"http://tumblr.com"},
                          @{@"Pinterest":@"http://pinterest.com"},
                          @{@"Instagram":@"http://instagram.com"},
                          @{@"Github":@"http://github.com"},
                          ];
        
        self.headerNib = [UINib nibWithNibName:@"MapHeader" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadLayout];
    [self.collectionView registerNib:self.headerNib forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
withReuseIdentifier:@"header"];
    self.collectionView.showsVerticalScrollIndicator = false;
}


//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    [self reloadLayout];
//}

-(void)reloadLayout{
    CSStickyHeaderFlowLayout *layout = (id)self.collectionViewLayout;
    
    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        layout.parallaxHeaderReferenceSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height/3*2);
        layout.itemSize = CGSizeMake(layout.itemSize.width, layout.itemSize.height);
        NSLog(@"width%f",self.view.frame.size.width);

    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"width%f",self.view.frame.size.width);
   // [self reloadLayout];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reloadLayout];

    NSLog(@"width%f",self.view.frame.size.width);

}

- (IBAction)startToRun:(UIButton *)sender {
     RunController* runController = [[UIStoryboard storyboardWithName:@"RunActivity" bundle:nil] instantiateViewControllerWithIdentifier:@"runController"];
    runController.managedObjectContext = self.managedObjectContext;
//    [self.navigationController pushViewController:runController animated:true];
    runController.navigation = self.navigationController;
    [self presentViewController:runController animated:true completion:nil];
}

- (void)startLocationUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.activityType = CLActivityTypeFitness;
    
    // Movement threshold for new events.
    self.locationManager.distanceFilter = 10; // meters
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
     return [self.sections count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *obj = self.sections[indexPath.section];
    
    HomeRunCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeRunCell"
                                                             forIndexPath:indexPath];
    
    cell.textLabel.text = [[obj allValues] firstObject];
    NSString* indicator = @"\uf3d3";
    cell.indicatorLabel.text = indicator;
    //[cell setAccessibilityLabel:indicator];
    return cell;

}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        NSDictionary *obj = self.sections[indexPath.section];
        
        SectionHeader *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                   withReuseIdentifier:@"sectionHeader"
                                                                          forIndexPath:indexPath];
        
        cell.textLabel.text = [[obj allKeys] firstObject];
        return cell;
    } else if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        MapHeaderCell* cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                 withReuseIdentifier:@"header"
                                                                        forIndexPath:indexPath];
//        UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
//                                                                            withReuseIdentifier:@"header"
//                                                                                   forIndexPath:indexPath];
        [self startLocationUpdates];
        self.mapView = cell.mapView;
        self.mapView.delegate = self;
        
        cell.mapView.showsUserLocation = true;
        return cell;
    }
    return nil;
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500, 500);
    [self.mapView setRegion:region animated:YES];

}
#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
