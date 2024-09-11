fx_version "cerulean"
games {"gta5"}

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

author "Chrisi"
description "Sevenlife Hunting Script"

version "1.0.1"

client_scripts {
    "config.lua",
    "license.lua",
    "client.lua",
    "verarbeiter_fleisch.lua",
    "verarbeiter.lua"
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
    "html/*.png"
}
