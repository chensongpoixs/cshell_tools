#!/bin/bash

在设置数据库自动备份时，需要自动输入密码，使用了expect命令。

#!/bin/bash
#第一版设置两个脚本为。
#/home/ccds/mysql.sh

#!/usr/bin/expect -f
#spawn /home/ccds/mysql1.sh
#set pass pass
#expect "password"
#send "$pass\n"
#interact


#/home/ccds/mysql1.sh

#!/bin/bash
#mysqldump -uroot -p test> /home/ccds/ccds/`date +%Y%m%d-%T`_ccds.sql

#上面这版使用./mysql.sh执行成功，放在计划任务里面时，可以建出sql文件，但是文件为空。

#第二个版本
#/home/ccds/mysql.sh

#!/usr/bin/expect -f
#spawn /home/ccds/mysql1.sh
#set pass pass
#expect "password"
#send "$pass\n"
#interact
#expect eof

#上面这版使用放在计划任务里面执行功，使用./mysql.sh执行时报expect: spawn id exp4 not open错误。
#interact 执行完成后保持交互状态，把控制权交给控制台，这个时候就可以手工操作了。如果没有这一句登录完成后会退出，而不是留在远程终端上。
#expect eof 结束expect匹配。
#一般为远程连接时，连接中断会报此错。在此处出现理解为interact已经退出expect捕获信息了，再次执行expect eof即会报错。

#最终版

#!/usr/bin/expect -f
spawn /home/ccds/mysql1.sh
set pass pass
expect "password"
send "$pass\n"
expect eof
#interact

