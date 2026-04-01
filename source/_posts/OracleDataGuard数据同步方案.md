---
title: OracleDataGuard数据同步方案
date: 2025-06-16 10:48:19
tags: 架构
---

## 1. Oracle DataGuard 概述

### 1.1 什么是DataGuard
Oracle DataGuard是Oracle数据库自带的灾难恢复和高可用性解决方案，通过维护一个或多个备用数据库（Standby Database）来保护生产数据库（Primary Database）。

### 1.2 核心价值
- **数据保护**：防止数据丢失和数据损坏
- **高可用性**：最小化计划内外停机时间
- **灾难恢复**：快速从灾难中恢复业务运营
- **读写分离**：备库可承担只读查询负载

## 2. DataGuard架构详解

### 2.1 基本架构组件

```
┌─────────────────────────────────┐
│         Primary Database        │
│    (海南本地 - 主生产库)        │
│                                 │
│  ┌─────────────┐ ┌──────────── │
│  │   LGWR      │ │ Archive Log │
│  │   Process   │ │   Process   │
│  └─────────────┘ └──────────── │
└─────────────┬───────────────────┘
              │ Redo Transport
              │ (归档日志传输)
              ▼
┌─────────────────────────────────┐
│        Standby Database         │
│     (华为云 - 备用库)           │
│                                 │
│  ┌─────────────┐ ┌──────────── │
│  │    RFS      │ │   MRP       │
│  │  Process    │ │  Process    │
│  └─────────────┘ └──────────── │
└─────────────────────────────────┘
```

### 2.2 关键进程说明

**主库端进程**：
- **LGWR (Log Writer)**：负责将重做日志写入主库，同时将日志传输到备库
- **ARCH (Archiver)**：负责归档重做日志并传输到备库
- **LNS (Log Writer NetworkServer)**：网络服务进程，负责日志传输

**备库端进程**：
- **RFS (Remote File Server)**：接收来自主库的重做日志
- **MRP (Media Recovery Process)**：应用重做日志到备库
- **LSP (Log Shipping Process)**：管理日志传输

## 3. DataGuard类型详解

### 3.1 Physical Standby（物理备库）- 推荐方案

#### 3.1.1 工作原理
- 通过应用重做日志在块级别维护与主库完全相同的副本
- 使用Oracle的恢复机制应用变更
- 数据在物理层面完全一致

#### 3.1.2 优势
- **完全数据保护**：块级别的精确复制
- **自动故障检测**：内置的监控和故障检测
- **透明应用切换**：应用程序无需修改
- **读取性能**：可以开启只读模式提供查询服务
- **自动同步**：无需手动干预

#### 3.1.3 配置示例
```sql
-- 主库配置
ALTER SYSTEM SET LOG_ARCHIVE_CONFIG='DG_CONFIG=(PRIMARY,STANDBY)';
ALTER SYSTEM SET LOG_ARCHIVE_DEST_1='LOCATION=/u01/archive VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=PRIMARY';
ALTER SYSTEM SET LOG_ARCHIVE_DEST_2='SERVICE=STANDBY LGWR ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=STANDBY';
ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_2=ENABLE;
ALTER SYSTEM SET REMOTE_LOGIN_PASSWORDFILE=EXCLUSIVE;
ALTER SYSTEM SET LOG_ARCHIVE_FORMAT='%t_%s_%r.dbf';
ALTER SYSTEM SET LOG_ARCHIVE_MAX_PROCESSES=5;
ALTER SYSTEM SET FAL_SERVER=STANDBY;
ALTER SYSTEM SET FAL_CLIENT=PRIMARY;

-- 备库配置
ALTER SYSTEM SET LOG_ARCHIVE_CONFIG='DG_CONFIG=(PRIMARY,STANDBY)';
ALTER SYSTEM SET LOG_ARCHIVE_DEST_1='LOCATION=/u01/archive VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=STANDBY';
ALTER SYSTEM SET LOG_ARCHIVE_DEST_2='SERVICE=PRIMARY LGWR ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=PRIMARY';
ALTER SYSTEM SET REMOTE_LOGIN_PASSWORDFILE=EXCLUSIVE;
ALTER SYSTEM SET FAL_SERVER=PRIMARY;
ALTER SYSTEM SET FAL_CLIENT=STANDBY;
```

