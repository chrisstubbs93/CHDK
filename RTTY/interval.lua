--[[
@title Intervalometer
@param a = interval (sec)
@default a 15
--]]

function txByte(e)
      c=string.byte(e)
   for f=0,6,1 do
          if(bitand(c,1) == 1) then 
        set_led(8,1)
        print("1")
     end
     if(bitand(c,1) == 0) then
        set_led(8,0)
        print("0")
     end
     c = bitshri(c,1)
     --txByte(string.sub(b,d,d))
     sleep(100)
   end
print("1")
print("1")
end

function txString(b)
   for d=1,4,1 do
     txByte(string.sub(b,d,d))
   end
end

print_screen(1)


-- Turn off flash
flash_mode = get_flash_mode()
if(flash_mode ~= 2) then
    print('Disabling flash...')
    while(flash_mode ~= 2) do
        press('up')
        release('up')
        sleep(500)
        flash_mode = get_flash_mode()
    end
    print('Flash disabled.')
    sleep(500)
else
    print('Flash is off.')
end
--End of turn off flash


    print('LED FLASH.')
    sleep(500)
    set_led(8,1)
    sleep(500)
    set_led(8,0)
    txString("RTTY")


repeat 
    start = get_tick_count()
	shoot()
--set_backlight(0)
sleep(500)
--set_backlight(0)
sleep(500)
--set_backlight(0)
    sleep(a*1000 - (get_tick_count() - start))
until ( false )

