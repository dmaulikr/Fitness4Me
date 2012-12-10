//
//  EquipmentDB.m
//  Fitness4Me
//
//  Created by Ciby  on 03/12/12.
//
//

#import "EquipmentDB.h"

@implementation EquipmentDB

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}



-(void)setUpDatabase
{
    self.databaseName =@"Fitness.sqlite";
    NSArray *docPath= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir =[docPath objectAtIndex:0];
    self.databasePath =[docDir stringByAppendingPathComponent:self.databaseName];
    
    
}


-(void)createDatabase{
    
    BOOL success;
    NSFileManager *filemanager =[NSFileManager defaultManager];
    success =[filemanager  fileExistsAtPath:self.databasePath];
    if(success){
        return;
    }
    
    NSString *databaseFromPath=[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:self.databaseName];
    [filemanager copyItemAtPath:databaseFromPath toPath:self.databasePath error:nil];
}


-(NSMutableArray*)getequipments{
       
    self.database =[FMDatabase databaseWithPath:self.databasePath];
    self.equipments=[[NSMutableArray alloc]init];
    
    if(!self.database.open){
       // NSLog(@"Databse not Open");
    }
    
    
    FMResultSet *resultSet=[self.database executeQuery:@"Select equipmentID,equipmentName from Equipments"];
    while(resultSet.next){
        NSString * equipmentId =[resultSet stringForColumnIndex:0];
        NSString *equipmentName = [resultSet stringForColumnIndex:1];
        Equipments *equipment = [[Equipments alloc]init];
        [equipment setEquipmentID:equipmentId];
        [equipment setEquipmentName:equipmentName];
        [self.equipments addObject:equipment];
    }
    
    [resultSet close];
       
    return self.equipments;
    

    
}


-(void)insertEquipment:(Equipments *)equipment{
    
    self.database =[FMDatabase databaseWithPath:self.databasePath];
    if(!self.database.open){
      //  NSLog(@"Databse not Open");
    }
    [self.database beginTransaction];
    [self.database executeUpdate:@"INSERT INTO Equipments (equipmentID,equipmentName) VALUES (?,?);",
     equipment.equipmentID,equipment.equipmentName, nil];
    [self.database commit];
    [self.database close];
    
    
}


-(void)insertEquipments:(NSMutableArray *)equipments;
{
    int equipmentCount =equipments.count;
    [self deleteEquipments];
    
    Equipments *equipment;
    
    for (int count=0; count<equipmentCount; count++) {
        
        equipment =[Equipments new];
        
        // NSString *excersiceIdnetity =[[excersices objectAtIndex: count] valueForKey:@"ExcersiceID"];
        equipment.equipmentID =  [[equipments objectAtIndex: count] valueForKey:@"equipmentID"];
        equipment.equipmentName = [[equipments objectAtIndex: count] valueForKey: @"equipmentName"];
       
        [self insertEquipment:equipment];
                
    }
    
}


-(NSString*)getSelectedEquipments:(NSString*)equipmentID{
    [self setUpDatabase];
    [self createDatabase];
    
    self.database =[FMDatabase databaseWithPath:self.databasePath];
    NSString *equipments =[[NSString alloc]init];
    if(!self.database.open){
     //   NSLog(@"Databse not Open");
    }
    
    NSString *query =[NSString stringWithFormat:@"Select * from Equipments where equipmentID in (%@)",equipmentID];
    FMResultSet *resultSet=[self.database executeQuery:query];
    
    
    while (resultSet.next) {
        
        
        if ([equipments length]==0) {
            
            equipments =[equipments stringByAppendingString:[resultSet stringForColumnIndex:1]];
        }
        else
        {
            equipments=[equipments stringByAppendingString:@","];
            equipments =[equipments stringByAppendingString:[resultSet stringForColumnIndex:1]];
            
        }
    }
    
    
    [resultSet close];
   // NSLog(@"%@",equipments );
    return equipments;
    
    
    
}


-(NSMutableArray*)getEquipmentsArray:(NSString*)equipmentsName{
    [self setUpDatabase];
    [self createDatabase];
    
    self.database =[FMDatabase databaseWithPath:self.databasePath];
    NSMutableArray *equipments =[[NSMutableArray alloc]init];
    if(!self.database.open){
        //   NSLog(@"Databse not Open");
    }
    
    NSString *query =[NSString stringWithFormat:@"Select * from Equipments where equipmentName in (%@)",equipmentsName];
    FMResultSet *resultSet=[self.database executeQuery:query];
    
    
    while (resultSet.next) {
        
        
        [equipments addObject:[resultSet stringForColumnIndex:0]];
    }
    
    
    [resultSet close];
    // NSLog(@"%@",equipments );
    return equipments;
    
    
    
}





-(void)deleteEquipments{
    
    self.database =[FMDatabase databaseWithPath:self.databasePath];
    
    if(!self.database.open){
        NSLog(@"Databse not Open");
    }
    
    
    [self.database beginTransaction];
    
    [self.database executeUpdate:@"Delete from Equipments"];
    
    [self.database commit];

    [self.database close];
    
    
}

@end
