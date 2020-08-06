
    USE [90SUCMS]
    
    DECLARE @taskID INT
    DECLARE @taskTypeID INT
    DECLARE @bna INT
    DECLARE @name VARCHAR(200)
    
    /**
    UPDATE tbl_Task 
       SET description=REPLACE(description,'Z-DO NOUT USE-', '')
       
     UPDATE tbl_Task 
       SET description=REPLACE(description,'-', '') WHERE description like ' -%' 
       
    
    -- First get rid of all unused task types
    SELECT * FROM tblTaskType 
      WHERE NOT EXISTS (SELECT ttID FROM tbl_Task WHERE tbl_task.taskTypeID=tblTaskType.ttID)
    DELETE FROM tblTaskType 
      WHERE NOT EXISTS (SELECT ttID FROM tbl_Task WHERE tbl_task.taskTypeID=tblTaskType.ttID)
   
    
    -- Sport  taskTypeID = 25
      -- taskID 3928 No Harmony
      -- taskID 5136 BNA
    DECLARE fld1 CURSOR FOR SELECT taskID, taskTypeID, [description] FROM tbl_Task 
      WHERE taskTypeID=25 AND ooa=0 AND taskID <> 3928
		OPEN fld1
		FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name

		WHILE @@FETCH_STATUS = 0
		   BEGIN
		     UPDATE tbl_TaskStaff 
		        SET taskID = 3928,
		            taskNote=@name + ' - ' + taskNote  
		        WHERE taskID = @taskID
		     FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name
		   END
		   
	   CLOSE fld1
	   DEALLOCATE fld1
	 
	DECLARE fld1 CURSOR FOR SELECT taskID, taskTypeID, [description] FROM tbl_Task 
      WHERE taskTypeID=25 AND ooa=2 AND taskID <> 5136
		OPEN fld1
		FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name

		WHILE @@FETCH_STATUS = 0
		   BEGIN
		     UPDATE tbl_TaskStaff 
		        SET taskID = 5136,
		            taskNote=@name + ' - ' + taskNote  
		        WHERE taskID = @taskID
		     FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name
		   END
		   
	   CLOSE fld1
	   DEALLOCATE fld1  
	
	  
    -- External Exercise taskTypeID = 29
     -- taskID  5364 No Harmony
     -- taskID  5365 OOA
     -- taskID  4047 BNA
   DECLARE fld1 CURSOR FOR SELECT taskID, taskTypeID, [description] FROM tbl_Task 
      WHERE taskTypeID=29 AND ooa=0 AND taskID <> 5364
		OPEN fld1
		FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name

		WHILE @@FETCH_STATUS = 0
		   BEGIN
		     UPDATE tbl_TaskStaff 
		        SET taskID = 5364,
		            taskNote=@name + ' - ' + taskNote  
		        WHERE taskID = @taskID
		     FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name
		   END
		   
	   CLOSE fld1
	   DEALLOCATE fld1
	     
	
	DECLARE fld1 CURSOR FOR SELECT taskID, taskTypeID, [description] FROM tbl_Task 
      WHERE taskTypeID=29 AND ooa=2 AND taskID <> 4047
		OPEN fld1
		FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name

		WHILE @@FETCH_STATUS = 0
		   BEGIN
		     UPDATE tbl_TaskStaff 
		        SET taskID = 4047,
		            taskNote=@name + ' - ' + taskNote  
		        WHERE taskID = @taskID
		     FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name
		   END
		   
	   CLOSE fld1
	   DEALLOCATE fld1
	   
	 DECLARE fld1 CURSOR FOR SELECT taskID, taskTypeID, [description] FROM tbl_Task 
      WHERE taskTypeID=29 AND ooa=1 AND taskID <> 5365
		OPEN fld1
		FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name

		WHILE @@FETCH_STATUS = 0
		   BEGIN
		     UPDATE tbl_TaskStaff 
		        SET taskID = 5365,
		            taskNote=@name + ' - ' + taskNote  
		        WHERE taskID = @taskID
		     FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name
		   END
		   
	   CLOSE fld1
	   DEALLOCATE fld1
	
	    
    -- Internal Exercise taskTypeID= 28
      -- taskID 4046 No Harmony
      -- taskID 5114  BNA
    DECLARE fld1 CURSOR FOR SELECT taskID, taskTypeID, [description] FROM tbl_Task 
      WHERE taskTypeID=28 AND ooa=0 AND taskID <> 4046
		OPEN fld1
		FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name

		WHILE @@FETCH_STATUS = 0
		   BEGIN
		     UPDATE tbl_TaskStaff 
		        SET taskID = 4046,
		            taskNote=@name + ' - ' + taskNote  
		        WHERE taskID = @taskID
		     FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name
		   END
		   
	   CLOSE fld1
	   DEALLOCATE fld1
	   
	DECLARE fld1 CURSOR FOR SELECT taskID, taskTypeID, [description] FROM tbl_Task 
      WHERE taskTypeID=28 AND ooa=2 AND taskID <> 5114
		OPEN fld1
		FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name

		WHILE @@FETCH_STATUS = 0
		   BEGIN
		     UPDATE tbl_TaskStaff 
		        SET taskID = 5114,
		            taskNote=@name + ' - ' + taskNote  
		        WHERE taskID = @taskID
		     FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name
		   END
		   
	   CLOSE fld1
	   DEALLOCATE fld1
	   
	    
	     

    -- Force Development taskTypeID = 37
     -- taskID 5328 No Harmony
     -- taskID 5365  BNA
     DECLARE fld1 CURSOR FOR SELECT taskID, taskTypeID, [description] FROM tbl_Task 
      WHERE taskTypeID=37 AND ooa=0 AND taskID <> 5328
		OPEN fld1
		FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name

		WHILE @@FETCH_STATUS = 0
		   BEGIN
		     UPDATE tbl_TaskStaff 
		        SET taskID = 5328,
		            taskNote=@name + ' - ' + taskNote  
		        WHERE taskID = @taskID
		     FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name
		   END
		   
	   CLOSE fld1
	   DEALLOCATE fld1
	   
	DECLARE fld1 CURSOR FOR SELECT taskID, taskTypeID, [description] FROM tbl_Task 
      WHERE taskTypeID=37 AND ooa=2 AND taskID <> 5366
		OPEN fld1
		FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name

		WHILE @@FETCH_STATUS = 0
		   BEGIN
		     UPDATE tbl_TaskStaff 
		        SET taskID = 5366,
		            taskNote=@name + ' - ' + taskNote  
		        WHERE taskID = @taskID
		     FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name
		   END
		   
	   CLOSE fld1
	   DEALLOCATE fld1
	   
	   
	    
		              
    -- Adventure Training taskTypeID=38
      -- taskID 5299 No Harmony
     DECLARE fld1 CURSOR FOR SELECT taskID, taskTypeID, [description] FROM tbl_Task 
      WHERE taskTypeID=38 AND ooa=0 AND taskID <> 5299
		OPEN fld1
		FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name

		WHILE @@FETCH_STATUS = 0
		   BEGIN
		     UPDATE tbl_TaskStaff 
		        SET taskID = 5299,
		            taskNote=@name + ' - ' + taskNote  
		        WHERE taskID = @taskID
		     FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name
		   END
		   
	   CLOSE fld1
	   DEALLOCATE fld1
	    
	   
	     
    -- Miscellaneous taskTypeID = 21
      -- taskID 154 No Harmony
      --  taskID 5367 BNA
    DECLARE fld1 CURSOR FOR SELECT taskID, taskTypeID, [description] FROM tbl_Task 
      WHERE taskTypeID=21 AND ooa=0 AND taskID <> 154
		OPEN fld1
		FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name

		WHILE @@FETCH_STATUS = 0
		   BEGIN
		     UPDATE tbl_TaskStaff 
		        SET taskID = 154,
		            taskNote=@name + ' - ' + taskNote  
		        WHERE taskID = @taskID
		     FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name
		   END
		   
	   CLOSE fld1
	   DEALLOCATE fld1
	   
	DECLARE fld1 CURSOR FOR SELECT taskID, taskTypeID, [description] FROM tbl_Task 
      WHERE taskTypeID=21 AND ooa=2 AND taskID <> 5367
		OPEN fld1
		FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name

		WHILE @@FETCH_STATUS = 0
		   BEGIN
		     UPDATE tbl_TaskStaff 
		        SET taskID = 5367,
		            taskNote=@name + ' - ' + taskNote  
		        WHERE taskID = @taskID
		     FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name
		   END
		   
	   CLOSE fld1
	   DEALLOCATE fld1
	
	 
    -- Training TaskTypeID=20
      -- taskID 3930   No Harmony
      -- taskID 5112   BNA
    DECLARE fld1 CURSOR FOR SELECT taskID, taskTypeID, [description] FROM tbl_Task 
      WHERE taskTypeID=20 AND ooa=0 AND taskID <> 3930
		OPEN fld1
		FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name

		WHILE @@FETCH_STATUS = 0
		   BEGIN
		     UPDATE tbl_TaskStaff 
		        SET taskID = 3930,
		            taskNote=@name + ' - ' + taskNote  
		        WHERE taskID = @taskID
		     FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name
		   END
		   
	   CLOSE fld1
	   DEALLOCATE fld1
	   
	DECLARE fld1 CURSOR FOR SELECT taskID, taskTypeID, [description] FROM tbl_Task 
      WHERE taskTypeID=20 AND ooa=2 AND taskID <> 5112
		OPEN fld1
		FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name

		WHILE @@FETCH_STATUS = 0
		   BEGIN
		     UPDATE tbl_TaskStaff 
		        SET taskID = 5112,
		            taskNote=@name + ' - ' + taskNote  
		        WHERE taskID = @taskID
		     FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name
		   END
		   
	   CLOSE fld1
	   DEALLOCATE fld1
	
	            
    -- Course  TaskTypeID=17
      -- taskID 3766  No Harmony
      -- taskID 5367  BNA 
     DECLARE fld1 CURSOR FOR SELECT taskID, taskTypeID, [description] FROM tbl_Task 
      WHERE taskTypeID=17 AND ooa=0 AND taskID <> 3766
		OPEN fld1
		FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name

		WHILE @@FETCH_STATUS = 0
		   BEGIN
		     UPDATE tbl_TaskStaff 
		        SET taskID = 3766,
		            taskNote=@name + ' - ' + taskNote  
		        WHERE taskID = @taskID
		     FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name
		   END
		   
	   CLOSE fld1
	   DEALLOCATE fld1
	   
	DECLARE fld1 CURSOR FOR SELECT taskID, taskTypeID, [description] FROM tbl_Task 
      WHERE taskTypeID=17 AND ooa=2 AND taskID <> 5368
		OPEN fld1
		FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name

		WHILE @@FETCH_STATUS = 0
		   BEGIN
		     UPDATE tbl_TaskStaff 
		        SET taskID = 5368,
		            taskNote=@name + ' - ' + taskNote  
		        WHERE taskID = @taskID
		     FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name
		   END
		   
	   CLOSE fld1
	   DEALLOCATE fld1
	
   
    -- FP Trg  TaskTypeID=16
      -- taskID 3900  No Harmony
      --  taskID 5368  OOA
      -- taskID 5369  BNA 
     DECLARE fld1 CURSOR FOR SELECT taskID, taskTypeID, [description] FROM tbl_Task 
      WHERE taskTypeID=16 AND ooa=0 AND taskID <> 3900
		OPEN fld1
		FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name

		WHILE @@FETCH_STATUS = 0
		   BEGIN
		     UPDATE tbl_TaskStaff 
		        SET taskID = 3900,
		            taskNote=@name + ' - ' + taskNote  
		        WHERE taskID = @taskID
		     FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name
		   END
		   
	   CLOSE fld1
	   DEALLOCATE fld1
	   
	DECLARE fld1 CURSOR FOR SELECT taskID, taskTypeID, [description] FROM tbl_Task 
      WHERE taskTypeID=16 AND ooa=1 AND taskID <> 5369
		OPEN fld1
		FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name

		WHILE @@FETCH_STATUS = 0
		   BEGIN
		     UPDATE tbl_TaskStaff 
		        SET taskID = 5369,
		            taskNote=@name + ' - ' + taskNote  
		        WHERE taskID = @taskID
		     FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name
		   END
		   
	   CLOSE fld1
	   DEALLOCATE fld1
	   
	DECLARE fld1 CURSOR FOR SELECT taskID, taskTypeID, [description] FROM tbl_Task 
      WHERE taskTypeID=16 AND ooa=2 AND taskID <> 5370
		OPEN fld1
		FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name

		WHILE @@FETCH_STATUS = 0
		   BEGIN
		     UPDATE tbl_TaskStaff 
		        SET taskID = 5370,
		            taskNote=@name + ' - ' + taskNote  
		        WHERE taskID = @taskID
		     FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name
		   END
		   
	   CLOSE fld1
	   DEALLOCATE fld1
	   
	 
   
      
     -- Station Duty taskTypeID=12, taskTypeID=13, taskTypeID=15
    --taskID 5370  - Duty no harmony
    --taskid 5375 - Duty BNA
    --taskid 5374 - Duty OOA 
    -- 3905, 3906,4021 - Guard
    DECLARE fld1 CURSOR FOR SELECT taskID, taskTypeID, [description] FROM tbl_Task 
      WHERE (taskTypeID=12 OR taskTypeID=13 OR taskTypeID=15) AND ooa=0 AND taskID <> 5371
		OPEN fld1
		FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name

		WHILE @@FETCH_STATUS = 0
		   BEGIN
		     UPDATE tbl_TaskStaff 
		        SET taskID = 5371,
		            taskNote=@name + ' - ' + taskNote  
		        WHERE taskID = @taskID
		     FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name
		   END
		   
	   CLOSE fld1
	   DEALLOCATE fld1
	   
	DECLARE fld1 CURSOR FOR SELECT taskID, taskTypeID, [description] FROM tbl_Task 
      WHERE (taskTypeID=12 OR taskTypeID=13 OR taskTypeID=15) AND ooa=1 AND taskID <> 5372
		OPEN fld1
		FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name

		WHILE @@FETCH_STATUS = 0
		   BEGIN
		     UPDATE tbl_TaskStaff 
		        SET taskID = 5372,
		            taskNote=@name + ' - ' + taskNote  
		        WHERE taskID = @taskID
		     FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name
		   END
		   
	   CLOSE fld1
	   DEALLOCATE fld1
	   
	DECLARE fld1 CURSOR FOR SELECT taskID, taskTypeID, [description] FROM tbl_Task 
      WHERE (taskTypeID=12 OR taskTypeID=13 OR taskTypeID=15) AND ooa=2 AND taskID <> 5373
		OPEN fld1
		FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name

		WHILE @@FETCH_STATUS = 0
		   BEGIN
		     UPDATE tbl_TaskStaff 
		        SET taskID = 5373,
		            taskNote=@name + ' - ' + taskNote  
		        WHERE taskID = @taskID
		     FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name
		   END
		   
	   CLOSE fld1
	   DEALLOCATE fld1
    
      
    -- Leave taskTypeID=4
     -- TaskID = 3807  No Harmony
     DECLARE fld1 CURSOR FOR SELECT taskID, taskTypeID, [description] FROM tbl_Task 
      WHERE taskTypeID=4 AND ooa=0 AND taskID <> 3807
		OPEN fld1
		FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name

		WHILE @@FETCH_STATUS = 0
		   BEGIN
		     UPDATE tbl_TaskStaff 
		        SET taskID = 3807,
		            taskNote=@name + ' - ' + taskNote  
		        WHERE taskID = @taskID
		     FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name
		   END
		   
	   CLOSE fld1
	   DEALLOCATE fld1
	    
	  
    -- Operations taskTypeID=1
      -- TaskID 5374  No Harmony
      -- TaskID 5362  OOA
      -- TaskID 5363  BNA
    DECLARE fld1 CURSOR FOR SELECT taskID, taskTypeID, [description] FROM tbl_Task 
      WHERE taskTypeID=1 AND ooa=0 AND taskID <> 5374
		OPEN fld1
		FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name

		WHILE @@FETCH_STATUS = 0
		   BEGIN
		     UPDATE tbl_TaskStaff 
		        SET taskID = 5374,
		            taskNote=@name + ' - ' + taskNote  
		        WHERE taskID = @taskID
		     FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name
		   END
		   
	   CLOSE fld1
	   DEALLOCATE fld1
	   
	DECLARE fld1 CURSOR FOR SELECT taskID, taskTypeID, [description] FROM tbl_Task 
      WHERE taskTypeID=1 AND ooa=1 AND taskID <> 5362
		OPEN fld1
		FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name

		WHILE @@FETCH_STATUS = 0
		   BEGIN
		     UPDATE tbl_TaskStaff 
		        SET taskID = 5362,
		            taskNote=@name + ' - ' + taskNote  
		        WHERE taskID = @taskID
		     FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name
		   END
		   
	   CLOSE fld1
	   DEALLOCATE fld1
	   
	DECLARE fld1 CURSOR FOR SELECT taskID, taskTypeID, [description] FROM tbl_Task 
      WHERE taskTypeID=1 AND ooa=2 AND taskID <> 5363
		OPEN fld1
		FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name

		WHILE @@FETCH_STATUS = 0
		   BEGIN
		     UPDATE tbl_TaskStaff 
		        SET taskID = 5363,
		            taskNote=@name + ' - ' + taskNote  
		        WHERE taskID = @taskID
		     FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name
		   END
		   
	   CLOSE fld1
	   DEALLOCATE fld1
    **/ 
	    
	   -- now delete Tasks with no stafftasks
	   DELETE FROM tbl_Task 
            WHERE NOT EXISTS(Select taskID FROM tbl_TaskStaff WHERE tbl_TaskStaff.taskID=tbl_Task.taskID)
  
	  -- now the tasktypes with no tasks
	  DELETE FROM tblTaskType 
      WHERE NOT EXISTS (SELECT ttID FROM tbl_Task WHERE tbl_task.taskTypeID=tblTaskType.ttID)
       /*******************************   
    -- Miscellaneous  taskTypeID=21
    
    -- taskid 5070 - Misc BNA
    -- taskID 154  - Misc no harmony
    
    -- Sport taskTypeID=25
    --taskID 3928  - sport no harmony
    --taskid 4900 - Misc BNA

    -- Station Duty taskTypeID=12, taskTypeID=13, taskTypeID=15
    --taskID 3926  - Duty no harmony
    --taskid 4912 - Duty BNA
    --taskid 5688 - Duty OOA 
    -- 3905, 3906,4021 - Guard
  **********/  
    /**
    DECLARE fld1 CURSOR FOR SELECT taskID, taskTypeID, [description] FROM tbl_Task 
      WHERE taskTypeID=13 AND ooa=1 AND taskID <> 5688
		OPEN fld1
		FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name

		WHILE @@FETCH_STATUS = 0
		   BEGIN
		     UPDATE tbl_TaskStaff 
		        SET taskID = 5688,
		            taskNote=@name + ' - ' + taskNote  
		        WHERE taskID = @taskID
		     FETCH NEXT FROM fld1 INTO @taskID, @taskTypeID, @name
		   END
		   
	   CLOSE fld1
	   DEALLOCATE fld1
	**/