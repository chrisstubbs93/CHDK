call_event_proc("SystemEventInit")
call_event_proc('Printf','Script Started')
sleep(1000)
fd=call_func_ptr(0xffec8b34,"/tyCo/0",0,0)
call_event_proc('Printf','Serial port accessed')
sleep(1000)
print("fd:",fd)
status=call_func_ptr(0xffec8630,fd,4,600) --FIOBAUDRATE,[baud]
status=call_func_ptr(0xffec8630,fd,3,0) --FIOSETOPTIONS,OPT_RAW
print("status:",status)
call_func_ptr(0xffec84f0,fd)
call_event_proc("SystemEventInit")

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

set_backlight(0)
sleep(100)
set_backlight(0)

imgid = 0
--start infinite loop
while true do

print("start  Freemem:")
print(collectgarbage("count")*1024)
sleep(3000)

--take 3 photos
shoot()
sleep(500)
shoot()
sleep(500)
shoot()

set_backlight(0)
sleep(100)
set_backlight(0)


maxsize = 0
bestfile = ""

--Find the largest file of the last 3 photos
	dir = os.listdir("A/DCIM/101CANON", false) --'true' shows also . and ..
	count = table.getn(dir)
	x = 0
	for i=count - 2, count do
		if os.stat("A/DCIM/101CANON/"..dir[i])["size"] > maxsize then
			maxsize = os.stat("A/DCIM/101CANON/"..dir[i])["size"]
			bestfile = dir[i]
		end
		x = x + 1
	end

set_backlight(0)
sleep(100)
set_backlight(0)


--open it
fh=io.open("A/DCIM/101CANON/"..bestfile)
jpeg=fh:read('*all')
fh:close() 

print("JPEG open Freemem:")
print(collectgarbage("count")*1024)
sleep(1000)

set_backlight(0)
sleep(100)
set_backlight(0)

--encode it
--ssdvout = io.open("A/imgout.ssdv","wb")

print("NEW SSDV")
s = ssdvenc.new("M6EDF", imgid)
imgid = imgid + 1

print("FEEDING")
ssdvenc.feed(s,jpeg)
jpeg = nil
i=1
print("READING")

rtty = ""

set_backlight(0)
sleep(100)
set_backlight(0)

repeat
	print("Packet ",i," encoding")
	r, packet = ssdvenc.read(s)
	if r == SSDV_OK then
		--If we have data, then do something with it
		--ssdvout:write(packet)
		rtty = rtty .. packet
		i=i+1
	end
until r ~= SSDV_OK

print("READ COMPLETE")

ssdvenc.close(s)

set_backlight(0)
sleep(250)
set_backlight(0)

--send it
call_event_proc('Printf',"UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU")
for d=1,string.len(rtty),1 do
	call_event_proc('Printf','%c',string.byte(rtty,d))
end


print("end")

end
--end of infinite loop