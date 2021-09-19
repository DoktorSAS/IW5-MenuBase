// initiate menu files
#include scripts\_lurkzy_utility;
#include scripts\_toxic;

#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
    level thread onplayerconnect();
}

onplayerconnect()
{
    for(;;)
    {
        level waittill("connected", player);
        
        player thread onplayerspawned();

        player thread initmenu();
        player thread watchDeath();

        // initiate player variables
        player.spawnText        = true;
    }
}

onplayerspawned()
{
    self endon("disconnect");
    for(;;)
    {
        self waittill("spawned_player");
        
        if(!self.per["isBot"])
            self freezeControls(false);

        if(self.spawnText)
        {
            self iprintln("Welcome to ^2Menu Base ^7by @Lurkzy");
            self iprintln("Press ^2[{+speed_throw}] ^7+ ^2[{+Actionslot 1}] ^7to open the menu");
        }
    }
}