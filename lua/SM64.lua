-- Edit this to make cool stuffs

memory.usememorydomain("RDRAM"); -- set this to "RDRAM" for N64 games

-- Initialize variables -- Do not use these variable names:
--frame
--command
--text
--textTime
count = 0;
groupATime = 0
odd = false;
cannonTime = 0;
cannonCam = false; 
name = "";
buttonTime = 0;
buttonTimeButton = "";
waluigi = false;

-- This function fires once for every command received
function main(commandId, username)
	if username == nil then
		username = "unknown";
	end
	--value = 10;
	console.writeline("Button " .. commandId .. " pressed by " .. username);
	name = username;
	if commandId == 1 or commandId == '1' then
		--Turn to Mario
		mario();
		reload();
		display("Mario");
	elseif commandId == '2' then
		--Turn to Luigi
		mario();
		memory.write_s16_be(0x2535C2, 0x3F89);
		memory.write_s16_be(0x2535BE, 0x3F40);
		memory.write_s16_be(0x7EC38, 0x7F);
		memory.write_s16_be(0x7EC40, 0xFF);
		reload();
		jump = 1.015;
		gravity = .95;
		console.writeline('2')
		display("Luigi");
	elseif commandId == "3" then
		--Turn to Wario
		mario();
		memory.write_s16_be(0x2535BE, 0x4000);
		memory.write_s16_be(0x2535CA, 0x4020);
		memory.write_s16_be(0x7EC40, 0xFFFF);
		memory.write_s16_be(0x7EC38, 0x5050);
		memory.write_s16_be(0x7EC20, 0x9900);
		memory.write_s16_be(0x7EC28, 0x3000);
		memory.write_s16_be(0x7EC2A, 0x9930);
		reload();
		jump = .985;
		gravity = 1.1;
		display("Wario")
		console.writeline('3');
	elseif commandId == "4" then
		--Turn to Waluigi
		sendNotReady('A');
		groupATime = 3600;
		mario();
		memory.write_s16_be(0x2535C2, 0x4000);
		memory.write_s16_be(0x2535BE, 0x3F80);
		memory.write_s16_be(0x7EC40, 0x800F);
		memory.write_s16_be(0x7EC38, 0x800F);
		memory.write_s16_be(0x7EC3A, 0xBB00);
		memory.write_s16_be(0x7EC20, 0x0);
		memory.write_s16_be(0x7EC22, 0x0);
		memory.write_s16_be(0x7EC28, 0x0);
		memory.write_s16_be(0x7EC2A, 0x0);
		reload();
		waluigi = true;
		display("Waluigi")
	elseif commandId == "5" then
		--Turn to Sonic
		mario();
		memory.write_s16_be(0x7EC40, 0x0);
		memory.write_s16_be(0x7EC42, 0x0);
		memory.write_s16_be(0x7EC38, 0x0);
		memory.write_s16_be(0x7EC3A, 0xDDDD);
		memory.write_s16_be(0x7EC20, 0x0);
		memory.write_s16_be(0x7EC22, 0xDDDD);
		memory.write_s16_be(0x7EC28, 0x0);
		memory.write_s16_be(0x7EC2A, 0x0);
		reload();

		acceleration = 0xBFFF;
		maxSpeed = 0x44A0;
		
		display("Sonic")
	elseif commandId == "6" then
		--Turn to neon
		sendNotReady('A');
		groupATime = 3600;
		mario();
		memory.write_s16_be(0x7EC40, 0xA5);
		memory.write_s16_be(0x7EC42, 0xBB00);
		memory.write_s16_be(0x7EC38, 0xA5);
		memory.write_s16_be(0x7EC3A, 0xBB00);
		memory.write_s16_be(0x7EC20, 0xA5);
		memory.write_s16_be(0x7EC22, 0x0);
		memory.write_s16_be(0x7EC28, 0xA5);
		memory.write_s16_be(0x7EC2A, 0x0);
		reload();
		jump = ((math.random() - .5) / 4) + 1
		gravity = ((math.random() - .5) / 4) + 1
		--print("Jump: " .. jump)
		--print("Gravity: " .. gravity)
		acceleration = math.random(1,0x5000);
		maxSpeed = math.random(1,0x5000);
		display("Neon")
	elseif commandId == "7" then
		--Toggle vanish cap
		--sendReady('A');
		if memory.read_s16_be(0x33B176) == 0x12 then
			memory.write_s16_be(0x33B176, 0x10);
		else
			memory.write_s16_be(0x33B176, 0x12);
		end
		display("vanish")
	elseif commandId == "8" then
		--Toggle metal cap
		if memory.read_s16_be(0x33B176) == 0x15 then
			memory.write_s16_be(0x33B176, 0x10);
		else
			memory.write_s16_be(0x33B176, 0x15);
		end
		display("metal")
	elseif commandId == "9" then
		--Toggle wing  cap
		if memory.read_s16_be(0x33B176) == 0x18 then
			memory.write_s16_be(0x33B176, 0x10);
		else
			memory.write_s16_be(0x33B176, 0x18);
		end
		display("wing")
	elseif commandId == "10" then
		--Toggle random cap
		local cap = math.random(1, 142);
		memory.write_s16_be(0x33B176, cap);
		display("random cap")
	elseif commandId == "11" then
		--Take X amount of health
		memory.writebyte(0x33B21E, memory.readbyte(0x33B21E) - 1);
		--print("oof")
		display("oof")
	elseif commandId == "12" then
		--Add speed
		memory.write_s32_be(0x33B17C, 0x4000440);
		memory.writefloat(0x33B1C4, memory.readfloat(0x33B1C4, true) + (100), true)
		display("speed+")
	elseif commandId == "13" then
		--Remove speed
		memory.write_s32_be(0x33B17C, 0x4000440);
		memory.writefloat(0x33B1C4, memory.readfloat(0x33B1C4, true) - (100), true)
		display("speed-")
	elseif commandId == "14" then
		--Teleport upwards
		memory.write_s32_be(0x33B17C, 0x3000880);
		memory.writefloat(0x33B1B0, memory.readfloat(0x33B1B0, true) + (500) + 20, true)
		--print("upwards")
		display("upwards")
	elseif commandId == "15" then
		--Cannon for X seconds
		if cannonTime < 0 then
			cannonTime = 0
		end
		cannonCam = true
		cannonTime = cannonTime + 10;
		text = username .. " added 10 seconds to CannonCamTM"
		textTime = 200
	elseif commandId == "16" then
		--Press A
		text = name .. " pressed A";
		textTime = 200
		press("P1 A");
	elseif commandId == "17" then
		--Press B
		text = name .. " pressed B";
		textTime = 200
		press("P1 B");
	elseif commandId == "18" then
		--Press Z
		text = name .. " pressed Z";
		textTime = 500
		press("P1 Z");
	end
