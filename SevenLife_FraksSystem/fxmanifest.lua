fx_version "cerulean"
games {"gta5"}

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

author "Chrisi"

description "Sevenlife Fuel Script"

version "1.0.1"

client_scripts {
    "config.lua",
    "LCN/FrakInvite/*.lua",
    "LCN/Lager/*.lua",
    "LCN/Garage/client.lua",
    "LCN/BossMenu/client.lua",
    "LCN/SpecieleItems/client.lua",
    "Main/Core.lua",
    "LCN/FamilienOrdnung/client.lua"
}
server_scripts {
    "config.lua",
    "Main/Server.lua",
    "LCN/Garage/server.lua",
    "LCN/LCNMain/Server.lua",
    "LCN/BossMenu/server.lua",
    "LCN/SpecieleItems/server.lua",
    "LCN/FamilienOrdnung/server.lua",
    "@mysql-async/lib/MySQL.lua"
}

ui_page "html/index.html"

files {
    "html/index.js",
    "html/index.html",
    "html/index.css",
    "html/src/*.png",
    "html/src/*.svg",
    "html/src/*.jpg",
    "html/items/*.png",
    "html/text/*.ttf"
}
