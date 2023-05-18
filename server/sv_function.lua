function labelText(text, ...)
    local library = Config.translation[Config.Locale]
    if library == nil then
        return ("Translation [%s] does not exist"):format(Config.Locale)
    end
    if library[text] == nil then
        return ("Translation [%s][%s] does not exist"):format(Config.Locale, text)
    end
    return library[text]:format(...)
end

function SendWebhookMessage(webhook, text, image, title, color)
    local ts = os.time()
    local time = os.date('%d-%m-%Y %H:%M:%S', ts)
    local color = color and embed_color[color]
    local connect = {
        {
            ["color"] = color or 3092790,
            ["title"] = title or 'Attention!',
            ["description"] = text,
            ["footer"] = {
                ["text"] = "\xF0\x9F\x92\xBB logged on " ..time,
            },
        }
    }

    if image then
        if image:find('webm') or image:find('mp4') then
            image = "https://i.imgur.com/7xZI8SN.jpg"
        end
        connect[1]["image"] = { ["url"] = image }
    end

    PerformHttpRequest(webhook, function(err, text, headers)

    end, 'POST', json.encode(
        {
            username = 'ExtraCode',
            embeds = connect,
        }
    ), { ['Content-Type'] = 'application/json' })
end