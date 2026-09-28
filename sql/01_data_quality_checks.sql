-- 01_data_quality_checks
-- Purpose: check the underlying records before trusting any analysis built 
-- On them.

-- Attendance data quality checks
-- Enrolments per status- unknown Records
SELECT status, COUNT(*) AS total_enrolments
FROM enrolments
GROUP BY status;

-- 178/565(31.5%) of enrolments have an unknown status.
-- Attendance by status - Not Recorded 
SELECT status, COUNT(*) AS total_attendance
FROM attendance
WHERE status ='Not Recorded'
GROUP BY status;
-- 1873/58944 (3.2%) of attendance records have a stats of 'Not Recorded'.

-- Missing contact information for students
SELECT
	SUM(email ='') AS missing_email,
    SUM(phone ='') AS missing_phone
    FROM students;
-- 195/260 of students have missing contact information (email or phone)
-- Decision made from these results:
-- 'Not Recorded' attendance from rows are excluded from attendance-rate calculations
-- Unknown enrolment status is kept as its own category.