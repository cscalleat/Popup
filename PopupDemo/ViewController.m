//
//  ViewController.m
//  PopupDemo
//
//  Created by Mark Miscavage on 4/19/15.
//  Copyright (c) 2015 Mark Miscavage. All rights reserved.
//

#import "ViewController.h"
#import "Popup.h"

BOOL hasRoundedCorners;

BOOL secure1;
BOOL secure2;
BOOL secure3;

BOOL setKey1;
BOOL setKey2;
BOOL setKey3;

int numFields = 0;

CGFloat width;

@interface ViewController () <PopupDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {

    NSString *titleText;
    NSString *subTitleText;
    NSString *cancelText;
    NSString *successText;

    NSString *keyboard1Type;
    NSString *keyboard2Type;
    NSString *keyboard3Type;

    PopupBackGroundBlurType blurType;
    PopupIncomingTransitionType incomingType;
    PopupOutgoingTransitionType outgoingType;
    
    Popup *popper;
    
    NSArray *keyboardTypes;
    NSArray *incomingTypes;
    NSArray *outgoingTypes;

}

@end

@implementation ViewController

#pragma mark View Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    width = self.view.frame.size.width;

    self.title = @"PopupDemo";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissEverything)];
    [tap setNumberOfTapsRequired:1];
    [tap setDelegate:self];
    [self.view addGestureRecognizer:tap];
    
    titleText = @"Title";
    subTitleText = @"Subtitle";
    cancelText = @"Cancel";
    successText = @"Success";
    
    [self setup];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Setup Methods

//--------------------------Title and Subtitle
- (void)setUpFirstLine {
    UITextField *titleField = [[UITextField alloc] initWithFrame:CGRectMake(8, 76, width/2 - 12, 30)];
    [titleField setText:titleText];
    [titleField setPlaceholder:@"Title"];
    [titleField setDelegate:self];
    [titleField setTag:1];
    [titleField setClearsOnBeginEditing:YES];
    [titleField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:titleField];
    
    UITextField *subTitleField = [[UITextField alloc] initWithFrame:CGRectMake(titleField.frame.size.width + 16, 76, width/2 - 12, 30)];
    [subTitleField setText:subTitleText];
    [subTitleField setPlaceholder:@"SubTitle"];
    [subTitleField setDelegate:self];
    [subTitleField setTag:2];
    [subTitleField setClearsOnBeginEditing:YES];
    [subTitleField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:subTitleField];
}

//--------------------------Cancel and Success Titles
- (void)setUpSecondLine {
    UITextField *successField = [[UITextField alloc] initWithFrame:CGRectMake(8, 114, width/2 - 12, 30)];
    [successField setText:successText];
    [successField setPlaceholder:@"Success Title"];
    [successField setDelegate:self];
    [successField setTag:3];
    [successField setClearsOnBeginEditing:YES];
    [successField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:successField];
    
    UITextField *cancelField = [[UITextField alloc] initWithFrame:CGRectMake(successField.frame.size.width + 16, 114, width/2 - 12, 30)];
    [cancelField setText:cancelText];
    [cancelField setPlaceholder:@"Cancel Title"];
    [cancelField setDelegate:self];
    [cancelField setTag:4];
    [cancelField setClearsOnBeginEditing:YES];
    [cancelField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:cancelField];
}

//--------------------------Blur label and buttons
- (void)setUpThirdLine {
    UILabel *blurLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 152, 40, 24)];
    [blurLabel setText:@"Blur:"];
    [self.view addSubview:blurLabel];
    
    UIButton *darkBtn = [[UIButton alloc] initWithFrame:CGRectMake(56, 154, 60, 24)];
    [darkBtn setBackgroundColor:[UIColor lightGrayColor]];
    [darkBtn setTitle:@"Dark" forState:UIControlStateNormal];
    [darkBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0]];
    [darkBtn.layer setCornerRadius:4.0];
    [darkBtn.layer setMasksToBounds:YES];
    [darkBtn setTag:5];
    [darkBtn addTarget:self action:@selector(setBlur:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:darkBtn];
    
    UIButton *lightBtn = [[UIButton alloc] initWithFrame:CGRectMake(124, 154, 60, 24)];
    [lightBtn setBackgroundColor:[UIColor lightGrayColor]];
    [lightBtn setTitle:@"Light" forState:UIControlStateNormal];
    [lightBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0]];
    [lightBtn.layer setCornerRadius:4.0];
    [lightBtn.layer setMasksToBounds:YES];
    [lightBtn setTag:6];
    [lightBtn addTarget:self action:@selector(setBlur:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lightBtn];
    
    UIButton *extraBtn = [[UIButton alloc] initWithFrame:CGRectMake(192, 154, 70, 24)];
    [extraBtn setBackgroundColor:[UIColor lightGrayColor]];
    [extraBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0]];
    [extraBtn setTitle:@"Extra Light" forState:UIControlStateNormal];
    [extraBtn.layer setCornerRadius:4.0];
    [extraBtn.layer setMasksToBounds:YES];
    [extraBtn setTag:7];
    [extraBtn addTarget:self action:@selector(setBlur:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:extraBtn];
    
    UIButton *noneBtn = [[UIButton alloc] initWithFrame:CGRectMake(270, 154, 50, 24)];
    [noneBtn setBackgroundColor:[UIColor lightGrayColor]];
    [noneBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0]];
    [noneBtn setTitle:@"None" forState:UIControlStateNormal];
    [noneBtn.layer setCornerRadius:4.0];
    [noneBtn.layer setMasksToBounds:YES];
    [noneBtn setTag:8];
    [noneBtn addTarget:self action:@selector(setBlur:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:noneBtn];
}

