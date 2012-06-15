//
//  ViewController.h
//  Composer
//
//  Created by Marian PAUL on 22/03/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>

@interface ViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>
{
    UILabel *_labelName, *_labelFirstName, *_labelPhoneNumber, *_labelMailAddress;
    UITextField *_textFieldBody, *_textFieldSubject;
    ABMultiValueRef _multiValueToDisplay;
}
@end
