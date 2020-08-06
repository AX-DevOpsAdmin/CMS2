
USE CMS2

--SELECT * FROM tblAuths
  /**
  SELECT T1.authID, T1.authCode, t2.authcode AS parent 
        FROM tblAuths AS T1
        LEFT OUTER JOIN tblAuths AS T2 ON T2.authID=T1.apprvID 
        -- WHERE T1.ndeID=@nodeID
        --WHERE T1.authID=18
     **/   
 WITH tblChild AS
		(
		   SELECT T1.authID, T1.authCode, T1.apprvID, CAST(T1.authID AS VARCHAR(255)) AS authPath -- 
		      --T1.hrclevel, T1.hrcchildren, CAST(T1.hrcID AS VARCHAR(255)) AS hrcPath -- , 0 AS depth
		     FROM tblAuths T1 WHERE T1.apprvID =0 -- AND T1.ndeID=@nodeID
		  UNION ALL
		   SELECT T2.authID, T2.authCode,T2.apprvID, CAST(AuthPath + '.' + CAST(T2.authID AS VARCHAR(255)) AS VARCHAR(255))    --  depth + 1
		     FROM tblAuths T2
		        INNER JOIN tblChild ON T2.apprvID=tblChild.authID
		  )
		  SELECT * FROM tblChild 