//--------------------------Incoming Transition
- (void)setUpFourthLine {
    UIButton *setIncomingTransitionBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 186, self.view.frame.size.width - 16, 30)];
    [setIncomingTransitionBtn.layer setCornerRadius:8.0];
    [setIncomingTransitionBtn.layer setMasksToBounds:YES];
    [setIncomingTransitionBtn setBackgroundColor:[UIColor grayColor]];
    [setIncomingTransitionBtn setTitle:@"Set Incoming Transition Type" forState:UIControlStateNormal];
    [setIncomingTransitionBtn addTarget:self action:@selector(setIncoming) forControlEvents:UIControlEventTouchUpInside];
    [setIncomingTransitionBtn setTag:99];
    [self.view addSubview:setIncomingTransitionBtn];
}

//--------------------------Outgoing Transition
- (void)setUpFifthLine {
    UIButton *setOutgoingTransitionBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 224, self.view.frame.size.width - 16, 30)];
    [setOutgoingTransitionBtn.layer setCornerRadius:8.0];
    [setOutgoingTransitionBtn.layer setMasksToBounds:YES];
    [setOutgoingTransitionBtn setBackgroundColor:[UIColor grayColor]];
    [setOutgoingTransitionBtn setTitle:@"Set Outgoing Transition Type" forState:UIControlStateNormal];
    [setOutgoingTransitionBtn addTarget:self action:@selector(setOutgoing) forControlEvents:UIControlEventTouchUpInside];
    [setOutgoingTransitionBtn setTag:100];
    [self.view addSubview:setOutgoingTransitionBtn];

}

//--------------------------Rounded corner button and switch
- (void)setUpSixthLine {
    UILabel *roundLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 266, 150, 24)];
    [roundLabel setText:@"Rounded Corners:"];
    [self.view addSubview:roundLabel];
    
    UISwitch *roundSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(166, 263, 40, 40)];
    [roundSwitch addTarget:self action:@selector(setRoundedCorners) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:roundSwitch];
}

//--------------------------Textfield label and buttons
- (void)setUpSeventhLine {
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 300, 90, 24)];
    [textLabel setText:@"Text Fields:"];
    [self.view addSubview:textLabel];
    
    UIButton *oneBtn = [[UIButton alloc] initWithFrame:CGRectMake(106, 300, 50, 24)];
    [oneBtn setBackgroundColor:[UIColor lightGrayColor]];
    [oneBtn setTitle:@"1" forState:UIControlStateNormal];
    [oneBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0]];
    [oneBtn.layer setCornerRadius:4.0];
    [oneBtn.layer setMasksToBounds:YES];
    [oneBtn setTag:9];
    [oneBtn addTarget:self action:@selector(setTextFields:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:oneBtn];
    
    UIButton *twoBtn = [[UIButton alloc] initWithFrame:CGRectMake(164, 300, 50, 24)];
    [twoBtn setBackgroundColor:[UIColor lightGrayColor]];
    [twoBtn setTitle:@"2" forState:UIControlStateNormal];
    [twoBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0]];
    [twoBtn.layer setCornerRadius:4.0];
    [twoBtn.layer setMasksToBounds:YES];
    [twoBtn setTag:10];
    [twoBtn addTarget:self action:@selector(setTextFields:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:twoBtn];
    
    UIButton *threeBtn = [[UIButton alloc] initWithFrame:CGRectMake(222, 300, 50, 24)];
    [threeBtn setBackgroundColor:[UIColor lightGrayColor]];
    [threeBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0]];
    [threeBtn setTitle:@"3" forState:UIControlStateNormal];
    [threeBtn.layer setCornerRadius:4.0];
    [threeBtn.layer setMasksToBounds:YES];
    [threeBtn setTag:11];
    [threeBtn addTarget:self action:@selector(setTextFields:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:threeBtn];
    
    UIButton *noneTextBtn = [[UIButton alloc] initWithFrame:CGRectMake(280, 300, 50, 24)];
    [noneTextBtn setBackgroundColor:[UIColor lightGrayColor]];
    [noneTextBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0]];
    [noneTextBtn setTitle:@"None" forState:UIControlStateNormal];
    [noneTextBtn.layer setCornerRadius:4.0];
    [noneTextBtn.layer setMasksToBounds:YES];
    [noneTextBtn setTag:12];
    [noneTextBtn addTarget:self action:@selector(setTextFields:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:noneTextBtn];

}