### 3.2 Logical Standby（逻辑备库）

#### 3.2.1 工作原理
- 通过应用SQL语句而非重做日志维护数据一致性
- 可以有不同的物理结构（表空间、索引等）
- 支持部分表的复制

#### 3.2.2 使用场景
- 需要在备库上创建附加索引或物化视图
- 只需要复制部分数据
- 需要不同的数据库物理结构

### 3.3 Snapshot Standby（快照备库）

#### 3.3.1 工作原理
- 临时将物理备库转换为可读写模式
- 用于测试、报表或开发
- 可以快速转换回同步模式

## 4. 数据同步模式

### 4.1 Maximum Performance（最大性能模式）- 默认模式

#### 4.1.1 特点
- **异步传输**：主库不等待备库确认就提交事务
- **性能最优**：对主库性能影响最小
- **数据风险**：可能有少量数据丢失

#### 4.1.2 适用场景
- 对性能要求高的OLTP系统
- 网络延迟较大的环境
- 可以接受极少量数据丢失的场景

#### 4.1.3 配置方法
```sql
ALTER DATABASE SET STANDBY DATABASE TO MAXIMIZE PERFORMANCE;
ALTER SYSTEM SET LOG_ARCHIVE_DEST_2='SERVICE=STANDBY LGWR ASYNC';
```

### 4.2 Maximum Availability（最大可用性模式）

#### 4.1.1 特点
- **同步传输**：通常情况下零数据丢失
- **网络容错**：网络故障时自动降级为异步模式
- **平衡性能**：在性能和数据保护间平衡

#### 4.2.2 适用场景
- 对数据安全要求高但也考虑性能
- 网络状况不够稳定的环境
- 推荐用于您的医药业务场景

#### 4.2.3 配置方法
```sql
ALTER DATABASE SET STANDBY DATABASE TO MAXIMIZE AVAILABILITY;
ALTER SYSTEM SET LOG_ARCHIVE_DEST_2='SERVICE=STANDBY LGWR SYNC AFFIRM';
```

### 4.3 Maximum Protection（最大保护模式）

#### 4.3.1 特点
- **零数据丢失**：绝对保证数据不丢失
- **严格同步**：必须等待备库确认才能提交
- **性能影响**：对主库性能影响较大

#### 4.3.2 适用场景
- 金融、医疗等对数据要求极其严格的行业
- 关键核心业务系统
- 网络稳定且延迟很低的环境

#### 4.3.3 配置方法
```sql
ALTER DATABASE SET STANDBY DATABASE TO MAXIMIZE PROTECTION;
ALTER SYSTEM SET LOG_ARCHIVE_DEST_2='SERVICE=STANDBY LGWR SYNC AFFIRM';
-- 必须配置至少一个SYNC备库
```

## 5. 实施步骤详解

### 5.1 环境准备阶段

#### 5.1.1 硬件和网络准备
```bash
# 网络连通性测试
ping <standby_server_ip>
telnet <standby_server_ip> 1521

# 确保两端Oracle版本一致
sqlplus / as sysdba
SELECT * FROM V$VERSION;
```

#### 5.1.2 参数配置检查
```sql
-- 检查主库必要参数
SELECT NAME, VALUE FROM V$PARAMETER WHERE NAME IN (
    'db_unique_name',
    'log_archive_config',
    'log_archive_dest_1',
    'log_archive_dest_2',
    'log_archive_dest_state_2',
    'remote_login_passwordfile',
    'log_archive_format',
    'log_archive_max_processes',
    'fal_server',
    'fal_client',
    'standby_file_management'
);
```

