//
//  DBManagerClass.m
//  PizzaSystem
//
//  Created by Harshul Shah on 27/05/14.
//  Copyright (c) 2014 Harshul Shah. All rights reserved.
//

#import "DBManagerClass.h"
//#import "Reachability.h"
#import "FMDatabaseAdditions.h"

static sqlite3_stmt *addSmt = nil;
@implementation DBManagerClass

-(void)FMDBOpen
{
    //NSFileManager *FileManager = [NSFileManager defaultManager];
	NSArray *UsrDocPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *DocsDir = [UsrDocPath objectAtIndex:0];
	NSString *DbPath = [DocsDir stringByAppendingPathComponent:NSLocalizedString(@"PizzaSystemDB.sqlite",nil)];
    database = [FMDatabase databaseWithPath:DbPath];
    [database open];
}





//***************** Common Method for Add Update Delete ***************

-(BOOL)UpdateDynamicData :(NSString *)tableName :(NSMutableDictionary *)updateDict :(NSString *)updateCriteria
{
    
    BOOL updateRecoed = false;
    
    
    NSArray *fieldNameKeyArray = [updateDict allKeys];
    NSString *dynamicQry = [NSString stringWithFormat:@"update %@ SET ",tableName];
    NSString *whereCondition = @"";
    if(![updateCriteria isEqualToString:@""])
    {
        whereCondition = [NSString stringWithFormat:@"%@%@",@"where ",updateCriteria];
    }
    
    for(int i=0;i<fieldNameKeyArray.count;i++)
    {
        NSString *filedName = [fieldNameKeyArray objectAtIndex:i];
        
        NSString *value = [updateDict objectForKey:filedName];
        
        dynamicQry = [dynamicQry stringByAppendingFormat:@"%@%@'%@'%@",filedName,@"=",value,@","];
        
    }
    
    dynamicQry = [dynamicQry substringToIndex:[dynamicQry length] - 1];
    
    dynamicQry = [dynamicQry stringByAppendingString:whereCondition];
    
    
    NSLog(@"Dynamic Insert Qry = %@",dynamicQry);
    
    
    @try
    {
        [self FMDBOpen];
        
        [database beginTransaction];
        
        updateRecoed = [database executeUpdate:dynamicQry,nil];
        
        
        int errorCode = [database lastErrorCode];
        //NSLog(@"Last Error Code = %d",errorCode);
        
        if(errorCode != 0 && updateRecoed == true)
        {
            [database rollback];
            //NSLog(@"last Error: %@",[database lastErrorMessage]);
            NSAssert1(0, @"Error while upate dynamic data in Database '%@'",[database lastErrorMessage] );
            updateRecoed = false;
        }
        
        [database commit];
        
        //[self FMDBOpen];
    }
    @catch (NSException *exception)
    {
        [database rollback];
        //NSLog(@"Exception Reason = %@",exception.reason);
        updateRecoed = false;
    }
    @finally
    {
        [database close];
    }
    
    return   updateRecoed;
    
  
    
}


-(BOOL)UpdateDynamicdata :(NSString *)tablename :(NSMutableDictionary *)updatedict :(NSString *)updatecriteria
{
    BOOL updateRecoed = false;
    
    
    NSArray *fieldNameKeyArray = [updatedict allKeys];
    NSString *dynamicQry = [NSString stringWithFormat:@"update %@ SET ",tablename];
    NSString *wherecondition = @"";
    if(![updatecriteria isEqualToString:@""])
    {
        wherecondition = [NSString stringWithFormat:@"%@%@",@"where ",updatecriteria];
    }
    
    for(int i=0;i<fieldNameKeyArray.count;i++)
    {
        NSString *filedName = [fieldNameKeyArray objectAtIndex:i];
        
        NSString *value = [updatedict objectForKey:filedName];
        
        dynamicQry = [dynamicQry stringByAppendingFormat:@"%@%@'%@'%@",filedName,@"=",value,@","];
        
    }
    
    dynamicQry = [dynamicQry substringToIndex:[dynamicQry length] - 1];
    
    dynamicQry = [dynamicQry stringByAppendingString:wherecondition];
    
    
    NSLog(@"Dynamic Insert Qry = %@",dynamicQry);
    
    
    @try
    {
        [self FMDBOpen];
        
        [database beginTransaction];
        
        updateRecoed = [database executeUpdate:dynamicQry,nil];
        
        
        int errorCode = [database lastErrorCode];
        //NSLog(@"Last Error Code = %d",errorCode);
        
        if(errorCode != 0 && updateRecoed == true)
        {
            [database rollback];
            //NSLog(@"last Error: %@",[database lastErrorMessage]);
            NSAssert1(0, @"Error while upate dynamic data in Database '%@'",[database lastErrorMessage] );
            updateRecoed = false;
        }
        
        [database commit];
        
        //[self FMDBOpen];
    }
    @catch (NSException *exception)
    {
        [database rollback];
        //NSLog(@"Exception Reason = %@",exception.reason);
        updateRecoed = false;
    }
    @finally
    {
        [database close];
    }
    
    return   updateRecoed;
    
}




