fx_version "cerulean"
games {"gta5"}

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description "SevenLife_Bankingssystem"

author "꧁☬ℭ𝔥𝔯𝔦𝔰𝔦☬꧂#0001"

version "1.0.0"

client_scripts {
    "client.lua",
    "config.lua"
}
ui_page {
    "html/index.html"
}
server_scripts {
    "server.lua",
    "config.lua",
    "@mysql-async/lib/MySQL.lua"
}
files {
    "html/fonts/*.ttf",
    "html/index.css",
    "html/src/*.png",
    "html/index.js",
    "html/index.html"
}
