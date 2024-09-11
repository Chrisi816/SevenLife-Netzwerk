fx_version "adamant"
games {"gta5"}

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description "SevenLife WaffenShops made by Chrisi"

author "꧁☬ℭ𝔥𝔯𝔦𝔰𝔦☬꧂#0001 on Discord"

version "1.0.0"

client_scripts {
    "config.lua",
    "client.lua"
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
    "html/img/*.png",
    "html/index.css",
    "html/index.js",
    "html/index.html",
    "html/fonts/*.ttf"
}