//Pass Insert Parameter field and value and table name
-(int)InsertDynamictData :(NSString *)tableName :(NSMutableDictionary *)insertDict
{
    // if table is order item that time ..
    // get sequence no or insert sequence no..
    
    if ([tableName isEqualToString:@"order_item"])
    {
        int getDisplayOrder = [[insertDict objectForKey:@"display_order"] intValue];
        
        if (getDisplayOrder > 0)
        {
            // do nothing
        }
        else
        {
            
            //SELECT MAX(order_sequence) FROM order_item
            
            NSString *dynQuery = @"SELECT MAX(display_order) FROM order_item";
            
            NSLog(@"dynQuery:%@",dynQuery);
            
            FMResultSet *results = [self SelectDataByQry:dynQuery];
            int orderMaxValue = 0;
            while ([results next])
            {
                orderMaxValue = [[results stringForColumn:@"MAX(display_order)"] intValue];
            }
            
            // update dict...
            NSLog(@"orderMaxValue:%d",orderMaxValue);
            orderMaxValue = orderMaxValue + 1;
            NSLog(@"orderMaxValue:%d",orderMaxValue);
            
            NSLog(@"dict:%@",insertDict);
            [insertDict setObject:[NSString stringWithFormat:@"%d",orderMaxValue] forKey:@"display_order"];
            NSLog(@"after change dict:%@",insertDict);
            NSLog(@"orderMaxValue:%d",orderMaxValue);
            
        }
            
    }
    
    
    
    NSLog(@"new insert Dict :%@",insertDict);
    
    int lastRecordInsertedId = 0;
    
    NSArray *fieldNameKeyArray = [insertDict allKeys];
    NSString *dynamicQry = [NSString stringWithFormat:@"insert into %@ (",tableName];
    
    NSString *valueString = @"values(";
    
    for(int i=0;i<fieldNameKeyArray.count;i++)
    {
        NSString *filedName = [fieldNameKeyArray objectAtIndex:i];
        
        NSString *value = [insertDict objectForKey:filedName];
        
        dynamicQry = [dynamicQry stringByAppendingFormat:@"%@%@",filedName,@","];
        
        valueString = [valueString stringByAppendingFormat:@"'%@'%@",value,@","];
        
    }
    
    dynamicQry = [dynamicQry substringToIndex:[dynamicQry length] - 1];
    NSLog(@"dynamicQry:%@",dynamicQry);
    
    valueString = [valueString substringToIndex:[valueString length] - 1];
    NSLog(@"valueString:%@",valueString);
    
    dynamicQry = [dynamicQry stringByAppendingFormat:@"%@%@%@",@")",valueString,@")"];
    NSLog(@"dynamicQry:%@",dynamicQry);
    
    //NSLog(@"Dynamic Insert Qry = %@",dynamicQry);
    
    @try
    {
        [self FMDBOpen];
        
        [database beginTransaction];
        
        BOOL insertRecord =   [database executeUpdate:dynamicQry,nil];
        
        int errorCode = [database lastErrorCode];
        
        //NSLog(@"Last Error Code = %d",errorCode);
        
        if(errorCode == 0 && insertRecord == true)
        {
            [database commit];
            lastRecordInsertedId = (int)[database lastInsertRowId];
            //NSLog(@"Last Inserted Row Id = %d",lastRecordInsertedId);
        }
        else
        {
            [database rollback];
            //NSLog(@"last Error: %@",[database lastErrorMessage]);
            NSAssert1(0, @"Error while inserting data in Database '%@'",[database lastErrorMessage] );
        }
        
        //[self FMDBOpen];
    }
    @catch (NSException *exception) {
        
        //NSLog(@"Exception Reason = %@",exception.reason);
        lastRecordInsertedId  = 0;
        [database rollback];
    }
    @finally
    {
        [database close];
    }
    
    return   lastRecordInsertedId;
    
}


