
local dir = "cached_audio/"
local sounds = {}
net.Receive( "vsAI:TransmitSound", function()
    local name, id, chunk_size = net.ReadString(), net.ReadInt(12), net.ReadInt(32)
    local data = net.ReadData(chunk_size)
    local total = net.ReadInt(12)
    sounds[name] = sounds[name] or ""
    sounds[name] = sounds[name] .. data
    if id == total then
        file.CreateDir(dir)
        file.Write(dir..name..".dat",sounds[name])
        sounds[name] = nil
        hook.Run( "vsAI:TransmitSoundCompleted", name, sounds[name] )
        VectivusLib.NicePrint( "Downloaded: "..name )
    end
end )

net.Receive( "vsAI:PlaySound", function()
    sound.PlayVoiceSound( net.ReadString() )
end )

function sound.PlayVoiceSound( name )
    local dir = "data/cached_audio/"
    sound.PlayFile( dir..name..".dat", "noplay", function( sound )
        if IsValid(sound) then
            sound:SetVolume(3)
            sound:Play()
        else
            RunConsoleCommand( "vsAI.RequestSound", name )
        end
    end )
end

hook.Add( "vsAI:TransmitSoundCompleted", "cached_loaded", function(name)
    sound.PlayVoiceSound(name)
end )