end

-- This function runs every frame
function process()
	--Stuff
	if buttonTime >= 0 then
		buttons = joypad.get();
		buttons[buttonTimeButton] = true
		joypad.set(buttons);
		buttonTime = buttonTime - 1;
	end
	
	updateCannonCam();
	updatePhysics();
	updateWaluigi();
	
	if groupATime >= 0 then
		groupATime = groupATime - 1;
		gui.drawText(0,10, "Character cooldown: " .. math.ceil(groupATime/60), nil, nil, 12*(client.bufferwidth()/400));
	end
	if groupATime == 0 then
		waluigi = false;
		mario();
		reload();
		sendReady('A');
		console.writeline("Character's available");
	end
end

--Sets all values of Mario to default
function mario()
	memory.write_s16_be(0x2535CA, 0x3F80);
	memory.write_s16_be(0x2535C2, 0x3F80);
	memory.write_s16_be(0x2535BE, 0x3F80);
	memory.write_s16_be(0x7EC40, 0xFF00);
	memory.write_s16_be(0x7EC42, 0x0);
	memory.write_s16_be(0x7EC38, 0x7F00);
	memory.write_s16_be(0x7EC3A, 0x0);
	memory.write_s16_be(0x7EC20, 0x0);
	memory.write_s16_be(0x7EC22, 0x7F00);
	memory.write_s16_be(0x7EC28, 0x0);
	memory.write_s16_be(0x7EC2A, 0xFF00);
	--Physics
	acceleration = 0x3F80;
	maxSpeed = 0x4240;
	jump = 1;
	gravity = 1;
	--waluigi = false;
end

-- Saves and loads a save state to update render
function reload()
	local save = memorysavestate.savecorestate();
	memorysavestate.loadcorestate(save);
end