### 5.2 备库创建步骤

#### 5.2.1 主库备份
```bash
# 创建主库备份
rman target /
RMAN> BACKUP DATABASE PLUS ARCHIVELOG;
RMAN> BACKUP CURRENT CONTROLFILE FOR STANDBY;

# 或使用更详细的备份命令
RMAN> RUN {
    ALLOCATE CHANNEL ch1 DEVICE TYPE DISK;
    BACKUP DATABASE FORMAT '/backup/db_%U';
    BACKUP ARCHIVELOG ALL FORMAT '/backup/arch_%U';
    BACKUP CURRENT CONTROLFILE FOR STANDBY FORMAT '/backup/standby_control_%U';
    RELEASE CHANNEL ch1;
}
```

#### 5.2.2 备库还原
```bash
# 在备库服务器上还原
rman target /
RMAN> RESTORE DATABASE FROM BACKUP;
RMAN> RESTORE CONTROLFILE FROM '/backup/standby_control_xxx';
```

#### 5.2.3 备库配置
```sql
-- 启动备库到mount状态
STARTUP MOUNT;

-- 启动应用日志进程
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE DISCONNECT FROM SESSION;

-- 开启实时应用（11g及以上版本）
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT;
```

### 5.3 状态验证

#### 5.3.1 主库状态检查
```sql
-- 检查数据库角色和状态
SELECT DATABASE_ROLE, OPEN_MODE FROM V$DATABASE;

-- 检查归档日志传输状态
SELECT DEST_ID, STATUS, ERROR FROM V$ARCHIVE_DEST WHERE DEST_ID=2;

-- 检查备库同步状态
SELECT SEQUENCE#, FIRST_TIME, NEXT_TIME, ARCHIVED, APPLIED 
FROM V$ARCHIVED_LOG 
WHERE DEST_ID=2 
ORDER BY SEQUENCE# DESC;
```

#### 5.3.2 备库状态检查
```sql
-- 检查备库角色
SELECT DATABASE_ROLE, OPEN_MODE FROM V$DATABASE;

-- 检查MRP进程状态
SELECT PROCESS, STATUS, THREAD#, SEQUENCE#, BLOCK#, BLOCKS 
FROM V$MANAGED_STANDBY;

-- 检查应用延迟
SELECT NAME, VALUE, DATUM_TIME, TIME_COMPUTED 
FROM V$DATAGUARD_STATS 
WHERE NAME IN ('transport lag', 'apply lag');
```

## 6. 切换操作详解

### 6.1 计划切换（Switchover）

#### 6.1.1 切换条件检查
```sql
-- 在主库检查是否可以切换
SELECT SWITCHOVER_STATUS FROM V$DATABASE;
-- 应该返回 'TO STANDBY' 或 'SESSIONS ACTIVE'

-- 在备库检查
SELECT SWITCHOVER_STATUS FROM V$DATABASE;
-- 应该返回 'NOT ALLOWED' 或 'SESSIONS ACTIVE'
```

#### 6.1.2 执行切换
```sql
-- 步骤1：在当前主库执行
ALTER DATABASE COMMIT TO SWITCHOVER TO STANDBY WITH SESSION SHUTDOWN;
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;

-- 步骤2：在当前备库执行
ALTER DATABASE COMMIT TO SWITCHOVER TO PRIMARY WITH SESSION SHUTDOWN;
SHUTDOWN IMMEDIATE;
STARTUP;

-- 步骤3：启动新的备库
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT;
```

### 6.2 故障切换（Failover）

#### 6.2.1 紧急切换（主库完全不可用）
```sql
-- 在备库执行
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE FINISH;
ALTER DATABASE ACTIVATE STANDBY DATABASE;
SHUTDOWN IMMEDIATE;
STARTUP;
```

