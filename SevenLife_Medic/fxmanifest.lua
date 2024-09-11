fx_version "cerulean"
games {"gta5"}

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description "SevenLife_Bankingssystem"

author "꧁☬ℭ𝔥𝔯𝔦𝔰𝔦☬꧂#0001"

version "1.0.0"

client_scripts {
    "config.lua",
    "client.lua",
    "medic/goindienst.lua",
    "medic/heandewaschen.lua",
    "medic/spender.lua",
    "medic/kleiderschrank.lua",
    "medic/flugzeugplatz.lua",
    "medic/aufzug.lua",
    "medic/heliped.lua",
    "medic/tiefgarage.lua",
    "medic/laydownonbeds.lua",
    "medic/garagenormal.lua",
    "medic/specieleitems.lua"
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
    "html/design/*.png",
    "html/index.css",
    "html/index.js",
    "html/index.html",
    "html/fonts/*ttf"
}
