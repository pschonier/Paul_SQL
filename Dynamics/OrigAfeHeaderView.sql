USE [Administration]
GO

/****** Object:  View [dbo].[vwAFEHeader]    Script Date: 6/15/2015 10:56:03 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwAFEHeader]
AS
SELECT        afe.ME_Job_ID AS AFENumber, RTRIM(pm.DSCRIPTN) + ' (' + RTRIM(pm.MEuserdefined1) + ')' AS ProjectManager, RTRIM(dpt.DSCRIPTN) 
                         + ' (' + RTRIM(afe.MEuserdefined3) + ')' AS Department, CASE me_job_status WHEN 1 THEN ' ' ELSE '(completed) ' END + afe.ME_Work_Scope AS Description, 
                         afe.ME_Job_Open_Date AS OpenDate, afe.ME_Actual_End_Date AS CompleteDate, afe.ME_Job_Close_Date AS CloseDate, 
                         afe.ME_Orig_Est_Cost_Labo + afe.ME_Orig_Est_Cost_Mate AS Estimate, details.PaidAmount AS actual, details.CommittedAmount AS Pending, 
                         details.JournalAmount AS Journal, details.CurrentAmount, details.PreviousAmount, CASE WHEN (LEN(afe.MEuserdefined2) > 2) 
                         THEN afe.MEuserdefined2 ELSE 'CAP' END AS AFECat
FROM            EPCO.dbo.ME97708 AS afe INNER JOIN
                         EPCO.dbo.ME97709 AS pm ON afe.MEuserdefined1 = pm.MEuserdefined1 INNER JOIN
                         EPCO.dbo.ME97702 AS dpt ON afe.MEuserdefined3 = dpt.MEuserdefined3 LEFT OUTER JOIN
                             (SELECT        AFENumber, SUM(CASE WHEN TransactionType = 'Paid' THEN amount ELSE 0 END) AS PaidAmount, 
                                                         SUM(CASE WHEN TransactionType = 'Committed' THEN amount ELSE 0 END) AS CommittedAmount, 
                                                         SUM(CASE WHEN TransactionType = 'Journal Entry' THEN amount ELSE 0 END) AS JournalAmount, SUM(CASE WHEN YEAR(PostingDate) 
                                                         = YEAR(GETDATE()) THEN amount ELSE 0 END) AS CurrentAmount, SUM(CASE WHEN YEAR(PostingDate) = (YEAR(GETDATE()) - 1) 
                                                         THEN amount ELSE 0 END) AS PreviousAmount
                               FROM            dbo.vwAFEDetail
                               GROUP BY AFENumber) AS details ON afe.ME_Job_ID = details.AFENumber
WHERE        (ISNUMERIC(afe.ME_Job_ID) = 1)

GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[28] 4[25] 2[28] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "afe"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 285
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "pm"
            Begin Extent = 
               Top = 6
               Left = 323
               Bottom = 135
               Right = 566
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "dpt"
            Begin Extent = 
               Top = 6
               Left = 604
               Bottom = 135
               Right = 847
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "details"
            Begin Extent = 
               Top = 6
               Left = 885
               Bottom = 135
               Right = 1079
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwAFEHeader'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwAFEHeader'
GO


