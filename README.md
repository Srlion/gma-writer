# GMAWriter Library

## Usage

```lua
local b = GMAWriter:new("MyAddonName", 76561198261855442) -- Initialize with addon name and SteamID

b:file("lua/init.lua", "print('Hello world!')")          -- Add a file with its content
b:file("materials/icon.vtf", "icony")               -- Add another file

b:write_to("myaddon.gma")
```
