import POSIXClock
import mraa

interval = 5000000 # 5000us

pin = 58

mraa.init()
gpio = mraa.gpio_init(pin)
mraa.gpio_dir(gpio, mraa.GPIO_OUT)

t = POSIXClock.timespec(0,0)
t.sec += 5 # start after 5 sec

n = 0

# Lock future memory
ccall(:mlockall, Cint, (Cint,), 2)

while true
  n+=1
  POSIXClock.nanosleep!(t,interval)
  if n%2==0
    mraa.gpio_write(gpio,1)
  else
    mraa.gpio_write(gpio,0)
  end
end


mraa.gpio_close(gpio)
