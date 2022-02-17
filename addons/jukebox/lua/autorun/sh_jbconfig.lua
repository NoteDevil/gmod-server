jukebox = jukebox or {}

jukebox.paymentMethod = "darkrp"
-- The method used to
-- can be 'ps' Pointshop, 'ps2' Pointshop 2 by Kamshak, 'darkrp' DarkRP, and 'free' (no price)

jukebox.addPrice = 500
-- price to play a song

jukebox.maxDuration = 600
-- maximum seconds a song can last

jukebox.ownerDurationBypass = true
-- owner of jukebox can bypass the duration limit set by jukebox.maxDuration

jukebox.allowSkip = false
-- allow users to skip a song

jukebox.skipPrice = 1000
-- price to skip current song

jukebox.ownerSkip = true
-- owner of jukebox can skip song

jukebox.adminSkip = true
-- admins can skip a song

jukebox.adminGroups = {
	"founder",
	"superadmin",
	"headadmin",
	"senioradmin",
	"admin",
	"dsuperadmin",
}
-- groups that can forceskip if jukebox.adminSkip is set to 'true'

jukebox.skipPrice = 1000
-- price to skip a song if jukebox.allowSkip is set to 'true'

jukebox.maxfade = 1024
-- The fade distance of the jukebox, default is 1024 (hammer units)
