//
//  RDLimitInput.m
//  Reader
//
//  Created by yuenov on 2020/2/19.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDLimitInput.h"
#import <objc/runtime.h>


#define RUNTIME_ADD_PROPERTY(propertyName)      \
-(id)valueForUndefinedKey:(NSString *)key {     \
if ([key isEqualToString:propertyName]) {   \
return objc_getAssociatedObject(self, key.UTF8String);  \
}                                           \
return nil;                                 \
}                                               \
-(void)setValue:(id)value forUndefinedKey:(NSString *)key { \
if ([key isEqualToString:propertyName]) {               \
objc_setAssociatedObject(self, key.UTF8String, value, OBJC_ASSOCIATION_RETAIN); \
}                                                       \
}

#define IMPLEMENT_PROPERTY(className) \
@implementation className (Limit) RUNTIME_ADD_PROPERTY(kLimitInputKey) @end

IMPLEMENT_PROPERTY(UITextField)
IMPLEMENT_PROPERTY(UITextView)

@implementation RDLimitInput

+ (void)load {
    [super load];
    [RDLimitInput sharedInstance];
}

+ (RDLimitInput *)sharedInstance {
    static RDLimitInput *g_limitInput;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        g_limitInput = [[RDLimitInput alloc] init];
        g_limitInput.enableLimitCount = YES;
    });
    
    return g_limitInput;
}

- (id)init {
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidChange:) name:UITextFieldTextDidChangeNotification object: nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object: nil];
    }
    
    return self;
}

- (void)textFieldViewDidChange:(NSNotification*)notification {
    if (!self.enableLimitCount) return;
    UITextField *textField = (UITextField *)notification.object;
    
    NSNumber *number = [textField valueForKey:kLimitInputKey];
    if (number && textField.text.length > [number integerValue] && textField.markedTextRange == nil) {
        NSRange emojiRange = [textField.text rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, [number integerValue])];
        textField.text = [textField.text substringWithRange: NSMakeRange(0, emojiRange.length)];
        [textField.undoManager removeAllActions];
    }
}

- (void)textViewDidChange: (NSNotification *) notificaiton {
    if (!self.enableLimitCount) return;
    UITextView *textView = (UITextView *)notificaiton.object;
    
    NSNumber *number = [textView valueForKey:kLimitInputKey];
    if (number && textView.text.length > [number integerValue] && textView.markedTextRange == nil) {
        //防止emoji字符被截取一半（会造成字符串不显示或显示乱码），导致字符串转码成NULL而崩溃
        NSRange emojiRange = [textView.text rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, [number integerValue])];
        textView.text = [textView.text substringWithRange:NSMakeRange(0, emojiRange.length)];
        [textView.undoManager removeAllActions];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