//--------------------------Textfield 1 secure entry and keyboard type
- (void)setUpEigthLine {
    UIButton *setOneFieldSecureBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 332, width/2-12, 28)];
    [setOneFieldSecureBtn setTitle:@"Textfield 1 secure?" forState:UIControlStateNormal];
    [setOneFieldSecureBtn.layer setCornerRadius:6.0];
    [setOneFieldSecureBtn.layer setMasksToBounds:YES];
    [setOneFieldSecureBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
    [setOneFieldSecureBtn setBackgroundColor:[UIColor lightGrayColor]];
    [setOneFieldSecureBtn addTarget:self action:@selector(setSecure:) forControlEvents:UIControlEventTouchUpInside];
    [setOneFieldSecureBtn setTag:13];
    [setOneFieldSecureBtn setAlpha:0.0];
    [self.view addSubview:setOneFieldSecureBtn];
    
    UIButton *setOneFieldKeyboardBtn = [[UIButton alloc] initWithFrame:CGRectMake(setOneFieldSecureBtn.frame.size.width + 14, 332, width/2-12, 28)];
    [setOneFieldKeyboardBtn setTitle:@"Set textfield 1 type" forState:UIControlStateNormal];
    [setOneFieldKeyboardBtn.layer setCornerRadius:6.0];
    [setOneFieldKeyboardBtn.layer setMasksToBounds:YES];
    [setOneFieldKeyboardBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
    [setOneFieldKeyboardBtn setBackgroundColor:[UIColor lightGrayColor]];
    [setOneFieldKeyboardBtn addTarget:self action:@selector(setKeyType:) forControlEvents:UIControlEventTouchUpInside];
    [setOneFieldKeyboardBtn setTag:14];
    [setOneFieldKeyboardBtn setAlpha:0.0];
    [self.view addSubview:setOneFieldKeyboardBtn];
}

//--------------------------Textfield 2 secure entry and keyboard type
- (void)setUpNinthLine {
    UIButton *setTwoFieldSecureBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 368, width/2-12, 28)];
    [setTwoFieldSecureBtn setTitle:@"Textfield 2 secure?" forState:UIControlStateNormal];
    [setTwoFieldSecureBtn.layer setCornerRadius:6.0];
    [setTwoFieldSecureBtn.layer setMasksToBounds:YES];
    [setTwoFieldSecureBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
    [setTwoFieldSecureBtn setBackgroundColor:[UIColor lightGrayColor]];
    [setTwoFieldSecureBtn addTarget:self action:@selector(setSecure:) forControlEvents:UIControlEventTouchUpInside];
    [setTwoFieldSecureBtn setTag:15];
    [setTwoFieldSecureBtn setAlpha:0.0];
    [self.view addSubview:setTwoFieldSecureBtn];
    
    UIButton *setTwoFieldKeyboardBtn = [[UIButton alloc] initWithFrame:CGRectMake(setTwoFieldSecureBtn.frame.size.width + 14, 368, width/2-12, 28)];
    [setTwoFieldKeyboardBtn setTitle:@"Set textfield 2 type" forState:UIControlStateNormal];
    [setTwoFieldKeyboardBtn.layer setCornerRadius:6.0];
    [setTwoFieldKeyboardBtn.layer setMasksToBounds:YES];
    [setTwoFieldKeyboardBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
    [setTwoFieldKeyboardBtn setBackgroundColor:[UIColor lightGrayColor]];
    [setTwoFieldKeyboardBtn addTarget:self action:@selector(setKeyType:) forControlEvents:UIControlEventTouchUpInside];
    [setTwoFieldKeyboardBtn setTag:16];
    [setTwoFieldKeyboardBtn setAlpha:0.0];
    [self.view addSubview:setTwoFieldKeyboardBtn];
}

//--------------------------Textfield 3 secure entry and keyboard type
- (void)setUpTenthLine {
    UIButton *setThreeFieldSecureBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 404, width/2-12, 28)];
    [setThreeFieldSecureBtn setTitle:@"Textfield 3 secure?" forState:UIControlStateNormal];
    [setThreeFieldSecureBtn.layer setCornerRadius:6.0];
    [setThreeFieldSecureBtn.layer setMasksToBounds:YES];
    [setThreeFieldSecureBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
    [setThreeFieldSecureBtn setBackgroundColor:[UIColor lightGrayColor]];
    [setThreeFieldSecureBtn addTarget:self action:@selector(setSecure:) forControlEvents:UIControlEventTouchUpInside];
    [setThreeFieldSecureBtn setTag:17];
    [setThreeFieldSecureBtn setAlpha:0.0];
    [self.view addSubview:setThreeFieldSecureBtn];
    
    UIButton *setThreeFieldKeyboardBtn = [[UIButton alloc] initWithFrame:CGRectMake(setThreeFieldSecureBtn.frame.size.width + 14, 404, width/2-12, 28)];
    [setThreeFieldKeyboardBtn setTitle:@"Set textfield 3 type" forState:UIControlStateNormal];
    [setThreeFieldKeyboardBtn.layer setCornerRadius:6.0];
    [setThreeFieldKeyboardBtn.layer setMasksToBounds:YES];
    [setThreeFieldKeyboardBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
    [setThreeFieldKeyboardBtn setBackgroundColor:[UIColor lightGrayColor]];
    [setThreeFieldKeyboardBtn addTarget:self action:@selector(setKeyType:) forControlEvents:UIControlEventTouchUpInside];
    [setThreeFieldKeyboardBtn setTag:18];
    [setThreeFieldKeyboardBtn setAlpha:0.0];
    [self.view addSubview:setThreeFieldKeyboardBtn];
}

//--------------------------Pop button
- (void)setUpEleventhLine {
    
    UIButton *popBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, self.view.frame.size.height - 48, self.view.frame.size.width - 16, 40)];
    [popBtn.layer setCornerRadius:8.0];
    [popBtn.layer setMasksToBounds:YES];
    [popBtn setBackgroundColor:[UIColor blueColor]];
    [popBtn setTitle:@"Pop me" forState:UIControlStateNormal];
    [popBtn addTarget:self action:@selector(showPopper) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popBtn];

}

//--------------------------Pickerviews for keyboard types
- (void)setUpTwelfthLine {
    
    keyboardTypes = @[@"DEFAULT",
                      @"ASCIICAPABLE",
                      @"NUMBERSANDPUNCTUATION",
                      @"URL",
                      @"NUMBER",
                      @"PHONE",
                      @"NAMEPHONE",
                      @"EMAIL",
                      @"DECIMAL",
                      @"TWITTER",
                      @"WEBSEARCH"];
    
    UIPickerView *picker1 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 180, width, 180)];
    [picker1 setDelegate:self];
    [picker1 setDataSource:self];
    [picker1 setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9]];
    [picker1 setShowsSelectionIndicator:YES];
    [picker1 setAlpha:0.0];
    [picker1 setTag:19];
    [self.view addSubview:picker1];
    
    UIPickerView *picker2 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 180, width, 180)];
    [picker2 setDelegate:self];
    [picker2 setDataSource:self];
    [picker2 setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9]];
    [picker2 setShowsSelectionIndicator:YES];
    [picker2 setAlpha:0.0];
    [picker2 setTag:20];
    [self.view addSubview:picker2];
    
    UIPickerView *picker3 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 180, width, 180)];
    [picker3 setDelegate:self];
    [picker3 setDataSource:self];
    [picker3 setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9]];
    [picker3 setShowsSelectionIndicator:YES];
    [picker3 setAlpha:0.0];
    [picker3 setTag:21];
    [self.view addSubview:picker3];
}

