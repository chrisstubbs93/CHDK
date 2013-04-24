--[[
@title Intervalometer
@param a = interval (sec)
@default a 15
--]]


-- Turn off flash
flash_mode = get_flash_mode()
if(flash_mode ~= 2) then
    print('Disabling flash...')
    while(flash_mode ~= 2) do
        press('up')
        release('up')
        flash_mode = get_flash_mode()
    end
    print('Flash disabled.')
    sleep(500)
else
    print('Flash is off.')
end


repeat 
    start = get_tick_count()
	shoot()
set_backlight(0)
sleep(500)
set_backlight(0)
sleep(500)
set_backlight(0)
    sleep(a*1000 - (get_tick_count() - start))
until ( false )


