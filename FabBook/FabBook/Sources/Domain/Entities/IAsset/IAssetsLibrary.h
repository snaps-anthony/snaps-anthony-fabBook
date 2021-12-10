//
//  IAssetsLibrary.h
//  FabBook
//
//  Created by anthony on 2021/12/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IAssetsLibrary <NSObject>

- (void)assetsGroup:(void(^)(NSArray *groups, NSError *error))block;

// [Renewal] add filter option
- (void)assetsGroupWithParam:(id)param block:(void(^)(NSArray *groups, NSError *error))block;

@end

NS_ASSUME_NONNULL_END
