# K_Lib

A Library of common functions i use in most of my resources. Also covers network scenes and scaleforms.

## Description

This project is ever expanding so please bear with me.

## Getting Started

### Dependencies

* Completely Standalone

### Installing

* stick it in your resources folder
* ensure k_lib in your server.cfg

### Executing program

There are 2 different ways to use k_lib in your server.
You can either find the export you need in the list below and call it using exports.k_lib:ExportName(params).
Or you can just use the export to grab the entire lib, `k_lib = exports.k_lib:GetLib()` ,and use k_lib.ExportName(params).

**Client Exports**
```
    exports.k_lib:DisplayInstructionalButtons(buttons)

    exports.k_lib:SetupScaleform(scaleform, buttons) -- not needed if first export is used (number, table)

    exports.k_lib:StartHackScene(model, usbOffset) -- plays usb hacking scene (string {x,y,z})

    exports.k_lib:StartDrillingScene(drillType, pins) -- plays drilling scene and minigame (string, int)

    exports.k_lib:HackingLaptop(background, password, speedTable, duration, lives, speed, hackConnect_bypass, bruteForce_bypass) -- plays Hacking Minigame (int sets desktop background, string 8 letter passcode for bruteforce, table see config for example, table {minutes, seconds, milliseconds}, int amount of failed attempts, int speed of ipHack, bool bypass ipHack, bool bypass rouletteHack)

    exports.k_lib:Drilling(drillType, discs) -- just plays drilling minigame (string, int)
```

**Server Exports**
```
    exports.k_lib:WriteData(fileName, fileData) -- overwrites data on the file (string, table)

    exports.k_lib:GetData(file) -- gets the current cached data for that file (string)
```

**Button Setup**
```
local buttons = {
    {type = "CLEAR_ALL"},
    {type = "SET_CLEAR_SPACE", int = 600},
    {type = "SET_DATA_SLOT", name = 'Reduce Pressure', keyIndex = {
        [173] = {
            action = function(data)
                print(data)
            end,
            args = 'Hello World'
        }
    }, int = 0},
    {type = "SET_DATA_SLOT", name = 'Add Pressure', keyIndex = {[172] = {}}, int = 1},
    {type = "SET_DATA_SLOT", name = 'Add/Reduce Speed/Size', keyIndex = {[175] = {}, [174] = {}}, int = 2}
    {type = "DRAW_INSTRUCTIONAL_BUTTONS"},
    {type = "SET_BACKGROUND_COLOUR"},
}

exports.k_lib:DisplayInstructionalButtons(buttons)
```

**Disclaimer**
Some of the features are not fully functional or implimented yet. There is a lot here. Any of the bits with documentation are supported