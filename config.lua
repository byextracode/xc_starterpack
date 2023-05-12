Config  = {}

Config.Locale = "en"

Config.target = true -- only ox_target compatible
Config.location = vector3(-1036.33, -2734.99, 20.17)
Config.distance = 50.0

Config.ped = { -- if Config.target = true
    model = "a_m_y_business_01",
    heading = 150.05,
}

Config.marker = { -- if Config.target = false
    type = 24,
    scale = 0.5
}

Config.blip = { -- add blip for starterpack claim location
    label = "Claim Starterpack",
    sprite = 605,
    scale = 0.6,
    color = 47
}

Config.items = {
    {
        name = 'burger',
        count = 20
    },
    {
        name = 'water',
        count = 20
    },
    {
        name = 'money',
        count = 50000
    },
    {
        name = 'phone',
        count = 1
    },
    {
        name = 'radio',
        count = 1
    },
}

Config.vehicle = {
    model = "calico",
    coords = vec3(-1050.45, -2769.93, 4.64),
    heading = 243.36
}

Config.log = true

Config.translation = {
    ["en"] = {
        ["textui"] = "Starterpack",
        ["claim"] = "Claim Starterpack",
        ["claimed"] = "Starterpack already claimed!",
        ["failure"] = "Failed claiming starterpack, please contact admin",
        ["success"] = "Succeed claiming starterpack",
    }
}