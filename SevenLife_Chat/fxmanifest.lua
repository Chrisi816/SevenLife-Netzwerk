fx_version "cerulean"
games {"gta5"}

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description "SevenLife Chat System"

author "꧁☬ℭ𝔥𝔯𝔦𝔰𝔦☬꧂#0001"

version "1.0.0"

client_scripts {
    "config.lua",
    "emotes.lua",
    "client.lua"
}
ui_page {
    "html/chat.html"
}
server_scripts {
    "server.lua",
    "@mysql-async/lib/MySQL.lua"
}
files {
    "html/src/*.png",
    "html/src/*.jpg",
    "html/chat.css",
    "html/chat.js",
    "html/chat.html",
    "html/text/*.ttf"
}
