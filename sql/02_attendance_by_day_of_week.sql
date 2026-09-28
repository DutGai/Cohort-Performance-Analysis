-- 02_attendance_by_day_of_week
-- Purpose: find day of the week has the weakest 
-- attendance, across all courses and cohorts.
SELECT DISTINCT status
FROM attendance;

SELECT DAYNAME(session_date) day_of_week,
    SUM(status IN('present', 'Late')) /COUNT(*) AS attendance_rate
FROM attendance
WHERE status != 'Not Recorded'
GROUP BY DAYNAME(session_date)
ORDER BY attendance_rate ASC;
-- Friday has the weekest attendance_rate(53.5%)

-- Attendance rate by day of week , by cohort
WITH cohort_attendance AS(
SELECT c.cohort_label, DAYNAME(a.session_date) day_of_week,
		SUM( a.status IN('present', 'late')) / COUNT(*) AS attendance_rate
FROM attendance a
JOIN enrolments e ON a.enrolment_id = e.enrolment_id
JOIN cohorts c ON e.cohort_id = c.cohort_id
WHERE a.status != 'Not Recorded'
GROUP BY c.cohort_label, DAYNAME(a.session_date)
)
SELECT cohort_label, day_of_week, attendance_rate,
		RANK() OVER(PARTITION BY cohort_label ORDER BY attendance_rate) rank_
        FROM cohort_attendance;
-- Friday has the weakest attendance rate across ALL cohorts.
 

