-- Config
-- see if the file exists
function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
function lines_from(file)
  if not file_exists(file) then return {} end
  lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end

local file = 'LuaConfig.txt'
local lines = lines_from(file)

-- Make array one string
auth = lines[1] .. "\n" .. lines[2];

-- Init
memory.usememorydomain("RDRAM");

command = 0;
lastSignature = 0;
signature = 0;

--ip = 'http://127.0.0.1:8081/lua/complete';
ip = "https://streamplusbizhawk-ebs.herokuapp.com";

console.writeline("\nStarting...");

count = 0;
textTime = 0;
time = 0
odd = false;
cannonTime = 0;
cannonCam = false;

function splitString(str)
	lines = {}
	for s in str:gmatch("[^\r\n]+") do
		table.insert(lines, s)
	end
	return lines;
end

-- Send to say that this script is ready for the next command
function sendReady()
	comm.httpPost(ip .. '/lua/complete', auth);
end

function getCommand()
	return splitString(comm.httpPost(ip .. '/lua/request', auth));
end

function display(str)
	text = username .. " used " .. str;
	textTime = 500
end

--mario();
--reload();

frame = 0
sendReady();

-- Loop
while true do
	if frame > 30 then
		frame = 0;
		-- Get command from EBS
		request = getCommand();
		
		command = request[1] or 0;
		signature = request[3] or 0;
		
		-- Check to see if command has changed
		if lastSignature ~= signature then
			console.writeline("Command: " .. command);
			console.writeline("Signature: " .. signature .. "\n");
			lastSignature = signature
			
			-- Run command 
			--executeCommand(command, value);
			
			sendReady();
		end
		
		-- Update things that must be done every frame
		--[[updateText();
		updatePhysics();
		updateWaluigi();
		updateCannonCam();]]--
	end
	
	frame = frame + 1;
	
	-- nExT fRaME
	emu.frameadvance();
end

function executeCommand(command, value)
	if command == "mario" then
		--Turn to Mario
		mario();
		reload();
		display("Mario");
	elseif command == "luigi" then
		--Turn to Luigi
		mario();
		memory.write_s16_be(0x2535C2, 0x3F89);
		memory.write_s16_be(0x2535BE, 0x3F40);
		memory.write_s16_be(0x7EC38, 0x7F);
		memory.write_s16_be(0x7EC40, 0xFF);
		reload();
		jump = 1.015;
		gravity = .95;
		display("Luigi");
	elseif command == "wario" then
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
	elseif command == "waluigi" then
		--Turn to Waluigi
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
	elseif command == "sonic" then
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
	elseif command == "neon" then
		--Turn to neon
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
		print("Jump: " .. jump)
		print("Gravity: " .. gravity)
		acceleration = math.random(1,0x5000);
		maxSpeed = math.random(1,0x5000);
		display("Neon")
	elseif command == "vanish" then
		--Toggle vanish cap
		if memory.read_s16_be(0x33B176) == 0x12 then
			memory.write_s16_be(0x33B176, 0x10);
		else
			memory.write_s16_be(0x33B176, 0x12);
		end
		display("vanish")
	elseif command == "metal" then
		--Toggle metal cap
		if memory.read_s16_be(0x33B176) == 0x15 then
			memory.write_s16_be(0x33B176, 0x10);
		else
			memory.write_s16_be(0x33B176, 0x15);
		end
		display("metal")
	elseif command == "wing" then
		--Toggle wing  cap
		if memory.read_s16_be(0x33B176) == 0x18 then
			memory.write_s16_be(0x33B176, 0x10);
		else
			memory.write_s16_be(0x33B176, 0x18);
		end
		display("wing")
	elseif command == "cap" then
		--Toggle random cap
		local cap = math.random(1, 142);
		memory.write_s16_be(0x33B176, cap);
		display("random cap")
	elseif command == "oof" then
		--Take X amount of health
		memory.writebyte(0x33B21E, memory.readbyte(0x33B21E) - value);
		print("oof")
		text = username .. " took " .. value .. " health"
		textTime = 500
	elseif command == "speed+" then
		--Add speed
		memory.write_s32_be(0x33B17C, 0x4000440);
		memory.writefloat(0x33B1C4, memory.readfloat(0x33B1C4, true) + (value*10), true)
		text = username .. " added " .. value .. " positive speed"
		textTime = 500
	elseif command == "speed-" then
		--Remove speed
		memory.write_s32_be(0x33B17C, 0x4000440);
		memory.writefloat(0x33B1C4, memory.readfloat(0x33B1C4, true) - (value*10), true)
		text = username .. " added " .. value .. " negative speed"
		textTime = 500
	elseif command == "upward" then
		--Teleport upwards
		memory.write_s32_be(0x33B17C, 0x3000880);
		memory.writefloat(0x33B1B0, memory.readfloat(0x33B1B0, true) + (value*50) + 20, true)
		print("upwards")
		text = username .. " upwards " .. value
		textTime = 500
	elseif command == "cannonCam" then
		--Cannon for X seconds
		if cannonTime < 0 then
			cannonTime = 0
		end
		cannonCam = true
		cannonTime = cannonTime + value;
		text = username .. " added " .. value .. " seconds to CannonCamTM"
		textTime = 500
	end
end

-- Display text if their is a message
function updateText()
	count = count + 1;
	textTime = textTime - 1;
	if textTime > 0 then
		gui.drawText(client.bufferwidth()/2, client.bufferheight()/4, text, nil, nil, (client.bufferwidth()*client.bufferheight())/50000, nil, nil, 'center', 'middle');
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

-- Invert Waluigi's controls if enabled
function updateWaluigi()
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

-- Enable cannonCam™ if enabled
function updateCannonCam()
	if cannonCam == true and cannonTime > 0 then
		cannonTime = cannonTime - (1/60)
		memory.writebyte(0x33C6D4, 0xA);
		gui.drawText(0,0, "Cannon time remaining: " .. math.ceil(cannonTime), nil, nil, 25);
	elseif cannonCam == true and memory.readbyte(0x33C6D4) == 0xA then
		memory.writebyte(0x33C6D4, 0x10);
	else
		cannonCam = false
	end
end

--Saves and loads a save state to update render
function reload()
	local save = memorysavestate.savecorestate();
	memorysavestate.loadcorestate(save);
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
	waluigi = false;
end