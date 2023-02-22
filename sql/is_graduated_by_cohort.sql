/*  is_graduated by cohort
*/


SELECT DISTINCT
                 a.student_id,
                 a.cohort_start_term_id,
                 a.cohort_desc,
                 a.cohort_degree_level_desc,
                 c.is_graduated,
                 a.is_graduated_year_1,
                 a.is_graduated_year_2,
                 a.is_graduated_year_3,
                 a.is_graduated_year_4,
                 c.graduated_term_id AS graduation_term,
                 c.degree_desc,
                 c.primary_major_desc,
                 d.college_desc,
                 c.graduation_date,
                 COALESCE(a.is_exclusion, FALSE) AS is_exclusion,
                 a.full_time_part_time_code,
                 b.gender_code,
                 b.ipeds_race_ethnicity,
                 b.is_athlete,
                 b.is_first_generation,
                 b.is_veteran,
                 f.is_pell_awarded,
                 b.is_international,
                 f.residency_code,
                 f.residency_code_desc
            FROM export.student_term_cohort a
       LEFT JOIN export.student b 
              ON b.student_id = a.student_id
       LEFT JOIN export.degrees_awarded c
              ON c.student_id = a.student_id
             AND c.is_highest_degree_awarded
             AND c.degree_status_code = 'AW'
       LEFT JOIN export.academic_programs d 
              ON d.program_id = c.primary_program_id
       LEFT JOIN export.term e
              ON e.term_id = a.cohort_start_term_id
       LEFT JOIN export.student_term_level f ON f.student_id = a.student_id
             AND f.term_id = a.cohort_start_term_id
           WHERE e.season = 'Fall'
             AND substr(a.cohort_start_term_id, 1, 4)::int >= (SELECT substr(term_id, 1, 4) ::int -5
                                                    FROM export.term
                                                    WHERE is_current_term);
