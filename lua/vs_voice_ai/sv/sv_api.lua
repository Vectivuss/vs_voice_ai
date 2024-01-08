
function sound.CreateVoice( name, voice_id, text )
    if !vsAI.api or vsAI.api == "" then error("Missing voice API, Make sure to add it to config!") return end
    if !name or !voice_id or !text then return end
    if hook.Run( "vsAI.CanCreateVoice", name, voice_id, text ) == false then return end

    local path = "cached_audio/"
    file.CreateDir(path)

    local headers = {
        ["xi-api-key"] = vsAI.api,
        ["Content-Type"] = "application/json",
    }
    local body = {
        model_id = "eleven_multilingual_v2", -- can be expensive, on networking AND filesize
        text = text,
        voice_settings = {
            similarity_boost = 1,
            stability = 1,
        }
    }

    local tbl = { -- thirdparty website we're using
        url = "https://api.elevenlabs.io/v1/text-to-speech/"..voice_id.."/stream?optimize_streaming_latency=1",
        method = "POST",
        type = "application/json",
        headers = headers,
        body = util.TableToJSON(body),
        success = function(code,b)
            if code == 200 then
                file.Write(path..name..".dat",b)
                hook.Run( "vsAI.CreatedVoice", name, voice_id, text )
                VectivusLib.NicePrint( "Voice: "..name.." Created!" )
            end
        end,
    }

    HTTP(tbl)
end
hook.Add( "vsAI.CanCreateVoice", "a", function( name, voice_id, text )
    local path = "cached_audio/"
    do // already exists
        if file.Exists(path..name..".dat","DATA") then return false end
    end
end )
