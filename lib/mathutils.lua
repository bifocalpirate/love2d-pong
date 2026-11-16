local MathUtils = {}

--@param n number
--@return number
function MathUtils.sign_is_positive(n)
    return n < 0 and -1 or 1
end

return MathUtils