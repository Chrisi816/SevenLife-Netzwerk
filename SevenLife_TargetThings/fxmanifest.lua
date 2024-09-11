fx_version "cerulean"
games {"gta5"}

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

author "Chrisi"
description "Sevenlife Fuel Script"

version "1.0.1"

client_scripts {
    "config.lua",
    "client.lua",
    "functions.lua"
}
server_scripts {
    "config.lua",
    "server.lua",
    "@mysql-async/lib/MySQL.lua"
}

files {
    "html/src/*.png",
    "html/src/*.jpg",
    "html/index.css",
    "html/index.js",
    "html/index.html",
    "html/text/*.ttf"
}
ui_page {
    "html/index.html"
}
