//
// Copyright (c) 2010-2011 René Sprotte, Provideal GmbH
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
// PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
// CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#define K_DEFAULT_LABEL_HEIGHT  20
#define K_DEFAULT_LABEL_INSET   5

#import "MMGridViewDefaultCell.h"

@implementation MMGridViewDefaultCell

@synthesize price, format;
@synthesize textLabelBackgroundView;
@synthesize imageFrame;

- (void)dealloc
{
//    [title release];
    [price release];
    [format release];
    [textLabelBackgroundView release];
    [imageFrame release];
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor whiteColor];
        
//        self.title = [[[UILabel alloc] initWithFrame:CGRectNull] autorelease];
//        self.title.textAlignment = UITextAlignmentCenter;
//        self.title.backgroundColor = [UIColor colorWithRed:46/255.0f green:177/255.0f blue:4/255.0f alpha:1.0f];
//        self.title.textColor = [UIColor whiteColor];
//        self.title.font = [UIFont systemFontOfSize:13];
//        [self addSubview:self.title];
        
        // Background view
        self.imageFrame = [[[UIImageView alloc] initWithFrame:CGRectNull] autorelease];
        self.imageFrame.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.imageFrame];
        
        // Label
        self.textLabelBackgroundView = [[[UIView alloc] initWithFrame:CGRectNull] autorelease];
        self.textLabelBackgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        
        self.format = [[[UILabel alloc] initWithFrame:CGRectNull] autorelease];
        self.format.textAlignment = UITextAlignmentRight;
        self.format.backgroundColor = [UIColor clearColor];
        self.format.textColor = [UIColor whiteColor];
        self.format.font = [UIFont systemFontOfSize:12];
        
        self.price = [[[UILabel alloc] initWithFrame:CGRectNull] autorelease];
        self.price.textAlignment = UITextAlignmentLeft;
        self.price.backgroundColor = [UIColor clearColor];
        self.price.textColor = [UIColor whiteColor];
        self.price.font = [UIFont systemFontOfSize:12];
        
        [self.textLabelBackgroundView addSubview:self.format];
        [self.textLabelBackgroundView addSubview:self.price];
        [self addSubview:self.textLabelBackgroundView];
    }
    
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    labelHeight = K_DEFAULT_LABEL_HEIGHT;
    labelInset = K_DEFAULT_LABEL_INSET;

//    self.title.frame = CGRectMake(0, 0, self.bounds.size.width, K_DEFAULT_LABEL_HEIGHT);
//    self.title.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Background view
    self.imageFrame.frame = CGRectMake(self.bounds.origin.x+2, self.bounds.origin.y+K_DEFAULT_LABEL_HEIGHT, self.bounds.size.width-4, self.bounds.size.height-K_DEFAULT_LABEL_HEIGHT
                                           );
    self.imageFrame.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    


    // Layout label
    self.textLabelBackgroundView.frame = CGRectMake(0,
                                                    self.bounds.size.height - K_DEFAULT_LABEL_HEIGHT,
                                                    self.bounds.size.width, 
                                                    labelHeight);
    self.textLabelBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Layout label background
    CGRect f = CGRectMake(0,
                          0, 
                          self.format.superview.bounds.size.width/2,
                          self.format.superview.bounds.size.height);
    
    CGRect r = CGRectMake(self.format.superview.bounds.size.width/2,
                          0,
                          self.format.superview.bounds.size.width/2,
                          self.format.superview.bounds.size.height);
    self.format.frame = CGRectInset(r, labelInset, 0);
    self.price.frame = CGRectInset(f, labelInset, 0);
    self.format.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.price.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

@end
