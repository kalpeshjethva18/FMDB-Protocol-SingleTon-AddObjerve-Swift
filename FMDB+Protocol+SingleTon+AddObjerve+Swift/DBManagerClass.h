//
//  DBManagerClass.h
//  PizzaSystem
//
//  Created by Harshul Shah on 27/05/14.
//  Copyright (c) 2014 Harshul Shah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import <sqlite3.h>

@interface DBManagerClass : NSObject
{
    sqlite3 *rowDatabase;
    FMDatabase *database;
}
//***************** Common Method for Add Update Delete ***************

-(int)InsertDynamictData :(NSString *)tableName :(NSMutableDictionary *)insertDict;

-(BOOL)UpdateDynamicData :(NSString *)tableName :(NSMutableDictionary *)updateDict :(NSString *)updateCriteria;

-(BOOL)DeleteDynamicData :(NSString *)tableName :(NSString *)deleteCriteria;

-(int)GetTableRowCount:(NSString *)tableName;

-(void)DeleteAllData :(NSString *)tableName;
-(FMResultSet *)SelectDataByQry:(NSString *)selectQry;
-(int)InsertDynamicQry :(NSString *)dynamicQry;

-(NSString *)getDate;

-(FMResultSet *)SelectDataByCriteria:(NSString *)tableName :(NSMutableArray *)fieldArray :(NSString *)selectCriteria;


-(FMResultSet *)SelectDataById:(NSString *)tableName :(NSMutableArray *)fieldArray :(NSString *)fieldName :(NSString *)value;

-(FMResultSet *)SelectData:(NSString *)tableName :(NSMutableArray *)fieldArray;


// multiple record using batch insert pass tablename ,array with itemfield and value dictionary if record insert success then return last record insert id else retun 0 means some error occur
-(int)BatchInsertData :(NSString *)tableName :(NSMutableArray *)insertValueArray;


-(double)GetSingleDoubleValue :(NSString *)tableName :(NSString *)fieldName :(NSString *)selectCriteria;
-(NSString *)GetSingleStringValue :(NSString *)tableName :(NSString *)fieldName :(NSString *)selectCriteria;
-(int)GetSingleIntegerValue :(NSString *)tableName :(NSString *)fieldName :(NSString *)selectCriteria;


//update order table
-(BOOL)UpdateDynamicdata :(NSString *)tablename :(NSMutableDictionary *)updatedict :(NSString *)updatecriteria;

-(void)FMDBClose;  //Close fmdb database

//****************** Common Method End here *****************************


@end
