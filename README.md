# Laboratory Operations & Data Quality

## Project Overview
A SQL Server and Power BI portfolio project using fictional laboratory records to analyze test turnaround performance and data quality.

## Tools Used
- SQL Server / SSMS
- Power BI Desktop
- DAX

## Project Objectives
- Measure laboratory turnaround performance against Routine (24-hour) and Urgent (12-hour) targets.
- Compare sample transportation and laboratory processing times.
- Identify duplicates, missing information, and invalid timestamps.

## Key Findings
- **9,548** tests eligible for turnaround analysis.
- **39.11%** overall on-time rate.
- **13.83%** on-time rate for Urgent tests.
- **43.25%** on-time rate for Routine tests.
- **5.50 hours** average transportation time.
- **20.96 hours** average processing time.
- **26.46 hours** average total turnaround time.

## Data Quality Findings
- 100 extra duplicate rows.
- 119 unique tests missing clinic information.
- 76 completed tests missing result values.
- 52 tests with invalid timestamps.

## Methodology
SQL views were used to deduplicate and standardize laboratory records, validate data quality, and calculate turnaround metrics. Power BI was used to create an interactive dashboard presenting operational performance and data quality findings.

## Dataset
This project uses fictional laboratory records for portfolio and learning purposes. No real patient information is included.