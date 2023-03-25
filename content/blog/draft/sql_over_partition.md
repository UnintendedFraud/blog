+++
title = "sql over partition"
+++


write and learn how over partition works

we had duplicates in our databases, needed to delete all of them except one
so had to query them, groupped together and know which one was a duplicate
so it can be removed safely and keep one occurence of each

```
select * from (
	select
		row_number() over (partition by convo_id order by convo_id desc) as row_num,
		* from messages
	where
		type = 'rekki-custom-notification'
		and content->'event'->>'broadcast_id' = '11144'
		and inserted_at > now() - interval '12 hours'
) as rn
where row_num > '1'
;
```
