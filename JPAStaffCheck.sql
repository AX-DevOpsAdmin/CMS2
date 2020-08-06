

--select * from tblhierarchy

DECLARE @staffID INT
DECLARE @servno VARCHAR(20)

DECLARE jpa1 SCROLL CURSOR FOR
 --SELECT tblStaff.staffID, firstname, surname, serviceno 
 SELECT tblStaff.staffID, serviceno
    FROM tblPost
    INNER JOIN tblStaffPost ON tblStaffPost.PostID=tblPost.postID AND tblStaffPost.endDate IS NULL
    INNER JOIN tblStaff ON tblStaff.staffID=tblStaffPost.StaffID
    INNER JOIN jpastaff ON jpastaff.[Employee Number]=tblStaff.serviceno
    WHERE tblPost.hrcID=677
    
    OPEN jpa1

 FETCH NEXT FROM jpa1 INTO @staffID, @servno
 
 WHILE @@FETCH_STATUS = 0
   BEGIN
      
       SELECT * FROM jpaDental WHERE [Employee Number] = @servno
       SELECT * FROM jpaFitness WHERE [Employee Number] = @servno
       
       FETCH NEXT FROM jpa1 INTO @staffID, @servno
       
   END
   
 CLOSE jpa1
 DEALLOCATE jpa1