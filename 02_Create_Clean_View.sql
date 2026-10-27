SELECT DISTINCT *
FROM dbo.stg_LabTests;

SELECT TOP (10)
    test_id,
    clinic AS OriginalClinic,
    UPPER(LTRIM(RTRIM(clinic))) AS CleanClinic
FROM dbo.stg_LabTests;

SELECT TOP (10)
    test_id,
    NULLIF(UPPER(LTRIM(RTRIM(clinic))), '') AS CleanClinic
FROM dbo.stg_LabTests;

SELECT TOP (10)
    test_id,
    NULLIF(UPPER(LTRIM(RTRIM(clinic))), '') AS CleanClinic,
    TRY_CONVERT(datetime2, collected_at, 120) AS CollectedAt
FROM dbo.stg_LabTests;

SELECT TOP (10)
    test_id,
    NULLIF(UPPER(LTRIM(RTRIM(clinic))), '') AS CleanClinic,
    TRY_CONVERT(datetime2, collected_at, 120) AS CollectedAt,
    TRY_CONVERT(datetime2, received_at, 120) AS ReceivedAt,
    TRY_CONVERT(
        datetime2,
        NULLIF(LTRIM(RTRIM(resulted_at)), ''),
        120
    ) AS ResultedAt
FROM dbo.stg_LabTests;

GO
CREATE OR ALTER VIEW dbo.vw_LabTests_Clean AS
SELECT DISTINCT
    test_id,
    NULLIF(UPPER(LTRIM(RTRIM(clinic))), '') AS CleanClinic,
    UPPER(LTRIM(RTRIM(test_type))) AS TestType,
    UPPER(LTRIM(RTRIM(priority))) AS Priority,
    TRY_CONVERT(datetime2, collected_at, 120) AS CollectedAt,
    TRY_CONVERT(datetime2, received_at, 120) AS ReceivedAt,
    TRY_CONVERT(
        datetime2,
        NULLIF(LTRIM(RTRIM(resulted_at)), ''),
        120
    ) AS ResultedAt,
    UPPER(LTRIM(RTRIM(status))) AS TestStatus,
    NULLIF(UPPER(LTRIM(RTRIM(result))), '') AS TestResult
FROM dbo.stg_LabTests;
GO

SELECT COUNT(*) AS TotalTests
FROM dbo.vw_LabTests_Clean;

SELECT COUNT(*) AS EligibleTests
FROM dbo.vw_LabTests_Clean
WHERE TestStatus = 'COMPLETED'
  AND ReceivedAt >= CollectedAt
  AND ResultedAt >= ReceivedAt;