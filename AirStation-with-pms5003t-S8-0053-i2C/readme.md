一台空气监测站用来测温湿度，PM2.5,PM10和二氧化碳,通过PM2.5和Pm10算出AQI,带屏幕并有json页面供智能家居平台访问。
上电后,空气监测站会自动使用己有的账号连接wifi，当空气监测站里没有wifi账号和密码时，为AP模式，SSID：AirStation,无密码。用你的无线设备连上AP,输入要连接WIFI的SSID和密码，然后重启。
空气监测站会自动连上wifi,用http://<ip>:81访问json数据。
显示见 https://github.com/pufand/NODEMCU/blob/master/AirStation-with-pms5003t-S8-0053-i2C/AirStation.jpg
显示说明：
AQI:
0-50:好	
51-100:中等
101-150:不适于敏感人群	
151-200:不健康
201-300:非常不健康
301-500:危险

CO2:用表情符号表示
<450:健康的 一般户外空气水准
450-700:可接受的范围
700-1000:感觉空气污浊和不舒服
1000-2500:身体会感觉困倦
2500-5000:对健康不利
>5000:不要在此环境下超过8小时	


使用的元件 有：攀藤科技PMS5003T,senseAir红外CO2模块二氧化碳传感器低功耗S8 0053,IIC接口128*64液晶屏模块,nodemcu。
接线为：nodemcu:RX接pms5003t:TX,nodemcu:D7接S8:TX,nodemcu:D8接S8:RX,nodemcu:D3接液晶屏:scl，nodemcu:D4接液晶屏:sda
创建nodemcu固件时选中file,gpio,http,i2c,net,node,tmr,u8g,uart,wifi 模块。

目前存在的问题，运行一段时间后，会自动重启（很快），不影响使用。

如果您想要打赏，请用支付宝扫描 https://github.com/pufand/NODEMCU/blob/master/AirStation-with-pms5003t-S8-0053-i2C/ThankYou.jpg 中的二维码，谢谢！
------------------by pufand ------------------
