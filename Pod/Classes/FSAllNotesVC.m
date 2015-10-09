//
//  FSAllNotesVC.m
//  Pods
//
//  Created by Fishington Studios on 10/9/15.
//
//

#import "FSAllNotesVC.h"
#import "FSNoteVC.h"

#define collectionItemEdgeInsets 5
#define notesPlistName @"notesData"

// keys for note
#define kNoteTextKey @"text"
#define kNoteDateKey @"date"

@interface FSAllNotesVC ()<NoteDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel;
@property (strong, nonatomic) NSMutableArray *notesArray;
@end

@implementation FSAllNotesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    // load data
    [self retrieveNotes];
    [_collectionView reloadData];
    
    

    
    self.navigationItem.title = NSLocalizedString(@"Reading Notes", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_collectionView reloadData];
    
    
    if(_notesArray.count == 0) {
        _helpLabel.text = NSLocalizedString(@"Welcome!  tap the + button to add a new reading note", nil);
    } else {
        _helpLabel.text = @"";
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}


-(void)goToNoteVCWithNote:(NSMutableDictionary *)selectedNote isNew:(BOOL)isNew andIndex:(NSInteger)noteIndex {
    FSNoteVC *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FSNoteVC"];
    viewController.delegate = self;
    viewController.selectedNote = selectedNote;
    viewController.noteIsNew = isNew;
    viewController.noteIndex = noteIndex;
    [self.navigationController pushViewController:viewController animated:YES];
}





#pragma mark UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _notesArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *note = [_notesArray objectAtIndex:indexPath.row];
    
     UILabel *titleLabel = (UILabel *)[cell viewWithTag:1001];
    titleLabel.text = note[kNoteTextKey];
    
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:1002];
    dateLabel.text = note[kNoteDateKey];
    
    return cell;
}




#pragma mark UICollectionView Delegate


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *selectedNote = [_notesArray objectAtIndex:indexPath.row];
    [self goToNoteVCWithNote:selectedNote isNew:YES andIndex:indexPath.row];
}







#pragma mark - UICollectionFlowLayout Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    float height = [self calculateSizeOfCellAtIndexPath:indexPath];
    return CGSizeMake(self.view.bounds.size.width-(collectionItemEdgeInsets*2), height);
}



- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(collectionItemEdgeInsets, collectionItemEdgeInsets, collectionItemEdgeInsets, collectionItemEdgeInsets);
}



- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return collectionItemEdgeInsets;
}



- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return collectionItemEdgeInsets;
}




#pragma mark - Helper Methods

-(NSString *)getStringFromDate:(NSDate *)date withFormat:(NSString *)format {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    return  dateString;
    
}


-(float)calculateSizeOfCellAtIndexPath:(NSIndexPath *)indexPath {
    
    // get a strand object for our calculations
    NSDictionary *note = [_notesArray objectAtIndex:indexPath.row];
    
    
    // this is the base height we'll be adding various things to.  A cell should never be smaller than this..
    float height = 8;
    
    // add the height of the date label
    height += 15;
    
    // add the padding between date label and text
    height += 8;
    
    NSString *noteText = note[kNoteTextKey];
        if(![noteText isEqualToString:@""]) {
            // since we can't get a handle to the textview on our cell, we'll make one set it's text to calculate it's height based on the text.  WE'll set the width to view width since this is the best we can do...
            UITextView *dummyTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)];
            dummyTextView.text = noteText;
            dummyTextView.font = [UIFont systemFontOfSize:14];
            float textViewHeight = [self calculateHeightForTextView:dummyTextView];
            height +=  textViewHeight;
        } else {
            height += 20; // just have 20 pixels of space showing if there isn't a message yet
        }
    
        // add some padding to the bottom
        height += 8;
    
    
    // return our final result
    return height;
    
}



-(float)calculateHeightForTextView:(UITextView *)textView {
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
    return textView.frame.size.height;
}



#pragma mark - Autorotation


-(BOOL)shouldAutorotate {
    return YES;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // adjust our layout for the new rotation
    [_collectionView reloadData]; // we'll need to update all the datasources for the new imageview sizes.....
    
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
}








#pragma mark - Actions

- (IBAction)addNewNoteButtonPressed:(id)sender {
    _helpLabel.text = @"";
    NSMutableDictionary *newNote = [self addNote].mutableCopy;
    [_notesArray addObject:newNote];
    [_collectionView reloadData];
    [self goToNoteVCWithNote:newNote isNew:YES andIndex:_notesArray.count-1];

}







#pragma mark - Data


-(void)saveNotes {
    
    //Create the filepath
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:@"Notes"];
    [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *plistPath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",notesPlistName]];
    
     // save to a plist.
    [_notesArray writeToFile:plistPath atomically:NO];
    
}


-(void)retrieveNotes {
   
    _notesArray = [[NSMutableArray alloc]init];
    
    //Create the filepath
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:@"Notes"];
    [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *plistPath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",notesPlistName]];
    
    NSArray *retrievedNotes = [NSArray arrayWithContentsOfFile:plistPath].mutableCopy;
    [_notesArray addObjectsFromArray:retrievedNotes];
    NSLog(@"notes: %@",_notesArray.description);
}



-(NSDictionary *)addNote {
    
    NSDictionary *note = @{
                           kNoteTextKey : @"",
                           kNoteDateKey : [self getStringFromDate:[NSDate date] withFormat:@"MMMM dd, yyyy hh:mm a"],
                           };
    
    [self saveNotes];
    
    return note;
    
}


// delegate method from FSNoteVC
-(void)didChangeNote:(NSDictionary *)editedNote atIndex:(NSInteger)index {
    [_notesArray replaceObjectAtIndex:index withObject:editedNote];
    [self saveNotes];
}



-(void)shouldDeleteNote:(NSDictionary *)deletedNote atIndex:(NSInteger)index {
    [_notesArray removeObjectAtIndex:index];
    [self saveNotes];
    [_collectionView reloadData];
}


@end