-- Enable cannonCam™ if enabled
function updateCannonCam()
	if cannonCam == true and cannonTime > 0 then
		cannonTime = cannonTime - (1/60)
		memory.writebyte(0x33C6D4, 0xA);
		gui.drawText(client.bufferwidth()/2,25, "Cannon time remaining: " .. math.ceil(cannonTime), nil, nil, 12*(client.bufferwidth()/400), nil, nil, 'center');
	elseif cannonCam == true and memory.readbyte(0x33C6D4) == 0xA then
		memory.writebyte(0x33C6D4, 0x10);
	else
		cannonCam = false
	end
end

-- Invert Waluigi's controls if enabled
function updateWaluigi()
	--console.writeline(waluigi);
	if waluigi then
		if odd then
			odd = false
			buttons = joypad.get();
			if buttons["P1 A Up"] == true then
				buttons["P1 A Up"] = false
				buttons["P1 A Down"] = true
			elseif buttons["P1 A Down"] == true then
				buttons["P1 A Down"] = false
				buttons["P1 A Up"] = true
			end
			if buttons["P1 A Left"] == true then
				buttons["P1 A Left"] = false
				buttons["P1 A Right"] = true
			elseif buttons["P1 A Right"] == true then
				buttons["P1 A Right"] = false
				buttons["P1 A Left"] = true
			end
			if buttons["P1 A"] == true then
				buttons["P1 A"] = false
				buttons["P1 B"] = true
			elseif buttons["P1 B"] == true then
				buttons["P1 B"] = false
				buttons["P1 A"] = true
			end
			if buttons["P1 R"] == true then
				buttons["P1 R"] = false
				buttons["P1 Z"] = true
			elseif buttons["P1 Z"] == true then
				buttons["P1 Z"] = false
				buttons["P1 R"] = true
			end
			joypad.set(buttons);
		else
			odd = true
		end
	end
end

-- Update physics if they are different
function updatePhysics()
	if memory.readfloat(0x33B1BC, true) > 0 then
		memory.writefloat(0x33B1BC, memory.readfloat(0x33B1BC, true) * jump, true);
	elseif memory.readfloat(0x33B1BC, true) < 0 then
		memory.writefloat(0x33B1BC, memory.readfloat(0x33B1BC, true) * gravity, true);
	end
	memory.write_s16_be(0x2653B6, acceleration);
	memory.write_s16_be(0x2653CE, maxSpeed);
end

mario();
reload();

function display(str)
	text = name .. " used " .. str;
	textTime = 200
end

-- Presses a button
function press(button)
	buttons = joypad.get();
	buttons[button] = true
	joypad.set(buttons);
	buttonTime = 10;
	buttonTimeButton = button;
end









-- Don't edit below here unless you know what you are doing

-- Init
frame = 0;
command = nil;
text = '';
textTime = 0;

-- Connect to broadcaster client
console.writeline("Connecting...");
comm.socketServerSetTimeout(0);
comm.socketServerSend("Wake up!");
comm.socketServerResponse();

-- Tell broadcaster client to start accepting commands from extension
function sendReady(groupId)
	if groupId == nil then
		groupId = '';
	end
	comm.socketServerSend('luaReady' .. groupId);
end

-- Ping to keep connection to the client alive
function ping()
	comm.socketServerSend('ping');
end

function sendNotReady(groupId)
	comm.socketServerSend('luaNotReady' .. groupId);
end

function splitString(str)
	lines = {}
	for s in str:gmatch("[^\n]+") do
		table.insert(lines, s)
	end
	return lines;
end

function splitCommand(str)
	lines = {}
	for s in str:gmatch("[^\r]+") do
		table.insert(lines, s)
	end
	return lines;
end

sendReady();

-- Main loop
while true do
	if frame > 10 then
		ping();
		command = splitString(comm.socketServerResponse());
		frame = 0;
	end
	
	frame = frame + 1;
	
	if command ~= nil and command ~= "" then
		if command ~= nil and #command == 0 then
			command = nil
		else
			for i = 1, #command do
				
				--console.writeline("command: " .. command[i]);
				local payload = splitCommand(command[i]);
				
				local commandId = payload[1];
				local commandSender = payload[2];
			
				-- Run the command
				main(commandId, commandSender);
				
				-- Delete the command
				command[i] = nil;
			end
		end
	end
	
	-- Display messages if any
	if textTime > 0 then
		textTime = textTime - 1;
		gui.drawText(client.bufferwidth()/2, client.bufferheight()/4, text, nil, nil, 12*(client.bufferwidth()/400), nil, nil, 'center', 'middle');
	end
	
	process();

	-- Next frame
	emu.frameadvance();
end