function run_setup()
    wifi.setmode(wifi.SOFTAP)
    cfg={}
    cfg.ssid="AirStation"
    wifi.ap.config(cfg)

    print("Opening WiFi credentials portal")
    dofile ("server.lua")
end

function read_wifi_credentials()
    local wifi_ssid
    local wifi_password

    if file.open("wifi_credentials", "r") then
        wifi_ssid = file.read("\n")
        wifi_ssid = string.format("%s", wifi_ssid:match( "^%s*(.-)%s*$" ))
        wifi_password = file.read("\n")
        wifi_password = string.format("%s", wifi_password:match( "^%s*(.-)%s*$" ))
        file.close()
    end

    if wifi_ssid ~= nil and wifi_ssid ~= "" and wifi_password ~= nil then
        return wifi_ssid, wifi_password
    end
    return nil, nil
end

function try_connecting(wifi_ssid, wifi_password)
    wifi.setmode(wifi.STATION)
    wifi.sta.config(wifi_ssid, wifi_password)

    tmr.alarm(0, 500, 1, function()
        if wifi.sta.getip()==nil then
          print("Connecting to AP...")
        else
          tmr.stop(1)
          tmr.stop(0)
          print("Connected as: " .. wifi.sta.getip())
          dofile ("server2.lua")
        end
    end)

    tmr.alarm(1, 5000, 0, function()
        if wifi.sta.getip()==nil then
            tmr.stop(0)
            print("Failed to connect to \"" .. wifi_ssid .. "\"")
            run_setup()
        end
    end)
end

wifi_ssid, wifi_password = read_wifi_credentials()
if wifi_ssid ~= nil and wifi_password ~= nil then
    print("")
    print("Retrieved stored WiFi credentials")
    print("---------------------------------")
    print("wifi_ssid     : " .. wifi_ssid)
    print("wifi_password : " .. wifi_password)
    print("")
    try_connecting(wifi_ssid, wifi_password)
else
    run_setup()
end
