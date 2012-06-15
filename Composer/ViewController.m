//
//  ViewController.m
//  Composer
//
//  Created by Marian PAUL on 22/03/12.
//  Copyright (c) 2012 IPuP SARL. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Ajout d'un bouton pour afficher le répertoire
    UIButton *buttonAddressBook = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonAddressBook setTitle:@"Choisir un contact" forState:UIControlStateNormal];
    [buttonAddressBook addTarget:self action:@selector(chooseContact:) forControlEvents:UIControlEventTouchUpInside];
    [buttonAddressBook setFrame:CGRectMake(30, 30, 260, 30)];
    [self.view addSubview:buttonAddressBook];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // ajout du label pour le nom
    _labelName = [[UILabel alloc] initWithFrame:CGRectMake(30, 80, 110, 30)];
    [_labelName setText:@"Nom"];
    _labelName.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:_labelName];
    
    // label pour le prénom
    _labelFirstName = [[UILabel alloc] initWithFrame:CGRectMake(180, 80, 110, 30)];
    [_labelFirstName setText:@"Prénom"];
    _labelFirstName.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:_labelFirstName];
    
    // label pour le numéro du destinataire
    _labelPhoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(30, 130, 110, 30)];
    [_labelPhoneNumber setText:@"Numéro"];
    _labelPhoneNumber.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:_labelPhoneNumber];
    
    // label pour le numéro du destinataire
    _labelMailAddress = [[UILabel alloc] initWithFrame:CGRectMake(180, 130, 110, 30)];
    [_labelMailAddress setText:@"Adresse mail"];
    _labelMailAddress.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:_labelMailAddress];
    
    // textField pour l'objet (dans le cas d'un mail)
    _textFieldSubject = [[UITextField alloc] initWithFrame:CGRectMake(30, 180, 260, 30)];
    [_textFieldSubject setBorderStyle:UITextBorderStyleRoundedRect];
    [_textFieldSubject setPlaceholder:@"Objet"];
    _textFieldSubject.delegate = self;
    [self.view addSubview:_textFieldSubject];
    
    // textField pour le contenu
    _textFieldBody = [[UITextField alloc] initWithFrame:CGRectMake(30, 230, 260, 100)];
    [_textFieldBody setBorderStyle:UITextBorderStyleRoundedRect];
    [_textFieldBody setPlaceholder:@"Message"];
    _textFieldBody.delegate = self;
    [self.view addSubview:_textFieldBody];
    
    // si l'appareil peut envoyer des sms, on ajoute le bouton
    if ([MFMessageComposeViewController canSendText]) {
        // bouton envoi SMS 
        UIButton *buttonSendSMS = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [buttonSendSMS setTitle:@"SMS" forState:UIControlStateNormal];
        [buttonSendSMS addTarget:self action:@selector(sendSMS:) forControlEvents:UIControlEventTouchUpInside];
        [buttonSendSMS setFrame:CGRectMake(30, 350, 110, 30)];
        [self.view addSubview:buttonSendSMS];
    }
    // si l'appareil peut envoyer des mails, on ajoute le bouton
    if ([MFMailComposeViewController canSendMail]) {
        // bouton envoi Mail 
        UIButton *buttonSendMail = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [buttonSendMail setTitle:@"Mail" forState:UIControlStateNormal];
        [buttonSendMail addTarget:self action:@selector(sendMail:) forControlEvents:UIControlEventTouchUpInside];
        [buttonSendMail setFrame:CGRectMake(180, 350, 110, 30)];
        [self.view addSubview:buttonSendMail];
    }

}

- (void) chooseContact:(id)sender 
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentModalViewController:picker animated:YES];
}

- (void) sendSMS :(id)sender 
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    // on met le numéro de téléphone
    picker.recipients = [NSArray arrayWithObject:_labelPhoneNumber.text];
    // on met le contenu du SMS
    picker.body = _textFieldBody.text;
    
    // on affiche la vue
    [self presentModalViewController:picker animated:YES];
}

- (void) sendMail :(id)sender 
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    // on met le destinataire du mail
    [picker setToRecipients:[NSArray arrayWithObject:_labelMailAddress.text]];
    /* on peut aussi spécifier
     // les gens en copie
     [picker setCcRecipients:];
     // les gens en copie cachée
     [picker setBccRecipients:];
     */
    // on met le sujet du mail
    [picker setSubject:_textFieldSubject.text];
    // on met le contenu du mail. On peut choisir de mettre du contenu html
    [picker setMessageBody:_textFieldBody.text isHTML:NO];
    
    // on affiche la vue
    [self presentModalViewController:picker animated:YES];
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate 

// appelée lorsque l'utilisateur annule
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker // [1]
{
    // on enlève le picker affiché
    [self dismissModalViewControllerAnimated:YES]; 
}

