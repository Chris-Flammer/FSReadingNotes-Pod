//
//  FSNoteVC.h
//  Pods
//
//  Created by Fishington Studios on 10/9/15.
//
//

#import <UIKit/UIKit.h>

@protocol NoteDelegate <NSObject>
-(void)didChangeNote:(NSDictionary *)editedNote atIndex:(NSInteger)index;
-(void)shouldDeleteNote:(NSDictionary *)deletedNote atIndex:(NSInteger)index;
@end

@interface FSNoteVC : UIViewController

@property (strong, nonatomic) NSMutableDictionary *selectedNote;
@property (nonatomic) BOOL noteIsNew;
@property (nonatomic) NSInteger noteIndex;
@property (nonatomic, assign) id <NoteDelegate> delegate;

@end
