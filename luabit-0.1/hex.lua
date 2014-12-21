--------------------
--Hex v0.4
--------------------
--Hex conversion lib for lua.

--How to use:
-- hex.to_hex(n) -- convert a number to a hex string
-- hex.to_dec(hex) -- convert a hex string(prefix with '0x' or '0X') to number
 
--Part of LuaBit(http://luaforge.net/projects/bit/).

--Under the MIT license.

--copyright(c) 2006~2007 hanzhao (abrash_han@hotmail.com)
--------------------

dofile('bit')

do
    local to_hex = function (n)
        if (type(n) ~= "number") then
            error("non-number type passed in.")
        end

        -- checking not float
        if (n - floor(n) > 0) then
            error("trying to apply bitwise operation on non-integer!")
        end

        if (n < 0) then
            -- negative
            n = bit.tobits(bit.bnot(abs(n)) + 1)
            n = bit.tonumb(n)
        end

        hex_tbl = { 'A', 'B', 'C', 'D', 'E', 'F' }
        hex_str = ""

        while (n ~= 0) do
            last = mod(n, 16)
            if (last < 10) then
                hex_str = tostring(last) .. hex_str
            else
                hex_str = hex_tbl[last - 10 + 1] .. hex_str
            end
            n = floor(n / 16)
        end
        if (hex_str == "") then
            hex_str = "0"
        end
        return "0x" .. hex_str
    end

    local to_dec = function(hex)
        if (type(hex) ~= "string") then
            error("non-string type passed in.")
        end

        head = strsub(hex, 1, 2)

        if (head ~= "0x" and head ~= "0X") then
            error("wrong hex format, should lead by 0x or 0X.")
        end

        v = tonumber(strsub(hex, 3), 16)

        return v;
    end

    --------------------
    -- hex lib interface
    hex = {
        to_dec = to_dec,
        to_hex = to_hex,
    }
end

--[[
-- test
d = 4341688
h = hex.to_hex(d)
--print(h)
--print(hex.to_dec(h))

i = 1
while i < 100000 do
 h = hex.to_hex(i)
 d = hex.to_dec(h)
 if(d ~= i) then 
  error("failed " .. i .. ", " .. h)
 end
 i = i + 1
end
--]]