//--------------------------Pickerviews for Incoming/Outgoing types
- (void)setUpThirteenthLine {

    incomingTypes = @[@"BounceFromCenter",
                      @"SlideFromLeft",
                      @"SlideFromTop",
                      @"SlideFromBottom",
                      @"SlideFromRight",
                      @"EaseFromCenter",
                      @"AppearCenter",
                      @"FallWithGravity",
                      @"GhostAppear",
                      @"ShrinkAppear"];


    outgoingTypes = @[@"BounceFromCenter",
                      @"SlideToLeft",
                      @"SlideToTop",
                      @"SlideToBottom",
                      @"SlideToRight",
                      @"EaseToCenter",
                      @"DisappearCenter",
                      @"FallWithGravity",
                      @"GhostDisappear",
                      @"GrowDisappear"];
    
    UIPickerView *picker4 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 180, width, 180)];
    [picker4 setDelegate:self];
    [picker4 setDataSource:self];
    [picker4 setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9]];
    [picker4 setShowsSelectionIndicator:YES];
    [picker4 setAlpha:0.0];
    [picker4 setTag:22];
    [self.view addSubview:picker4];
    
    UIPickerView *picker5 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 180, width, 180)];
    [picker5 setDelegate:self];
    [picker5 setDataSource:self];
    [picker5 setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9]];
    [picker5 setShowsSelectionIndicator:YES];
    [picker5 setAlpha:0.0];
    [picker5 setTag:23];
    [self.view addSubview:picker5];
    
}

- (void)setup {
    
    //-------------------------------Line 1
    //Title and Subtitle
    [self setUpFirstLine];
    
    //-------------------------------Line 2
    //Cancel and Success Titles
    [self setUpSecondLine];

    //-------------------------------Line 3
    //Blur label and buttons
    [self setUpThirdLine];
    
    //-------------------------------Line 4
    //Incoming Transition
    [self setUpFourthLine];
    
    //-------------------------------Line 5
    //Outgoing Transition
    [self setUpFifthLine];
    
    //-------------------------------Line 6
    //Rounded corner button and switch
    [self setUpSixthLine];
 
    //-------------------------------Line 7
    //Textfield label and buttons
    [self setUpSeventhLine];
    
    //-------------------------------Line 8
    //Textfield 1 secure entry and keyboard type
    [self setUpEigthLine];
   
    //-------------------------------Line 9
    //Textfield 2 secure entry and keyboard type
    [self setUpNinthLine];

    //-------------------------------Line 10
    //Textfield 3 secure entry and keyboard type
    [self setUpTenthLine];

    //-------------------------------Line 11
    //Pop button
    [self setUpEleventhLine];
    
    //-------------------------------Line 12
    //Pickerviews for keyboard types
    [self setUpTwelfthLine];

    //-------------------------------Line 13
    //Pickerviews for Incoming/Outgoing types
    [self setUpThirteenthLine];
}

#pragma mark Setting Methods

- (void)setSecure:(id)sender {
    UIButton *button = (UIButton *)sender;

    if ([button tag] == 13) {
        if ([[button backgroundColor] isEqual:[UIColor lightGrayColor]]) {
            [button setBackgroundColor:[UIColor darkGrayColor]];
            secure1 = YES;
        }
        else {
            [button setBackgroundColor:[UIColor lightGrayColor]];
            secure1 = NO;
        }

    }
    else if ([button tag] == 15) {
        if ([[button backgroundColor] isEqual:[UIColor lightGrayColor]]) {
            [button setBackgroundColor:[UIColor darkGrayColor]];
            secure2 = YES;
        }
        else {
            [button setBackgroundColor:[UIColor lightGrayColor]];
            secure2 = NO;
        }
        
    }
    else if ([button tag] == 17) {
        if ([[button backgroundColor] isEqual:[UIColor lightGrayColor]]) {
            [button setBackgroundColor:[UIColor darkGrayColor]];
            secure3 = YES;
        }
        else {
            [button setBackgroundColor:[UIColor lightGrayColor]];
            secure3 = NO;
        }
        
    }
    
}

- (void)figureOutSecure {

    if (secure1 && !secure2 && !secure3) {
        [popper setTextFieldTypeForTextFields:@[@"PASSWORD"]];
    }
    else if (secure1 && secure2 && !secure3) {
        [popper setTextFieldTypeForTextFields:@[@"PASSWORD", @"PASSWORD"]];
    }
    else if (secure1 && secure2 && secure3) {
        [popper setTextFieldTypeForTextFields:@[@"PASSWORD", @"PASSWORD", @"PASSWORD"]];
    }
    else if (secure1 && !secure2 && secure3) {
        [popper setTextFieldTypeForTextFields:@[@"PASSWORD", @"", @"PASSWORD"]];
    }
    else if (!secure1 && secure2 && !secure3) {
        [popper setTextFieldTypeForTextFields:@[@"", @"PASSWORD"]];
    }
    else if (!secure1 && !secure2 && secure3) {
        [popper setTextFieldTypeForTextFields:@[@"", @"", @"PASSWORD"]];
    }
    else if (!secure1 && !secure2 && !secure3) {
        //none
    }
    else if (secure1 && !secure2 && secure3) {
        [popper setTextFieldTypeForTextFields:@[@"PASSWORD", @"", @"PASSWORD"]];
    }
    else if (!secure1 && secure2 && secure3) {
        [popper setTextFieldTypeForTextFields:@[@"", @"PASSWORD", @"PASSWORD"]];
    }

}

