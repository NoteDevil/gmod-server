local CONFIG = {} //DO NOT REMOVE

//Set how to use Prop Protection
//1: No protection
//2: Owner can let his friends use it
//3: Only the owner can touch it
CONFIG.UsePropProtection	= 3

//Distances settings
//Being closer than this distance will make the volume maximum
CONFIG.CloseDistance = 200
//Being further than this distance will make the volume 0
CONFIG.FarDistance = 800
//Display render distance (in units). Set this to 0 to disable the screen
CONFIG.RenderDistance = 1200

//Remove all the boomboxs of this player upon switching job
CONFIG.RemOnJobSwitch = false
//Adds the boombox to the F4 menu in DarkRP (disable this if you do it yourself)
CONFIG.AddEntityToF4 = true
//Adds the boombox to the traitor/detective menu in TTT (disable this if you do it yourself)
CONFIG.AddTraitorWeapon = true
CONFIG.AddDetectiveWeapon = true
//Adds the boombox to pointshop1
CONFIG.AddPointshop1Weapon = false

/////////////////// UI THEMES ///////////////////

CONFIG.themes = {

	{
		name = "Default",

		primary = Color(80, 20, 20),
		secondary = Color(180, 180, 180),
		text_1 = Color(255, 255, 255),
		text_2 = Color(40,5,5),

		time_primary = Color(180, 180, 180),
		time_secondary = Color(40,5,5),
		time_scroll = Color(200,0,0),

		volume_active = Color(180,180,180),
		volume_inactive = Color(120, 70, 70)
	},
	//--> Down to this line. (including the '{' and the '},' )
	//2. Paste it here.
	//3. Change the name in quotes.
	//4. Edit the numbers to change the colors.

	{
		name = "Gray",

		primary = Color(45, 45, 45),
		secondary = Color(120, 120, 120),
		text_1 = Color(255, 255, 255),
		text_2 = Color(0,0,0),

		time_primary = Color(120, 120, 120),
		time_secondary = Color(70,70,70),
		time_scroll = Color(255,255,255),

		volume_active = Color(70, 100, 70),
		volume_inactive = Color(70, 70, 70)
	},

}

//SKINS
//You cannot ADD skins Currently, this section is only to remove skins from the in-game options
//To remove a skin, put "//" before the corresponding line.

CONFIG.skins = {
	["Red"] = 0,
	["Black"] = 1,
	["Blue"] = 2,
	["Green"] = 3,
	["Pink"] = 4,
	["Purple"] = 5,
	["Yellow"] = 6,
	["White"] = 7
}



BOOMBOX.config = CONFIG //DO NOT REMOVE


//WeaponSwitchDelay compat
hook.Add("Initialize", "Boombox.Initialize", function()
	if WSDelay and WSDelay.addWeaponWhitelist then
		WSDelay:addWeaponWhitelist("hold_boombox")
	end
end)
