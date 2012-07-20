//
//  CalculatorViewController.m
//  Calculator
//
//  Created by 式正 鍋田 on 12/07/03.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphViewController.h"
#import "SplitViewBarButtonItemPresenter.h"

@interface CalculatorViewController () <SplitViewBarButtonItemPresenter>
@property (nonatomic) BOOL userInTheMiddleOfEnteringANumber;
@property (nonatomic,strong) CalculatorBrain *brain;
@property (nonatomic,strong) NSDictionary* testVariableValues;
@end

@implementation CalculatorViewController
@synthesize display;
@synthesize history;
@synthesize userInTheMiddleOfEnteringANumber;
@synthesize brain=_brain;
@synthesize testVariableValues=_testVariableValues;
@synthesize splitViewBarButtonItem=_splitViewBarButtonItem;

-(NSDictionary*) variableValues
{
    if(! _testVariableValues){
        _testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithDouble:0], @"x",
                           [NSNumber numberWithDouble:0], @"a",
                           [NSNumber numberWithDouble:0], @"b", nil];
    }
    return _testVariableValues;
}

-(CalculatorBrain*) brain
{
    if(!_brain){
        _brain=[[CalculatorBrain alloc] init];
    }
    return _brain;
}

// Requiredtask#4
// Hitting Undo when the user is in the middle of typing should take back the last digit or 
// decimal point pressed until doing so would clear the display entirely at which point it should
// show the result of running the brain's current program in the display( and now the user 
// is clearly not in the middle of typing, so take care of that)
- (IBAction)undoPressed {
    if(userInTheMiddleOfEnteringANumber){
        self.display.text=[self.display.text substringToIndex:self.display.text.length-1];
    } else {
        id topOfStack = [self.brain popStack];
        if ([topOfStack isKindOfClass:[NSString class]]){
            self.display.text=@"";
        }
        double result=[CalculatorBrain runProgram:self.brain.program usingVariableValues:self.testVariableValues];
        self.display.text=[NSString stringWithFormat:@"%g", result];
        self.history.text=[CalculatorBrain descriptionOfProgram:self.brain.program];
    }
}


- (IBAction)floatingPointPressed {
    NSRange range=[self.display.text rangeOfString:@"."];
    if(range.location == NSNotFound){
        self.display.text=[self.display.text stringByAppendingString:@"."];
        userInTheMiddleOfEnteringANumber=YES;
    }
}
- (IBAction)clearPressed {
    [self.brain clearStack];
    self.history.text=@"";
    self.display.text=@"0";
    userInTheMiddleOfEnteringANumber=NO;
}

- (IBAction)digitPressed:(UIButton*)sender {
    NSString* digit=[sender currentTitle];
    if(userInTheMiddleOfEnteringANumber){
        self.display.text=[self.display.text stringByAppendingString:digit];
    } else {
        self.display.text=digit;
        userInTheMiddleOfEnteringANumber=YES;
    }
}
- (IBAction)enterPressed 
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.history.text=[CalculatorBrain descriptionOfProgram:self.brain.program];
    userInTheMiddleOfEnteringANumber=NO;
}

- (IBAction)operationPressed:(id)sender {
    if(userInTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    NSString *operation=[sender currentTitle];
    double result= [self.brain performOperation:operation];
    self.display.text=[NSString stringWithFormat:@"%g", result];
    self.history.text=[CalculatorBrain descriptionOfProgram:self.brain.program];
}
- (void)viewDidUnload {
    [self setDisplay:nil];
    [self setHistory:nil];
    [super viewDidUnload];
}

- (GraphViewController *)splitViewGraphViewController
{
    id gvc = [self.splitViewController.viewControllers lastObject];
    if (![gvc isKindOfClass:[GraphViewController class]]) {
        gvc = nil;
    }
    return gvc;
}
- (IBAction)graphPressed {
    if ([self splitViewGraphViewController]) {
        [self splitViewGraphViewController].program = self.brain.program; 
    } else {
        // else segue using ShowDiagnosis
        [self performSegueWithIdentifier:@"ShowGraph" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowGraph"]) {
        [segue.destinationViewController setProgram:self.brain.program];
    }
}

#pragma mark - UISplitViewControllerDelegate
//
//
//
- (void)awakeFromNib  // always try to be the split view's delegate
{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

- (id <SplitViewBarButtonItemPresenter>)splitViewBarButtonItemPresenter
{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if (![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]) {
        detailVC = nil;
    }
    return detailVC;
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return [self splitViewBarButtonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation) : NO;
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = self.title;
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}



@end
