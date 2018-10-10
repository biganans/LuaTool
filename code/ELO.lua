--[[
    根据ELO书写
    参考：
    https://www.gameres.com/823640.html
    https://zhuanlan.zhihu.com/p/28190267
    https://www.jianshu.com/p/1ae01cf56f0a
    http://www.codeweblog.com/%E7%94%B5%E5%BD%B1%E7%A4%BE%E4%BA%A4%E7%BD%91%E7%BB%9C%E4%B8%ADfacemash%E5%A5%B3%E7%94%9F%E8%AF%84%E6%AF%94%E7%AE%97%E6%B3%95java%E5%AE%9E%E7%8E%B0/
]]
--不同积分范围对应的K值【K值越小就越趋近收敛，可以这样理解玩家需要赢到多少分后达到一个临界点，即在不同的分数区间所达到的速度快慢】
local scores =
{
    [1] = {s = 0,k=100},
    [2] = {s = 500,k=80},
    [3] = {s = 1000,k=50},
    [4] = {s = 1500,k=40},
    [5] = {s = 2000,k=32},
    [6] = {s = 2400,k=20},
    [7] = {s = 2500,k=10},
}
--每一个参数选手的属性
local girls1 = {
    id = 1,
    score = 1400,
    --期望胜率，需要和对手进行计算
    expectWin = 0.5,
    win = 0,
    total = 0,
}

local girls2 = {
    id = 2,
    score = 2000,
    --期望胜率，需要和对手进行计算
    expectWin = 0.5,
    win = 0,
    total = 0,
}

local win
local lost

local round = function(a)
    local r1,r2 = math.modf(a)
    if r2 > 0.5 then
        return r1+1
    end
    return r1
end

local getKvalue = function(score)
    for i=1,#scores do
        if score <= scores[i].s then
            return scores[i].k
        end
    end
    return scores[#scores].k
end

--计算E值(胜率) e为胜利得到的相差分数
local getExpecteWin = function(e)
    local tmp = e/400
    local eWin = 1/(1+math.pow(10,tmp))
    return eWin
end

--计算期望值
--如果两个或者多个玩家期望值对应
local computeExpectWin = function()
    -- 分数是一样的
    if win.score == lost.score then
        win.expectWin = 0.5
        lost.expectWin = 0.5
    else
        local winSub = lost.score - win.score
        local lostSub = win.score - lost.score
        win.expectWin = getExpecteWin(winSub)
        lost.expectWin = getExpecteWin(lostSub)
    end
end

-- 根据胜负选手得到各自的积分变化
-- result胜利失败，score以前的分数，expectWin期望胜率
-- result胜1 平0.5 负0
local resultScore = function(result,score,expectWin)
    local tmp = result - expectWin
    local k = getKvalue(score)
    return round(score + k*tmp)
end

--模拟结果战斗

for i=1,100000 do
    local a = math.random(1,10)
    a = 1
    local r1 = 1
    local r2 = 0
    girls1.total = girls1.total + 1
    girls2.total = girls2.total + 1
    if a == 5 then
        r1 = 0.5
        r2 = 0.5
        print("1 VS 2 Draw")
        win = girls1
        lost = girls2
    elseif a > 5 then
        r1 = 0
        r2 = 1
        print("1 VS 2 Lost")
        win = girls2
        lost = girls1
        girls2.win = girls2.win + 1
    else
        print("1 VS 2 Win")
        win = girls1
        lost = girls2
        girls1.win = girls1.win + 1
    end
    computeExpectWin()

    local g1 = resultScore(r1,girls1.score,girls1.expectWin)
    girls1.score = g1
    local g2 = resultScore(r2,girls2.score,girls2.expectWin)
    --挑战的对方玩家积分固定
    -- girls2.score = g2

    print("g1 >>"..g1.."  g2 >>"..g2)

    if g1 >= 2000 then
        print("win count"..i)
        break
    end
end

local r1 = girls1.win/girls1.total
local r2 = girls2.win/girls2.total
print("g1 win rate:"..r1.."  g2 win rate:"..r2)

--[[
    D = Rb - Ra 积分差异：Rb对手分数，Ra自己的分数
    P = 1/(1+10^(D/400)) 期望胜率，就是A PK B胜率的概率
    战后积分计算Rn = R0+K*(G-Ge) Rn：最后得分，R0比赛前分数，G对局分（胜利1，平局0.5，输0），Ge自己胜率预期。
    1V1挑战模式：
    可以观察得出K的值是影响玩家得分多少，即得分的速度，一般分数越高K值越低，这样就容易收敛于一个小区间，从而使得竞争更激烈产生的顶尖高手才是最真实的。在一定的范围内玩家会出现胜利不会得分情况（分数进行了四舍五入），这种情况就是因为K值低
    此时就需要制定更合理的匹配规则，积分相差过大代表就是积分大的获胜不会得分并且只要输了就会让对方获得高分，
    并且在一定程度上可以表现为战斗力很高的时候几乎得到的分数会越来越少，这个和K设置有关。
    根据现有游戏匹配模式，有几种改进：
    1.天梯分数计算：使用所有的hero进行积分*次数累加再除以所有英雄的次数得到天梯积分（目前不流行）
    2.赛季制：目前最流行的方式，加入各种辅助积分来影响游戏体验，但是所有的匹配都是走的隐藏的积分R，而非显示的积分，所以你是大神的时候打小号还是会匹配到和你一个段位的人，除非换账号，换区是没有用的。
    MVM挑战模式：多人组队模式
    主要是对手的积分值的计算，比较赞同知乎的加权计算方式：Rc = (Ra/A所在队伍的总分)*B队总分
    D = Rc - Ra （Rc为修复后的积分值）
    这样计算得分就比较丝顺柔滑了。
]]
