# LuaTool
一般有用的lua方法，有的是自己的，有的是网上收集的，如有不小心碰车需要删除的请私信或留言，也欢迎大家一起共享。    
# 方法类型如下
## utf8.lua [utf8字符操作](https://github.com/biganans/LuaTool/blob/master/code/utf8.lua)        
## file.lua [文件处理](https://github.com/biganans/LuaTool/blob/master/code/file.lua)    
## table.lua [table表的操作](https://github.com/biganans/LuaTool/blob/master/code/table.lua)
## string.lua [字符操作](https://github.com/biganans/LuaTool/blob/master/code/string.lua)   
## ProFi.lua [lua内存打印，排除内存泄漏和优化内存](https://github.com/biganans/LuaTool/blob/master/code/ProFi.lua)   
## ELO.lua [ELO匹配算法](https://github.com/biganans/LuaTool/blob/master/code/ELO.lua)  
# 很神奇的发现    
1.table.sort    invalid order function for sorting
当sort里面导致排序不是稳定的时候怎么办，怎么搞都不对的时候，试试下面的骚操作：
```
local _sortTask = function(t1,t2)
  if t1 == nil or t1 == nil then
        return false
    end
    local bcomp = function(t1,t2)
    --随便你怎么骚写判定条件
    end
    return bcomp(t1,t2)
end
```    
