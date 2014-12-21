----------------
-- LuaBit v0.1
-------------------
-- a bitwise operation lib for lua 3.2.
-- http://luaforge.net/projects/bit/

-- How to use:
-------------------
-- bit.bnot(n) -- bitwise not (~n)
-- bit.band(m, n) -- bitwise and (m & n)
-- bit.bor(m, n) -- bitwise or (m | n)
-- bit.bxor(m, n) -- bitwise xor (m ^ n)
-- bit.brshift(n, bits) -- right shift (n >> bits)
-- bit.blshift(n, bits) -- left shift (n << bits)
-- bit.blogic_rshift(n, bits) -- logic right shift(zero fill >>>)

--Please note that bit.brshift and bit.blshift only support number within 32 bits.

-- 2 utility functions are provided too:
-- bit.tobits(n) -- convert n into a bit table(which is a 1/0 sequence)
-- high bits first
-- bit.tonumb(bit_tbl) -- convert a bit table into a number
-------------------
-- Under the MIT license.
-- copyright(c) 2006~2007 hanzhao (abrash_han@hotmail.com)
-----------------

do
    ------------------------
    -- bit lib implementions
    local treversed = function(tbl)
        local tb = {}
        local size = getn(tbl)
        local i = size
        while i > 0 do
            tb[size - i + 1] = tbl[i]
            i = i - 1
        end
        return tb
    end

    local check_int = function(n)
        -- checking not float
        if (n - floor(n) > 0) then
            error("trying to use bitwise operation on non-integer!")
        end
    end

    local to_bits = function(n)
        % check_int(n)
        if (n < 0) then
            -- negative
            return to_bits(bit.bnot(abs(n)) + 1)
        end
        -- to bits table
        local tbl = {}
        local cnt = 1
        while (n > 0) do
            local last = mod(n, 2)
            if (last == 1) then
                tbl[cnt] = 1
            else
                tbl[cnt] = 0
            end
            n = (n - last) / 2
            cnt = cnt + 1
        end
        return % treversed(tbl)
    end

    local tbl_to_number = function(tbl)
        local size = getn(tbl)
        local rslt = 0
        local i = 0
        while i < size do
            rslt = rslt + (tbl[size - i] * 2 ^ i)
            i = i + 1;
        end
        return rslt
    end

    local zfill = function(tbl_a, tbl_b)
        local tbl_an = getn(tbl_a)
        local tbl_bn = getn(tbl_b)

        if tbl_an > tbl_bn then
            return tbl_a
        end
        local tb = {}
        local size = tbl_bn - tbl_an + 1
        local i = 1

        while i < size do
            tb[i] = 0
            i = i + 1
        end

        foreach(tbl_a, function(x, v)
            local size = getn(% tb);
            % tb[size + 1] = v
        end)

        return tb
    end

    local bit_or = function(m, n)
        local tbl_m = % to_bits(m)
        local tbl_n = % to_bits(n)

        tbl_m = % zfill(tbl_m, tbl_n)
        tbl_n = % zfill(tbl_n, tbl_m)

        local tbl = {}

        foreach(tbl_m, function(i, v)
            if (v == 0 and % tbl_n[i] == 0) then
                % tbl[i] = 0
            else
                % tbl[i] = 1
            end
        end)

        return % tbl_to_number(tbl)
    end

    local bitwriter = function(tbl)
        local size = getn(tbl)
        foreach(tbl, function(i, v)
            write(v)
            if % size == i then
                write('<br/>')
            end
        end)
    end

    local bit_and = function(m, n)
        local tbl_m = % to_bits(m)
        local tbl_n = % to_bits(n)

        tbl_m = % zfill(tbl_m, tbl_n)
        tbl_n = % zfill(tbl_n, tbl_m)

        assert(getn(tbl_m) == getn(tbl_n), '[band] zfill')

        local tbl = {}
        local size = getn(tbl_m)

        foreach(tbl_m, function(i, v)
            if (v == 0 or % tbl_n[i] == 0) then
                % tbl[i] = 0
            else
                % tbl[i] = 1
            end
        end)

        --% bitwriter(tbl)

        return % tbl_to_number(tbl)
    end

    local bit_not = function(n)
        local tbl = % to_bits(n)
        local size = max(getn(tbl), 32)
        local i = 1
        while i < size do
            if (tbl[i] == 1) then
                tbl[i] = 0
            else
                tbl[i] = 1
            end
            i = i + 1
        end
        return % tbl_to_number(tbl)
    end

    local bit_xor = function(m, n)
        local tbl_m = % to_bits(m)
        local tbl_n = % to_bits(n)

        tbl_m = % zfill(tbl_m, tbl_n)
        tbl_n = % zfill(tbl_n, tbl_m)

        assert(getn(tbl_m) == getn(tbl_n), '[xor] zfill')

        local tbl = {}

        foreach(tbl_m, function(i, v)
            if (v ~= % tbl_n[i]) then
                % tbl[i] = 1
            else
                % tbl[i] = 0
            end
        end)

        return % tbl_to_number(tbl)
    end

    local bit_rshift = function(n, bits)
        % check_int(n)

        local high_bit = 0
        if (n < 0) then
            -- negative
            n = % bit_not(abs(n)) + 1
            high_bit = 2147483648 -- 0x80000000
        end
        local i = 1
        while i < bits do
            n = n / 2
            n = % bit_or(floor(n), high_bit)
            i = i + 1
        end
        return floor(n)
    end

    -- logic rightshift assures zero filling shift
    local bit_logic_rshift = function(n, bits)
        % check_int(n)
        if (n < 0) then -- negative
            n = % bit_not(abs(n)) + 1
        end
        local i = 0
        while i < bits do
            n = n / 2
            i = i + 1
        end
        return floor(n)
    end

    local bit_lshift = function(n, bits)
        % check_int(n)

        if (n < 0) then -- negative
            n = % bit_not(abs(n)) + 1
        end
        local i = 0
        while i < bits do
            n = n * 2
            i = i + 1
        end
        return % bit_and(n, 4294967295) -- 0xFFFFFFFF
    end

    local bit_xor2 = function(m, n)
        local rhs = % bit_or(% bit_not(m), % bit_not(n))
        local lhs = % bit_or(m, n)
        local rslt = % bit_and(lhs, rhs)
        return rslt
    end

    --------------------
    -- bit lib interface

    bit = {
        -- bit operations
        bnot = bit_not,
        band = bit_and,
        bor = bit_or,
        bxor = bit_xor,
        brshift = bit_rshift,
        blshift = bit_lshift,
        bxor2 = bit_xor2,
        blogic_rshift = bit_logic_rshift,

        -- utility func
        tobits = to_bits,
        tonumb = tbl_to_number,
        bwriter = bitwriter
    }
end