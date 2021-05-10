function oneDArray(t::DataType, len::Int)
    return zeros(t, len)
end

function twoDArray(t::DataType, len_x::Int, len_y::Int)
    return zeros(t, len_x, len_y)
end