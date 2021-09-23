local tArgs = {...} --Perimeter side length, layers to mine, whether to mark corners
local layersMined = 0
local bedrockHit = false

function definePerimeter(p) --Marks the corners of the mining area
    for k = 0, 3 do
        turtle.digDown()
        for i = 0, p - 2 do
            if turtle.detect() then
                turtle.dig()
            end
            turtle.forward()
        end
        turtle.turnRight()
    end
end
function mineLayer(p) --Mines a layer of the specified size
    turtle.select(1)
    if suc and data.name == "minecraft:bedrock" then --Checks for bedrock
        bedrockHit = true return
    else
        if turtle.detectDown() then
            turtle.digDown() end
    local suc, data = turtle.inspectDown()

        turtle.down()
    end
    layersMined = layersMined + 1

    for y = 0, p - 1 do --Mines one layer
        for x = 0, p - 2 do --Mines one strip
            suc, data = turtle.inspect()
            if suc and data.name == "minecraft:bedrock" then --Checks for bedrock
                bedrockHit = true return
            else
                if isInvFull() then deposit() end
                if turtle.detect() then
                    turtle.dig() end
                turtle.forward()
            end
        end
        if y ~= p-1 then
            if y % 2 == 0 then turtle.turnRight()
            else turtle.turnLeft() end

            suc, data = turtle.inspect()
            if suc and data.name == "minecraft:bedrock" then --Checks for bedrock
                bedrockHit = true return
            else
                if turtle.detect() then
                    turtle.dig() end
                turtle.forward()
            end

            if y % 2 == 0 then turtle.turnRight()
            else turtle.turnLeft() end
        end
    end
    turtle.turnRight()
    if p % 2 == 1 then turtle.turnRight() end
end
function returnToSurface() --Flies to surface
    for i = 0, layersMined-2 do
        turtle.up()
    end
end
function isInvFull() --Checks inventory status
    if turtle.getItemCount(14) ~= 0 then
        return true
    else
        return false
    end
end
function deposit() --deposits mined ores
    turtle.select(16)

    if turtle.detectUp() then turtle.digUp() end

    turtle.placeUp()
    for i = 1, 14 do
        turtle.select(i)
        turtle.dropUp()
    end
    turtle.select(16)
    turtle.digUp()
    turtle.select(1)
end
function refuel() --Fills turtle from coal chest
    turtle.select(15)

    if turtle.detectUp() then turtle.digUp() end
    
    turtle.placeUp()
    turtle.suckUp()
    turtle.refuel()
    turtle.dropUp()
    turtle.digUp()
    turtle.select(1)
end
function pitStop() --Cleans up turtle inventory and refuels
    deposit()
    refuel()
end

--Main Program

if tArgs[3] == "t" then definePerimeter(tArgs[1]) end
while bedrockHit == false and layersMined < tonumber(tArgs[2]) do 
    if turtle.getFuelLevel() < 5000 then
        refuel()
    end
    mineLayer(tArgs[1])
    deposit()
end
returnToSurface()
term.write("Done! :) dug "..layersMined.." layers of "..tArgs[1].."x"..tArgs[1].." area.")