- (void)figureOutKeyboardType {
    
    UIButton *key1 = (UIButton *)[self.view viewWithTag:14];
    UIButton *key2 = (UIButton *)[self.view viewWithTag:16];
    UIButton *key3 = (UIButton *)[self.view viewWithTag:18];
    
    NSString *k1 = key1.titleLabel.text;
    NSString *k2 = key2.titleLabel.text;
    NSString *k3 = key3.titleLabel.text;
    
    keyboardTypes = @[@"DEFAULT",
                      @"ASCIICAPABLE",
                      @"NUMBERSANDPUNCTUATION",
                      @"URL",
                      @"NUMBER",
                      @"PHONE",
                      @"NAMEPHONE",
                      @"EMAIL",
                      @"DECIMAL",
                      @"TWITTER",
                      @"WEBSEARCH"];
    
    
    if (setKey1 && !setKey2 && !setKey3) {
        [popper setKeyboardTypeForTextFields:@[k1]];
    }
    else if (setKey1 && setKey2 && !setKey3) {
        [popper setKeyboardTypeForTextFields:@[k1, k2]];
    }
    else if (setKey1 && setKey2 && setKey3) {
        [popper setKeyboardTypeForTextFields:@[k1, k2, k3]];
    }
    else if (setKey1 && !setKey2 && setKey3) {
        [popper setKeyboardTypeForTextFields:@[k1, @"", k3]];
    }
    else if (!setKey1 && setKey2 && !setKey3) {
        [popper setKeyboardTypeForTextFields:@[@"", k2]];
    }
    else if (!setKey1 && !setKey2 && setKey3) {
        [popper setKeyboardTypeForTextFields:@[@"", @"", k3]];
    }
    else if (!setKey1 && !setKey2 && !setKey3) {
        //none
    }
    else if (setKey1 && !setKey2 && setKey3) {
        [popper setKeyboardTypeForTextFields:@[k1, @"", k3]];
    }
    else if (!setKey1 && setKey2 && setKey3) {
        [popper setKeyboardTypeForTextFields:@[@"", k2, k3]];
    }

    
    
}

- (void)setShowTextFieldBtns:(int)num {
    
    UIButton *button13 = (UIButton *)[self.view viewWithTag:13];
    UIButton *button14 = (UIButton *)[self.view viewWithTag:14];
    
    UIButton *button15 = (UIButton *)[self.view viewWithTag:15];
    UIButton *button16 = (UIButton *)[self.view viewWithTag:16];

    UIButton *button17 = (UIButton *)[self.view viewWithTag:17];
    UIButton *button18 = (UIButton *)[self.view viewWithTag:18];

    if (num == 12) {
        [button13 setAlpha:0.0];
        [button14 setAlpha:0.0];
        [button15 setAlpha:0.0];
        [button16 setAlpha:0.0];
        [button17 setAlpha:0.0];
        [button18 setAlpha:0.0];
    }
    else if (num == 9) {
        [button13 setAlpha:1.0];
        [button14 setAlpha:1.0];
        [button15 setAlpha:0.0];
        [button16 setAlpha:0.0];
        [button17 setAlpha:0.0];
        [button18 setAlpha:0.0];
    }
    else if (num == 10) {
        [button13 setAlpha:1.0];
        [button14 setAlpha:1.0];
        [button15 setAlpha:1.0];
        [button16 setAlpha:1.0];
        [button17 setAlpha:0.0];
        [button18 setAlpha:0.0];
    }
    else if (num == 11) {
        [button13 setAlpha:1.0];
        [button14 setAlpha:1.0];
        [button15 setAlpha:1.0];
        [button16 setAlpha:1.0];
        [button17 setAlpha:1.0];
        [button18 setAlpha:1.0];
    }

}

- (void)setRoundedCorners {
    
    if (hasRoundedCorners) {
        hasRoundedCorners = NO;
    }
    else {
        hasRoundedCorners = YES;
    }
    
}

- (void)setIncoming {
    [self.view endEditing:YES];
    
    UIPickerView *picker19 = (UIPickerView *)[self.view viewWithTag:19];
    UIPickerView *picker20 = (UIPickerView *)[self.view viewWithTag:20];
    UIPickerView *picker21 = (UIPickerView *)[self.view viewWithTag:21];
    UIPickerView *picker22 = (UIPickerView *)[self.view viewWithTag:22];
    UIPickerView *picker23 = (UIPickerView *)[self.view viewWithTag:23];

    if ([picker22 alpha] == 1.0) {
        [picker19 setAlpha:0.0];
        [picker20 setAlpha:0.0];
        [picker21 setAlpha:0.0];
        [picker22 setAlpha:0.0];
        [picker23 setAlpha:0.0];
    }
    else {
        [picker19 setAlpha:0.0];
        [picker20 setAlpha:0.0];
        [picker21 setAlpha:0.0];
        [picker22 setAlpha:1.0];
        [picker23 setAlpha:0.0];
    }
}

- (void)setOutgoing {
    [self.view endEditing:YES];
    
    UIPickerView *picker19 = (UIPickerView *)[self.view viewWithTag:19];
    UIPickerView *picker20 = (UIPickerView *)[self.view viewWithTag:20];
    UIPickerView *picker21 = (UIPickerView *)[self.view viewWithTag:21];
    UIPickerView *picker22 = (UIPickerView *)[self.view viewWithTag:22];
    UIPickerView *picker23 = (UIPickerView *)[self.view viewWithTag:23];
    
    if ([picker23 alpha] == 1.0) {
        [picker19 setAlpha:0.0];
        [picker20 setAlpha:0.0];
        [picker21 setAlpha:0.0];
        [picker22 setAlpha:0.0];
        [picker23 setAlpha:0.0];
    }
    else {
        [picker19 setAlpha:0.0];
        [picker20 setAlpha:0.0];
        [picker21 setAlpha:0.0];
        [picker22 setAlpha:0.0];
        [picker23 setAlpha:1.0];
    }

}

