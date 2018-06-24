--[[
    处理文件
]]

--直接加载一个文本为lua
function doFile(path)
    local fileData = cc.FileUtils:getInstance():getStringFromFile(path)
    local fun = loadstring(fileData)
    local ret, flist = pcall(fun)
    if ret then
        return flist
    end

    return flist
end

--写文件
function writefile(path, content, mode)
    mode = mode or "w+b"
    local file = io.open(path, mode)
    if file then
        if file:write(content) == nil then return false end
        io.close(file)
        return true
    else
        return false
    end
end

