---
title: Es健康检查
date: 2025-11-11 14:21:02
tags: 运维
---

1.检查
~~~bash
# 检查集群健康状态
curl -X GET "localhost:9200/_cluster/health?pretty"

# 检查监控索引状态
curl -X GET "localhost:9200/.monitoring-*/_search?pretty"

# 查看节点状态
curl -X GET "localhost:9200/_cat/nodes?v"

# 查看节点详细信息
curl -X GET "localhost:9200/_nodes/stats?pretty"

# 查看是哪些索引有问题 这是监控数据索引，不是业务数据,业务索引谨慎删除
curl -X GET "localhost:9200/_cat/indices?v&health=red"

# 查看节点的 CPU、内存、负载
curl -X GET "localhost:9200/_cat/nodes?v&h=name,heap.percent,ram.percent,cpu,load_1m,load_5m,load_15m"

# 查看详细的 JVM 堆内存使用
curl -X GET "localhost:9200/_nodes/stats/jvm?pretty" | grep -A 10 "heap"

# 查看磁盘 I/O 统计
curl -X GET "localhost:9200/_nodes/stats/fs?pretty"


# 查看是否有慢查询
curl -X GET "localhost:9200/_nodes/stats/indices/search?pretty" | grep -A 5 "query_time"

# 启用慢查询日志（如果未启用）
curl -X PUT "localhost:9200/_all/_settings" -H 'Content-Type: application/json' -d'
{
  "index.search.slowlog.threshold.query.warn": "2s",
  "index.search.slowlog.threshold.query.info": "1s",
  "index.search.slowlog.threshold.fetch.warn": "1s",
  "index.search.slowlog.threshold.fetch.info": "500ms"
}'

# 查看慢查询日志文件
tail -100 /var/log/elasticsearch/prod-elasticsearch-532-cluster_index_search_slowlog.log

# 查看当前活跃的查询任务
curl -X GET "localhost:9200/_tasks?detailed=true&actions=*search*&pretty"

# 查看热点线程（找出 CPU 占用高的线程）
curl -X GET "localhost:9200/_nodes/hot_threads"
~~~

实操
~~~bash
# 删除有问题的监控索引
curl -X DELETE "localhost:9200/.monitoring-kibana-2-2025.11.08"
curl -X DELETE "localhost:9200/.monitoring-data-2"

# 等待几秒后检查集群状态
sleep 5
curl -X GET "localhost:9200/_cluster/health?pretty"

# 可以尝试禁用监控功能
# 在 kibana.yml 中添加：
xpack.monitoring.enabled: false

   # 查看哪些分片未分配
curl -X GET "localhost:9200/_cat/shards?h=index,shard,prirep,state,unassigned.reason" | grep UNASSIGNED

# 获取详细的未分配原因
curl -X GET "localhost:9200/_cluster/allocation/explain?pretty"

# 检查磁盘使用情况
curl -X GET "localhost:9200/_cat/allocation?v"

# 如果磁盘空间不足，调整水位线（临时方案）
curl -X PUT "localhost:9200/_cluster/settings" -H 'Content-Type: application/json' -d'
{
  "transient": {
    "cluster.routing.allocation.disk.watermark.low": "90%",
    "cluster.routing.allocation.disk.watermark.high": "95%",
    "cluster.routing.allocation.disk.watermark.flood_stage": "97%"
  }
}'

# 查看索引设置
curl -X GET "localhost:9200/_cat/indices?v&health=red"

# 如果是副本问题，可以临时减少副本数
curl -X PUT "localhost:9200/<index_name>/_settings" -H 'Content-Type: application/json' -d'
{
  "number_of_replicas": 1
}'

# 检查分配设置
curl -X GET "localhost:9200/_cluster/settings?pretty&include_defaults=true" | grep allocation.enable

# 如果被禁用，启用分配
curl -X PUT "localhost:9200/_cluster/settings" -H 'Content-Type: application/json' -d'
{
  "persistent": {
    "cluster.routing.allocation.enable": "all"
  }
}'
~~~
