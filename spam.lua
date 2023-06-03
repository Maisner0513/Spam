local config = {
    {
        ["name"] = "",
        ["password"] = "",
        ["world"] = "HEAVEN", -- world name bot spams at
        ["text"] = "im a spam bot", -- text that bot spams
        ["x"] = 92, -- x pos bot pathfinds to
        ["y"] = 23 -- y pos bot pathfinds to
    }
}

function walk_to(bot, x, y)
    for _, pos in pairs(bot:find_path(x, y)) do
        bot:set_pos_at_tile(pos.x, pos.y)
        sleep(300)
    end
end


function spam(bot, world, text, x, y)
::start::
    bot:set_action("connecting")
    while bot.status ~= bot_status.connected do
        bot:connect()
        sleep(10000)
    end
    
    bot:set_action("warping")
    while bot:get_world() == nil or bot:get_world().name ~= world do
        bot:warp(world)
        sleep(3000)
    end
    
    sleep(2000)
    bot:set_action("walking")
    walk_to(bot, x, y)
    
    bot:set_action("spamming")
    while true do
        if bot.status ~= bot_status.connected then goto start end
        bot:say(text)
        sleep(10000)
    end
end

for _, bot_config in pairs(config) do
    local name = bot_config["name"]
    local password = bot_config["password"]
    local world_name = bot_config["world"]
    
    local bot = bot_manager.get_bot(name)
    
    if bot == nil then
        print("adding bot " .. name)
        bot = bot_manager.add_bot(name,password)
    end
    
    -- cant pass params to threads yet so we can do this
    create_thread(function() spam(bot, world_name, bot_config["text"], bot_config["x"], bot_config["y"]) end)
end