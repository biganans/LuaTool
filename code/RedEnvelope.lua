--洗牌算法，用于将一组数据等概率随机打乱。等概率算法。
local function shuffle(t)
    if not t then return end
    local cnt = #t
    for i=1,cnt do
        local j = math.random(i,cnt)
        t[i],t[j] = t[j],t[i]
    end
end

--分红包算法
local function split(m,n)
    --构造m-1个可用的分割标记位
    local mark = {}
    for i=1,m-1 do
        mark[i] = i
    end

    --打乱标所有记位
    shuffle(mark)
    --构建一个新的表，并从mark表中取前n-1个位置作为有效标记位
    local validMark = {}
    for i=1,n-1 do
        validMark[i] = mark[i]
    end

    --重新按从小到大排序有效标记
    table.sort(validMark,function (a,b)
        return a<b
    end)

    --设置有效标记表的头、尾分别为0和m
    validMark[0] = 0
    validMark[n] = m
    --构建输出数组
    local out = {}
    for i=1,n do
        out[i] = validMark[i] - validMark[i-1]
    end
    return out
end

local function main()
    --设置随机数种子
    math.randomseed(tostring(os.time()):reverse():sub(1,6))
    local M = 10000
    local N = 100
    local data = split(M,N)

    -- 输出结果，并验算一下红包总钱数
    local datasum = 0
    local outstr = ""
    for i=1,N do
        datasum = data[i] + datasum
        outstr = outstr .. data[i] .. ((0 == i%10) and "\n" or "\t")
    end

    print ("datasum = " .. datasum)
    print (outstr)
end

main()
--------------------- 
作者：wondergong 
来源：CSDN 
原文：https://blog.csdn.net/qq_16209077/article/details/54291189 
版权声明：本文为博主原创文章，转载请附上博文链接！
