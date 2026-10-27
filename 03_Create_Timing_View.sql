CREATE OR ALTER VIEW dbo.vw_LabTests_Timing AS
SELECT
    test_id,
    Priority,
    CollectedAt,
    ReceivedAt,
    ResultedAt,
    DATEDIFF(MINUTE, CollectedAt, ResultedAt) / 60.0
        AS TurnaroundHours,
    DATEDIFF(MINUTE, CollectedAt, ReceivedAt) / 60.0
        AS TransportHours,
    DATEDIFF(MINUTE, ReceivedAt, ResultedAt) / 60.0
        AS ProcessingHours,
    CASE
        WHEN Priority = 'URGENT' THEN 12
        WHEN Priority = 'ROUTINE' THEN 24
        ELSE NULL
    END AS TargetHours,
    CASE
        WHEN Priority = 'URGENT'
             AND DATEDIFF(MINUTE, CollectedAt, ResultedAt) <= 720
            THEN 'ON TIME'
        WHEN Priority = 'ROUTINE'
             AND DATEDIFF(MINUTE, CollectedAt, ResultedAt) <= 1440
            THEN 'ON TIME'
        WHEN Priority IN ('URGENT', 'ROUTINE')
            THEN 'LATE'
        ELSE 'UNKNOWN TARGET'
    END AS ReportingStatus
FROM dbo.vw_LabTests_Clean
WHERE TestStatus = 'COMPLETED'
  AND ReceivedAt >= CollectedAt
  AND ResultedAt >= ReceivedAt;
GO
  
  SELECT
    ReportingStatus,
    COUNT(*) AS Tests
FROM dbo.vw_LabTests_Timing
GROUP BY ReportingStatus;

SELECT
    100.0 * SUM(
        CASE WHEN ReportingStatus = 'ON TIME' THEN 1 ELSE 0 END
    ) / COUNT(*) AS OnTimePercentage
FROM dbo.vw_LabTests_Timing
WHERE ReportingStatus IN ('ON TIME', 'LATE');


