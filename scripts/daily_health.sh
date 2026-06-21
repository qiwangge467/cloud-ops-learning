#!/bin/bash
# daily_health.sh - 系统健康体检脚本
# 功能：检查磁盘、内存、负载，并生成日报

# 定义颜色（让输出更好看）
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
NC='\033[0m' # 恢复默认颜色

# 定义日志文件（按日期命名）
LOG_FILE="/var/log/daily_health_$(date +%F).log"

# 写入日志头
echo "========================================" | tee -a $LOG_FILE
echo "  系统健康体检报告 - $(date '+%Y-%m-%d %H:%M:%S')" | tee -a $LOG_FILE
echo "========================================" | tee -a $LOG_FILE

# 1. 检查磁盘使用率（红线 80%）
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ $DISK_USAGE -gt 80 ]; then
    echo -e "${RED}⚠️  磁盘告警：使用率已达 ${DISK_USAGE}%，建议立即清理！${NC}" | tee -a $LOG_FILE
elif [ $DISK_USAGE -gt 70 ]; then
    echo -e "${YELLOW}⚡ 磁盘注意：使用率 ${DISK_USAGE}%，接近警戒线。${NC}" | tee -a $LOG_FILE
else
    echo -e "${GREEN}✅ 磁盘正常：使用率 ${DISK_USAGE}%。${NC}" | tee -a $LOG_FILE
fi

# 2. 检查内存使用率（红线 90%）
MEM_USAGE=$(free | grep Mem | awk '{printf("%.0f", $3/$2 * 100)}')
if [ $MEM_USAGE -gt 90 ]; then
    echo -e "${RED}⚠️  内存告警：使用率已达 ${MEM_USAGE}%，存在卡顿风险！${NC}" | tee -a $LOG_FILE
elif [ $MEM_USAGE -gt 80 ]; then
    echo -e "${YELLOW}⚡ 内存注意：使用率 ${MEM_USAGE}%，建议关注。${NC}" | tee -a $LOG_FILE
else
    echo -e "${GREEN}✅ 内存正常：使用率 ${MEM_USAGE}%。${NC}" | tee -a $LOG_FILE
fi

# 3. 检查系统负载（1分钟负载）
LOAD=$(uptime | awk -F'load average:' '{print $2}' | cut -d, -f1 | xargs)
echo "📊 系统负载（1分钟）：$LOAD" | tee -a $LOG_FILE

# 4. 输出磁盘详情（供参考）
echo "" | tee -a $LOG_FILE
echo "📁 磁盘详情：" | tee -a $LOG_FILE
df -h | tee -a $LOG_FILE

echo "" | tee -a $LOG_FILE
echo "📁 内存详情：" | tee -a $LOG_FILE
free -h | tee -a $LOG_FILE

echo "========================================" | tee -a $LOG_FILE
echo "✅ 体检完成！日志已保存至：$LOG_FILE" | tee -a $LOG_FILE
