//
//  IAssetsGroup.h
//  FabBook
//
//  Created by anthony on 2021/12/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IAssetsGroup <NSObject>

@optional
/**
 * @brief    그룹 내의 아이템 수
 * @remark  불러온게 아님. 전체 수.
 * @author  Jang, Dong Sam
 * @todo    이름 바꾸기 numberOfAllAssets
 */
- (NSNumber *)numberOfAssets;

/**
 * @brief    그룹 이름
 * @author    Jang, Dong Sam
 */
- (NSString *)groupTitle;

/**
 * @brief    그룹 대표이미지 삽입 취소
 * @param    imageView - 대표이미지를 삽입하려고한 이미지뷰
 * @author    Jang, Dong Sam
 */
- (void)cancelPosterLoad:(UIImageView *)imageView;

/**
 * @brief    그룹 대표이미지 삽입
 * @param    imageView - 삽입할 이미지뷰
 * @author  Jang, Dong Sam
 */
- (void)insertPoster:(UIImageView *)imageView;
/**
 * @brief    그룹 대표이미지 URL
 * @author  Jang, Dong Sam
 */
- (id)groupThumnail;

/**
 * @brief    더 불러올 아이템 존재여부 반환
 * @return    더 있으면 YES, 아니면 NO
 * @author    Jang, Dong Sam
 */
- (BOOL)hasLoadmoreItems;

/**
 * @brief    아이템 불러오기
 * @return    error - 아이템 불러오다 오류 났을 경우 오류, 아니면 nil
 * @author    Jang, Dong Sam
 */
- (void)loadAssetLists:(void (^)(NSError *))finished;

/**
 * @brief    그룹내에 불러온 아이템의 수
 * @remark  전체 아이템 수와 다를수 있음
 * @author    Jang, Dong Sam
 */
- (NSUInteger)numberOfLoadedAssets;

/**
 * @brief    인덱스에 해당 하는 아이템 반환
 * @param    index - 반환 받으려는 아이템 인덱스
 * @author    Jang, Dong Sam
 */
- (id<IAsset>)assetAtIndex:(NSUInteger)index;

/**
 * @brief    아이템에 해당하는 인덱스 반환
 * @param    asset - 인덱스에 해당하는 아이템
 * @author    Jang, Dong Sam
 */
- (NSUInteger)indexOfAsset:(id<IAsset>)asset;

/**
 * @brief    아이템 나열
 * @return    asset - 아이템
 * @return    idx - 아이템 인덱스
 * @return    stop - 반복 종료를 원할 경우 YES, 아니면 NO 혹은 무시
 * @author    Jang, Dong Sam
 */
- (void)enumerateAssetsUsingBlock:(void (^)(id<IAsset> asset, NSUInteger idx, BOOL *stop))block;

/**
 * @brief    아이템 캐싱 시작
 * @param    indexs - 캐싱 대상 인덱스들
 * @param   wantSize - 캐싱할 사이즈
 * @remark    현재 단말 이미지에서만 사용
 * @author    Jang, Dong Sam
 */
- (void)startCachingAssetsForIndexes:(NSArray<NSNumber *> *)indexes wantSize:(CGSize)wantSize;

/**
 * @brief    아이템 캐싱 종료
 * @param    indexs - 캐싱 종료 대상 인덱스들
 * @param   wantSize - 캐싱할 사이즈
 * @remark    현재 단말 이미지에서만 사용
 * @author    Jang, Dong Sam
 */
- (void)stopCachingAssetsForIndexes:(NSArray<NSNumber *> *)indexes wantSize:(CGSize)wantSize;

/**
 * @brief    전체 아이템 캐싱 종료
 * @remark    현재 단말 이미지에서만 사용
 * @author    Jang, Dong Sam
 */
- (void)stopCachingAllAssets;

- (NSMutableArray*)getGroupTheMonth;
- (NSMutableArray*)getGroupTheDay;
- (NSMutableArray*)getGroupTheMonthEight;
@end


NS_ASSUME_NONNULL_END
