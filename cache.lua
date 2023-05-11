return function(ctx)
  local cache = {}


  cache.TTL = ctx.cache_ttl or 60
  cache.timer = {}

  cache.timers = {}
  cache.frames = {}


  local function timerCreator(cb)
    return hs.timer.delayed.new(cache.TTL, cb)
  end

  function cache.timer:start(id)
    if (not cache.timers[id]) then
      cache.timers[id] = timerCreator(function()
        cache.frames[id] = nil
      end)
    end

    cache.timers[id]:start()
  end

  function cache:set(win)
    local win = win or hs.window.focusedWindow()
    if (not win) or (not win:id()) then return end

    self.frames[win:id()] = win:frame()

    cache.timer:start(win:id())
  end

  function cache:clear()
    self.frames = {}
    -- Stop all timers, if they are running
    -- Remove hs.timer.delay object
    for id,timer in pairs(self.timers) do
      timer:stop()
      self.timers[id] = nil
    end
  end

  return cache
end
