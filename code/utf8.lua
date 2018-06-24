--[[
    UTF-8字符处理
]]

--[[
    -- 返回utf8长度,中英文长度可以统一
]]
local utf8len = function(input)
    local str = input or nil
    local len = 0
    if str and string.len(str) > 0 then
        local count = string.len(str)
        local i, ch = 1, nil
        --linxh 最多按3个算，按照标准最多有6个的
        while i <= count do
            ch = string.byte(str, i)
            if ch < 0x80 then
                i = i + 1
            elseif ch < 0xE0 then
                i = i + 2
            else
                i = i + 3
            end
            len = len + 1
        end
    end
    return len
end

--[[
    -- 截取utf8字符长度，包含中文的整字长度
]]
local subUtf8Str = function (str, len, start)
    start = start or 1
    len = len or 0
    local text = ""
    if str and string.len(str) > 0 then
        local  count = string.len(str)
        local strLen, i, ch = 0, start, nil
        --linxh 最多按3个算，按照标准最多有6个的
        while i <= count and strLen < len do
            ch = string.byte(str, i)
            if ch < 0x80 then
                text = text .. string.sub(str, i, i)
                i = i + 1
            elseif ch < 0xE0 then
                text = text .. string.sub(str, i, i+1)
                i = i + 2
            else
                text = text .. string.sub(str, i, i+2)
                i = i + 3
            end

            strLen = strLen + 1
        end
    end

    return text
end
