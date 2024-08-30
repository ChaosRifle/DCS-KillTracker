--KillTracker
--requires codebases:               tableIO and ChaosTools for logging/saving data
--requires config file containing:  MissionName, FilePath


local saveDataSubfolder = 'saves/'
local saveNamePrefix = MissionName .. '_'




--main script
if not FileExists(table.concat({FilePath, saveDataSubfolder, saveNamePrefix, 'KillTracker_B_Players.lua'})) then                --first boot prep
    TableSave(table.concat({FilePath, saveDataSubfolder, saveNamePrefix, 'KillTracker_B_Players.lua'}), {})
end
if not FileExists(table.concat({FilePath, saveDataSubfolder, saveNamePrefix, 'KillTracker_B_AI.lua'})) then                     --first boot prep
    TableSave(table.concat({FilePath, saveDataSubfolder, saveNamePrefix, 'KillTracker_B_AI.lua'}), {})
end
if not FileExists(table.concat({FilePath, saveDataSubfolder, saveNamePrefix, 'KillTracker_R_Players.lua'})) then                --first boot prep
    TableSave(table.concat({FilePath, saveDataSubfolder, saveNamePrefix, 'KillTracker_R_Players.lua'}), {})
end
if not FileExists(table.concat({FilePath, saveDataSubfolder, saveNamePrefix, 'KillTracker_R_AI.lua'})) then                     --first boot prep
    TableSave(table.concat({FilePath, saveDataSubfolder, saveNamePrefix, 'KillTracker_R_AI.lua'}), {})
end

local killTracker = {} --eventhandler
local B_Players = TableLoad(table.concat({FilePath, saveDataSubfolder, saveNamePrefix, 'KillTracker_B_Players.lua'}) )          --load data from file
local B_AI = TableLoad(table.concat({FilePath, saveDataSubfolder, saveNamePrefix, 'KillTracker_B_AI.lua'}) )                    --load data from file
local R_Players = TableLoad(table.concat({FilePath, saveDataSubfolder, saveNamePrefix, 'KillTracker_R_Players.lua'}) )          --load data from file
local R_AI = TableLoad(table.concat({FilePath, saveDataSubfolder, saveNamePrefix, 'KillTracker_R_AI.lua'}) )                    --load data from file



function killTracker:onEvent(event)
    if event.id == world.event.S_EVENT_UNIT_LOST then --unit lost
        -- Event = {
        --   id = 30,
        --   time = Time,
        --   initiator = Unit,
        -- }
        if event.initiator then
            ChaosLog('killtracker initiator', event.initiator)
            ChaosLog('killtracker typename', Unit.getTypeName(event.initiator))
            local playerName = Unit.getPlayerName(event.initiator)
            if playerName then                                                                                                  -- PLAYER
                local playerlist = net.get_player_list()
                local playerInfo = nil
                for x = 1, #playerlist, 1 do
                    playerInfo = net.get_player_info(playerlist[x])
                    if playerInfo.name == playerName then
                        break
                    end
                end

                if playerInfo.side == coalition.side.RED then
                    if not R_Players[Unit.getTypeName(event.initiator)] then
                        R_Players[Unit.getTypeName(event.initiator)] = 1
                        TableSave(table.concat({FilePath, saveDataSubfolder, saveNamePrefix, 'KillTracker_R_Players.lua'}), R_Players)
                    else
                        R_Players[Unit.getTypeName(event.initiator)] = R_Players[Unit.getTypeName(event.initiator)] + 1
                        TableSave(table.concat({FilePath, saveDataSubfolder, saveNamePrefix, 'KillTracker_R_Players.lua'}), R_Players)
                    end
                elseif playerInfo.side == coalition.side.BLUE then
                    if not B_Players[Unit.getTypeName(event.initiator)] then
                        B_Players[Unit.getTypeName(event.initiator)] = 1
                        TableSave(table.concat({FilePath, saveDataSubfolder, saveNamePrefix, 'KillTracker_B_Players.lua'}), B_Players)
                    else
                        B_Players[Unit.getTypeName(event.initiator)] = B_Players[Unit.getTypeName(event.initiator)] + 1
                        TableSave(table.concat({FilePath, saveDataSubfolder, saveNamePrefix, 'KillTracker_B_Players.lua'}), B_Players)
                    end
                end

            else                                                                                                                -- AI

                if Unit.getCoalition(event.initiator) == coalition.side.RED then
                    if not R_AI[Unit.getTypeName(event.initiator)] then
                        R_AI[Unit.getTypeName(event.initiator)] = 1
                        TableSave(table.concat({FilePath, saveDataSubfolder, saveNamePrefix, 'KillTracker_R_AI.lua'}), R_AI)
                    else
                        R_AI[Unit.getTypeName(event.initiator)] = R_AI[Unit.getTypeName(event.initiator)] + 1
                        TableSave(table.concat({FilePath, saveDataSubfolder, saveNamePrefix, 'KillTracker_R_AI.lua'}), R_AI)
                    end
                elseif Unit.getCoalition(event.initiator) == coalition.side.BLUE then
                    if not B_AI[Unit.getTypeName(event.initiator)] then
                        B_AI[Unit.getTypeName(event.initiator)] = 1
                        TableSave(table.concat({FilePath, saveDataSubfolder, saveNamePrefix, 'KillTracker_B_AI.lua'}), B_AI)
                    else
                        B_AI[Unit.getTypeName(event.initiator)] = B_AI[Unit.getTypeName(event.initiator)] + 1
                        TableSave(table.concat({FilePath, saveDataSubfolder, saveNamePrefix, 'KillTracker_B_AI.lua'}), B_AI)
                    end
                end

            end
        end
    end
end

world.addEventHandler(killTracker)