import POSIXClock
import mraa

function main()
interval = 800000 # 800us

pin = 58

mraa.init()
gpio = mraa.gpio_init(pin)
mraa.gpio_dir(gpio, mraa.GPIO_OUT)

t::POSIXClock.timespec = POSIXClock.gettime(POSIXClock.CLOCK_MONOTONIC)

n = 0

# Lock future memory allocations, disable GC
ccall(:mlockall, Cint, (Cint,), 2)
gc_enable(false)

@time while n < div(60000000000,interval) # run for a minute
  n+=1
  t = POSIXClock.nanosleep(t,interval)
  if n%2==0
    mraa.gpio_write(gpio,1)
  else
    mraa.gpio_write(gpio,0)
  end
end

mraa.gpio_close(gpio)

# Unlock memory allocations, enable GC
ccall(:munlockall, Cint, ())
gc_enable(true)

return nothing
end

main()
