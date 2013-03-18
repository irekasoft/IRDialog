//
//  JZPickerView.h
//  Created by Muhammad Hijazi Bin Bahaman on 14/03/12.


#import <Foundation/Foundation.h>

@protocol IRPickerViewDelegate;

@interface IRPickerView : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>{

    
	UIButton *overlayButton;
    
}


- (void)show;

// init & show the picker with array of selection with preselected row
// for example using button title.
- (id)initWithOptions:(NSArray *)array withSelectedIndex:(int)index;


@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIToolbar* toolBar;
@property (assign, nonatomic) id <IRPickerViewDelegate> delegate;
@property (strong, nonatomic) NSArray *optionsArray;

@property int selectedPicker;

@end


@protocol IRPickerViewDelegate <NSObject>

@optional

- (void) pickerDoneClicked:(NSString *)name forIndex:(int)index;

@end