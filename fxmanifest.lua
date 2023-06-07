fx_version "cerulean"
lua54 "yes"
game "gta5"

name "xc_starterpack"
version "1.0.0"
description "ESX starterpack with ox_inventory"
author "wibowo#7184"

shared_scripts {
    "@es_extended/imports.lua",
    "@ox_lib/init.lua"
}

shared_script "config.lua"
client_script "client/*.lua"
server_script "@oxmysql/lib/MySQL.lua"
server_script "server/*.lua"

dependencies {
    "oxmysql",
    "es_extended",
    "ox_lib",
    "esx_vehicleshop",
    -- "ox_target", -- optional
}