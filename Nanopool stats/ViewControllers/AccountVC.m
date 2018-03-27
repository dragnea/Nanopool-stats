//
//  HomeVC.m
//  Nanopool stats
//
//  Created by Mihai Dragnea on 8/8/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "AccountVC.h"
#import "AddAccountVC.h"
#import "Account.h"
#import "DBController.h"
#import "NanopoolController.h"
#import "WorkersVC.h"
#import "PaymentsVC.h"
#import "SharesVC.h"
#import "EstimatedCalculatorVC.h"
#import "BottomMenuCell.h"
#import <Charts/Charts.h>

@interface AccountVC ()<ChartViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, AddAccountVCDelegate>
@property (nonatomic, weak) IBOutlet CombinedChartView *chartView;
@property (nonatomic, weak) IBOutlet UILabel *balanceTitleLabel;

@property (nonatomic, weak) IBOutlet UILabel *balanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *equivalentBalanceLabel;
@property (nonatomic, weak) IBOutlet DMSSegmentedBar *hashrateSelector;


@property (nonatomic, weak) IBOutlet UICollectionView *bottomMenuCollectionView;
@property (nonatomic, strong) NSMutableArray <BottomMenuItem*>*bottomMenuDataSource;

@property (nonatomic, strong) Account *account;
@property (nonatomic, strong) NSURL *apiURL;

@property (nonatomic, strong) NSArray *sortedCHartData;
@end

@implementation AccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTouched:)];
    
    self.apiURL = [NSURL URLWithString:@"https://api.nanopool.org/v1"];
    
    self.balanceTitleLabel.textColor = [UIColor themeColorHighlightedHard];
    self.balanceLabel.textColor = [UIColor themeColorHighlightedHard];
    self.equivalentBalanceLabel.textColor = [UIColor themeColorHighlightBlue];
    
    self.view.backgroundColor = [UIColor themeColorBackground];
    
    /*
    self.hashrateSelector.backgroundColor = [UIColor themeColorBackgroundDark];
    self.hashrateSelector.borderColor = [UIColor themeColorHighlightedSoft];
    self.hashrateSelector.textColorNormal = [UIColor themeColorHighlightedSoft];
    self.hashrateSelector.textColorDisabled = [UIColor themeColorHighlightedSoft];
    self.hashrateSelector.textColorHighlighted = [UIColor themeColorHighlightBlue];
    self.hashrateSelector.textColorSelected = [UIColor themeColorHighlightedMedium];
     */
    
    self.hashrateSelector.segments = [Account avgHashrateLabels];
    self.hashrateSelector.backgroundColor = self.view.backgroundColor;
    self.hashrateSelector.borderColor = [UIColor themeColorHighlightedSoft];
    self.hashrateSelector.textColorNormal = [UIColor themeColorHighlightedSoft];
    self.hashrateSelector.textColorDisabled = [UIColor themeColorHighlightedSoft];
    self.hashrateSelector.textColorHighlighted = [UIColor themeColorHighlightBlue];
    self.hashrateSelector.textColorSelected = [UIColor themeColorHighlightedHard];
    
    self.chartView.chartDescription.enabled = NO;
    self.chartView.drawBarShadowEnabled = NO;
    self.chartView.highlightFullBarEnabled = NO;
    self.chartView.drawOrder = @[@(CombinedChartDrawOrderLine), @(CombinedChartDrawOrderBar)];
    self.chartView.minOffset = 0.0;
    self.chartView.delegate = self;
    self.chartView.autoScaleMinMaxEnabled = YES;
    self.chartView.legend.form = ChartLegendFormCircle;
    self.chartView.highlightPerTapEnabled = NO;
    self.chartView.legend.textColor = [UIColor themeColorHighlightedMedium];
    self.chartView.pinchZoomEnabled = NO;
    self.chartView.doubleTapToZoomEnabled = NO;
    [self.chartView animateWithXAxisDuration:0.4f easingOption:ChartEasingOptionEaseOutBounce];
    
    self.chartView.leftAxis.enabled = NO;
    
    self.chartView.rightAxis.enabled = YES;
    self.chartView.rightAxis.labelPosition = YAxisLabelPositionInsideChart;
    self.chartView.rightAxis.granularity = 1.0f;
    self.chartView.rightAxis.granularityEnabled = YES;
    self.chartView.rightAxis.drawGridLinesEnabled = YES;
    self.chartView.rightAxis.drawZeroLineEnabled = NO;
    self.chartView.rightAxis.drawAxisLineEnabled = NO;
    self.chartView.rightAxis.gridColor = [UIColor themeColorHighlightedSoft];
    self.chartView.rightAxis.labelTextColor = [UIColor themeColorHighlightedMedium];
    
    self.chartView.xAxis.labelPosition = XAxisLabelPositionBottom;
    self.chartView.xAxis.labelTextColor = [UIColor themeColorHighlightedSoft];
    self.chartView.xAxis.granularityEnabled = YES;
    self.chartView.xAxis.granularity = 1.0;
    self.chartView.xAxis.drawGridLinesEnabled = NO;
    self.chartView.xAxis.drawAxisLineEnabled = NO;
    self.chartView.xAxis.centerAxisLabelsEnabled = YES;
    self.chartView.xAxis.drawLabelsEnabled = NO;
    
    self.chartView.extraTopOffset = 6.0f;
    self.chartView.extraBottomOffset = 10.0f;
    
    [self updateAccount];
    [self updateCharts];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAccountNotification:) name:NanopoolControllerDidUpdateAccountNotification object:nil];
    
    [[NanopoolController sharedInstance] updateAccount:self.account];
    [[NanopoolController sharedInstance] updateChartDataWithAccount:self.account];
    
    
    [BottomMenuCell registerNibInCollectionView:self.bottomMenuCollectionView];
    
    self.bottomMenuDataSource = [NSMutableArray array];
    [self.bottomMenuDataSource addObject:[[BottomMenuItem alloc] initWithTitle:@"Workers" detail:@"All active" selector:@selector(showWorkers)]];
    [self.bottomMenuDataSource addObject:[[BottomMenuItem alloc] initWithTitle:@"Payouts" detail:@"4 days ago" selector:@selector(showPayouts)]];
    [self.bottomMenuDataSource addObject:[[BottomMenuItem alloc] initWithTitle:@"Calculator" detail:@"See details" selector:@selector(showCalculator)]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NanopoolControllerDidUpdateAccountNotification object:nil];
}

