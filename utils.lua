local log = hs.logger.new("WindowManager:utils")

  local function similar(key, a, b)
    local diff = nil
    if (a[key] > b[key]) then
      diff = a[key] - b[key]
    else
      diff = b[key] - a[key]
    end
    local isSimilar = (diff <= 90)
    -- log.d('~', key, diff, isSimilar) -- TESTING
    return isSimilar
  end

local function similarWidth(a, b)
  return similar("w", a, b)
end

local function similarHeight(a, b)
  return similar("h", a, b)
end

local function similarCenter(a, b)
  local diff = a:distance(b)
  local isSimilar = (math.abs(diff) < 50)
  -- log.d('~', 'c', diff, isSimilar) -- TESTING
  return isSimilar
end

local function indexOf (array, item)
  log.d("array:", array)
  log.d("length:", #array)
  log.d("item:", item)
  -- log.d('item.center:', item.center) -- TESTING
  local result = -1
  for index = 0, #array do
    -- log.d('--- COMPARING ELEMENTS ---') -- TESTING
    -- log.d("i:", index, "ele:", array[index]) -- TESTING
    -- log.d('ele.center:', array[index].center) -- TESTING
    local isEqual = array[index]:equals(item)
    local isSimilarWidth = similarWidth(array[index], item)
    local isSimilarHeight = similarHeight(array[index], item)
    local isSimilarCenter = similarCenter(array[index], item)
    local isClose = (
      isSimilarWidth and
      isSimilarHeight and
      isSimilarCenter
    )
    -- log.d("isEqual:", isEqual) -- TESTING
    -- log.d("isSimilarWidth:", isSimilarWidth) -- TESTING
    -- log.d("isSimilarHeight:", isSimilarHeight) -- TESTING
    -- log.d("isSimilarCenter:", isSimilarCenter) -- TESTING
    -- log.d("isClose:", isClose) -- TESTING
    if (isEqual or isClose) then
      result = index
      break
    end
  end

  return result
end

return function(ctx)
  local m = {}

  function m:findWindow()
    log.d("finding window...")
    local win = hs.window.focusedWindow()
    log.d("window:", win)
    return win
  end

  function m:findNextPosition(win, frame, direction)
    log.d("finding next position...")
    local nextFrame = frame
    local nextIndex = nil

    local list = ctx.POSITIONS[win:screen():name()][direction]
    local posIndex = indexOf(list, frame)
    log.d("posIndex:", posIndex)
    log.d("list.length:", #list)
    if (posIndex == -1 or posIndex == #list) then
      -- NOTE: not in a set position, push to first
      -- NOTE: end of the list, push to first
      nextIndex = 0
    else
      nextIndex = posIndex + 1
    end
    nextFrame = list[nextIndex]
    log.d("nextFrame:", nextFrame)
    log.d("nextIndex:", nextIndex)
    return nextFrame
  end

  function m:findCurrentFrame(win)
    log.d("finding current frame...")
    local frame = win:frame()
    log.d("curFrame:", frame)
    return frame
  end

  function m:shiftWindow(win, pos)
    log.d("shifting window...")
    log.d("pos:", pos)
    win:setFrame(pos)
    -- TODO: Check if window is off screen (Spotify)
  end

  function m:moveHandler(loc, prettyName)
    local output = loc
    if (prettyName ~= nil) then
      output = prettyName
    end
    log.df("handle shift - %s", output)
    local win = self:findWindow()
    local curFrame = self:findCurrentFrame(win)
    local nextFrame = self:findNextPosition(win, curFrame, loc)
    self:shiftWindow(win, nextFrame)
    log.d("done shift")
  end

  return m
end
