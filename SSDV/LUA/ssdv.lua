call_event_proc("SystemEventInit")
call_event_proc('Printf','Script Started')
fd=call_func_ptr(0xffec8b34,"/tyCo/0",0,0)
print("fd:",fd)
status=call_func_ptr(0xffec8630,fd,4,600) --FIOBAUDRATE,[baud]
status=call_func_ptr(0xffec8630,fd,3,0) --FIOSETOPTIONS,OPT_RAW
print("status:",status)
call_func_ptr(0xffec84f0,fd)
call_event_proc("SystemEventInit")


function compare(a,b)
  return a[1] < b[1]
end


imgid = 0
--start infinite loop
while true do

print("start")

--take 5 photos
shoot()
sleep(1000)
shoot()
sleep(1000)
shoot()
sleep(1000)
shoot()
sleep(1000)
shoot()
maxsize = 0
bestfile = ""
list = {}

--Find the largest file of the last 5 photos
	dir = os.listdir("A/DCIM/101CANON", false) --'true' shows also . and ..
	count = table.getn(dir)
	x = 0
	for i=count - 4, count do
		--if os.stat("A/DCIM/101CANON/"..dir[i])["size"] > maxsize then
		--	maxsize = os.stat("A/DCIM/101CANON/"..dir[i])["size"]
		--	bestfile = dir[i]
		--end
		--Store each file name & size in list
		list[x] = {dir[i],os.stat("A/DCIM/101CANON/"..dir[i])["size"]}
		x = x + 1
	end

--sort list
table.sort(list, compare)

for k,v in pairs(list) do print(k,v) end

sleep(5000)


--open it
fh=io.open("A/DCIM/101CANON/"..bestfile)
jpeg=fh:read('*all')
fh:close() 


--encode it
ssdvout = io.open("A/imgout.ssdv","wb")

print("NEW SSDV")
s = ssdvenc.new("M6EDF", imgid)
imgid = imgid + 1

print("FEEDING")
ssdvenc.feed(s,jpeg)
i=1
print("READING")

rtty = ""

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

--send it
call_event_proc('Printf',"UUUUUUUUUUUUUUUUUUUUUUU")
for d=1,string.len(rtty),1 do
	call_event_proc('Printf','%c',string.byte(rtty,d))
end


print("end")

end
--end of infinite loop