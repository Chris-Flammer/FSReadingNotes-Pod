//
//  FSNoteVC.m
//  Pods
//
//  Created by Fishington Studios on 10/9/15.
//
//

#import "FSNoteVC.h"

#define kNoteTextKey @"text"


@interface FSNoteVC () {
    BOOL _noteEdited;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewDistanceFromBottom;

@end

@implementation FSNoteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set our text
    _textView.text = _selectedNote[kNoteTextKey];

}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // #1  add in our notification observers for the keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(_noteIsNew) {
        //[_textView becomeFirstResponder];
    }
    
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if(_noteEdited) {
        [_delegate didChangeNote:_selectedNote atIndex:_noteIndex];
    }
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



#pragma mark - Actions

- (IBAction)deleteButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [_delegate shouldDeleteNote:_selectedNote atIndex:_noteIndex];
}




#pragma mark - UITextView Delegate

- (void)textViewDidChange:(UITextView * _Nonnull)textView {
    _selectedNote[kNoteTextKey] = textView.text;
    _noteEdited = YES;
}












#pragma mark - Keyboard Handling methods




// check keyboard size so we can adjust the textview appropiately
- (void)keyboardWillShow:(NSNotification *)notification
{
    
    // Step 1: Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    float sizeForKeyboardHeight = keyboardSize.height;
    
    
    
    // get animation duration of keyboard
    NSValue* value = [[notification userInfo]objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];
    
    
    // first, calculate the size of our banner ad at the bottom.
    float sizeOfBannerAd = 0;
    
    // now set our bottom constraint constant to a new value (20 pixels above the keyboard)
    self.textViewDistanceFromBottom.constant = sizeForKeyboardHeight - sizeOfBannerAd;
    
    
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
    
    
    //self.navigationItem.rightBarButtonItem = _keyboardDoneButton;
    
}




// check keyboard size so we can adjust the textview appropiately
- (void)keyboardWillHide:(NSNotification *)notification
{
    
    // get animation duration of keyboard
    NSValue* value = [[notification userInfo]objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];
    
    
    // just reset our bottom constraint to its default value (20).  The hardcode isn't great, but it works.
    self.textViewDistanceFromBottom.constant = 0;
    
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
    
    
    
    //self.navigationItem.rightBarButtonItem = _actionButton;
    
    
}




@end
