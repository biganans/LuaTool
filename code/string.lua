--字符串处理

--[[--
    描述: 获取字符串的GBK转码的长度
    @param  str 字符串可以包括中文英文数字符号
    @return length
]]
function getStingGBKLength(str)
    if str == nil then
        return 0
    end
    local fontSize = 2
    local lenInByte = #str
    local length = 0
    local i = 1

    while i <= lenInByte do
        local curByte = string.byte(str, i)
        local byteCount = 1

        if curByte > 0 and curByte <= 127 then
            byteCount = 1
        elseif curByte >= 192 and curByte < 223 then
            byteCount = 2
        elseif curByte >= 224 and curByte < 239 then
            byteCount = 3
        elseif curByte >= 240 and curByte <= 247 then
            byteCount = 4
        end

        local char = string.sub(str, i, i + byteCount - 1)
        i = i + byteCount
        if 1 == byteCount then
            length = length + fontSize * 0.5
        elseif 4 == byteCount then
            length = length + byteCount
        else
            length = length + fontSize
        end
    end
    return length
end
