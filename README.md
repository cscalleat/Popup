# Popup

## • Screenshots and Gifs

  <img align="left" src="http://i.imgur.com/yRIHacH.gif" alt="SS1" width="240" height="427"/>
  <img align="center" src="http://i.imgur.com/nC8DOEx.png" alt="SS2" width="240" height="427"/>
  <img align="right" src="http://i.imgur.com/O8ZooU4.png" alt="SS3" width="240" height="427"/>
 
## • Installation

Just drag and drop the "Popup" folder into your project, and make sure you check the "Copy items into destination group's folder" box

###### - Then import Popup.h and set the PopupDelegate wherever you need it
```objective-c
#import "Popup.h"

@interface ViewController () <PopupDelegate>
```

## • Creating Popups

###### - Creating a Basic Popup

```objective-c
Popup *popup = [[Popup alloc] initWithTitle:@"Title"
                                   subTitle:@"Subtitle"
                                cancelTitle:@"Cancel"
                               successTitle:@"Success"];
[popup setDelegate:self];
[popup showPopup];
```
###### - Creating a Popup with Blocks
```objective-c
Popup *popup = [[Popup alloc] initWithTitle:@"Title"
                                   subTitle:@"Subtitle"
                                cancelTitle:@"Cancel"
                               successTitle:@"Success"
                                cancelBlock:^{
                                //Custom code after cancel button was pressed
                                } successBlock:^{
                                //Custom code after success button was pressed
}];
[popup setDelegate:self];
[popup showPopup];
```

###### - Creating a Popup with Textfields

You can only add at most 3 textfields to Popup. Creating the textfields is as easy as creating an array with the placeholders you want your textfields to have: `@[@"Placeholder1", @"Placeholder2", @"Placeholder3"]` will create 3 textfields.

If you don't want a certain textfield to have a placeholder, you can leave the string blank: `@[@"", @"Placeholder2"]` will create 2 textfields, the first one with no placeholder text and the second textfield will have a placeholder of "Placeholder2".

The example below creates a Popup that has one textfield with a placeholder of "Username":
```objective-c
Popup *popup = [[Popup alloc] initWithTitle:@"Title"
                                   subTitle:@"Subtitle"
                      textFieldPlaceholders:@[@"Username"]
                                cancelTitle:@"Cancel"
                               successTitle:@"Success"
                                cancelBlock:^{
                                    //Custom code after cancel button was pressed
                                } successBlock:^{
                                    //Custom code after success button was pressed
}];
[popup setDelegate:self];
[popup showPopup];
```

##### - Caveats
You don't need to set anything in Popup if you don't want to. Just set `nil` values to the values that you don't want.

For example, if you don't want a cancel button, you can do the following:

```objective-c
Popup *popup = [[Popup alloc] initWithTitle:@"Title"
                                   subTitle:@"Subtitle"
                                cancelTitle:nil
                               successTitle:@"Success"];
```

## • Setting Textfield Attributes

After creating a Popup with 1, 2 or 3 textfields, you can still manipulate each individual textfield to your liking.

###### - Secure entry
Popup has functions that allow you to set a certain textfield to secure.
Popup textfields can either be of type `@"PASSWORD"` or `@"DEFAULT"` (they are set to `@"DEFAULT"` or `@""` automatically).

The example below will set 3 textfields' entry types. The first and second textfield will have secure entry, and the last textfield will have default entry. 
```objective-c
[popup setTextFieldTypeForTextFields:@[@"PASSWORD", @"PASSWORD", @"DEFAULT"]];
```
###### - Keyboard Types
You can set each individual textfield's `UIKeyboardType` by putting the type in an array and passing it through the popup.
The types can be either `@"DEFAULT", @"ASCIICAPABLE", @"NUMBERSANDPUNCTUATION", @"URL", @"NUMBER", @"PHONE", @"NAMEPHONE", @"EMAIL", @"DECIMAL", @"TWITTER", @"WEBSEARCH` (they are set to `@"DEFAULT"`, or `@""` automatically).

