---
title: Mysql date_add()函数的用法
date: 2024-09-18 11:37:25
tags: mysql
---

`DATE_ADD()` 是 MySQL 中用于在日期上增加时间间隔的函数。它可以对 `DATE`, `DATETIME`, 或 `TIMESTAMP` 数据类型进行操作，返回修改后的日期或时间。

### 语法：

```
sql
DATE_ADD(date, INTERVAL expr unit)
```

- `date`: 需要进行加法运算的原始日期，通常为 `DATE`, `DATETIME`, 或 `TIMESTAMP` 类型。
- `expr`: 要添加的时间间隔，可以是整数或小数。
- `unit`: 表示时间单位，可以是年、月、日、小时等。

### 常见的 `unit` 单位：

- `YEAR`: 年
- `MONTH`: 月
- `DAY`: 天
- `HOUR`: 小时
- `MINUTE`: 分钟
- `SECOND`: 秒
- `WEEK`: 周
- `QUARTER`: 季度
- `MICROSECOND`: 微秒

### 示例：

1. **增加天数：**

   增加 10 天：

   ```
   sql
   SELECT DATE_ADD('2024-09-12', INTERVAL 10 DAY);
   ```

   结果：`2024-09-22`
   原始日期 `2024-09-12` 上加 10 天。

2. **增加月份：**

   增加 3 个月：

   ```
   sql
   SELECT DATE_ADD('2024-09-12', INTERVAL 3 MONTH);
   ```

   结果：`2024-12-12`
   原始日期 `2024-09-12` 上加 3 个月。

3. **增加年份：**

   增加 5 年：

   ```
   sql
   SELECT DATE_ADD('2024-09-12', INTERVAL 5 YEAR);
   ```

   结果：`2029-09-12`

4. **增加小时：**

   增加 2 小时：

   ```
   sql
   SELECT DATE_ADD('2024-09-12 14:00:00', INTERVAL 2 HOUR);
   ```

   结果：`2024-09-12 16:00:00`

5. **增加复合时间：**

   增加 1 年 2 个月：

   ```
   sql
   SELECT DATE_ADD('2024-09-12', INTERVAL 1 YEAR + INTERVAL 2 MONTH);
   ```

   结果：`2025-11-12`

### 注意事项：

- 如果日期无效或超出范围，MySQL 会返回 `NULL`。
- 如果使用负的 `expr` 值，`DATE_ADD` 可以实现日期的减法运算。例如，`INTERVAL -10 DAY` 会减去 10 天。

### 小结：

`DATE_ADD()` 是处理时间和日期运算的常用函数，可以方便地增加时间单位（如年、月、日、小时等）到一个日期或时间。
