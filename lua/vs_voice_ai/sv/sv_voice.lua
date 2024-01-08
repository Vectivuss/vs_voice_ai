
util.AddNetworkString( "vsAI:TransmitSound" )
local function SplitSoundData(p, name, data)
    local words = string.Explode( "", data )
    local lines = {}
    local lineIndex = 1
    for _, v in pairs(words) do
        lines[lineIndex]=lines[lineIndex] or ""
        lines[lineIndex]=lines[lineIndex]..v
        if string.len(lines[lineIndex])>45000 then
            lineIndex=lineIndex+1
        end
    end

    for i=1, lineIndex do
        net.Start("vsAI:TransmitSound")
            net.WriteString( name )
            net.WriteInt( i, 12 )
            net.WriteInt( #lines[i], 32 )
            net.WriteData( lines[i], #lines[i] )
            net.WriteInt(lineIndex,12)
        net.Send(p)
    end
end

local function TransmitSound( p, sound )
    if !IsValid(p) then return end
    local f = file.Open( "cached_audio/"..sound..".dat", "rb", "DATA" )
    if !f then return end
    local str = f:Read( f:Size() )
    SplitSoundData(p, sound, str)
end
concommand.Add( "vsAI.RequestSound", function( p, _, t )
    local name = tostring(t[1] or "")
    if p._voiceCache[name] then return end
    p._voiceCache[name] = true
    TransmitSound( p, name )
end )

util.AddNetworkString( "vsAI:PlaySound" ) 
function sound.PlayVoiceSound( p, sound )
    if !IsValid(p) or !sound then return end
    net.Start("vsAI:PlaySound")
        net.WriteString(sound)
    net.Send(p)
end
