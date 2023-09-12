#!/bin/bash
##############################################################
# Expect 实现 SSH 免交互执行命令
##############################################################

# 方法1
USER=root
PASS=123.com
IP=192.168.1.120
expect <<EOF
set timeout 30
spawn ssh $USER@$IP
expect {    
    "(yes/no)" {send "yes\r"; exp_continue}    
    "password:" {send "$PASS\r"}
}
expect "$USER@*"  {send "$1\r"}
expect "$USER@*"  {send "exit\r"}
expect eof
EOF

# 方法2
USER=root
PASS=123.com
IP=192.168.1.120
expect -c "
    spawn ssh $USER@$IP
    expect {
        \"(yes/no)\" {send \"yes\r\"; exp_continue}
        \"password:\" {send \"$PASS\r\"; exp_continue}
        \"$USER@*\" {send \"df -h\r exit\r\"; exp_continue}
}"
