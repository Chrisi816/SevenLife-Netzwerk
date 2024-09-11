fx_version "adamant"
games {"gta5"}

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

author "Chrisi"
description "Sevenlife Fuel Script"

version "1.0.1"

client_scripts {
    "config.lua",
    "client.lua",
    "laggerraum.lua",
    "mechaniker.lua",
    "tuning.lua",
    "repairkit.lua"
}
server_scripts {
    "config.lua",
    "server.lua",
    "@mysql-async/lib/MySQL.lua"
}

ui_page "html/index.html"

files {
    "html/index.js",
    "html/index.html",
    "html/index.css",
    "html/src/*.png",
    "html/src/*.jpg",
    "html/src/tuning/*.png",
    "html/src/tuning/*.jpg"
}
