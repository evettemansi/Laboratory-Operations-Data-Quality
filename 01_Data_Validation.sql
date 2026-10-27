SELECT COUNT(*) AS TotalRows
FROM dbo.stg_LabTests;

SELECT COUNT(DISTINCT test_id) AS UniqueTests
FROM dbo.stg_LabTests;

SELECT test_id, COUNT(*) AS TimesRecorded
FROM dbo.stg_LabTests
GROUP BY test_id
HAVING COUNT(*) > 1;

SELECT *
FROM dbo.stg_LabTests
WHERE test_id = 'T001607';

SELECT COUNT(*) AS DistinctFullRows
FROM (
    SELECT DISTINCT *
    FROM dbo.stg_LabTests
) AS d;

SELECT COUNT(*) AS RowsMissingClinic
FROM dbo.stg_LabTests
WHERE clinic IS NULL
   OR LTRIM(RTRIM(clinic)) = '';

   SELECT COUNT(DISTINCT test_id) AS TestsMissingClinic
FROM dbo.stg_LabTests
WHERE clinic IS NULL
   OR LTRIM(RTRIM(clinic)) = '';

       SELECT DISTINCT clinic
    FROM dbo.stg_LabTests
    ORDER BY clinic;

    SELECT DISTINCT
    UPPER(LTRIM(RTRIM(clinic))) AS StandardClinic
FROM dbo.stg_LabTests
ORDER BY StandardClinic;

SELECT TOP (10)
    collected_at,
    TRY_CONVERT(datetime2, collected_at, 120) AS CollectedDateTime
FROM dbo.stg_LabTests;

SELECT COUNT(*) AS InvalidCollectionDates
FROM dbo.stg_LabTests
WHERE TRY_CONVERT(
    datetime2,
    NULLIF(LTRIM(RTRIM(collected_at)), ''),
    120
) IS NULL;

SELECT COUNT(*) AS InvalidReceivedDates
FROM dbo.stg_LabTests
WHERE TRY_CONVERT(
    datetime2,
    NULLIF(LTRIM(RTRIM(received_at)), ''),
    120
) IS NULL;

SELECT COUNT(*) AS CompletedWithInvalidResultDate
FROM dbo.stg_LabTests
WHERE UPPER(LTRIM(RTRIM(status))) = 'COMPLETED'
  AND TRY_CONVERT(
      datetime2,
      NULLIF(LTRIM(RTRIM(resulted_at)), ''),
      120
  ) IS NULL;

  SELECT COUNT(*) AS ReceivedBeforeCollection
FROM dbo.stg_LabTests
WHERE TRY_CONVERT(datetime2, received_at, 120)
    < TRY_CONVERT(datetime2, collected_at, 120);

    SELECT COUNT(*) AS ResultBeforeReceipt
FROM dbo.stg_LabTests
WHERE UPPER(LTRIM(RTRIM(status))) = 'COMPLETED'
  AND TRY_CONVERT(datetime2, resulted_at, 120)
    < TRY_CONVERT(datetime2, received_at, 120);

    SELECT TOP (5)
    test_id,
    received_at,
    resulted_at
FROM dbo.stg_LabTests
WHERE UPPER(LTRIM(RTRIM(status))) = 'COMPLETED'
  AND TRY_CONVERT(datetime2, resulted_at, 120)
    < TRY_CONVERT(datetime2, received_at, 120);

    SELECT COUNT(DISTINCT test_id) AS TestsWithInvalidTiming
FROM dbo.stg_LabTests
WHERE UPPER(LTRIM(RTRIM(status))) = 'COMPLETED'
  AND TRY_CONVERT(datetime2, resulted_at, 120)
    < TRY_CONVERT(datetime2, received_at, 120);

    SELECT COUNT(DISTINCT test_id) AS CompletedMissingResult
FROM dbo.stg_LabTests
WHERE UPPER(LTRIM(RTRIM(status))) = 'COMPLETED'
  AND (
      result IS NULL
      OR LTRIM(RTRIM(result)) = ''
  );

  SELECT
    UPPER(LTRIM(RTRIM(status))) AS TestStatus,
    COUNT(DISTINCT test_id) AS Tests
FROM dbo.stg_LabTests
GROUP BY UPPER(LTRIM(RTRIM(status)));