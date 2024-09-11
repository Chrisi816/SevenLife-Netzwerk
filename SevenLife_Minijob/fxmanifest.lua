fx_version "adamant"
games {"gta5"}

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description "SevenLife_Bankingssystem"

author "꧁☬ℭ𝔥𝔯𝔦𝔰𝔦☬꧂#0001"

version "1.0.0"

client_scripts {
    "config.lua",
    "truckminijob/client.lua"
}
ui_page {
     "truckminijob/html/nui.html"
}
server_scripts {
    "config.lua",
    "truckminijob/server.lua"
}
files {
    "truckminijob/html/src/*.png",
    "truckminijob/html/nui.css",
    "truckminijob/html/nui.js",
    "truckminijob/html/nui.html"
}
