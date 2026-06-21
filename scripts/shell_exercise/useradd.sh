#!/bin/bash
for user in wxq wxq1 wxq2 
do useradd -m $user
echo "123456" |  passwd --stdin $user
echo "用户$user创建成功" 
done
