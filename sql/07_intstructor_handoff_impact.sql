-- 07_intstructor_handoff_impact.sql
-- Purpose: For the course/cohort pairings where the instructor changed
-- mid-run, compare attendance before and after the handoff.

-- Step 1: Find every course/cohort pairing with more than one instructor
-- assignment, meaning a handoff happened
WITH multiple_intstructors AS(
	SELECT
		course_id,
        cohort_id,
        c.course_name,
        COUNT(*) AS assignments
	FROM instructor_assignments i
    JOIN courses c USING(course_id)
    GROUP BY course_id , cohort_id, course_name
    HAVING COUNT(*) > 1
)
-- Step 2: Attendance rate per instructor before and after the handoff
SELECT 
	i.instructor_id,
    i.start_date,
    i.end_date,
    c.course_name,
	ROUND(
		SUM(a.status IN('Present', 'Late')) / COUNT(*) *100, 1
	) AS attendance_rate,
    COUNT(*) sessions
    FROM instructor_assignments i
    JOIN enrolments e ON i.course_id = e.course_id AND i.cohort_id = e.cohort_id
    JOIN attendance a ON e.enrolment_id = a.enrolment_id
		AND a.session_date BETWEEN i.start_date AND i.end_date
	JOIN courses c ON c.course_id = i.course_id
 	WHERE (i.course_id, i.cohort_id) IN(SELECT course_id, cohort_id FROM multiple_intstructors)
		AND a.status <> 'Not Recorded'
	GROUP BY i.instructor_id, start_date, end_date,course_name
    ORDER BY start_date;
    
    -- Data Analysis has a big drop in attendance_rate( 63.9% to 36.3%) compare to other courses
    -- which had a smaller drop in attendance_rate
    
    
    

