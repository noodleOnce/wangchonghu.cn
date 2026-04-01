---
title: Mysql ON DUPLICATE KEY UPDATE 和 REPLACE INTO的区别
date: 2024-12-13 11:01:47
tags: mysql
---

1. 执行机制不同：
    ~~~bash
    -- REPLACE INTO 的执行过程
    REPLACE INTO table_name VALUES (1, 'test')  
    -- 等价于：
    DELETE FROM table_name WHERE id = 1;
    INSERT INTO table_name VALUES (1, 'test');
    
    -- ON DUPLICATE KEY UPDATE 的执行过程
    INSERT INTO table_name VALUES (1, 'test') ON DUPLICATE KEY UPDATE name = 'test'
    -- 等价于：
    UPDATE table_name SET name = 'test' WHERE id = 1;
    ~~~
2. 性能影响：
    - REPLACE INTO 会先删除后插入，会导致：
        - 自增ID会变化（删除后重新插入会生成新的ID）
        - 触发器会执行两次（DELETE和INSERT）
        - 可能产生不必要的数据碎片
    - ON DUPLICATE KEY UPDATE：
        - 直接更新已存在的记录
        - 自增ID保持不变
        - 触发器只执行一次
        - 性能通常更好 

3. 使用场景：
    ~~~bash
    -- 当需要完全替换记录时使用 REPLACE INTO
    REPLACE INTO users (id, name, age, created_at) 
    VALUES (1, '张三', 25, NOW());
    
    -- 当需要更新特定字段时使用 ON DUPLICATE KEY UPDATE
    INSERT INTO users (id, name, age) 
    VALUES (1, '张三', 25)
    ON DUPLICATE KEY UPDATE 
    name = VALUES(name),
    age = VALUES(age);
    ~~~
4. 灵活性：
    - ON DUPLICATE KEY UPDATE 更灵活，可以：
        - 选择性更新某些字段
        - 可以使用表达式
        - 可以引用其他字段的值
    - REPLACE INTO 必须提供完整的记录数据 
5. 最佳实践建议：
    - 如果只需要更新部分字段，使用 ON DUPLICATE KEY UPDATE
    - 如果需要完全替换记录，使用 REPLACE INTO
    - 如果关心性能和数据一致性，优先使用 ON DUPLICATE KEY UPDATE