//
//  TestEmployee.h
//  TestCoreData
//
//  Created by 贾志丹 on 15/7/20.
//  Copyright (c) 2015年 jiazhidan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TestEmployee : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSDate * birthday;

@end