// Pass Delete TableName and delete criteria(where condition) if condition not exist then ""
-(BOOL)DeleteDynamicData :(NSString *)tableName :(NSString *)deleteCriteria
{
   

    BOOL deleteRecord = false;
    
    NSString *dynamicQry = [NSString stringWithFormat:@"%@%@",@"delete from ",tableName];
    
    NSString *deleteWhereCondition = @"";
    if(![deleteCriteria isEqualToString:@""])
    {
        deleteWhereCondition = [NSString stringWithFormat:@" Where %@",deleteCriteria];
    }
    dynamicQry = [dynamicQry stringByAppendingString:deleteWhereCondition];
    
    NSLog(@"dynamicQry:%@",dynamicQry);
    
    @try
    {
        [self FMDBOpen];
        
        [database beginTransaction];
        
        deleteRecord = [database executeUpdate:dynamicQry,nil];
        
        int errorCode = [database lastErrorCode];
        
        //NSLog(@"Last Error Code = %d",errorCode);
        
        if(errorCode != 0)
        {
            [database rollback];
            deleteRecord = false;
            //NSLog(@"last Error: %@",[database lastErrorMessage]);
            NSAssert1(0, @"Error while inserting data in Database '%@'",[database lastErrorMessage] );
        }
        
        [database commit];
        //[self FMDBOpen];
    }
    @catch (NSException *exception)
    {
        [database rollback];
        //NSLog(@"Exception Reason = %@",exception.reason);
        deleteRecord = false;
    }
    @finally
    {
        [database close];
    }
    
    return   deleteRecord;
    
}


-(void)DeleteAllData :(NSString *)tableName
{
    BOOL deleteRecord = false;
    
    NSString *dynamicQry = [NSString stringWithFormat:@"delete from %@",tableName];
    /*
    NSString *deleteWhereCondition = @"";
    if(![deleteCriteria isEqualToString:@""])
    {
        deleteWhereCondition = [NSString stringWithFormat:@" Where %@",deleteCriteria];
    }
    dynamicQry = [dynamicQry stringByAppendingString:deleteWhereCondition];
    */
    NSLog(@"dynamicQry:%@",dynamicQry);
    
    @try
    {
        [self FMDBOpen];
        
        [database beginTransaction];
        
        deleteRecord = [database executeUpdate:dynamicQry,nil];
        
        int errorCode = [database lastErrorCode];
        
        //NSLog(@"Last Error Code = %d",errorCode);
        
        if(errorCode != 0)
        {
            [database rollback];
            deleteRecord = false;
            //NSLog(@"last Error: %@",[database lastErrorMessage]);
            NSAssert1(0, @"Error while inserting data in Database '%@'",[database lastErrorMessage] );
        }
        
        [database commit];
        //[self FMDBOpen];
    }
    @catch (NSException *exception)
    {
        [database rollback];
        //NSLog(@"Exception Reason = %@",exception.reason);
        deleteRecord = false;
    }
    @finally
    {
        [database close];
    }
    
   // return   deleteRecord;
    
}


