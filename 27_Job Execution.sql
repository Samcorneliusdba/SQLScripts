--Last Run
; WITH JLR (name,Duration,[Last_Run__date])
AS

(SELECT j.name, 
durationHHMMSS = STUFF(STUFF(REPLACE(STR(h.run_duration,7,0), ' ','0'),4,0,':'),7,0,':'),
[Last_Run_date] = CONVERT(DATETIME, RTRIM(run_date) + ' ' + STUFF(STUFF(REPLACE(STR(RTRIM(h.run_time),6,0), ' ','0'),3,0,':'),6,0,':')) FROM msdb.dbo.sysjobs 
AS j INNER JOIN
( 
SELECT job_id, instance_id = MAX(instance_id) FROM msdb.dbo.sysjobhistory GROUP BY job_id 
)
AS l ON j.job_id = l.job_id INNER JOIN msdb.dbo.sysjobhistory 
AS h ON h.job_id = l.job_id AND h.instance_id = l.instance_id 
)




--Avg Run
, JAR (name,[Avg_Run_Duration])
AS
(SELECT 
job_name = name,
--avg_sec = rd, 
 avg_hhmmss = CONVERT(varchar, DATEADD(ms,rd * 1000, 0), 114)
--avg_hhmm = CONVERT(VARCHAR(11),rd / 60) + ':' + RIGHT('0' + CONVERT(VARCHAR(11),rd % 60), 2) 
FROM 
(
SELECT j.name, rd = AVG(DATEDIFF(SECOND, 0, STUFF(STUFF(RIGHT('000000' + CONVERT(VARCHAR(6),run_duration),6),5,0,':'),3,0,':'))) 
FROM msdb.dbo.sysjobhistory AS h INNER JOIN msdb.dbo.sysjobs 
AS j ON h.job_id = j.job_id GROUP BY j.name
) 
AS t )






--Oldest Run
, JOR (name,Duration,[Oldest_Run_Date])
AS
(SELECT j.name, 
durationHHMMSS = STUFF(STUFF(REPLACE(STR(h.run_duration,7,0), ' ','0'),4,0,':'),7,0,':'),
[start_date] = CONVERT(DATETIME, RTRIM(run_date) + ' ' + STUFF(STUFF(REPLACE(STR(RTRIM(h.run_time),6,0), ' ','0'),3,0,':'),6,0,':')) FROM msdb.dbo.sysjobs 
AS j INNER JOIN
( 
SELECT job_id, instance_id = MIN(instance_id) FROM msdb.dbo.sysjobhistory GROUP BY job_id 
)
AS l ON j.job_id = l.job_id INNER JOIN msdb.dbo.sysjobhistory 
AS h ON h.job_id = l.job_id AND h.instance_id = l.instance_id 
)

---Summary
select JOR.name as 'Job Name',JOR.Oldest_Run_Date,JOR.Duration as 'Oldest Run Duration',JLR.Last_Run__date, JLR.Duration 'Last Run Duration',JAR.Avg_Run_Duration
from JOR join JLR on JOR.name = JLR.name
join JAR
on JOR.name=JAR.name
order by JOR.name


