table.insert(manolis.Hacking.Missions.Missions, {
        uid='ppmanox',
        reward = math.floor(math.random()*2000)+300,
        sid = '0',
        init = function(self)
                local email = {}
                email.from = 'jamiexXx@live.com'
                email.subject = 'I want my money back'
 
                email.message = table.Random(manolis.Hacking.Missions.Greetings)..'\n\nDon\'t ask me how I found you, I had to search through some weird shit, but I really, really need your help.. \nSo my girlfriend of 8 years took all of my money out of my bank account and left me for some sleeze bag, out of the blue, I really need my money back, I can\'t get thrown out of my apartment again… \nI have cats to feed! \nPlease, please hack into her bank account, 80,000 dollars of it is mine, I am begging you. \nI, well they, will pay you whatever is left over after I get my savings back. \nHelp me get revenge? You in? Just don\'t let us get caught! \nI, well they, can pay you $'..string.Comma(self.reward_)..'. That should be all that\'s left after I get my money back \nOkay, let me know how it goes. \n\nThe password is on a secure FTP server at '..self.ip..'\n\n'..table.Random(manolis.Hacking.Missions.ByeList)

                hackingTerminal:SendMail(email)

self:LoadProgram('ftp')
self.ftp = {}
self.ftp.username = 'sophie'
self.ftp.password = table.Random(manolis.Hacking.Missions.Passwords)
self.ftp.isCrackable = true
self.ftp.files = {}

local pw = table.Random(manolis.Hacking.Missions.Passwords)
table.insert(self.ftp.files, {path='haha.txt', contents="Hey baby!\n\nHere are my new banking details from my dickhead ex: \n\n"..'IB9531589139:'..pw})
 


 
                manolis.Hacking.mBank.addAccount('IB9531589139', pw, 80000, function()
                       local email_= {}
                        email_.from = 'jamiexXx@live.com'
                        email_.subject = 'I got my money back'
                        email_.message = table.Random(manolis.Hacking.Missions.Greetings)..'\n'..'I can\'t believe you did it and it worked, holy crap, I\'m sending the rest of the money over right now, cheers!\n\n'..table.Random(manolis.Hacking.Missions.ByeList)


                        hackingTerminal:SendMail(email_)
			self:CompleteMission()
		end)

 
        end
})