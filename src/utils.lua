function foreach(t,f)
    for k,v in pairs(t) do
        f(v)
    end
end
function clamp(v,lb,ub)
    if v > ub then return ub end
    if v < lb then return lb end
    return v
end

function addToSet(set, key)
    set[key] = true
end 

function removeFromSet(set, key)
    set[key] = nil
end

function setContains(set, key)
    return set[key] ~= nil
end	
