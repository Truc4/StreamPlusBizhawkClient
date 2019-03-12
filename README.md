# StreamPlusBizhawk Client

# Usage

This program is used for communication between the StreamPlusBizhawk extension and the Bizhawk emulator.
Designed to work with special lua scripts that are easy to customize and create for many games on the Bizhawk Emulator.

To use the client:
- Set up the emulator and config (read Setup)
- Run the StreamPlusBizhawkClient Program (StreamPlusBizhawkClient Windows.exe on windows)
- Open Bizhawk emulator
- Run lua script in the Lua Console in Bizhawk
- Done

# Setup

The StreamPlusBizhawkClient comes in two parts the application and the lua scripts. 
Read below to properly set them up.

## StreamPlusBizhawk Client Application

For the client to connect to the server you will need to set up the config.json file

### Config

In the config.json file you will see channel and token. The channel and token are listen on the extensions configuration page. 
Copy and paste them into the proper spots in the config.json file

## Bizhawk

In order for the scripts to work you need to set up a Bizhawk emulator shortcut with the parameters for connected to the application.
Make a shortcut for Bizhawk, right click it and select "properties", then paste this to the end of the target box: ` --socket_ip=127.0.0.1 --socket_port=8081`
Whenever you want to use the StreamPlusBizhawk Client the emulator must be launched with this shortcut.

### Lua scripts

In the lua folder you will see various lua scripts one for each corresponding game.
The scripts must be loaded in the Bizhawk emulator after the StreamPlusBizhawk Client Application is running.
To load a script open Bizhawk and go to ( Tools > Lua Console ) this will open the console, then open to ( Script > Open Script... )
and navigate to where you installed StreamPlusBizhawk Client and load the .lua script for the game you are playing.

### Creating Lua scripts for games

You may notice the Template.lua file, if you want to make a .lua file for a new game or want to make your own commands you can by modifing this file.