#### 6.2.2 完整故障切换流程
```sql
-- 步骤1：停止MRP进程
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;

-- 步骤2：应用所有可用的重做日志
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE FINISH;

-- 步骤3：激活备库
ALTER DATABASE ACTIVATE STANDBY DATABASE;

-- 步骤4：重启数据库
SHUTDOWN IMMEDIATE;
STARTUP;

-- 步骤5：验证数据库状态
SELECT DATABASE_ROLE, OPEN_MODE FROM V$DATABASE;
```

## 7. 监控和维护

### 7.1 关键监控指标

#### 7.1.1 传输延迟监控
```sql
-- 创建监控视图
CREATE OR REPLACE VIEW DG_LAG_MONITOR AS
SELECT 
    NAME,
    VALUE,
    DATUM_TIME,
    CASE 
        WHEN NAME = 'transport lag' AND TO_NUMBER(SUBSTR(VALUE,1,INSTR(VALUE,' ')-1)) > 300 
        THEN 'WARNING'
        WHEN NAME = 'apply lag' AND TO_NUMBER(SUBSTR(VALUE,1,INSTR(VALUE,' ')-1)) > 600 
        THEN 'WARNING'
        ELSE 'OK'
    END AS STATUS
FROM V$DATAGUARD_STATS 
WHERE NAME IN ('transport lag', 'apply lag');

-- 定期检查
SELECT * FROM DG_LAG_MONITOR;
```

#### 7.1.2 同步状态监控
```sql
-- 创建同步监控脚本
SELECT 
    ds.dest_id,
    ds.status,
    ds.error,
    al.sequence# as last_archived_seq,
    als.sequence# as last_applied_seq,
    al.sequence# - als.sequence# as lag_sequences
FROM 
    v$archive_dest ds,
    (SELECT sequence# FROM v$archived_log WHERE dest_id=1 AND ROWNUM=1 ORDER BY sequence# DESC) al,
    (SELECT sequence# FROM v$archived_log WHERE dest_id=2 AND applied='YES' AND ROWNUM=1 ORDER BY sequence# DESC) als
WHERE ds.dest_id = 2;
```

### 7.2 日常维护任务

#### 7.2.1 归档日志管理
```sql
-- 检查归档日志空间使用
SELECT 
    dest_name,
    status,
    binding,
    name_space,
    used_space,
    space_limit,
    ROUND(used_space/space_limit*100,2) as usage_pct
FROM V$RECOVERY_AREA_USAGE;

-- 自动清理过期归档日志
RMAN> CROSSCHECK ARCHIVELOG ALL;
RMAN> DELETE EXPIRED ARCHIVELOG ALL;
RMAN> DELETE ARCHIVELOG ALL COMPLETED BEFORE 'SYSDATE-7';
```

#### 7.2.2 性能优化
```sql
-- 调整日志传输并发度
ALTER SYSTEM SET LOG_ARCHIVE_MAX_PROCESSES=5;

-- 优化网络缓冲区
ALTER SYSTEM SET LOG_ARCHIVE_DEST_2='SERVICE=STANDBY LGWR ASYNC NET_TIMEOUT=30 REOPEN=15';

-- 启用压缩传输（11g及以上）
ALTER SYSTEM SET LOG_ARCHIVE_DEST_2='SERVICE=STANDBY LGWR ASYNC COMPRESSION=ENABLE';
```

## 8. 故障排除指南

### 8.1 常见问题及解决方案

#### 8.1.1 传输中断问题
```sql
-- 问题诊断
SELECT MESSAGE FROM V$DATAGUARD_STATUS WHERE SEVERITY IN ('Error','Warning');

-- 解决方案
ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_2=DEFER;  -- 暂停传输
ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_2=ENABLE; -- 重新启用

-- 手动同步缺失的归档日志
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT;
```

#### 8.1.2 应用延迟问题
```sql
-- 检查MRP进程状态
SELECT PROCESS, STATUS, SEQUENCE# FROM V$MANAGED_STANDBY WHERE PROCESS LIKE 'MRP%';

-- 重启MRP进程
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT;

-- 启用并行应用（12c及以上）
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT PARALLEL 4;
```

