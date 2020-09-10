# cshell_tools
linux上shell脚本的工具



## awk 命令的使用

```
#!/bin/bash

server='chensong|192.168.1.82'
name=`echo $server | awk -F\| '{ print $1 }'`
ip=`echo $server | awk -F\| '{ print $2 }'`

echo "name:$name-ip:$ip";
```

output

```
name:chensong-ip:192.168.1.82
```






