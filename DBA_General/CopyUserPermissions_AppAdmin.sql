DECLARE @UsertoCopy VARCHAR(55) = 'ametcalf';
DECLARE @UsertoInsert VARCHAR(55) = 'jowatkins.contractor';

INSERT  INTO AppAdmin.[dbo].[SysRoleMembers]
        ( [Environment] ,
          [UserId] ,
          [RoleId]
        )
        SELECT  [Environment] ,
                @UsertoInsert ,
                [RoleId]
        FROM    [AppAdmin].[dbo].[SysRoleMembers]
        WHERE   UserId = @UsertoCopy;


		TheBobbinTater3#