The exmple below will set 3 textfields' `UIKeyboardType` by passing in the type as metioned above into an array. The first textfield will be set to `UIKeyboardTypeDefault`, the second textfield will be set to `UIKeyboardTypeTwitter` the third will be set to `UIKeyboardTypeEmailAddress`.
```objective-c
[popup setKeyboardTypeForTextFields:@"", @"TWITTER", @"EMAIL"];
```
###### - Keyboard Appearance
To set the overall `UIKeyboardAppearance` for all textfields in Popup, call one function on your existing Popup:
The example below will set all keyboards to have a `UIKeyboardAppearanceDark`.
```objective-c
[popup setOverallKeyboardAppearance:UIKeyboardAppearanceDark];
```
## • Setting Popup Visual Attributes

###### - Popup colors
You can pretty much set every color in Popup: Background, border color text labels, even button titles and button backgrounds.
```objective-c
[popper setBackgroundColor:[UIColor whiteColor]];
[popper setBorderColor:[UIColor blackColor]];
[popper setTitleColor:[UIColor darkTextColor]];
[popper setSubTitleColor:[UIColor lightTextColor]];
[popper setSuccessBtnColor:[UIColor blueColor]];
[popper setSuccessTitleColor:[UIColor whiteColor]];
[popper setCancelBtnColor:[UIColor redColor]];
[popper setCancelTitleColor:[UIColor whiteColor]];
```

###### - Background Blurs
Background blurs allow Popup to be viewed unobtrusively, disregarding the background content. Popup contains 4 background blur types: `PopupBackGroundBlurTypeDark, PopupBackGroundBlurTypeLight, PopupBackGroundBlurTypeExtraLight, PopupBackGroundBlurTypeNone` 

```objective-c
[popup setBackgroundBlurType: PopupBackGroundBlurTypeDark];
```

###### - Popup Corners
You can set if your Popup has rounded corners or not.

```objective-c
[popper setRoundedCorners:hasRoundedCorners];
```

## • Setting Incoming and Outgoing Transitions

###### - Incoming Transitions
Popup has 10 incoming transition types that can be used to add an animation while presenting your Popup.

```objective-c
[popup setIncomingTransition: PopupIncomingTransitionTypeBounceFromCenter];
```

###### - Outgoing Transitions
Popup has 10 outgoing transition types that can be used to add an animation while dismissing your Popup.

```objective-c
[popup setOutgoingTransition:PopupOutgoingTransitionTypeBounceFromCenter];
```

## • Delegate Methods

###### - Appear and Disappear
Set Popup's delegate functions to tell when your Popup is appearing and which button the user pressed when dismissing.

```objective-c
- (void)popupWillAppear:(Popup *)popup;
- (void)popupDidAppear:(Popup *)popup;
- (void)popupWilldisappear:(Popup *)popup buttonType:(PopupButtonType)buttonType;
- (void)popupDidDisappear:(Popup *)popup buttonType:(PopupButtonType)buttonType;
```

###### - Button Callbacks

```objective-c
- (void)popupPressButton:(Popup *)popup buttonType:(PopupButtonType)buttonType {
    
    if (buttonType == PopupButtonCancel) {
        //Do whatever when the user taps the "Cancel" button
    }
    else if (buttonType == PopupButtonSuccess) {
        //Do whatever when the user taps the "Success" button
    }
    
}
```

###### - Retrieving Textfield Text
For all of the textfields in your Popup, it's easy to get the user's text input. The `NSMutableDictionary` returns the placeholders as the keys and the text from the textfields as the values. To get the strings from each individual textfields use the `NSArray *stringArray` to grab the object at a certain index:

```objective-c
- (void)dictionary:(NSMutableDictionary *)dictionary forpopup:(Popup *)popup stringsFromTextFields:(NSArray *)stringArray {
   
    NSString *textFromBox1 = [stringArray objectAtIndex:0];
    NSString *textFromBox2 = [stringArray objectAtIndex:1];
    NSString *textFromBox3 = [stringArray objectAtIndex:2];

}
```
## • To-do

- Add comments to Popup
- Clean up codebase

## • Say Hi

Tweet at me or something : [@markmiscavage](https://twitter.com/markmiscavage).

## • License

The MIT License (MIT)

Copyright (c) 2015 Mark Miscavage

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