- (void)figureOutTransitions {

    UIButton *inBtn = (UIButton *)[self.view viewWithTag:99];
    UIButton *outBtn = (UIButton *)[self.view viewWithTag:100];

    NSString *inTitle = inBtn.titleLabel.text;
    NSString *outTitle = outBtn.titleLabel.text;
    
    //inTitle
    if ([inTitle isEqualToString:@"BounceFromCenter"]) {
        incomingType = PopupIncomingTransitionTypeBounceFromCenter;
    }
    else if ([inTitle isEqualToString:@"SlideFromLeft"]) {
        incomingType = PopupIncomingTransitionTypeSlideFromLeft;
    }
    else if ([inTitle isEqualToString:@"SlideFromTop"]) {
        incomingType = PopupIncomingTransitionTypeSlideFromTop;
    }
    else if ([inTitle isEqualToString:@"SlideFromBottom"]) {
        incomingType = PopupIncomingTransitionTypeSlideFromBottom;
    }
    else if ([inTitle isEqualToString:@"SlideFromRight"]) {
        incomingType = PopupIncomingTransitionTypeSlideFromRight;
    }
    else if ([inTitle isEqualToString:@"EaseFromCenter"]) {
        incomingType = PopupIncomingTransitionTypeEaseFromCenter;
    }
    else if ([inTitle isEqualToString:@"AppearCenter"]) {
        incomingType = PopupIncomingTransitionTypeAppearCenter;
    }
    else if ([inTitle isEqualToString:@"FallWithGravity"]) {
        incomingType = PopupIncomingTransitionTypeFallWithGravity;
    }
    else if ([inTitle isEqualToString:@"GhostAppear"]) {
        incomingType = PopupIncomingTransitionTypeGhostAppear;
    }
    else if ([inTitle isEqualToString:@"ShrinkAppear"]) {
        incomingType = PopupIncomingTransitionTypeShrinkAppear;
    }
    else {
        incomingType = PopupIncomingTransitionTypeFallWithGravity;
    }

    //outTitle
    if ([outTitle isEqualToString:@"BounceFromCenter"]) {
        outgoingType = PopupOutgoingTransitionTypeBounceFromCenter;
    }
    else if ([outTitle isEqualToString:@"SlideToLeft"]) {
        outgoingType = PopupOutgoingTransitionTypeSlideToLeft;
    }
    else if ([outTitle isEqualToString:@"SlideToTop"]) {
        outgoingType = PopupOutgoingTransitionTypeSlideToTop;
    }
    else if ([outTitle isEqualToString:@"SlideToBottom"]) {
        outgoingType = PopupOutgoingTransitionTypeSlideToBottom;
    }
    else if ([outTitle isEqualToString:@"SlideToRight"]) {
        outgoingType = PopupOutgoingTransitionTypeSlideToRight;
    }
    else if ([outTitle isEqualToString:@"EaseToCenter"]) {
        outgoingType = PopupOutgoingTransitionTypeEaseToCenter;
    }
    else if ([outTitle isEqualToString:@"DisappearCenter"]) {
        outgoingType = PopupOutgoingTransitionTypeDisappearCenter;
    }
    else if ([outTitle isEqualToString:@"FallWithGravity"]) {
        outgoingType = PopupOutgoingTransitionTypeFallWithGravity;
    }
    else if ([inTitle isEqualToString:@"GhostDisappear"]) {
        outgoingType = PopupOutgoingTransitionTypeGhostDisappear;
    }
    else if ([outTitle isEqualToString:@"GrowDisappear"]) {
        outgoingType = PopupOutgoingTransitionTypeGrowDisappear;
    }
    else {
        outgoingType = PopupOutgoingTransitionTypeBounceFromCenter;
    }
}

- (void)setBlur:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    UIButton *button5 = (UIButton *)[self.view viewWithTag:5];
    UIButton *button6 = (UIButton *)[self.view viewWithTag:6];
    UIButton *button7 = (UIButton *)[self.view viewWithTag:7];
    UIButton *button8 = (UIButton *)[self.view viewWithTag:8];
    
    if ([button tag] == 5) {
        if ([[button backgroundColor] isEqual:[UIColor lightGrayColor]]) {
            [button setBackgroundColor:[UIColor darkGrayColor]];
            blurType = PopupBackGroundBlurTypeDark;
        }
        else {
            blurType = PopupBackGroundBlurTypeNone;
            [button setBackgroundColor:[UIColor lightGrayColor]];
        }
        [button6 setBackgroundColor:[UIColor lightGrayColor]];
        [button7 setBackgroundColor:[UIColor lightGrayColor]];
        [button8 setBackgroundColor:[UIColor lightGrayColor]];
    }
    else if ([button tag] == 6) {
        if ([[button backgroundColor] isEqual:[UIColor lightGrayColor]]) {
            [button setBackgroundColor:[UIColor darkGrayColor]];
            blurType = PopupBackGroundBlurTypeLight;
        }
        else {
            [button setBackgroundColor:[UIColor lightGrayColor]];
            blurType = PopupBackGroundBlurTypeNone;
        }
        [button5 setBackgroundColor:[UIColor lightGrayColor]];
        [button7 setBackgroundColor:[UIColor lightGrayColor]];
        [button8 setBackgroundColor:[UIColor lightGrayColor]];
    }
    else if ([button tag] == 7) {
        if ([[button backgroundColor] isEqual:[UIColor lightGrayColor]]) {
            [button setBackgroundColor:[UIColor darkGrayColor]];
            blurType = PopupBackGroundBlurTypeExtraLight;
        }
        else {
            [button setBackgroundColor:[UIColor lightGrayColor]];
            blurType = PopupBackGroundBlurTypeNone;
        }
        [button5 setBackgroundColor:[UIColor lightGrayColor]];
        [button6 setBackgroundColor:[UIColor lightGrayColor]];
        [button8 setBackgroundColor:[UIColor lightGrayColor]];
    }
    else if ([button tag] == 8) {
        if ([[button backgroundColor] isEqual:[UIColor lightGrayColor]]) {
            [button setBackgroundColor:[UIColor darkGrayColor]];
            blurType = PopupBackGroundBlurTypeNone;
        }
        else {
            [button setBackgroundColor:[UIColor lightGrayColor]];
            blurType = PopupBackGroundBlurTypeNone;
        }
        [button5 setBackgroundColor:[UIColor lightGrayColor]];
        [button6 setBackgroundColor:[UIColor lightGrayColor]];
        [button7 setBackgroundColor:[UIColor lightGrayColor]];
    }
    
    
}

