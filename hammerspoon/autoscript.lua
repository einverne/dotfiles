log = hs.logger.new('autoscript', 'debug')

function taskCallback(exitCode, stdOut, stdErr)
	log.i("task call back ", exitCode, stdOut, stdErr)
end

function runAutoScripts()
	args = {"-c", "/Users/einverne/Sync/wiki/auto-push.sh"}
	autoCommitTask = hs.task.new("/bin/bash", taskCallback, args)
	autoCommitTask:setWorkingDirectory("/Users/einverne/Sync/wiki/")
	autoCommitTask:start()
end

myTimer = hs.timer.doEvery(7200, runAutoScripts)
myTimer:start()
