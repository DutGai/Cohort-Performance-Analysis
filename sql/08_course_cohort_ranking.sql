-- 08_course_cohort_ranking.sql
-- Purpose: rank ever course/cohort combination that has run in the program
-- by attendance rate, alonside its completion rate, to spot specific
-- offerings are underforming and whether any course repeats near the 
-- bottom across multiple cohorts

WITH att AS(
	SELECT 
		e.course_id,
        e.cohort_id,
        c.course_name,
        ROUND(100.0 * SUM(a.status IN('Present' , 'Late'))
        / COUNT(*), 1) AS attendance_rate
        
	FROM enrolments e
    JOIN courses c USING(course_id)
    JOIN attendance a USING(enrolment_id)
    WHERE a.status != 'Not Recorded'
    GROUP BY e.course_id, e.cohort_id, course_name
),
COMP AS (
	SELECT 
		e.course_id,
        e.cohort_id,
        c.course_name,
        ROUND(100.0 * SUM( e.status = 'Completed')
        / COUNT(*), 1) AS completion_rate, 
        COUNT(*) AS enrolled 
	FROM enrolments e
    JOIN courses c USING(course_id)
    GROUP BY course_id, cohort_id, course_name
)
SELECT
	att.course_name, 
    att.cohort_id,
    att.attendance_rate,
    comp.completion_rate,
    comp.enrolled
FROM att
JOIN comp USING(course_id, cohort_id)
ORDER BY att.attendance_rate ASC;


-- Result: Data Analysis appears twice in the weakest five(cohort 4 and
-- Cohort 5), suggesting a course level patern than one bad cohort
-- Completion rates for Cohort 4, 5 read low across almost every row
-- here because of the Unknown-status data quality issue documented in
--  01_data_quality_checks.sql, not because those cohorts genuinely performed
-- worse.
    