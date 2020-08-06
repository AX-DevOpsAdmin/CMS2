

DELETE tblNode WHERE ndeID>3

DELETE tblHierarchy WHERE ndeID>3

DELETE tblTradeGroup WHERE ndeID>3

DELETE tblTrade WHERE ndeID>3

DELETE tblRank WHERE ndeID>3

DELETE tblRankWeight WHERE ndeID>3

DELETE tblConfig WHERE ndeID>3

DELETE tblPost WHERE ndeID>3

DELETE tblStaff WHERE ndeID>3

DELETE tblStaffPost WHERE ndeID>3

DELETE tblPassword WHERE ndeID>3
GO

DBCC CHECKIDENT('tblNode', RESEED, 3)