- (void)setKeyType:(id)sender {
    [self.view endEditing:YES];
    
    UIPickerView *picker19 = (UIPickerView *)[self.view viewWithTag:19];
    UIPickerView *picker20 = (UIPickerView *)[self.view viewWithTag:20];
    UIPickerView *picker21 = (UIPickerView *)[self.view viewWithTag:21];
    UIPickerView *picker22 = (UIPickerView *)[self.view viewWithTag:22];
    UIPickerView *picker23 = (UIPickerView *)[self.view viewWithTag:23];

    if ([sender tag] == 14) {
        [picker19 setAlpha:1.0];
        [picker20 setAlpha:0.0];
        [picker21 setAlpha:0.0];
        [picker22 setAlpha:0.0];
        [picker23 setAlpha:0.0];
    }
    else if ([sender tag] == 16) {
        [picker19 setAlpha:0.0];
        [picker20 setAlpha:1.0];
        [picker21 setAlpha:0.0];
        [picker22 setAlpha:0.0];
        [picker23 setAlpha:0.0];
    }
    else if ([sender tag] == 18) {
        [picker19 setAlpha:0.0];
        [picker20 setAlpha:0.0];
        [picker21 setAlpha:1.0];
        [picker22 setAlpha:0.0];
        [picker23 setAlpha:0.0];
    }

}

#pragma mark UIPickerView Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([pickerView tag] == 19 || [pickerView tag] == 20 || [pickerView tag] == 21) {
        return [keyboardTypes count];
    }
    else if ([pickerView tag] == 22) {
        return [incomingTypes count];
    }
    else if ([pickerView tag] == 23) {
        return [outgoingTypes count];
    }
    else return 1;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([pickerView tag] == 19 || [pickerView tag] == 20 || [pickerView tag] == 21) {
        return keyboardTypes[row];
    }
    else if ([pickerView tag] == 22) {
        return incomingTypes[row];
    }
    else if ([pickerView tag] == 23) {
        return outgoingTypes[row];
    }
    else return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    UIButton *setOneFieldKeyboardBtn = (UIButton *)[self.view viewWithTag:14];
    UIButton *setTwoFieldKeyboardBtn = (UIButton *)[self.view viewWithTag:16];
    UIButton *setThreeFieldKeyboardBtn = (UIButton *)[self.view viewWithTag:18];

    UIButton *inBtn = (UIButton *)[self.view viewWithTag:99];
    UIButton *outBtn = (UIButton *)[self.view viewWithTag:100];
    
    if ([pickerView tag] == 19) {
        setKey1 = YES;
        [setOneFieldKeyboardBtn setTitle:keyboardTypes[row] forState:UIControlStateNormal];
    }
    else if ([pickerView tag] == 20) {
        setKey2 = YES;
        [setTwoFieldKeyboardBtn setTitle:keyboardTypes[row] forState:UIControlStateNormal];
    }
    else if ([pickerView tag] == 21) {
        setKey3 = YES;
        [setThreeFieldKeyboardBtn setTitle:keyboardTypes[row] forState:UIControlStateNormal];
    }
    else if ([pickerView tag] == 22) {
        [inBtn setTitle:incomingTypes[row] forState:UIControlStateNormal];
    }
    else if ([pickerView tag] == 23) {
        [outBtn setTitle:outgoingTypes[row] forState:UIControlStateNormal];
    }
    
}

#pragma mark UITextField Methods

