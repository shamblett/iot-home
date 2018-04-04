import time
import pyupm_grove as grove

# Create the temperature sensor object using AIO pin 2
temp = grove.GroveTemp(3)

# Read and print the celsius temperature
celsius = temp.value()
print "%d" % (celsius)



