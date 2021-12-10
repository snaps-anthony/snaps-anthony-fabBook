//
//  IAssetsGroupCategory.h
//  FabBook
//
//  Created by anthony on 2021/12/10.
//

#import <Foundation/Foundation.h>


#import "IAssetsLibrary.h"
NS_ASSUME_NONNULL_BEGIN
@protocol IAssetsGroupCategory <NSObject>

#pragma mark - 기본정보

/**
 * @brief    <#Description#>
 * @param    <#Parameter#>
 * @return    <#Return#>
 * @remark    <#Remark#>
 * @see        <#See#>
 * @author  Jang, Dong Sam
 */
- (UIImage *)icon;

/**
 * @brief    <#Description#>
 * @param    <#Parameter#>
 * @return    <#Return#>
 * @remark    <#Remark#>
 * @see        <#See#>
 * @author  Jang, Dong Sam
 */
- (NSString *)name;

/**
 * @brief    <#Description#>
 * @param    <#Parameter#>
 * @return    <#Return#>
 * @remark    <#Remark#>
 * @see        <#See#>
 * @author  Jang, Dong Sam
 */
- (NSString *)title;


#pragma mark -

/**
 * @brief    <#Description#>
 * @param    <#Parameter#>
 * @return    <#Return#>
 * @remark    <#Remark#>
 * @see        <#See#>
 * @author  Jang, Dong Sam
 */
- (id<IAssetsLibrary>)assetsLibrary;

/**
 * @brief    <#Description#>
 * @param    <#Parameter#>
 * @return    <#Return#>
 * @remark    <#Remark#>
 * @see        <#See#>
 * @author  Jang, Dong Sam
 */
- (BOOL)isProcessPerformSegueID:(NSString *)identifier;

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender;
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

/**
 * @brief    <#Description#>
 * @param    <#Parameter#>
 * @return    <#Return#>
 * @remark    <#Remark#>
 * @see        <#See#>
 * @author  Jang, Dong Sam
 */
- (void)preparePerformSegueID:(NSString *)identifier sender:(id)sender performSegue:(void (^)(void))block;

/**
 * @brief    <#Description#>
 * @param    <#Parameter#>
 * @return    <#Return#>
 * @remark    <#Remark#>
 * @see        <#See#>
 * @author  ifunbae
 */
- (void) pushGroupViewControllerWithSender:(UIViewController*) viewController animated:(BOOL) animated;

@end



NS_ASSUME_NONNULL_END
