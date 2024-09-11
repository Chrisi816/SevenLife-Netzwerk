fx_version "cerulean"
games {"gta5"}

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description "SevenLife_Bankingssystem"

author "꧁☬ℭ𝔥𝔯𝔦𝔰𝔦☬꧂#0001"

version "1.0.0"

client_scripts {
    "config.lua",
    "nui.lua",
    "client.lua"
}
ui_page {
    "html/index.html"
}
server_scripts {
    "config.lua",
    "server.lua",
    "@mysql-async/lib/MySQL.lua"
}
files {
    "html/src/*.png",
    "html/index.css",
    "html/index.js",
    "html/index.html",
    "html/text/*.ttf"
}
