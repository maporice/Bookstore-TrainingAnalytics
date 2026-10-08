WITH user_attempt_history AS (
    SELECT 
        id AS progress_id,
        user_id,
        module_id,
        quiz_id,
        score,
        CASE 
            WHEN CAST(passed AS VARCHAR(10)) IN ('1', 'True', 'true') THEN 1 
            ELSE 0 
        END AS passed_flag,
        completed_at,
        ROW_NUMBER() OVER (
            PARTITION BY user_id 
            ORDER BY completed_at ASC
        ) AS attempt_number
    FROM user_progress_rows  -- Points directly to the imported table
),
attempt_stage_classification AS (
    SELECT 
        progress_id,
        user_id,
        module_id,
        score,
        passed_flag,
        attempt_number,
        CASE 
            WHEN attempt_number BETWEEN 1 AND 3 THEN '1. Initial Onboarding (1-3)'
            WHEN attempt_number BETWEEN 4 AND 10 THEN '2. Early Progression (4-10)'
            WHEN attempt_number BETWEEN 11 AND 20 THEN '3. Advanced Operational (11-20)'
            ELSE '4. Full Curriculum / Mastery (21-31)'
        END AS onboarding_stage
    FROM user_attempt_history
)
SELECT 
    onboarding_stage,
    COUNT(progress_id) AS total_quizzes_taken,
    COUNT(DISTINCT user_id) AS active_users_remaining,
    ROUND(AVG(CAST(score AS FLOAT)), 2) AS avg_score,
    SUM(CASE WHEN passed_flag = 0 THEN 1 ELSE 0 END) AS total_failures,
    ROUND((CAST(SUM(passed_flag) AS FLOAT) / COUNT(progress_id)) * 100.0, 1) AS pass_rate_pct
FROM attempt_stage_classification
GROUP BY onboarding_stage
ORDER BY onboarding_stage ASC;