- (void)addButtonTouched:(UIBarButtonItem *)barButtonItem {
    AddAccountVC *addAccountVC = [[AddAccountVC alloc] init];
    addAccountVC.delegate = self;
    [self.navigationController pushViewController:addAccountVC animated:YES];
}

- (IBAction)hashrateSelectorChanged:(DMSSegmentedBar *)sender {
    self.account.selectedAvgHashrateIndex = sender.selectedIndex;
    [self updateAccount];
    [self updateCharts];
}

- (void)showWorkers {
    WorkersVC *workersVC = [[WorkersVC alloc] initWithAddress:self.account.address];
    [self.navigationController pushViewController:workersVC animated:YES];
}

- (void)showPayouts {
    PaymentsVC *paymentsVC = [[PaymentsVC alloc] initWithAddress:self.account.address];
    [self.navigationController pushViewController:paymentsVC animated:YES];
}

- (void)showShares {
    SharesVC *sharesVC = [[SharesVC alloc] initWithAddress:self.account.address];
    [self.navigationController pushViewController:sharesVC animated:YES];
}

- (void)showCalculator {
    EstimatedCalculatorVC *calculatorVC = [[EstimatedCalculatorVC alloc] initWithAddress:self.account.address];
    [self.navigationController pushViewController:calculatorVC animated:YES];
}

- (void)updateAccountNotification:(NSNotification *)notification {
    [self updateAccount];
    [self updateCharts];
}

