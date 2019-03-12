-- Edit this to make cool stuffs

memory.usememorydomain("RDRAM"); -- set this to "RDRAM" for N64 games

-- Initialize variables -- Do use these variable names:
--frame
--command
--text
--textTime 

-- This function fires once for every command received
function main(commandId, username)
	console.writeline("Button " .. commandId .. " pressed by " .. username);
	if commandId == '1' then
		-- If button 1 from extension is pressed
		
		-- Edit memory domain example
		--memory.write_s16_be(0x2535CA, 0x3F80); -- This writes 0x3F80 to the signed 16 bit ram value 0x2535CA
		
		-- Display message to emulator
		display(username .. " pressed button " .. commandId, 500);
		
	elseif commandId == '2' then
		-- If button 2 is pressed
	elseif commandId == '3' then
		-- etc...
	end
end

-- Displays message in emulator
function display(str, displayTime)
	text = str;
	textTime = displayTime
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
function sendReady()
	comm.socketServerSend('luaReady');
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
		command = splitString(comm.socketServerResponse());
		frame = 0;
	end
	
	frame = frame + 1;
	
	if command ~= nil and command ~= "" then
		if command ~= nil and #command == 0 then
			command = nil
		else
			for i = 1, #command do
				
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
		gui.drawText(client.bufferwidth()/2, client.bufferheight()/4, text, nil, nil, (client.bufferwidth()*client.bufferheight())/50000, nil, nil, 'center', 'middle');
	end

	-- Next frame
	emu.frameadvance();
end