-(FMResultSet *)SelectData:(NSString *)tableName :(NSMutableArray *)fieldArray
{
   
    
    NSString *dynamicQuery = @"Select ";
    
    for(int i=0;i<fieldArray.count;i++)
    {
        dynamicQuery = [dynamicQuery stringByAppendingFormat:@"%@%@",[fieldArray objectAtIndex:i],@","];
    }
    
    dynamicQuery = [dynamicQuery substringToIndex:[dynamicQuery length] -1];
    
    dynamicQuery = [dynamicQuery stringByAppendingFormat:@" from %@",tableName];
    
    FMResultSet *results;
    @try
    {
        [self FMDBOpen];
        
        results = [database executeQuery:dynamicQuery];
        
        int errorCode = [database lastErrorCode];
        
        if(errorCode != 0)
        {
            results = NULL;
            
            //NSLog(@"Select All Data Error = %@",[database lastErrorMessage]);
        }
        
        return results;
        
    }
    @catch (NSException *exception)
    {
        //NSLog(@"Exception for Select All Data = %@",exception.reason);
        
        return results;
        
    }
    @finally
    {
        [database close];
    }
    
    
}

-(FMResultSet *)SelectDataById:(NSString *)tableName :(NSMutableArray *)fieldArray :(NSString *)fieldName :(NSString *)value
{
   
    NSString *dynamicQuery = @"Select ";
    
    for(int i=0;i<fieldArray.count;i++)
    {
        dynamicQuery = [dynamicQuery stringByAppendingFormat:@"%@%@",[fieldArray objectAtIndex:i],@","];
    }
    
    dynamicQuery = [dynamicQuery substringToIndex:[dynamicQuery length] -1];
    
    dynamicQuery = [dynamicQuery stringByAppendingFormat:@" from %@",tableName];
    
    NSString *whereCondition = [NSString stringWithFormat:@"%@%@%@%@",@" Where ",fieldName,@"=",value];
    
    dynamicQuery = [dynamicQuery stringByAppendingString:whereCondition];
    
    
    FMResultSet *results;
    
    @try
    {
        [self FMDBOpen];
        
        results = [database executeQuery:dynamicQuery];
        
        int errorCode = [database lastErrorCode];
        
        if(errorCode != 0)
        {
            results = NULL;
            
            //NSLog(@"Select All Data Error = %@",[database lastErrorMessage]);
        }
        
        return results;
        
    }
    @catch (NSException *exception)
    {
        //NSLog(@"Exception for Select All Data = %@",exception.reason);
        
        return results;
        
    }
    @finally
    {
        [database close];
    }
    
    
}

-(FMResultSet *)SelectDataByCriteria:(NSString *)tableName :(NSMutableArray *)fieldArray :(NSString *)selectCriteria
{
   

    //NSLog(@"FieldArray from DBManage = %@",fieldArray);
    
    NSString *dynamicQuery = @"Select ";
    
    for(int i=0;i<fieldArray.count;i++)
    {
        dynamicQuery = [dynamicQuery stringByAppendingFormat:@"%@%@",[fieldArray objectAtIndex:i],@","];
    }
    
    dynamicQuery = [dynamicQuery substringToIndex:[dynamicQuery length] -1];
    
    dynamicQuery = [dynamicQuery stringByAppendingFormat:@" from %@",tableName];
    
    NSString *whereCondition = @"";
    
    if(![selectCriteria isEqualToString:@""])
    {
        whereCondition = [NSString stringWithFormat:@"%@%@",@" Where ",selectCriteria];
    }
    
    dynamicQuery = [dynamicQuery stringByAppendingString:whereCondition];
    
    NSLog(@"Dynamic Query = %@",dynamicQuery);
    
    FMResultSet *results;
    @try
    {
        [self FMDBOpen];
        
        results = [database executeQuery:dynamicQuery];
        
        int errorCode = [database lastErrorCode];
        
        if(errorCode != 0)
        {
            results = NULL;
            
            //NSLog(@"Select All Data Error = %@",[database lastErrorMessage]);
        }
        
        return results;
        
    }
    @catch (NSException *exception)
    {
        //NSLog(@"Exception for Select All Data = %@",exception.reason);
        
        return results;
        
    }
    @finally
    {
        //[database close];
    }
    
}


-(FMResultSet *)SelectDataByQry:(NSString *)selectQry
{
    
    //NSLog(@"Qry = %@",selectQry);
    
    FMResultSet *results;
    @try
    {
        [self FMDBOpen];
        
        results = [database executeQuery:selectQry];
        
        int errorCode = [database lastErrorCode];
        
        if(errorCode != 0)
        {
            results = NULL;
            
            //NSLog(@"Select All Data Error = %@",[database lastErrorMessage]);
        }
        
        //NSLog(@"Results = %@",results);
        
        return results;
        
    }
    @catch (NSException *exception)
    {
        //NSLog(@"Exception for Select All Data = %@",exception.reason);
        
        return results;
        
    }
    @finally
    {
        //[database close];
    }
    
    
}


