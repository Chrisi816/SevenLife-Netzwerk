fx_version "adamant"
games {"gta5"}

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

author "Chrisi"
description "Sevenlife Garagen Script"

version "1.0.1"

client_scripts {
    "config.lua",
    "client.lua",
    "html/nui.lua"
}

ui_page "html/index.html"

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "server.lua"
}

files {
    "html/index.js",
    "html/index.css",
    "html/index.html",
    "html/src/*.png",
    "html/src/*.jpg"
}
