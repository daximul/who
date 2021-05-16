local Prot = {}

local spec = {
    getrawmt = (debug and debug.getmetatable) or getrawmetatable;
    getcons = getconnections or get_signal_cons;
    getnamecall = getnamecallmethod or get_namecall_method;
    makereadonly = setreadonly or (make_writeable and function(table, readonly) if readonly then make_readonly(table) else make_writeable(table) end end);
    newclose = newcclosure or protect_function or function(f) return f end;
}

local ProtectedInstances = {}
local SpoofedInstances = {}

local Methods = {
    "FindFirstChild",
    "FindFirstChildWhichIsA",
    "FindFirstChildOfClass",
    "IsA"
}

local AllowedIndexes = {
    "RootPart",
    "Parent"
}

local AllowedNewIndexes = {
    "Jump"
}

local mt = spec.getrawmt(game)
local OldMetaMethods = {}
spec.makereadonly(mt, false)

for i, v in next, mt do
    OldMetaMethods[i] = v
end

local __Namecall = OldMetaMethods.__namecall
local __Index = OldMetaMethods.__index
local __NewIndex = OldMetaMethods.__newindex

mt.__namecall = newclose(function(self, ...)
    if (checkcaller()) then
        return __Namecall(self, ...)
    end
    
    local Method = spec.getnamecall():gsub("%z", function(x)
        return x
    end):gsub("%z", "")

    local Protected = ProtectedInstances[self]

    if Protected then
        if table.find(Methods, Method) then
            return Method == "IsA" and false or nil
        end
    end
    return __Namecall(self, ...)
end)

mt.__index = newclose(function(Instance_, Index)
    if (checkcaller()) then
        return __Index(Instance_, Index)
    end

    Index = type(Index) == "string" and Index:gsub("%z", function(x)
        return x
    end):gsub("%z", "") or Index
    
    local Protected = ProtectedInstances[Instance_]
    local Spoofed = SpoofedInstances[Instance_]
    
    if Spoofed then
        if table.find(AllowedIndexes, Index) then
            return __Index(Instance_, Index)
        end
        if Instance_:IsA("Humanoid") and game.PlaceId == 6650331930 then
            for i, v in next, spec.getcons(Instance_:GetPropertyChangedSignal("WalkSpeed")) do
                v:Disable()
            end
        end
        return __Index(Spoofed, Index)
    end

    if Protected then
        if table.find(Methods, Index) then
            return function()
                return Index == "IsA" and false or nil
            end
        end
    end

    return __Index(Instance_, Index)
end)

mt.__newindex = newclose(function(Instance_, Index, Value)
    if (checkcaller()) then
        return __NewIndex(Instance_, Index, Value)
    end

    local Spoofed = SpoofedInstances[Instance_]

    if Spoofed then
        if table.find(AllowedNewIndexes, Index) then
            return __NewIndex(Instance_, Index, Value)
        end
        return __NewIndex(Spoofed, Index, Spoofed[Index])
    end

    return __NewIndex(Instance_, Index, Value)
end)

spec.makereadonly(mt, true)

Prot.Protect = function(Instance_)
    ProtectedInstances[#ProtectedInstances + 1] = Instance_
    if syn and syn.protect_gui then
        syn.protect_gui(Instance_)
    end
end

Prot.Spoof = function(Instance_, Instance2)
    SpoofedInstances[Instance_] = Instance2 and Instance2 or Instance_:Clone()
end

return Prot
