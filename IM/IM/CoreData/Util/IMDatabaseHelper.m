//
//  IMDatabaseHelper.m
//  IM
//
//  Created by LT-MacbookPro on 17/4/20.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "IMDatabaseHelper.h"

static IMDatabaseHelper * iMDatabaseHelper;

@interface IMDatabaseHelper ()

@property (nonatomic,strong) NSManagedObjectContext * managedObjectContext;

/**
 *  Entity唯一标识的字典
 */
@property (nonatomic,strong) NSMutableDictionary * keyDictionary;

@end


@implementation IMDatabaseHelper

#pragma mark - lazy load
- (NSManagedObjectContext *)managedObjectContext
{
    if(_managedObjectContext == nil){
        _managedObjectContext = [NSManagedObjectContext MR_defaultContext];
    }
    return _managedObjectContext;
}


+ (instancetype) allocWithZone:(struct _NSZone *)zone{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        iMDatabaseHelper = [super allocWithZone:zone];
    });
    return iMDatabaseHelper;
}

- (id)copyWithZone:(NSZone *)zone{

    return iMDatabaseHelper;
}

-(id)mutableCopyWithZone:(NSZone *)zone{

    return iMDatabaseHelper;
}

+ (instancetype)sharedInstance{

    return [[self alloc] init];
}

#pragma mark - 常规 增/删/改/查

/**
 *  插入对象
 *
 *  @param object 待插入到数据库的对象
 */
- (void)insertObjectToDB:(NSManagedObject *)object
{
    NSString * entityName = NSStringFromClass([object class]);
    [self insertOrIgnoreObject:object withEntityName:entityName];
}

- (void)insertOrIgnoreObject:(NSManagedObject *)object withEntityName:(NSString *)entityName
{
    NSString * uniqueKey = [self.keyDictionary valueForKey:entityName];
    if(uniqueKey){
        NSArray * resultArray = [self queryEntity:entityName withUniqueKey:uniqueKey value:[object valueForKey:uniqueKey]];
        if(!resultArray || resultArray.count == 0){
            [self.managedObjectContext insertObject:object];
        }
    }else{
        //没有唯一值约束，直接插入数据库
        [self.managedObjectContext insertObject:object];
    }
    
    [self.managedObjectContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {}];
}

/**
 *  批量插入对象
 *
 *  @param objects    对象数组
 */
- (void)insertObjectsToDB:(NSArray *)objects
{
    for (NSManagedObject * object in objects) {
        [self insertObjectToDB:object];
    }
}


/**
 *  查询对象
 *
 *  @param entityName 实体名称
 *  @param key        唯一键
 *  @param value      唯一键对应的值
 *
 *  @return 查询结果
 */
- (NSArray *)queryEntity:(NSString *)entityName withUniqueKey:(NSString *)key value:(id)value
{
    NSFetchRequest * request = [[NSFetchRequest alloc]initWithEntityName:entityName];
    //设置查询条件
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"%K == '%@'",key,value];
    [request setPredicate:predicate];
    
    NSError * error;
    NSArray * resultArray = [self.managedObjectContext executeFetchRequest:request error:&error];
    if(!error){
        return resultArray;
    }else{
        return nil;
    }
}


/**
 *  查询满足条件的数据
 *
 *  @param entityName      实体名称
 *  @param predicateString 谓词字符串
 *  @param sortDescriptor  排序器
 *  @param fetchLimit      每页的记录个数
 *  @param fetchOffset     分页偏移量
 *
 *  @return 查询结果
 */
- (NSArray *)queryObjectArrWithEntityName:(NSString *)entityName predicateString:(NSString *)predicateString sortDescriptor:(NSSortDescriptor *)sortDescriptor fetchLimit:(NSInteger)fetchLimit fetchOffset:(NSInteger)fetchOffset
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext]];
    [request setReturnsObjectsAsFaults:NO];
    if (predicateString != nil) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:predicateString];
        [request setPredicate:predicate];
    }
    //设置排序
    if (sortDescriptor) {
        [request setSortDescriptors:@[sortDescriptor]];
    }
    
    //设置分页参数
    if (fetchLimit != 0) {
        [request setFetchLimit:fetchLimit];
        [request setFetchOffset:fetchOffset];
    }
    
    NSError *error = nil;
    NSArray *resultArray = [self.managedObjectContext executeFetchRequest:request error:&error];
    return resultArray;
}


/**
 *  删除对象
 *
 *  @param entityName      实体名称
 *  @param predicateString 谓词字符串
 */
- (void)deleteObjectWithEntityName:(NSString *)entityName predicateString:(NSString *)predicateString
{
    //查出所有符合条件的数据
    NSArray * resultArray = [self queryObjectArrWithEntityName:entityName predicateString:predicateString sortDescriptor:nil fetchLimit:0 fetchOffset:0];
    if (resultArray.count > 0) {//存在改对象
        for (NSManagedObject *obj in resultArray) {
            //删除旧的实体对象
            [self.managedObjectContext deleteObject:obj];
        }
        [self.managedObjectContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {}];
    }
}

#pragma mark - 用户相关
- (IMUser *)getUserWithUserId:(int64_t)userId{

    if(!userId){
        return nil;
    }
    return [IMUser MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"uid == %lld",userId]] inContext:self.managedObjectContext];
}

#pragma mark - 会话相关
- (IMConversation *)getConversationWithId:(NSString *)conversationId{

    if(!conversationId){
    
        return nil;
    }
    
    return [IMConversation MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"conversationId == '%@'",conversationId]] inContext:self.managedObjectContext];
}




@end
