// Thank you for purchasing gTerminal 1.0 by ng-vrondakis!
// If you like this addon, please consider leaving a review. It REALLY helps my sales
// If you have a suggestion (either feature or config setting), please open a ticket.
// Thanks! Enjoy!

if(!manolis) then manolis = {} end                          // Ignore
if(!manolis.Hacking) then manolis.Hacking = {} end          // Ignore
if(!manolis.Hacking.Config) then manolis.Hacking.Config = {} end // Ignore

local config = {}											// Ignore

config.waitTime	= 300										// Amount of time until a random mission is given

// If you need help, PLEASE make a ticket before leaving a shitty review. I'll reply as soon as I see it.
// I'm not really sure what there is to configure. If you have a suggestion / want something added, please make a ticket.
// You can edit/add missions in the missions folder

// x

// The actual job and stuff:
-- TEAM_HACKER = DarkRP.createJob("Hacker", {
--     color = Color(0, 255, 0, 255),
--     model = "models/player/kleiner.mdl",
--     description = [[Hacker job. Allows you to buy hacking terminals and carry out hacking jobs]],
--     command = "hacker",
--     max = 5,
--     level = 10,
--     salary = 200,
--     admin = 0,
-- })

DarkRP.createEntity("Терминал хакера", {
	level = 10,
    ent = "mh_computer",
    model = "models/props_lab/monitor01a.mdl",
    price = 1500,
    max = 1,
    cmd = "buyhackingterminal",
    allowed = {TEAM_OTLICHNIK},
})




manolis.Hacking.Config = config                             // Ignore