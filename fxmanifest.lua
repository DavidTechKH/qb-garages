fx_version 'cerulean'
game 'gta5'

author 'Hoàng Đức'
version '1.0.0'
description 'QB-NewGarages'

shared_script 'config.lua'
client_scripts {
    '@PolyZone/client.lua',
	'client.lua'
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

exports {
	'IsInGarage'
}

lua54 'yes'