// return count row of table
-(int)GetTableRowCount:(NSString *)tableName
{
   
    int count = 0;
    
    @try {
        
        [self FMDBOpen];
        
        NSString *strQuery = @"";
        
        strQuery = [NSString stringWithFormat:@"Select Count(*) from %@",tableName];
        /*
         strQuery = [strQuery stringByAppendingString:@"SELECT COUNT (*) FROM "];
         strQuery = [strQuery stringByAppendingFormat:@"%@",tableName];
         */
        count = [database intForQuery:strQuery];
        
        int errorCode = [database lastErrorCode];
        if(errorCode != 0)
        {
            
            //NSLog(@"last Error: %@",[database lastErrorMessage]);
            NSAssert1(0, @"Error while inserting data in Database '%@'",[database lastErrorMessage] );
            count = 0;
        }
        
    }
    @catch (NSException *exception) {
        
        count = 0;
        NSAssert1(0, @"Error while inserting data in Database '%@'",exception.reason);
        
    }
    @finally {
        [database close];
    }
    
    //NSLog(@"Table Row Count = %d",count);
    
    return count;
}

-(NSString *)getDate
{
    //server_date
    NSString *getResultValue;
    @try {
        
        [self FMDBOpen];
        
        NSString *strQuery = @"";
        
        strQuery = [NSString stringWithFormat:@"SELECT server_date FROM data_sync ORDER BY id DESC LIMIT 1"];
        
                
        getResultValue = [database stringForQuery:strQuery];
        
        int errorCode = [database lastErrorCode];
        if(errorCode != 0)
        {
            
            NSLog(@"last Error: %@",[database lastErrorMessage]);
            NSAssert1(0, @"Error while inserting data in Database '%@'",[database lastErrorMessage] );
           
        }
        
    }
    @catch (NSException *exception) {
        
        
        NSAssert1(0, @"Error while get single double value in Database '%@'",exception.reason);
        
    }
    @finally {
        [database close];
    }

    return getResultValue;
}
-(int)BatchInsertData :(NSString *)tableName :(NSMutableArray *)insertValueArray
{
    
    int fixInsertCount = 49 ;
    int lastRecordInsertedId = 0;
    @try
    {
        
        NSString *dynamicQuery = [NSString stringWithFormat:@"Insert into %@",tableName];
        NSString *fieldString  = @"(";
        NSString *valueString = @"Select ";
        
        
        BOOL filedBind  = false;
        for(int i=0; i<insertValueArray.count;i++)
        {
            
            NSMutableDictionary *itemDict = [insertValueArray objectAtIndex:i];
            
            
           // NSLog(@"<#string#>")
            NSArray *itemDictKeysArray = [itemDict allKeys];
            
            for(int j=0;j<itemDictKeysArray.count;j++)
            {
                if(!filedBind)
                {
                    fieldString = [fieldString stringByAppendingFormat:@"%@%@",[itemDictKeysArray objectAtIndex:j],@","];
                }
                valueString = [valueString stringByAppendingFormat:@"'%@'%@",[itemDict objectForKey:[itemDictKeysArray objectAtIndex:j]],@","];
                
                // //NSLog(@"Value String = %@",valueString);
            }
            filedBind = true;
            valueString = [valueString substringToIndex:[valueString length]-1];
            //valueString = [valueString stringByAppendingFormat:@"%@%@",@")",@",("];
            
            
            if( (i%fixInsertCount != 0 || i == 0) && i != (insertValueArray.count - 1))
            {
                valueString = [valueString stringByAppendingFormat:@"%@",@"UNION SELECT "];
            }
            
            // //NSLog(@"Outer loop Value String = %@",valueString);
            
            
            if(i!=0 && i%fixInsertCount == 0)
            {
                fieldString = [fieldString substringToIndex:[fieldString length]-1];
                
                fieldString = [fieldString stringByAppendingString:@")"];
                
                //valueString = [valueString substringToIndex:[valueString length]-2];
                //valueString = [valueString stringByAppendingString:@")"];
                
                dynamicQuery = [dynamicQuery stringByAppendingFormat:@"%@%@",fieldString,valueString];
                
                // dynamicQuery = @"Insert into test(name,age,city,Amount) SELECT 'Rashid',25,'Ahmedabad',50.0 UNION SELECT 'Mahipal',25,'Ahmedabad',50.25";
                
                // //NSLog(@"Dynamic Query = %@",dynamicQuery);
                
                lastRecordInsertedId =  [self InsertDynamicQry:dynamicQuery];
                filedBind = false;
                dynamicQuery = [NSString stringWithFormat:@"Insert into %@",tableName];
                fieldString  = @"(";
                valueString = @"Select ";
                
            }
            
        }
        
        //remaining data
        if(insertValueArray.count != fixInsertCount)
        {
            fieldString = [fieldString substringToIndex:[fieldString length]-1];
            fieldString = [fieldString stringByAppendingString:@")"];
            
            //valueString = [valueString substringToIndex:[valueString length]-2];
            //valueString = [valueString stringByAppendingString:@")"];
            
            dynamicQuery = [dynamicQuery stringByAppendingFormat:@"%@%@",fieldString,valueString];
            
            // dynamicQuery = @"Insert into test(name,age,city,Amount) SELECT 'Rashid',25,'Ahmedabad',50.0 UNION SELECT 'Mahipal',25,'Ahmedabad',50.25";
            
            // //NSLog(@"Dynamic Query = %@",dynamicQuery);
            
            lastRecordInsertedId =  [self InsertDynamicQry:dynamicQuery];
            
        }
        
        
        //[self FMDBOpen];
    }
    @catch (NSException *exception) {
        
        //NSLog(@"Exception Reason = %@",exception.reason);
        lastRecordInsertedId  = 0;
        [database rollback];
    }
    @finally {
        [database close];
    }
    
    return   lastRecordInsertedId;
    
    
    
}


