# Imports
from mqtt import MQTTClient
from machine import Pin, ADC
from time import sleep


# Variables
server = '192.168.1.230' # Address Pi
client_id = "mathias"
topic_sub = 'test/msg'
topic_pub = 'test/msg'

led = Pin(33, Pin.OUT) # 33 number in is Output
button = Pin(32, Pin.IN, Pin.PULL_UP) # 32 number pin is input
pot = ADC(Pin(34)) # Analog pin for potentio meter

pot.atten(ADC.ATTN_11DB)

# ----------------------------------------------------------------------------------

print("")
print("\tStarting up the main.py")
print("------------------------------------------")

# Function that connects to the mqtt broker running in a docker container on the pi
def connect_and_subscribe():
  print('\tConnect_And_Subscribe function')
  
  global client_id, mqtt_server, topic_sub
  
  print('\t\tClient ID           ', client_id)
  print('\t\tMQTT Server         ', mqtt_server)
  print('\t\tSubscription Topic  ', topic_sub)
  
  client = MQTTClient(client_id, mqtt_server)
  client.connect()
  print('\t\tClient              ', client)  
  
  print('\t\tConnected to %s MQTT broker, subscribed to %s topic' % (mqtt_server, topic_sub))
  
  return client


def restart_and_reconnect():
  print("\tRestart_And_ReConnect")
  print('\t\tFailed to connect to MQTT broker. Reconnecting...')
  
  time.sleep(10)
  machine.reset()

def stop_the_script():
    print("#############")
    print("Wrong value!")
    print("Script is stopping")
    print("#############")
    
    led.value(0)
    exit

  
def sensor1():
    print("\n- Function - Sensor1")
    
    logic_state = button.value()
    
    if logic_state == 0:
        print("\tLights are turned off")
        value = 0
        
        print("\t\tldr is now registering " + str(value))
        print("\n\t\tSending " + str(value) + " to mqtt broker")
        
        client.publish("house/livingroom/ldr", str(value))
        print("\t\t\tSent Successfully!")
                
        led.value(0)
        
    elif logic_state == 1:
        print("\tLights are turned on")
        
        pot_value = pot.read()
        converted = ((pot_value / 4095) * 100)
        value = round(converted, 2)
        
        print("\t\tldr is now registering " + str(value))
        
        print("\n\t\tSending " +  str(value) + " to mqtt broker")
        
        client.publish("house/livingroom/ldr", str(value))
        print("\t\t\tSent Successfully!")
        
        led.value(1)
        
    else:
        stop_the_script()

def sensor2():
    print("\n- Function - Sensor2")
    
    logic_state = button.value()
    
    if logic_state == 0:
        print("\tLights are turned off")

        msg = "Light is turned off"
        print("\n\t\tsending: " + msg + " to mqtt broker")

        client.publish("house/livingroom/lightbulb", msg)
        print("\t\t\tSent Successfully!")
        
        led.value(0)
        
    elif logic_state == 1:
        print("\tLights are turned on")

        msg = "Light is turned on"
        print("\n\t\tsending: " + msg + " to mqtt broker")

        client.publish("house/livingroom/lightbulb", msg)
        print("\t\t\tSent Successfully!")
        
        led.value(1)
        
    else:
        stop_the_script()

try:
  client = connect_and_subscribe()

except OSError as e:
  restart_and_reconnect()

while True:
    sensor1()
    sensor2()
    time.sleep(2)

