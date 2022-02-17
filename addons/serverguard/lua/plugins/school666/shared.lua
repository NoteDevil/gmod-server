local plugin = plugin;

plugin.name = "Школа 666";
plugin.author = "chelog";
plugin.version = "1.0";
plugin.description = "Всякая хрень для Школы 666.";
plugin.gamemodes = {"darkrp"};
plugin.permissions = {
	"SRP: VIP статус",
	"SRP: Видеть админ-запросы",
};

local meta = FindMetaTable "Player"
function meta:query( priv )

	return serverguard.player:HasPermission( self, priv )

end