- (void)updateAccount {
    self.account = [Account entitiesInContext:[DBController mainContext] predicate:[NSPredicate predicateWithFormat:@"isCurrent == YES"]].firstObject;
    self.hashrateSelector.selectedIndex = self.account.selectedAvgHashrateIndex;
    self.balanceLabel.text = [NSString stringWithFormat:@"%f %@", self.account.balance, [Account currencyForType:self.account.type]];
    
    NSAttributedString *dollarValueString = [[NSAttributedString alloc] initWithString:@"304.43 $" attributes:@{NSForegroundColorAttributeName: [UIColor themeColorHighlightedMedium]}];
    NSMutableAttributedString *valueString = [[NSMutableAttributedString alloc] initWithAttributedString:dollarValueString];
    [valueString appendAttributedString:[[NSAttributedString alloc] initWithString:@" • " attributes:@{NSForegroundColorAttributeName: [UIColor themeColorHighlightedSoft]}]];
    [valueString appendAttributedString:[[NSAttributedString alloc] initWithString:@"0.0343449 BTC" attributes:@{NSForegroundColorAttributeName: [UIColor themeColorHighlightedMedium]}]];
    self.equivalentBalanceLabel.text = [NSString stringWithFormat:@"%f • %f", 304.0343f, 0.034935523f];
    
    NSPredicate *historyPredicate = [NSPredicate predicateWithFormat:@"date > %f", [[Account dateForAvgHour:self.account.selectedAvgHashrateIndex] timeIntervalSince1970]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    self.sortedCHartData = [[self.account.chartData filteredSetUsingPredicate:historyPredicate] sortedArrayUsingDescriptors:@[sortDescriptor]];
}

- (NSString *)formattedStringForHashrate:(double)hashrate {
    if (hashrate == 0.0f) {
        return @"0h";
    } else if (hashrate > 1024.0f * 1024.0f) {
        return [NSString stringWithFormat:@"%.2fTh", hashrate / 1024.0f / 1024.0f];
    } else if (hashrate > 1024.0f) {
        return [NSString stringWithFormat:@"%.2fGh", hashrate / 1024.0f];
    } else {
        return [NSString stringWithFormat:@"%ldMh", lround(hashrate)];
    }
}

- (LineChartData *)lineChartData {
    NSMutableArray *dataEntries = [NSMutableArray array];
    NSArray <NSNumber *>*hashrates = [self.sortedCHartData valueForKeyPath:@"hashrate"];
    for (int index = 0; index < hashrates.count; index++) {
        ChartDataEntry *dataEntry = [[ChartDataEntry alloc] initWithX:index y:hashrates[index].doubleValue];
        [dataEntries addObject:dataEntry];
    }
    
    UIColor *lineColor = [UIColor themeColorHighlightBlue];
    
    NSString *hashrateTitle = [NSString stringWithFormat:@"Reported hashrate (avg %@)", [self formattedStringForHashrate:self.account.selectedAvgHashrate * 1000]];
    LineChartDataSet *lineDataSet = [[LineChartDataSet alloc] initWithValues:dataEntries label:hashrateTitle];
    [lineDataSet setColor:lineColor];
    lineDataSet.lineWidth = 1.0;
    lineDataSet.drawCirclesEnabled = NO;
    lineDataSet.mode = LineChartModeCubicBezier;
    lineDataSet.drawValuesEnabled = YES;
    lineDataSet.valueFont = [UIFont systemFontOfSize:12.f];
    lineDataSet.valueTextColor = [UIColor themeColorHighlightedSoft];
    lineDataSet.axisDependency = AxisDependencyLeft;
    lineDataSet.valueFormatter = [ChartDefaultValueFormatter withBlock:^NSString *(double value, ChartDataEntry *dataEntry, NSInteger x, ChartViewPortHandler *portHandler) {
        return [self formattedStringForHashrate:value];
    }];
    
    NSArray *gradientArray = @[(__bridge id)lineColor.CGColor, (__bridge id)[UIColor clearColor].CGColor];
    CGFloat gradientColorLocations[2] = {1.0f, 0.0f};
    CGGradientRef gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), (__bridge CFArrayRef)gradientArray, gradientColorLocations);
    ChartFill *lineFill = [[ChartFill alloc] initWithLinearGradient:gradient angle:90.0];
    CGGradientRelease(gradient);
    lineDataSet.fill = lineFill;
    lineDataSet.drawFilledEnabled = YES;
    lineDataSet.drawValuesEnabled = NO;

    LineChartData *lineData = [[LineChartData alloc] init];
    [lineData addDataSet:lineDataSet];
    return lineData;
}

