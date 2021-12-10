//
//  IAsset.h
//  FabBook
//
//  Created by anthony on 2021/12/10.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IAsset <NSObject>


#pragma mark - Asset Information
@optional
/**
 * @brief    서버 업로드 타입
 * @author    Jang, Dong Sam
 */
//- (NSString *)uploadType;

/**
 * @brief    asset thumbnail URL
 * @author    Jang, Dong Sam
 */
- (NSURL *)thumbnailURL;
/**
 * @brief    asset thumbnail URL
 * @author    Jang, Dong Sam
 */
- (NSString *)schemeThumbnailURLString;
/**
 * @brief    asset thumbnail URL for swift
 * @author    Phillip
 */
- (NSString *)schemeThumbnailURLStringForSwift;
/**
 * @brief    asset original image URL
 * @author    Jang, Dong Sam
 */
- (NSURL *)originalURL;

/**
 * @brief    asset size
 * @author    Jang, Dong Sam
 */
- (CGSize)size;

/**
 * @brief    asset orientaion
 * @author    Jang, Dong Sam
 */
//- (CGFloat)degree;

- (NSUInteger)best;
- (NSArray *)replies;
- (NSArray *)feeling;
- (NSUInteger)numberOfReplies;
- (NSUInteger)numberOfFeeling;

/**
 * @brief    XML제작시 필요한 값 복사
 * @author    Jang, Dong Sam
 */
//- (void)copyToSource:(Source *)source;


/**
 * @brief    only polariod 'back' 촬영일 추가
 * @author  Jang, Dong Sam
 */
//- (void)dateToTextList:(TextList *)textList;

///**
// * @brief    thumbnail insert
// * @author  Jang, Dong Sam
// */
//- (void)insertAspectRatioThumbnail:(UIImageView *)imageView wantSize:(CGSize)wantSize;
//
///**
// * @brief    original image insert
// * @author  Jang, Dong Sam
// */
//- (void)insertFullScreenImage:(UIImageView *)imageView;



#pragma mark - V2

/**
 * @brief    asset 고유값
 * @author    Jang, Dong Sam
 */
- (NSString *)assetID;

- (void)cancelImageLoad:(UIImageView *)imageView;
- (void)insertThumbnail:(UIImageView *)imageView wantSize:(CGSize)wantSize;
- (void)insertThumbnail:(UIImageView *)imageView wantSize:(CGSize)wantSize finished:(void(^)(void))finished;
- (void)thumbnailImageWantSize:(CGSize)wantSize resultBlock:(void (^)(UIImage *, NSError *))resultBlock;
@end


NS_ASSUME_NONNULL_END