-(int)InsertDynamicQry :(NSString *)dynamicQry
{
    int lastRecordInsertedId = 0;
    
    @try
    {
        
        [self FMDBOpen];
        
        [database beginTransaction];
        
        //     BOOL insertRecord =   [database executeUpdate:dynamicQuery,nil];
        
        BOOL insertRecord = [database executeUpdate:dynamicQry];
        int errorCode = [database lastErrorCode];
        
        //NSLog(@"Last Error Code = %d",errorCode);
        
        if(errorCode == 0 && insertRecord == true)
        {
            [database commit];
            lastRecordInsertedId = (int)[database lastInsertRowId];
            //NSLog(@"Last Inserted Row Id = %d",lastRecordInsertedId);
        }
        else
        {
            [database rollback];
            lastRecordInsertedId = 0;
            //NSLog(@"last Error: %@",[database lastErrorMessage]);
            NSAssert1(0, @"Error while Batch inserting data in Database '%@'",[database lastErrorMessage] );
        }
        
        
    }
    @catch (NSException *exception) {
        lastRecordInsertedId = 0;
    }
    @finally {
        
        [database close];
    }
}

-(double)GetSingleDoubleValue :(NSString *)tableName :(NSString *)fieldName :(NSString *)selectCriteria
{
    
    NSLog(@"tabl name 1 == %@",tableName);
    
    NSLog(@"tabl name 2 == %@",tableName);
    double getResultValue = 0;
    
    @try {
        
        [self FMDBOpen];
        
        NSString *strQuery = @"";
        
        strQuery = [NSString stringWithFormat:@"Select %@ from %@ ",fieldName,tableName];
        
        NSString *whereCondition = @"";
        if(![selectCriteria isEqualToString:@""])
        {
            whereCondition = [whereCondition stringByAppendingFormat:@" Where %@",selectCriteria];
        }
        strQuery = [strQuery stringByAppendingString:whereCondition];
        
        NSLog(@"strQuery:%@",strQuery);
        
        getResultValue = [database doubleForQuery:strQuery];
        
        int errorCode = [database lastErrorCode];
        if(errorCode != 0)
        {
            
            NSLog(@"last Error: %@",[database lastErrorMessage]);
            NSAssert1(0, @"Error while inserting data in Database '%@'",[database lastErrorMessage] );
            getResultValue = 0;
        }
        
    }
    @catch (NSException *exception) {
        
        getResultValue = 0;
        NSAssert1(0, @"Error while get single double value in Database '%@'",exception.reason);
        
    }
    @finally {
        [database close];
    }
    
    return getResultValue;
    
}


