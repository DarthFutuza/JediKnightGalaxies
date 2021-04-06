--Dice Roller System
--Written by Futuza (2021)
--[[
    Simple dice rolling system.  Currently it only rolls dice locally in a small range (uses /say cmd essentially).  While this could be expanded to work globally, that seems a bit spammy.
    Eventually it'd be a good idea to generalize this for any chat style, by specifying the chat channel to use.  eg: /roll <general/say/team> <dice> <sides>  
]]--


-- [[ General Functions() ]] --
local function SystemReply(ply, message)
	ply:SendChat("^7System: " .. message)
end

local function RollOneDice(ply, sides)
    chatmsg( "^3Dice: ^7" .. ply:GetName() .. "^7 rolls a " .. math.floor(sides) .. "-sided dice: ^3" .. sys.GetRandomInt(1, sides));  --using Q_Irand(), because built in lua random functions suck
    return
end

-- [[ Main Dice Roller ]] --
local function DiceRoller(ply, argc, argv)

	if argc > 3 or argc < 2 then
        SystemReply(ply, "^3Syntax: /roll <# of sides>^7, ^3/roll <# of dice> <# of sides>")
        return
	end

	local diceargs = {}

    for i=1,argc-1 do
        if(tonumber(argv[i])) then
            if(tonumber(argv[i]) > 0 and tonumber(argv[i]) < 32768) then --make sure it can convert to a number, and between 2 and 32767
                table.insert( diceargs, tonumber(argv[i]) )
            else
                SystemReply(ply, "^3Error: Range of sides: 2 - 32767.")
                return
            end	
        else
            SystemReply(ply, "^3Syntax: /roll <# of sides>^7, ^3/roll <# of dice> <# of sides>")
            return
        end
    end

    if tablelength(diceargs) == 1 then --if rolling one die
        RollOneDice(ply, diceargs[1])
        return
    end

    if tablelength(diceargs) == 2 then --if rolling several dice
        local dice = {}
        local sum = 0
        local highest = 0

        if(diceargs[1] > 100) then
            diceargs[1] = 100
            SystemReply(ply, "^3Error: Requested too many dice! Rolling 100 instead.")
        end

        --if it's just 1
        if(diceargs[1] == 1) then
            RollOneDice(ply, diceargs[2])
            return
        end

        chatmsg( "^3Dice: ^7Rolling " .. diceargs[1] .. ", " .. diceargs[2] .. "-sided dice for " .. ply:GetName() .. "^7:");
        for i=1,diceargs[1] do
            table.insert(dice, sys.GetRandomInt(1, diceargs[2]))
            sum = sum + dice[i]
            if(highest < dice[i]) then
                highest = dice[i]
            end

            if(i < 5) then
                chatmsg("^7Roll[" .. tostring(i) ..  "]: ^3" .. dice[i])
            else
                ply:SendPrint("^7Roll[" .. tostring(i) ..  "]: ^3" .. dice[i])
            end
        end

        if(tablelength(dice) > 4) then
            chatmsg("^3Dice: ^7Too many dice.  See console to view more individual dice rolls.")
        end

        chatmsg("^3Dice:^7 Sum: ^3" .. tostring(sum) .. "^7, Avg: ^3" .. tostring( math.floor( (sum / tablelength(dice))*100 )/100 ) .. "^7, High Roll: ^3" .. tostring(highest) .. "^7.") -- math.floor(x*100)/100
        return
    end

    SystemReply(ply, "^3Syntax: /roll <# of sides>^7, ^3/roll <# of dice> <# of sides>")
    return
end


--add to cmd table
cmds.Add("roll", DiceRoller)
chatcmds.Add("roll", DiceRoller)