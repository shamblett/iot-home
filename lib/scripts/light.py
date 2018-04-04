import time
import pyupm_grove as grove

# Create the light sensor object using AIO pin 0
light = grove.GroveLight(1)

# Read the input and print a rough lux value 
print "%d" % light.value()

