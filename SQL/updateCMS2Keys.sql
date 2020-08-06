


 EXEC sp_rename 'tblMilitarySkills.msvpID', 'vpID', 'COLUMN';
 GO
 EXEC sp_rename 'tblMilitaryVacs.mvvpID', 'vpID', 'COLUMN';
 GO
 EXEC sp_rename 'tblFitness.FitnessvpID', 'vpID', 'COLUMN';
 GO
 EXEC sp_rename 'tblDental.dentalvpID', 'vpID', 'COLUMN';
 GO
 EXEC sp_rename 'tbl_task.ttID', 'ttID', 'COLUMN';
 GO
 EXEC sp_rename 'tbl_taskCategory.ttID', 'ttID', 'COLUMN';
 GO