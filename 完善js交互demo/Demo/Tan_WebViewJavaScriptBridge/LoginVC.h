//
//  LoginVC.h
//  Tan_WebViewJavaScriptBridge
//

#import <UIKit/UIKit.h>

@class LoginVC;
@protocol LoginVCDelegate <NSObject>
@optional
-(void)sendData:(LoginVC*)loginvc data:(NSString*)dataStr;

@end

@interface LoginVC : UIViewController

@property(nonatomic,assign)id<LoginVCDelegate>delegate;


@end
