local inFirst = false
AddEvent("OnKeyPress", function(key)
    if key == "B" then
        inFirst = not inFirst
        EnableFirstPersonCamera(inFirst)
    end
end)