- (BarChartData *)barChartData {
    NSMutableArray<BarChartDataEntry *> *entries1 = [[NSMutableArray alloc] init];
    NSArray <NSNumber *>*shares = [self.sortedCHartData valueForKeyPath:@"shares"];
    double maxLines = [self.chartView.lineData getYMaxWithAxis:AxisDependencyLeft] / 2.0;
    double maxBars = [[shares valueForKeyPath:@"@max.doubleValue"] doubleValue];
    double avgShares = [[shares valueForKeyPath:@"@avg.doubleValue"] doubleValue];
    double scale = maxLines / maxBars;
    for (int index = 0; index < shares.count; index++) {
        [entries1 addObject:[[BarChartDataEntry alloc] initWithX:index y:shares[index].integerValue * scale]];
    }
    
    BarChartDataSet *barChartDataSet = [[BarChartDataSet alloc] initWithValues:entries1 label:[NSString stringWithFormat:@"Shares (avg %.0f)", avgShares]];
    [barChartDataSet setColor:[UIColor themeColorHighlightRed]];
    barChartDataSet.valueTextColor = [UIColor themeColorHighlightRed];
    barChartDataSet.valueFont = [UIFont systemFontOfSize:10.f];
    barChartDataSet.axisDependency = AxisDependencyLeft;
    barChartDataSet.drawValuesEnabled = NO;
    
    BarChartData *barChartData = [[BarChartData alloc] initWithDataSet:barChartDataSet];
    barChartData.barWidth = 0.5;
    return barChartData;
}

- (void)updateCharts {
    CombinedChartData *combinedChartData = [[CombinedChartData alloc] init];
    combinedChartData.lineData = [self lineChartData];
    combinedChartData.barData = [self barChartData];
    //self.chartView.xAxis.axisMaximum = combinedChartData.xMax * 0.25;
    self.chartView.data = combinedChartData;
    
    NSArray <NSNumber *>*timestamps = [self.sortedCHartData valueForKeyPath:@"date"];
    NSMutableArray *dates = [NSMutableArray array];
    for (NSNumber *dateTimestamp in timestamps) {
        [dates addObject:[DateFormatter stringFromTimeInterval:dateTimestamp.doubleValue]];
    }
    self.chartView.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:dates];
    self.chartView.rightAxis.valueFormatter = [ChartDefaultAxisValueFormatter withBlock:^NSString *(double value, ChartAxisBase *axis) {
        return [self formattedStringForHashrate:value];
    }];
    
    [self.chartView animateWithYAxisDuration:0.4f easingOption:ChartEasingOptionEaseOutCirc];
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase *)chartView entry:(ChartDataEntry *)entry highlight:(ChartHighlight *)highlight {
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width / self.bottomMenuDataSource.count, collectionView.bounds.size.height);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.bottomMenuDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BottomMenuCell *cell = [BottomMenuCell cellInCollectionView:collectionView atIndexPath:indexPath];
    cell.item = self.bottomMenuDataSource[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SEL selector = self.bottomMenuDataSource[indexPath.item].selector;
    performMethod(self, selector);
}

#pragma mark - AddAccountVCDelegate

- (void)addAccountVC:(AddAccountVC *)addAccountVC didAddAccountName:(NSString *)name address:(NSString *)address type:(int16_t)type {
    // TODO: implement a loader
}

@end
