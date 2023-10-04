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
		row_number() over (partition by column_name order by column_name2 desc) as row_num,
		* from table_name
	where
		type = 'xxx'
		and content->'prop_name'->>'prop_name2' = 'xxx'
		and column_name3 > now() - interval '12 hours'
) as rn
where row_num > '1'
;
```
