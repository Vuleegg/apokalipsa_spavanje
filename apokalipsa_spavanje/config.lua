Config                            = {}

Config.ZoneSize     = {x = 19.0, y = 19.0, z = 2.5}

Config.Zones = {
	vector3(872.5667, -26.0113, 79.768),
    vector3(911.6322, -43.4403, 79.948),
    vector3(919.4583, -63.1896, 79.683),
    vector3(930.7407, -90.6036, 79.948)

}
Config.debugsystem = false
Config.addhungerandthirst = true
Config.tiredeffect = true
Config.tiredpedmovement = true
Config.timeforremovetired = 30 ----- If the player is asleep, reduce tired every 30 minutes
Config.timeforaddtired = 60 ---- Add tired to the player every 1 hours (0 - 4 = normal) (4 - 8 = a bit tired) (8 - 12 =  Very tired)
Config.removetiredofflineplayer = true ---- If the player was offline but asleep, reduce tired
Config.addtiredofflineplayer = false --- If the player was offline but not asleep, increase tired