-(int)GetSingleIntegerValue :(NSString *)tableName :(NSString *)fieldName :(NSString *)selectCriteria
{
    
    int getResultValue = 0;
    
    @try {
        
        [self FMDBOpen];
        
        NSString *strQuery = @"";
        
        strQuery = [NSString stringWithFormat:@"Select %@ from %@ ",fieldName,tableName];
        
        NSLog(@"strquery:%@",strQuery);
        
        NSString *whereCondition = @"";
        if(![selectCriteria isEqualToString:@""])
        {
            whereCondition = [whereCondition stringByAppendingFormat:@" Where %@",selectCriteria];
        }
        strQuery = [strQuery stringByAppendingString:whereCondition];
        
        NSLog(@"strQuery:%@",strQuery);
        
        getResultValue = [database doubleForQuery:strQuery];
        
        NSLog(@"get result value:%d",getResultValue);
        
        int errorCode = [database lastErrorCode];
        if(errorCode != 0)
        {
            
            //NSLog(@"last Error: %@",[database lastErrorMessage]);
            NSAssert1(0, @"Error while inserting data in Database '%@'",[database lastErrorMessage] );
            getResultValue = 0;
        }
        
    }
    @catch (NSException *exception) {
        
        getResultValue = 0;
        NSAssert1(0, @"Error while get single double value in Database '%@'",exception.reason);
        
    }
    @finally {
        [database close];
    }
    
    return getResultValue;
    
}


-(NSString *)GetSingleStringValue :(NSString *)tableName :(NSString *)fieldName :(NSString *)selectCriteria
{
    NSString  *getResultValue = @"";
    
    @try {
        
        [self FMDBOpen];
        
        NSString *strQuery = @"";
        
        strQuery = [NSString stringWithFormat:@"Select %@ from %@ ",fieldName,tableName];
        NSLog(@"strquery:%@",strQuery);
        
        NSString *whereCondition = @"";
        if(![selectCriteria isEqualToString:@""])
        {
            whereCondition = [whereCondition stringByAppendingFormat:@" Where %@",selectCriteria];
        }
        
        strQuery = [strQuery stringByAppendingString:whereCondition];
        NSLog(@"strquery:%@",strQuery);
        
        
        getResultValue = [database stringForQuery:strQuery];
        NSLog(@"getResultValue:%@",getResultValue);
        
        
        int errorCode = [database lastErrorCode];
        if(errorCode != 0)
        {
            //NSLog(@"last Error: %@",[database lastErrorMessage]);
            NSAssert1(0, @"Error while inserting data in Database '%@'",[database lastErrorMessage]);
            getResultValue = @"";
        }
        
    }
    @catch (NSException *exception)
    {
        
        getResultValue = @"";
        NSAssert1(0, @"Error while get single double value in Database '%@'",exception.reason);
        
    }
    @finally
    {
        [database close];
    }
    
    return getResultValue;
    
}


-(void)FMDBClose
{
    if(database != NULL)
    {
        [database close];
    }
}


//***************** Common Method for Add Update Delete End here ***************

-(void)openDatabase
{
    BOOL success = NO;
    
	//NSError *Error;
	NSFileManager *FileManager = [NSFileManager defaultManager];
	NSArray *UsrDocPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *DocsDir = [UsrDocPath objectAtIndex:0];
	NSString *DbPath = [DocsDir stringByAppendingPathComponent:NSLocalizedString(@"appDatabaseName",nil)];
    
    //NSLog(@"DataBase Path In Docs Directory:%@", DbPath);
	
    success = [FileManager fileExistsAtPath:DbPath];
    
    if(success)
    {
		if(sqlite3_open([DbPath UTF8String], &rowDatabase)!=SQLITE_OK)
        {
			sqlite3_close(rowDatabase);
        }
        addSmt = nil;
    }
    
}





@end
