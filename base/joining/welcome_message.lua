-- Show the welcome message to the chat
local function drawWelcomeMessage(msg)
    
    -- Clear the chat
    for i=1, 50 do
        AddPlayerChat("\n")
    end

    -- Send message to the chat
    Delay(500, function()
        AddPlayerChat("<span color=\"#ff392b\">"..msg.."</>")
    end)
end
AddRemoteEvent("SendWelcomeMessage", drawWelcomeMessage)