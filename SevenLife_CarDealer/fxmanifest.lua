fx_version "adamant"
games {"gta5"}

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description "SevenLife robbery"

author "꧁☬ℭ𝔥𝔯𝔦𝔰𝔦☬꧂#0001"

version "1.0.0"

client_scripts {
    "config.lua",
    "client.lua",
    "html/nui.lua",
    "functions.lua"
}

ui_page "html/index.html"

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "server.lua"
}

files {
    "html/index.html",
    "html/index.js",
    "html/index.css",
    "html/src/*.png",
    "html/src/*.jpg"
}