- (void)setTextFields:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    UIButton *button9 = (UIButton *)[self.view viewWithTag:9];
    UIButton *button10 = (UIButton *)[self.view viewWithTag:10];
    UIButton *button11 = (UIButton *)[self.view viewWithTag:11];
    UIButton *button12 = (UIButton *)[self.view viewWithTag:12];
    
    if ([button tag] == 9) {
        if ([[button backgroundColor] isEqual:[UIColor lightGrayColor]]) {
            [button setBackgroundColor:[UIColor darkGrayColor]];
            numFields = 1;
            [self setShowTextFieldBtns:9];
        }
        else {
            numFields = 0;
            [self setShowTextFieldBtns:12];
            [button setBackgroundColor:[UIColor lightGrayColor]];
        }
        [button10 setBackgroundColor:[UIColor lightGrayColor]];
        [button11 setBackgroundColor:[UIColor lightGrayColor]];
        [button12 setBackgroundColor:[UIColor lightGrayColor]];
    }
    else if ([button tag] == 10) {
        if ([[button backgroundColor] isEqual:[UIColor lightGrayColor]]) {
            [button setBackgroundColor:[UIColor darkGrayColor]];
            numFields = 2;
            [self setShowTextFieldBtns:10];
        }
        else {
            [button setBackgroundColor:[UIColor lightGrayColor]];
            numFields = 0;
            [self setShowTextFieldBtns:12];
        }
        [button9 setBackgroundColor:[UIColor lightGrayColor]];
        [button11 setBackgroundColor:[UIColor lightGrayColor]];
        [button12 setBackgroundColor:[UIColor lightGrayColor]];
    }
    else if ([button tag] == 11) {
        if ([[button backgroundColor] isEqual:[UIColor lightGrayColor]]) {
            [button setBackgroundColor:[UIColor darkGrayColor]];
            numFields = 3;
            [self setShowTextFieldBtns:11];
        }
        else {
            [button setBackgroundColor:[UIColor lightGrayColor]];
            numFields = 0;
            [self setShowTextFieldBtns:12];
        }
        [button9 setBackgroundColor:[UIColor lightGrayColor]];
        [button10 setBackgroundColor:[UIColor lightGrayColor]];
        [button12 setBackgroundColor:[UIColor lightGrayColor]];
    }
    else if ([button tag] == 12) {
        if ([[button backgroundColor] isEqual:[UIColor lightGrayColor]]) {
            [button setBackgroundColor:[UIColor darkGrayColor]];
            numFields = 0;
            [self setShowTextFieldBtns:12];
        }
        else {
            [button setBackgroundColor:[UIColor lightGrayColor]];
            numFields = 0;
            [self setShowTextFieldBtns:12];
        }
        [button9 setBackgroundColor:[UIColor lightGrayColor]];
        [button10 setBackgroundColor:[UIColor lightGrayColor]];
        [button11 setBackgroundColor:[UIColor lightGrayColor]];
    }
    

    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if ([textField tag] == 1) {
        titleText = textField.text;
    }
    else if ([textField tag] == 2) {
        subTitleText = textField.text;
    }
    else if ([textField tag] == 3) {
        successText = textField.text;
    }
    else if ([textField tag] == 4) {
        cancelText = textField.text;
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    UIPickerView *picker19 = (UIPickerView *)[self.view viewWithTag:19];
    UIPickerView *picker20 = (UIPickerView *)[self.view viewWithTag:20];
    UIPickerView *picker21 = (UIPickerView *)[self.view viewWithTag:21];
    UIPickerView *picker22 = (UIPickerView *)[self.view viewWithTag:22];
    UIPickerView *picker23 = (UIPickerView *)[self.view viewWithTag:23];
    
    [picker19 setAlpha:0.0];
    [picker20 setAlpha:0.0];
    [picker21 setAlpha:0.0];
    [picker22 setAlpha:0.0];
    [picker23 setAlpha:0.0];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (void)dismissEverything {
    [self.view endEditing:YES];
    
    UIPickerView *picker19 = (UIPickerView *)[self.view viewWithTag:19];
    UIPickerView *picker20 = (UIPickerView *)[self.view viewWithTag:20];
    UIPickerView *picker21 = (UIPickerView *)[self.view viewWithTag:21];
    UIPickerView *picker22 = (UIPickerView *)[self.view viewWithTag:22];
    UIPickerView *picker23 = (UIPickerView *)[self.view viewWithTag:23];
    
    [picker19 setAlpha:0.0];
    [picker20 setAlpha:0.0];
    [picker21 setAlpha:0.0];
    [picker22 setAlpha:0.0];
    [picker23 setAlpha:0.0];
    
}

#pragma mark Popup Methods

- (void)showPopper {

    if (numFields == 0) {
        popper = [[Popup alloc] initWithTitle:titleText subTitle:subTitleText cancelTitle:cancelText successTitle:successText];
    }
    else if (numFields == 1) {
        popper = [[Popup alloc] initWithTitle:titleText subTitle:subTitleText textFieldPlaceholders:@[@"One Text Field"] cancelTitle:cancelText successTitle:successText cancelBlock:^{
            NSLog(@"Cancel block 1");
        } successBlock:^{
            NSLog(@"Success block 1");
        }];
    }
    else if (numFields == 2) {
        popper = [[Popup alloc] initWithTitle:titleText subTitle:subTitleText textFieldPlaceholders:@[@"One Text Field", @"Two Text Fields"] cancelTitle:cancelText successTitle:successText cancelBlock:^{
            NSLog(@"Cancel block 2");
        } successBlock:^{
            NSLog(@"Success block 2");
        }];
    }
    else if (numFields == 3) {
        popper = [[Popup alloc] initWithTitle:titleText subTitle:subTitleText textFieldPlaceholders:@[@"One Text Field", @"Two Text Fields", @"Three Text Fields"] cancelTitle:cancelText successTitle:successText cancelBlock:^{
            NSLog(@"Cancel block 3");
        } successBlock:^{
            NSLog(@"Success block 3");
        }];
    }
    
    [self figureOutSecure];
    [self figureOutTransitions];
    [self figureOutKeyboardType];
    
    [popper setDelegate:self];
    [popper setBackgroundBlurType:blurType];
    [popper setIncomingTransition:incomingType];
    [popper setOutgoingTransition:outgoingType];
    [popper setRoundedCorners:hasRoundedCorners];
    [popper showPopup];
 
}

- (void)popupWillAppear:(Popup *)popup {
    NSLog(@"popupWillAppear");
}

- (void)popupDidAppear:(Popup *)popup {
    NSLog(@"popupDidAppear");
}

- (void)popupWilldisappear:(Popup *)popup buttonType:(PopupButtonType)buttonType {
    NSLog(@"popupWilldisappear");
}

- (void)popupDidDisappear:(Popup *)popup buttonType:(PopupButtonType)buttonType {
    NSLog(@"popupDidDisappear");
}

- (void)popupPressButton:(Popup *)popup buttonType:(PopupButtonType)buttonType {
    
    if (buttonType == PopupButtonCancel) {
        NSLog(@"popupPressButton - PopupButtonCancel");
    }
    else if (buttonType == PopupButtonSuccess) {
        NSLog(@"popupPressButton - PopupButtonSuccess");
    }
    
}

- (void)dictionary:(NSMutableDictionary *)dictionary forpopup:(Popup *)popup stringsFromTextFields:(NSArray *)stringArray {
    
    NSLog(@"Dictionary from textfields: %@", dictionary);
    NSLog(@"Array from textfields: %@", stringArray);

    //NSString *textFromBox1 = [stringArray objectAtIndex:0];
    //NSString *textFromBox2 = [stringArray objectAtIndex:1];
    //NSString *textFromBox3 = [stringArray objectAtIndex:2];
}

@end