#### 8.1.3 网络问题诊断
```bash
# 测试TNS连接
tnsping STANDBY

# 测试SQL*Net连接
sqlplus sys/password@STANDBY as sysdba

# 检查监听器状态
lsnrctl status
```

### 8.2 应急处理流程

#### 8.2.1 主库故障应急流程
```
1. 确认主库真正不可用（网络、电源、硬件）
2. 评估数据丢失风险
3. 决定是否执行failover
4. 在备库执行failover操作
5. 重新配置应用程序连接
6. 通知相关人员
7. 记录故障和处理过程
```

#### 8.2.2 备库故障应急流程
```
1. 主库继续正常运行
2. 检查归档日志传输状态
3. 修复备库问题
4. 重新同步备库
5. 验证同步状态
```

## 9. 性能调优建议

### 9.1 网络优化
```sql
-- 启用网络压缩
ALTER SYSTEM SET LOG_ARCHIVE_DEST_2='SERVICE=STANDBY LGWR ASYNC COMPRESSION=ENABLE';

-- 调整网络超时参数
ALTER SYSTEM SET LOG_ARCHIVE_DEST_2='SERVICE=STANDBY LGWR ASYNC NET_TIMEOUT=30';

-- 优化SDU和TDU参数（在tnsnames.ora中）
STANDBY =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = standby_host)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = standby_service)
      (SDU = 32767)
      (TDU = 32767)
    )
  )
```

### 9.2 I/O优化
```sql
-- 启用异步I/O
ALTER SYSTEM SET DISK_ASYNCH_IO=TRUE;

-- 调整归档日志大小
ALTER DATABASE ADD LOGFILE GROUP 4 '/u01/oradata/redo04.log' SIZE 1G;

-- 优化归档目录
ALTER SYSTEM SET LOG_ARCHIVE_DEST_1='LOCATION=/fast_disk/archive MANDATORY';
```

### 9.3 并行处理优化
```sql
-- 启用并行恢复（12c+）
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT PARALLEL 4;

-- 调整并行进程数
ALTER SYSTEM SET LOG_ARCHIVE_MAX_PROCESSES=8;
```

## 10. 最佳实践总结

### 10.1 配置最佳实践
1. **使用Physical Standby**：提供最完整的数据保护
2. **选择Maximum Availability模式**：平衡性能和数据安全
3. **启用Real-time Apply**：减少恢复时间
4. **配置Fast-Start Failover**：实现自动故障切换
5. **使用压缩传输**：减少网络带宽占用

### 10.2 运维最佳实践
1. **定期测试切换**：确保切换流程可用
2. **监控关键指标**：及时发现问题
3. **定期清理归档**：避免磁盘空间不足
4. **文档化操作流程**：标准化运维操作
5. **培训运维人员**：确保操作正确

### 10.3 安全最佳实践
1. **启用加密传输**：保护数据传输安全
2. **配置防火墙规则**：限制网络访问
3. **定期更新补丁**：保持系统安全
4. **监控审计日志**：跟踪系统访问
5. **备份控制文件**：确保可恢复性

## 11. 针对您业务的具体建议

### 11.1 推荐配置
- **同步模式**：Maximum Availability（最大可用性）
- **备库类型**：Physical Standby
- **传输方式**：LGWR ASYNC with COMPRESSION
- **应用方式**：Real-time Apply
- **监控频率**：每5分钟检查一次同步状态

### 11.2 RPO/RTO预期
- **RPO**：5-15分钟（取决于网络状况）
- **RTO**：10-30分钟（包括应用程序重新连接时间）

### 11.3 成本考虑
- **Oracle许可**：备库在灾备用途下通常不需要额外许可
- **硬件成本**：云端ECS + RDS成本
- **网络成本**：专线或VPN连接成本
- **运维成本**：培训和日常维护成本