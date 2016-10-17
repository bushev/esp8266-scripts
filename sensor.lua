local dht11Pin = 5
local timeBetweenUpdates = 30 * 1000

local function updateData()
    local dht11status, dht11temp, dht11humi, dht11tempDec, dht11humiDec = dht.read(dht11Pin)

    if dht11status == dht.OK then

        mqttClient:publish("/DHT11/temperature", dht11temp, 0, 1, function(client)
            mqttClient:publish("/DHT11/humidity", dht11humi, 0, 1, function(client)

                print("DHT11 data published");
            end)
        end)

    elseif dht11status == dht.ERROR_CHECKSUM then
        print("ERROR: DHT Checksum error.")
    elseif dht11status == dht.ERROR_TIMEOUT then
        print("ERROR: DHT timed out.")
    end
end

tmr.alarm(1, timeBetweenUpdates, tmr.ALARM_AUTO, function() updateData() end);
