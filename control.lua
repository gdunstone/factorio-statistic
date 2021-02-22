require("json")
function getForceStatistic(force)
    local statistic = {
        stats = {},
        forceData = {}
    };

    if game.active_mods['teams'] ~= nil then
        for k,data in pairs(remove.call('teams','getFoceData')) do
            if data.cName == force.name then
                statistic.forceData.color = data.color;
                statistic.forceData.title = data.title;
                statistic.forceData.name = data.name;
                statistic.forceData.cName = data.cName;
            end
        end
    else
--        statistic.forceData.title = force.name;
--        statistic.forceData.cName = force.name;
        statistic.forceData.name = force.name;
        statistic.forceData.color = {r = 0, g = 0, b = 0, a = 1};
    end

    for k,name in ipairs({
        "item_production_statistics",
        "fluid_production_statistics",
        "kill_count_statistics",
        "entity_build_count_statistics",
    }) do
        statistic.stats[name] = {
            input = force[name].input_counts,
            output = force[name].output_counts,
        }
    end

    return statistic;
end

function writeForceStatistic(statistic, force)
    local file = getFileNameForForce(force);
    game.write_file(file, json.stringify(statistic), false, 0 )
    game.write_file(file, content, false, 0); -- write only for server ;)
end


function getFileNameForForce(force)
    return 'statistic/forces/'..force.name..'.json';
end

function statistic_tick(tick)
    if tick % 3600 == 0 then -- write statistic every minute ;)
        for k, f in pairs(game.forces) do
            writeForceStatistic(getForceStatistic(f), f);
        end
    end
end
script.on_event(defines.events.on_tick, function(event)
    statistic_tick(event.tick);
end)