
vsAI = vsAI or {}
VectivusLib = VectivusLib or {}

function VectivusLib.NicePrint( txt )
	if SERVER then
		MsgC("\n", Color(0, 255, 255), txt .. "\n")
	else
		MsgC("\n", Color(255, 102, 0), txt .. "\n")
	end
end

local function PreLoadFile(path)
	if CLIENT then
		include(path)
	else
		AddCSLuaFile(path)
		include(path)
	end
end

local function LoadFile( path, name )
    path = path or ""
    local _typ = string.lower( string.Left( name, 3 ) )
    local s = path..name
    if SERVER and _typ == "sv_" then
        include(s)
    elseif _typ == "sh_" then
        if SERVER then timer.Simple(0,function() AddCSLuaFile(s) end) end
        include(s)
    elseif _typ == "cl_" then
        if SERVER then
            timer.Simple(0,function() AddCSLuaFile(s) end)
        else
            timer.Simple(0,function() include(s) end)
        end
    end
end

local function LoadDirectory( dir )
    dir = dir .. "/"
    local files, directory = file.Find( dir.."*", "LUA" )
    for _, v in ipairs( files ) do
        if string.EndsWith( v, ".lua" ) then
            LoadFile( dir, v )
        end
    end
	for _, dirs in ipairs( directory ) do
		LoadDirectory( dir..dirs )
	end
end

local function Initialize()
    LoadDirectory("vs_voice_ai")
	VectivusLib.NicePrint("Vectivus Voice AI loaded!")
end

Initialize()
