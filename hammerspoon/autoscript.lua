log = hs.logger.new('autoscript', 'debug')
local cmdArr = {
    "cd /Users/einverne/Sync/wiki/ && /bin/bash auto-push.sh",
    "/usr/bin/rsync --remove-source-files -azvh ~/Downloads/*.torrent omv_proxy:/sharedfolders/pt/watch/ >> /tmp/rsync-bittorrent.log",
}

function shell(cmd)
	hs.alert.show("execute")
	log.i('execute')
	output, status, t, rc = hs.execute(string.format("%s", cmd), true)
    -- result, output, err = hs.osascript.applescript(string.format('do shell script "%s"', cmd))
	log.i(output)
	log.i(status)
	log.i(t)
	log.i(rc)
end

function runAutoScripts()
    for key, cmd in ipairs(cmdArr) do
		log.i("execute" .. key .. " " .. cmd)
        shell(cmd)
    end
end


myTimer = hs.timer.doEvery(1800, runAutoScripts)
myTimer:start()
