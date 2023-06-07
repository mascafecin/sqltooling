Declare @sql varchar(max) = ''
declare @table_name as varchar(255) = '##temp_a' /*full table name*/
declare @col_count as int 
declare @columns table (column_name varchar(255), column_index int)
declare @i as int


select @i = 0 ;
select @col_count  =	count(c.name) from sys.columns c
						inner join sys.tables t on c.object_id = t.object_id	
						where t.name = @table_name ;
insert into @columns
	select c.name, ROW_NUMBER() over (order by c.name)
	from sys.columns c
	inner join sys.tables t on c.object_id = t.object_id	
	where t.name = @table_name;

--select * from @columns

while  @i < @col_count
begin
	select @i =  @i + 1
--	select column_name from @columns where column_index = @i;
	select @sql  = 'select 1.00 * count(' +(select  column_name from @columns where column_index = @i  ) + + ') / count(1) from '  +@table_name
end

exec(@sql)

/*EXEC (@sql)*/
