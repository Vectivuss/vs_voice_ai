
## Vectivus´s Voice AI
Created as an extension to the existing sound library this will allow you to convert text to speech using voices of your choosing. The system is powered by a thirdparty [elevenlabs](https://elevenlabs.io). How this works is in the config serverside you're able to create voices by using a 'voice_id" and with that you can then generate the text of your choosing. You can then play these sounds on the client(s)

## How to create text to speech?
```lua
sound.CreateVoice( filename, voice_id, text )
```

## How to use sound?
```lua
sound.PlayVoiceSound( player, sound ) -- serverside
sound.PlayVoiceSound( name ) -- clientside
```

## Requirements
- A Garry's Mod server
- [Elevenlabs](https://elevenlabs.io) free account, To create OWN voices you require their cheapest subscription

## Installation
- Place `vs_voice_ai` within your servers `garrysmod/addons`.
  
