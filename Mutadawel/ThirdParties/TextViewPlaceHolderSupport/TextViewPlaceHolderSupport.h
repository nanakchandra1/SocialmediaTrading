//
//  SSTextView.h
//  SSToolkit
//
//  Created by Sam Soffes on 8/18/10.
//  Copyright 2010-2011 Sam Soffes. All rights reserved.
//

/**
 UITextView subclass that adds placeholder support like UITextField has.
 */
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface TextViewPlaceHolderSupport : UITextView

/**
 The string that is displayed when there is no other text in the text view.
 
 The default value is `nil`.
 */
@property (nonatomic, strong) NSString *placeholder;

/**
 The color of the placeholder.
 
 The default is `[UIColor lightGrayColor]`.
 */
@property (nonatomic, strong) UIColor *placeholderTextColor;

//
@property(nonatomic) NSTextAlignment Alignment;
@property (assign,nonatomic)BOOL hideBorder;
-(void)updateForTextFieldLikeView;
@end
