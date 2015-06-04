//
//  RecordEngine.m
//  ContactManager
//  通话记录管理
//  Created by mini1 on 13-6-7.
//  Copyright (c) 2013年 D-TONG-TELECOM. All rights reserved.
//

#import "RecordEngine.h"
#import "SQL.h"
#import "WldhDBManager.h"
#import "ContactUtils.h"

@implementation RecordEngine

/*
 函数描述：插入通话记录
 输入参数：oneRecord    通话记录信息
 输出参数：N/A
 返 回 值：BOOL   成功与否
 作    者：刘斌
 */
- (BOOL)insertOneRecord:(ContactRecordNode *)oneRecord
{
    if (nil == oneRecord)
    {
        return NO;
    }
    
    return [[WldhDBManager shareInstance] updataUserDBWithSql:kSQLInsertCallRecord,
            [NSNumber numberWithInteger:oneRecord.contactID],
            oneRecord.phoneNum,
            [NSNumber numberWithInteger:oneRecord.recordTotalTime],
            oneRecord.recordDateString,
            [NSNumber numberWithInteger:oneRecord.recordType]];
}

/*
 函数描述：获取所有的通话记录
 输入参数：N/A
 输出参数：N/A
 返 回 值：NSArray   通话记录列表
 作    者：刘斌
 */
- (NSArray *)allRecord
{
    NSArray *result = [[WldhDBManager shareInstance] queryUserDBWithSql:kSQLQueryAllCallRecord];
    
    
    NSMutableArray *aList = [NSMutableArray arrayWithCapacity:2];
    for (NSDictionary *aDict in result)
    {
        ContactRecordNode *oneRecord = [[ContactRecordNode alloc] init];
        oneRecord.recordID = [[aDict objectForKey:@"recordid"] integerValue];
        oneRecord.contactID = [[aDict objectForKey:@"contactid"] integerValue];
        NSString *phoneNum = [aDict objectForKey:@"phonenumber"];
        oneRecord.phoneNum = [ContactUtils deleteCountryCodeFromPhoneNumber:phoneNum
                                                             countryCode:[ContactUtils getCurrentCountryCode]];
        oneRecord.recordTotalTime = [[aDict objectForKey:@"duration"] integerValue];
        oneRecord.recordDateString = [aDict objectForKey:@"calldate"];
        oneRecord.recordType = [[aDict objectForKey:@"calltype"] integerValue];
        
        [aList addObject:oneRecord];
    }
    
    return aList;
}

- (NSInteger)recordCount
{
    NSArray *result = [[WldhDBManager shareInstance] queryUserDBWithSql:kSQLQueryCallRecordCount];
    if ([result count] > 0)
    {
        return [[result objectAtIndex:0] integerValue];
    }
    return 0;
}

/*
 函数描述：删除一条通话记录
 输入参数：recordID   通话记录ID
 输出参数：N/A
 返 回 值：BOOL   成功与否
 作    者：刘斌
 */
- (BOOL)deleteOneRecord:(NSInteger)recordID
{
    if (recordID >= 0)
    {
        return [[WldhDBManager shareInstance] updataUserDBWithSql:kSQLDeleteOneCallRecord,recordID];
    }
    
    return NO;
}

/*
 函数描述：批量删除通话记录
 输入参数：recordIDList   待删除的通话记录ID列表
 输出参数：N/A
 返 回 值：BOOL   成功与否
 作    者：刘斌
 */
- (BOOL)deleteRecords:(NSArray *)recordIDList
{
    if (0 == [recordIDList count])
    {
        return NO;
    }
    
    NSMutableArray *sqlList = [NSMutableArray arrayWithCapacity:2];
    for (NSNumber *recordIDNum in recordIDList)
    {
        [sqlList addObject:kSQLDeleteCallRecordMulity([recordIDNum intValue])];
    }
    
    return [[WldhDBManager shareInstance] transactionUpdataUserDBWithSqlArray:sqlList];
}

/*
 函数描述：删除所有的通话记录
 输入参数：N/A
 输出参数：N/A
 返 回 值：BOOL   成功与否
 作    者：刘斌
 */
- (BOOL)deleteAllRecord
{
    return [[WldhDBManager shareInstance] updataUserDBWithSql:kSQLDeleteAllCallRecord];
}

@end
