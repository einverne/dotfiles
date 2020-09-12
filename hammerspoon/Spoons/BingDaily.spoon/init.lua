--- === BingDaily ===
---
--- Use Bing daily picture as your wallpaper, automatically.
---
--- Download: [https://github.com/Hammerspoon/Spoons/raw/master/Spoons/BingDaily.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/BingDaily.spoon.zip)
log = hs.logger.new('BingDaily', 'debug')

local obj={}
obj.__index = obj

-- Metadata
obj.name = "BingDaily"
obj.version = "1.0"
obj.author = "ashfinal <ashfinal@gmail.com>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"
obj.bing_path = os.getenv("HOME") .. "/Pictures/Bing/"

local function curl_callback(exitCode, stdOut, stdErr)
    if exitCode == 0 then
        obj.task = nil
		local allScreens = hs.screen.allScreens()
		for i = 1, #allScreens do
			local newScreen = allScreens[i]:desktopImageURL("file://" .. obj.localpath)
			log.i(newScreen:desktopImageURL())
		end
        --hs.screen.mainScreen():desktopImageURL("file://" .. obj.localpath)
    else
        print(stdOut, stdErr)
    end
end

local function writeDescToFile(filename, content)
	f = io.open(obj.bing_path .. "/" .. filename .. ".txt", "w")
	io.output(f)
	io.write(content)
	io.close(f)
end

local function bingRequest()
    local user_agent_str = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/603.2.4 (KHTML, like Gecko) Version/10.1.1 Safari/603.2.4"
    local json_req_url = "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1"
    hs.http.asyncGet(json_req_url, {["User-Agent"]=user_agent_str}, function(stat,body,header)
        if stat == 200 then
            if pcall(function() hs.json.decode(body) end) then
                local decode_data = hs.json.decode(body)
                local pic_url = decode_data.images[1].url
                -- local pic_name = hs.http.urlParts(pic_url).lastPathComponent
				local pic_content_name = decode_data.images[1].copyright
				local fullstartdate = decode_data.images[1].fullstartdate
				local pic_name = fullstartdate .. ".jpg"
				writeDescToFile(fullstartdate, pic_content_name)
				local pic_name = pic_name:gsub("/", "_")
				local pic_name = pic_name:gsub(" ", "_")
				local localpath = obj.bing_path .. pic_name
                if obj.localpath ~= localpath then
                    obj.full_url = "https://www.bing.com" .. pic_url
                    if obj.task then
                        obj.task:terminate()
                        obj.task = nil
                    end
					obj.localpath = localpath
                    obj.task = hs.task.new("/usr/bin/curl", curl_callback, {"-A", user_agent_str, obj.full_url, "-o", localpath})
                    obj.task:start()
                end
            end
        else
            log.i("Bing URL request failed!")
        end
    end)
end

function create_dir(path)
	if hs.fs.dir(path) == nil then
		hs.fs.mkdir(path)
		log.i("path: " .. path .. " create successfully!")
	end
end

function obj:init()
	create_dir(obj.bing_path)
    if obj.timer == nil then
        obj.timer = hs.timer.doEvery(60, function() bingRequest() end)
        obj.timer:setNextTrigger(5)
    else
        obj.timer:start()
    end
end

return obj
