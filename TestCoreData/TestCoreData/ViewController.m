//
//  ViewController.m
//  TestCoreData
//
//  Created by 贾志丹 on 15/7/20.
//  Copyright (c) 2015年 jiazhidan. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "TestEmployee.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*
     * 关联的时候，如果本地没有数据库文件，Ｃoreadata自己会创建
     */
    
    // 1. 上下文
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    
    // 2. 上下文关连数据库
    
    // 2.1 model模型文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    // 2.2 持久化存储调度器
    // 持久化，把数据保存到一个文件，而不是内存
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    // 2.3 设置CoreData数据库的名字和路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sqlitePath = [doc stringByAppendingPathComponent:@"TestCore.sqlite"];
    
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlitePath] options:nil error:nil];
    
    context.persistentStoreCoordinator = store;
    _context = context;
}

-(IBAction)addEmployee{
    
    // 创建一个员工对象
    //Employee *emp = [[Employee alloc] init]; 不能用此方法创建
    TestEmployee *emp = [NSEntityDescription insertNewObjectForEntityForName:@"TestEmployee" inManagedObjectContext:_context];
    emp.name = @"zhangsan";
    emp.height = @1.80;
    emp.birthday = [NSDate date];
    
    // 直接保存数据库
    NSError *error = nil;
    [_context save:&error];
    
    if (error) {
        NSLog(@"%@",error);
    }
}

-(IBAction)readEmployee{
    
    // 1.FetchRequest 获取请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TestEmployee"];
    
    // 2.设置过滤条件
    // 查找zhangsan
//    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name = %@",
//                        @"wangwu"];
//    request.predicate = pre;
//    
//    // 3.设置排序
//    // 身高的升序排序
//    NSSortDescriptor *heigtSort = [NSSortDescriptor sortDescriptorWithKey:@"height" ascending:NO];
//    request.sortDescriptors = @[heigtSort];
    
    // 4.执行请求
    NSError *error = nil;
    
    NSArray *emps = [_context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"error");
    }
    
    //NSLog(@"%@",emps);
    //遍历员工
    for (TestEmployee *emp in emps) {
        NSLog(@"名字 %@ 身高 %@ 生日 %@",emp.name,emp.height,emp.birthday);
    }
}


-(IBAction)updateEmployee{
    // 改变zhangsan的身高为2m
    
    // 1.查找到zhangsan
    // 1.1FectchRequest 抓取请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TestEmployee"];
    
    // 1.2设置过滤条件
    // 查找zhangsan
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name = %@", @"zhangsan"];
    request.predicate = pre;
    
    // 1.3执行请求
    NSArray *emps = [_context executeFetchRequest:request error:nil];
    
    // 2.更新身高
    for (TestEmployee *e in emps) {
        e.height = @2.0;
    }
    
    // 3.保存
    NSError *error = nil;
    [_context save:&error];
    
    if (error) {
        NSLog(@"%@",error);
    }
}


-(IBAction)deleteEmployee{
    
    // 删除 lisi
    
    // 1.查找lisi
    // 1.1FectchRequest 抓取请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TestEmployee"];
    
    // 1.2设置过滤条件
    // 查找zhangsan
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name = %@",
                        @"zhansan"];
    request.predicate = pre;
    
    // 1.3执行请求
    NSArray *emps = [_context executeFetchRequest:request error:nil];
    
    // 2.删除
    for (TestEmployee *e in emps) {
        [_context deleteObject:e];
    }
    
    // 3.保存
    NSError *error = nil;
    [_context save:&error];
    
    if (error) {
        NSLog(@"%@",error);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
