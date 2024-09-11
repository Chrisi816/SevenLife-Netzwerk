fx_version "cerulean"
games {"gta5"}

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description "Official SevenLife LifeInvader"

author "꧁☬ℭ𝔥𝔯𝔦𝔰𝔦☬꧂#0001"

version "1.0.0"

client_scripts {
    "config_lifeinvader.lua",
    "client.lua"
}
ui_page {
    "html/index.html"
}
server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "config_lifeinvader.lua",
    "server.lua"
}
files {
    "html/index.html",
    "html/index.js",
    "html/index.css",
    "html/src/*.png",
    "html/src/*.jpg"
}
