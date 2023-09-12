#!/bin/bash
##############################################################
# 批量修改服务器用户密码
##############################################################

# cat old_pass.txt
# 192.168.18.217  root    123456     22
# 192.168.18.218  root    123456     22

OLD_INFO=old_pass.txt
NEW_INFO=new_pass.txt
for IP in $(awk '/^[^#]/{print $1}' $OLD_INFO); do
    USER=$(awk -v I=$IP 'I==$1{print $2}' $OLD_INFO)
    PASS=$(awk -v I=$IP 'I==$1{print $3}' $OLD_INFO)
    PORT=$(awk -v I=$IP 'I==$1{print $4}' $OLD_INFO)
    NEW_PASS=$(mkpasswd -l 8) # 随机密码
    echo "$IP   $USER   $NEW_PASS   $PORT" >>$NEW_INFO
    expect -c "  
    spawn ssh -p$PORT $USER@$IP  
    set timeout 2  
    expect {  
        \"(yes/no)\" {send \"yes\r\";exp_continue}  
        \"password:\" {send \"$PASS\r\";exp_continue}  
        \"$USER@*\" {send \"echo \'$NEW_PASS\' |passwd --stdin $USER\r exit\r\";exp_continue}  
    }"
done
