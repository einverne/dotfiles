local obj = {}
obj.__index = obj

-- Metadata
obj.name = "PomodoroTimer"
obj.version = "1.0"
obj.author = "Ein Verne"
obj.homepage = "https://github.com/einverne/dotfiles"
obj.license = "MIT - https://opensource.org/licenses/MIT"

-- 设置默认值
obj.workDuration = 25 * 60  -- 25分钟工作时间
obj.breakDuration = 5 * 60  -- 5分钟休息时间
obj.timer = nil
obj.isWorking = true

obj.startSound = hs.sound.getByName("Submarine")  -- 开始声音
obj.endSound = hs.sound.getByName("Glass")  -- 结束声音

function obj:toggle()
    if self.timer == nil then
        self:start()
        log.d("PomodoroTimer started")
    else
        self:stop()
        log.d("PomodoroTimer stopped")
    end
end

function obj:start()
    log.d("PomodoroTimer start")
    hs.alert.show("番茄时钟已启动", 2)
    self.startSound:play()  -- 播放开始声音
    self:startTimer()
end

function obj:startTimer()
    local duration = self.isWorking and self.workDuration or self.breakDuration
    self.timer = hs.timer.doAfter(duration, function()
        self.endSound:play()  -- 播放结束声音
        if self.isWorking then
            hs.alert.show("工作时间结束，开始休息！", 5)
            hs.notify.new({title="番茄时钟", informativeText="工作时间结束，开始休息！"}):send()
            self.isWorking = false
        else
            hs.alert.show("休息时间结束，开始工作！", 5)
            hs.notify.new({title="番茄时钟", informativeText="休息时间结束，开始工作！"}):send()
            self.isWorking = true
        end
        self:startTimer()  -- 开始下一个计时周期
    end)
end

function obj:stop()
    if self.timer then
        self.timer:stop()
        self.timer = nil
    end
    self.isWorking = true  -- 重置为工作状态
    hs.alert.show("番茄时钟已停止", 2)
    self.endSound:play()  -- 播放结束声音
end

return obj