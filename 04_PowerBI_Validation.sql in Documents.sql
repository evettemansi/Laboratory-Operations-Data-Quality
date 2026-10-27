-- Overall totals and data quality
SELECT
    COUNT(*) AS TotalTests,
    SUM(CASE WHEN TestStatus = 'COMPLETED' THEN 1 ELSE 0 END)
        AS CompletedTests,
    SUM(CASE WHEN TestStatus = 'CANCELLED' THEN 1 ELSE 0 END)
        AS CancelledTests,
    COUNT(DISTINCT CleanClinic) AS NamedClinics,
    SUM(CASE WHEN CleanClinic IS NULL THEN 1 ELSE 0 END)
        AS TestsMissingClinic,
    SUM(CASE WHEN TestStatus = 'COMPLETED'
                  AND TestResult IS NULL THEN 1 ELSE 0 END)
        AS CompletedMissingResult,
    SUM(CASE WHEN TestStatus = 'COMPLETED'
                  AND ResultedAt < ReceivedAt THEN 1 ELSE 0 END)
        AS TestsWithInvalidTiming
FROM dbo.vw_LabTests_Clean;

-- Timing and reporting performance
SELECT
    COUNT(*) AS TimingEligibleTests,
    SUM(CASE WHEN ReportingStatus = 'ON TIME' THEN 1 ELSE 0 END)
        AS OnTimeTests,
    SUM(CASE WHEN ReportingStatus = 'LATE' THEN 1 ELSE 0 END)
        AS LateTests,
    ROUND(
        100.0 * SUM(
            CASE WHEN ReportingStatus = 'ON TIME' THEN 1 ELSE 0 END
        ) / NULLIF(SUM(
            CASE WHEN ReportingStatus IN ('ON TIME', 'LATE')
                 THEN 1 ELSE 0 END
        ), 0),
        2
    ) AS OnTimePercentage,
    ROUND(AVG(TransportHours), 2) AS AvgTransportHours,
    ROUND(AVG(ProcessingHours), 2) AS AvgProcessingHours,
    ROUND(AVG(TurnaroundHours), 2) AS AvgTurnaroundHours
FROM dbo.vw_LabTests_Timing;