// appelée lorsque le picker choisit un contact et demande si il peut continuer
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person // [2]
{
    
    // on récupère le prénom
    NSString* name = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty); // [1]
    _labelFirstName.text = name;
    
    // on récupère le nom
    name = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    _labelName.text = name;
    
    // on récupère le ou les e-mail(s)
    ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
    // on les place dans un tableau
    NSArray *theArray = (__bridge_transfer id)ABMultiValueCopyArrayOfAllValues(emails);
    CFRelease(emails);
    
    UIActionSheet *actionSheet = nil;
    
    if ([theArray count] == 0) 
    {
        // pas d'adresse mail
        _labelMailAddress.text = @"Pas de mail";
    }
    else 
    {
        if ([theArray count] == 1) 
        {
            // une seule adresse 
            _labelMailAddress.text = [theArray objectAtIndex:0];
        }
        else 
        {
            // on demande à l'utilisateur de choisir
            actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choisir un email" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
            // ajouter un bouton pour chaque e-mail
            for (NSString *email in theArray)
                [actionSheet addButtonWithTitle:email];
            [actionSheet showInView:self.view];    
        }
    }
    
    // on récupère le ou les numéro(s) de téléphone
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
    // on les place dans un tableau
    theArray = (__bridge_transfer id)ABMultiValueCopyArrayOfAllValues(phoneNumbers);
    CFRelease(phoneNumbers);
    
    if ([theArray count] == 0) 
    {
        // pas de téléphone
        _labelPhoneNumber.text = @"Pas de téléphone";
    }
    else 
    {
        if ([theArray count] == 1) 
        {
            // un seul numéro 
            _labelPhoneNumber.text = [theArray objectAtIndex:0];
        }
        else 
        {
            if(actionSheet)
            {
                // on a déjà une action sheet d'affichée donc on attend avant d'afficher la suivante
                _multiValueToDisplay = phoneNumbers;
            }
            else
            {
                // il n'y avait que 0 ou 1 mail
                // on demande à l'utilisateur de choisir
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choisir un téléphone" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
                // ajouter un bouton pour chaque numéro
                for (NSString *numbers in theArray)
                    [actionSheet addButtonWithTitle:numbers];
                [actionSheet showInView:self.view];    
            }
        }    
    }
    
    [self dismissModalViewControllerAnimated:YES];
    return NO;
}

//// appelé lorsque l'utilisateur choisit une propriété d'un contact
//- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
//{
//    if(property == kABPersonPhoneProperty)
//    {
//        // on récupère le ou les numéro(s) de téléphone
//        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
//        // on les place dans un tableau
//        NSArray *theArray = (__bridge_transfert id)ABMultiValueCopyArrayOfAllValues(phoneNumbers);
//        // on affiche le numéro de téléphone choisit en fonction de l'identifier
//        NSLog(@"numéro de téléphone %@", [theArray objectAtIndex:ABMultiValueGetIndexForIdentifier(phoneNumbers, identifier)]);
//        [self dismissModalViewControllerAnimated:YES];
//    }    
//    return NO;    
//}

// appelé lorsque l'utilisateur choisit une propriété d'un contact
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{   
    [self dismissModalViewControllerAnimated:YES];
    return NO;    
}

#pragma mark - actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([actionSheet.title isEqualToString:@"Choisir un email"]) // [1]
    { 
        [_labelMailAddress setText:[actionSheet buttonTitleAtIndex:buttonIndex]]; 
        if (_multiValueToDisplay) // [2]
        {
            // on va maintenant demander de choisir parmi les numéros de téléphones disponibles
            NSArray *theArray = (__bridge_transfer id)ABMultiValueCopyArrayOfAllValues(_multiValueToDisplay);
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choisir un téléphone" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
            // ajouter un bouton pour chaque numéro
            for (NSString *numbers in theArray)
                [actionSheet addButtonWithTitle:numbers];
            [actionSheet showInView:self.view];    
        }
    }    
    else // [3]
    { 
        [_labelPhoneNumber setText:[actionSheet buttonTitleAtIndex:buttonIndex]]; 
    }
}

#pragma mark - Text field delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // cacher le clavier
    [textField resignFirstResponder];
    return YES;
}

// appelée lorsque l'utilisateur va éditer
- (void)textFieldDidBeginEditing:(UITextField *)textField 
{
    // on anime le retour de la vue
    [UIView animateWithDuration:0.5
                     animations:^{
                         // on déplace la vue de 120 pixels vers le haut
                         self.view.transform = CGAffineTransformMakeTranslation(0.0, -120.0); 
                     }];
}
// appelée lorsque l'utilisateur arrête l'édition
- (void)textFieldDidEndEditing:(UITextField *)textField 
{
    // on déplace la vue en même temps que le clavier pour qu'il ne cache pas le text field
    [UIView animateWithDuration:0.5
                     animations:^{
                         // on remet la vue à son état initial
                         self.view.transform = CGAffineTransformIdentity;
                     }];
}

#pragma mark - Message SMS delegate
- (void) messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result 
{
    switch (result) {
        case MessageComposeResultSent:
            NSLog(@"SMS envoyé");
            break;
        case MessageComposeResultCancelled:
            NSLog(@"SMS annulé");
            break;
        case MessageComposeResultFailed:
            NSLog(@"SMS échec de l'envoi");
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
} 

#pragma mark -
#pragma mark Mail compose delegate
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error 
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"Mail envoyé");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail sauvegardé");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail échec de l'envoi");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"Mail annulé");
            break;            
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
