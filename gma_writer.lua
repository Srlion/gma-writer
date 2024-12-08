local HEADER = "GMAD"
local VERSION = 3

local function write_c_string(f, s)
    assert(s:find("\0", 1, true) == nil, "String contains null byte")
    f:Write(s)
    f:WriteByte(0) -- Null terminator
end

local GMAWriter = {}
GMAWriter.__index = GMAWriter

function GMAWriter:new(name, steam_id64)
    return setmetatable({
        name = name,
        steam_id64 = steam_id64,
        author = "unknown",
        description = "",
        entries = {},
    }, GMAWriter)
end

function GMAWriter:file(name, bytes)
    table.insert(self.entries, {name = name, content = bytes})
end

function GMAWriter:write_to(filename)
    local f = file.Open(filename, "wb", "DATA")
    assert(f, "Failed to open file")

    f:Write(HEADER)
    f:WriteByte(VERSION)
    f:WriteUInt64(self.steam_id64)

    f:WriteUInt64(tostring(os.time()))

    -- Required content (unused)
    f:WriteByte(0)

    write_c_string(f, self.name)
    write_c_string(f, self.description)
    write_c_string(f, self.author)

    -- Version (unused) - this is a signed 32-bit integer
    f:WriteLong(1)

    for i, e in ipairs(self.entries) do
        f:WriteULong(i)
        write_c_string(f, e.name)
        f:WriteUInt64(tostring(#e.content))
        f:WriteULong(0) -- CRC (unused)
    end

    f:WriteULong(0)

    -- Write file contents
    for _, e in ipairs(self.entries) do
        f:Write(e.content)
    end

    f:WriteULong(0)

    f:Close()
    return true
end

return GMAWriter
