fx_version "adamant"
games {"gta5"}

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description "SevenLife_Farming System"

author "꧁☬ℭ𝔥𝔯𝔦𝔰𝔦☬꧂#0001"

version "1.0.1"

client_scripts {
    "config.lua",
    "postal_office/postal_client.lua",
    "postal_job/posta_job_client.lua",
    "postal_office/inoffice.lua"
}
server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "postal_office/postal_server.lua",
    "postal_job/postal_job_server.lua"
}

ui_page {"html/index.html"}

files {
    "html/index.css",
    "html/index.js",
    "html/fonts/*.ttf",
    "html/index.html",
    "html/src/*.png"
}
