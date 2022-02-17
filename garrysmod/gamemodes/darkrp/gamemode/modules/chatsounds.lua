-- This module will make voice sounds play when certain words are typed in the chat
-- You can add/remove sounds as you wish using DarkRP.setChatSound, just follow the format used here
-- To disable them completely, set GM.Config.chatsounds to false
-- TODO: Add female sounds & detect gender of model, and use combine sounds for CPs

local sounds = {}
-- АфоняТВ
sounds["ахуели"]            = { "up_bw/afonya/ahueli.mp3" }
sounds["дермище"]           = { "up_bw/afonya/dermishe.mp3" }
sounds["пиздец"]            = { "up_bw/afonya/polniy_pizdec.mp3" }
sounds["слив"]              = { "up_bw/afonya/sliv.mp3" }
sounds["говно"]             = { "up_bw/afonya/tfu_govno.mp3" }
    
-- Big Russian Boss 
sounds["точно"]             = { "up_bw/brb/eto_tochno.mp3" }
sounds["иди отсюда"]        = { "up_bw/brb/idi_otsuda.mp3" }
sounds["причепиздил"]       = { "up_bw/brb/prichepizdil.mp3" }
sounds["смешно"]            = { "up_bw/brb/smeshno.mp3" }
sounds["привет"]            = { "up_bw/brb/zdorova.mp3" }

-- Эрик Давыдыч
sounds["сучка"]             = { "up_bw/dovidich/suchka_bolnaya.mp3" }

-- Ларин
sounds["нихуя"]             = { "up_bw/larin/ni_hu_ya.mp3" }
sounds["ты что"]            = { "up_bw/larin/ti_chto_mraz.mp3" }

-- Литвинков
sounds["бесит"]             = { "up_bw/litvinkov/besit.mp3" }
sounds["вкусный чай"]       = { "up_bw/litvinkov/vkushniy_chat.mp3" }

-- Шурыгина
sounds["что плохого"]       = { "up_bw/shurigina/a_chto_v_etom_plohogo.mp3" }
sounds["на донышке"]        = { "up_bw/shurigina/na_donishke.mp3" }
sounds["всмысле"]           = { "up_bw/shurigina/v_smisle_srazu.mp3" }

-- Остальное
sounds["ахуено"]            = { "up_bw/ahuenno.mp3" }
sounds["аккуратнее"]        = { "up_bw/akkuratnee.mp3" }
sounds["чем пахнет"]        = { "up_bw/chem_pahnet.mp3" }
sounds["пиздит"]            = { "up_bw/chto_pizdit.mp3" }
sounds["давалка"]           = { "up_bw/davalka.mp3" }
sounds["наепсики"]          = { "up_bw/naepsiki.mp3" }
sounds["не пушистик"]       = { "up_bw/ne_pushistik.mp3" }
sounds["похуй"]             = { "up_bw/pohuy.mp3" }
sounds["я не знаю"]         = { "up_bw/ya_ne_znau.mp3" }

DarkRP.hookStub{
    name = "canChatSound",
    description = "Whether a chat sound can be played.",
    parameters = {
        {
            name = "ply",
            description = "The player who triggered the chat sound.",
            type = "Player"
        },
        {
            name = "chatPhrase",
            description = "The chat sound phrase that has been detected.",
            type = "string"
        },
        {
            name = "chatText",
            description = "The whole chat text the player sent that contains the chat sound phrase.",
            type = "string"
        }
    },
    returns = {
        {
            name = "canChatSound",
            description = "False if the chat sound should not be played.",
            type = "boolean"
        }
    }
}

DarkRP.hookStub{
    name = "onChatSound",
    description = "When a chat sound is played.",
    parameters = {
        {
            name = "ply",
            description = "The player who triggered the chat sound.",
            type = "Player"
        },
        {
            name = "chatPhrase",
            description = "The chat sound phrase that was detected.",
            type = "string"
        },
        {
            name = "chatText",
            description = "The whole chat text the player sent that contains the chat sound phrase.",
            type = "string"
        }
    },
    returns = {
    }
}

local function CheckChat(ply, text)
    if ply.nextSpeechSound and ply.nextSpeechSound > CurTime() then return end
    local prefix = string.sub(text, 0, 1)
    if prefix == "/" or prefix == "!" or prefix == "@" then return end -- should cover most chat commands for various mods/addons
    for k, v in pairs(sounds) do
        local res1, res2 = string.find(string.lower(text), k)
        if res1 and (not text[res1 - 1] or text[res1 - 1] == "" or text[res1 - 1] == " ") and (not text[res2 + 1] or text[res2 + 1] == "" or text[res2 + 1] == " ") then
            local canChatSound = hook.Call("canChatSound", nil, ply, k, text)
            if canChatSound == false then return end
            ply:EmitSound(table.Random(v), 80, 100)
            ply.nextSpeechSound = CurTime() + GAMEMODE.Config.chatsoundsdelay -- make sure they don't spam HAX HAX HAX, if the server owner so desires
            hook.Call("onChatSound", nil, ply, k, text)
            break
        end
    end
end
hook.Add("PostPlayerSay", "ChatSounds", CheckChat)

DarkRP.getChatSound = DarkRP.stub{
    name = "getChatSound",
    description = "Get a chat sound (play a noise when someone says something) associated with the given phrase.",
    parameters = {
        {
            name = "text",
            description = "The text that triggers the chat sound.",
            type = "string",
            optional = false
        }
    },
    returns = {
        {
            name = "soundPaths",
            description = "A table of string sound paths associated with the given text.",
            type = "table"
        }
    },
    metatable = DarkRP
}

function DarkRP.getChatSound(text)
    return sounds[string.lower(text or "")]
end

DarkRP.setChatSound = DarkRP.stub{
    name = "setChatSound",
    description = "Set a chat sound (play a noise when someone says something)",
    parameters = {
        {
            name = "text",
            description = "The text that should trigger the sound.",
            type = "string",
            optional = false
        },
        {
            name = "sounds",
            description = "A table of string sound paths.",
            type = "table",
            optional = false
        }
    },
    returns = {
    },
    metatable = DarkRP
}

function DarkRP.setChatSound(text, sndTable)
    sounds[string.lower(text or "")] = sndTable
end

concommand.Add("chat_sounds", function(ply)
    for k,v in pairs(sounds) do
        print(k)
    end
end)
