fx_version "cerulean"
games {"gta5"}

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description "SevenLife Farming System"

author "꧁☬ℭ𝔥𝔯𝔦𝔰𝔦☬꧂#0001"

version "1.0.0"

client_scripts {
    "config.lua",
    "main.lua",
    "BaumMarkt.lua",
    "Karotten.lua",
    "Verarbeiter.lua",
    "Sand.lua",
    "Kartoffel.lua"
}
ui_page {
    "html/index.html"
}
server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "server.lua"
}
files {
    "html/src/*.png",
    "html/src/*.webp",
    "html/index.css",
    "html/fonts/*.ttf",
    "html/index.css",
    "html/index.js",
    "html/index.html"
}
