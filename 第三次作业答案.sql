
解题思路如下：
总体和第二次作业的第三题思路相同，用到了row_number() over() 组内排序函数
user_user_id click_time  	获得下一次的点击时间    计算两次点击的时长	 	大于30分钟为1    recount_type    	rn
A,2020-05-15 01:30:00 	2020-05-15 01:35:00				5						0				0				1
A,2020-05-15 01:35:00	2020-05-15 02:00:00				25						0               0               2
A,2020-05-15 02:00:00	2020-05-15 03:00:10				60                      1               1               1
A,2020-05-15 03:00:10	2020-05-15 03:05:00				5                       0               1               2
A,2020-05-15 03:05:00	null
B,2020-05-15 02:03:00
B,2020-05-15 02:29:40
B,2020-05-15 04:00:00


答案：
select c.user_id,c.click_time,row_number() over(partition by c.user_id,c.recount_type order by c.click_time) as rn from(
    select b.user_id ,b.click_time, sum(b.recount_flag) over(partition by b.user_id order by b.click_time) recount_type from (
    select user_id,click_time,
case when (unix_timestamp(click_time,"yyyy/mm/dd hh:mm")-
unix_timestamp(lag(click_time,1,click_time) over(partition by user_id order by click_time) ,"yyyy/mm/dd hh:mm"))/60 >30 then 1
else 0 end as recount_flag
from user_clicklog
) b
) c 