function parse(data)
    local bs = {}
    for i = 1, #data do
        bs[i] = string.byte(data, i)
    end

    if (bs[1] ~= 0x42) or (bs[2] ~= 0x4d) then
        return nil
    end

    local d = {}    
    d['pm1_0-CF1-ST'] = bs[5] * 256 + bs[6]
    d['pm2_5-CF1-ST'] = bs[7] * 256 + bs[8]
    d['pm10-CF1-ST']  = bs[9] * 256 + bs[10]
    d['pm1_0-AT']     = bs[11] * 256 + bs[12]
    d['pm2_5-AT']     = bs[13] * 256 + bs[14]
    d['pm10-AT']      = bs[15] * 256 + bs[16]
    d['0_3um-count']  = bs[17] * 256 + bs[18]
    d['0_5um-count']  = bs[19] * 256 + bs[20]
    d['1_0um-count']  = bs[21] * 256 + bs[22]
    d['2_5um-count']  = bs[23] * 256 + bs[24]
    d['temperature']  = bs[25] * 256 + bs[26]
    d['humidity']     = bs[27] * 256 + bs[28]   
    return d 
end -- parse

function aqipm25(t)
  if (t <= 12) then return t * 50 / 12
  elseif (t <= 35) then return 50 + (t - 12) * 50 / 23
  elseif (t <= 55) then return 100 + (t - 35) * 5 / 2
  elseif (t <= 150) then return 150 + (t - 55) * 2
  elseif (t <= 350) then return 50 + t
  else return 400 + (t - 350) * 2 / 3 
  end
end --aqi_pm25

function aqipm10(t)
  if (t <= 55) then return t * 50 / 55
  elseif (t <= 355) then return 50 + (t - 55) / 2
  elseif (t <= 425) then return 200 + (t - 355) * 10 / 7
  elseif (t <= 505) then return 300 + (t - 425) * 10 / 8
  else return t - 105 
  end
end --aqi_pm10

function aqi(t25,t10)
  if (t25 < t10) then return t10
  else return t25 
  end
end --aqi

function getaqi()
    uart.alt(0)
    uart.setup(0, 9600, 8, 0, 1, 0)
    data = nil
    uart.on("data", 32,function(data)
        pms5 = parse(data)         
        pm01 = pms5['pm1_0-AT']
        pm25 = pms5['pm2_5-AT']
        pm10 = pms5['pm10-AT'] 
        temp = pms5['temperature'] / 10
        hum = pms5['humidity'] / 10
        aqi25 = aqipm25(pm25)
        aqi10 = aqipm10(pm10)
        aqi1  = aqi(aqi25,aqi10)
        getco2()  
        if pms5 == nil then    
           return       
        end
    end,0 ) 
end --getaqi

function getco2()
    uart.alt(1) 
    data = nil
    uart.setup(0, 9600, 8, 0, 1, 0)
    tmr.alarm(3, 10000, 1, function()
    data = nil
    uart.write(0,0xFE,0x04,0x00,0x03,0x00,0x01,0xD5,0xC5)
    end)
    uart.on("data", 7, function(data)
        if string.len(data) == 7  then
            co2 = string.byte(data,4)*256 + string.byte(data,5)
            tmr.stop(3)
            getaqi() 
        end
        if data == nil then
                return       
        end      
    end,0)
end --getco2

pms5 = nil
getaqi()
