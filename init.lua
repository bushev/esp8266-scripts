dofile("credentials.lua")

wifi.sta.disconnect()
wifi.setmode(wifi.STATION)
wifi.sta.config(wiFiSSID, wiFiPassword, 0)
wifi.sta.connect()

mqttClient = mqtt.Client(mqttUserId, 120, mqttUsername, mqttPassword)

mqttClient:on("offline", function(client) print ("MQTT client offline") end)

tmr.alarm(0, 500, tmr.ALARM_AUTO, function()
    if wifi.sta.getip() == nil then
        print("Waiting for IP address..")
    else
        tmr.stop(0)

        mqttClient:connect(mqttBrokerAddress, mqttBrokerPort, 0,
            function(client)
                print("MQTT connected")

                dofile("relay.lua")
                dofile("sensor.lua")

            end, function(client, reason)
                print("ERROR: MQTT failed to connect: " .. reason)
                tmr.start(0)
            end)
    end
end)