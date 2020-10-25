
解题思路如下：
总体和第二次作业的第三题思路相同，这次用到了row_number() over() 组内排序函数
user_user_id click_time  	获得上一次的点击时间    计算两次点击的时长	 	大于30分钟为1    recount_type    	rn
A,2020-05-15 01:30:00 	2020-05-15 01:30:00				0						0				0				1
A,2020-05-15 01:35:00	2020-05-15 01:30:00				5						0               0               2
A,2020-05-15 02:00:00	2020-05-15 01:35:00				25                      0               0               3
A,2020-05-15 03:00:10	2020-05-15 02:00:00				60                      1               1               1
A,2020-05-15 03:05:00	2020-05-15 03:00:10             5                       0               1               2
B,2020-05-15 02:03:00   
B,2020-05-15 02:29:40
B,2020-05-15 04:00:00


答案：
select user_id,click_time,row_number() over(partition by user_id,recount_type order by click_time) as rn from(
    select user_id ,click_time, sum(recount_flag) over(partition by user_id order by click_time) recount_type from (
    select user_id,click_time,
case when (unix_timestamp(click_time)-unix_timestamp(lag(click_time) over(partition by user_id order by click_time)))/60 >30 then 1
else 0 end as recount_flag
from user_clicklog
) b
) c 
