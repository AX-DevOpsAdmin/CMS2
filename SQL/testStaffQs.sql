

DECLARE @staffID INT
DECLARE @postID INT
DECLARE @thisDate varchar(30)
 

SET dateformat dmy

SET @staffID=1375
set @postID=1181
SET @thisDate='06/01/2016'
--declare @PostID int
DECLARE @qtot INT

select * from vwStaffQs where staffid=@staffId and ((validFrom <= @thisDate and validEnd >=@thisDate) or (validFrom <= @thisDate and validEnd is null)) 

/**************
SET @qtot=(select sum(total) from (select  tempStaffQs.staffID,

case tempStaffQs.TypeID 

	when '2'then

		case when Competent <> 'N' then qwValue
			else  qwValue/2
		end
		
	else qwValue
end 

as total

from (select * from vwStaffQs where staffid=@staffId and ((validFrom <= @thisDate and validEnd >=@thisDate) or (validFrom <= @thisDate and validEnd is null))) as  tempStaffQs

inner  join 

(select postID,qwValue,startDate,EndDate,postQID,typeID from vwStaffpostQs where staffid=@staffId and postId = @postID and ((startDate <= @thisDate and endDate >=@thisDate) or (startDate <= @thisDate and endDate is null)))  as tempStaffPostQs
   on  tempStaffQs.staffQID = tempStaffPostQs.postQID and tempStaffQs.typeID = tempStaffPostQs.typeID) as newTable 
group by staffID) 


IF @qtot IS NULL
  SET @qtot = 0
SELECT  @qtot as staffQTotal
*********/