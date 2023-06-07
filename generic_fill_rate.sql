Declare @sql varchar(max) = ''
declare @table_name as varchar(255) = '##temp_a'
declare @column as varchar(255)
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
	select @column = column_name from @columns where column_index = @i
	select @sql  = @sql +  iif(@i > 1, ' union all ' , '') +   ' select  ''' + @column +  ''' , 1.00 * count(' +@column+ + ') / count(1) from '  +@table_name
end



EXEC (@sql)
