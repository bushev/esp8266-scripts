relayPin = 3
relayName = "1"

gpio.mode(relayPin, gpio.OUTPUT)

mqttClient:subscribe("/relay/" .. relayName, 0, function(client)
    print("Subscribed for relay/1 topic")
end)

mqttClient:on("message", function(conn, topic, data)
    if data ~= nil then
        if topic == "/relay/" .. relayName then
            if data == "on" then
                print("Relay is ON")
                gpio.write(relayPin, gpio.LOW)
            else
                print("Relay is OFF")
                gpio.write(relayPin, gpio.HIGH)
            end
        end
    end
end)
