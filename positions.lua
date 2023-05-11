return function(ctx)
  local m = {}

  function m:configure(screen, frame)
    local columns = ctx.COLUMNS
    local rows = ctx.ROWS

    ctx.log.d("screen:", screen)
    ctx.log.d("frame:", frame)
    ctx.log.d("Columns:", columns)
    ctx.log.d("Rows:", rows)
    hs.grid.setGrid(hs.geometry.size(columns, rows), screen, frame)
  end

  function m:generate(frame)
    local MENU_HEIGHT = ctx.MENU_HEIGHT
    local columns = ctx.COLUMNS
    local rows = ctx.ROWS

    ctx.log.d("screen:", frame)
    ctx.log.d("width:", frame.w)
    ctx.log.d("height:", frame.h)
    local colBreak = frame.w / columns
    local halfScreen = frame.w / 2
    ctx.log.d("colBreak:", colBreak)
    local positions = {
      left = { },
      right = { },
    }

    -----------------------------
    -- Set LEFT position
    -----------------------------
    ctx.log.d("GENERATING LEFT POSITIONS")
    local leftColLimit = (columns / 2) - 1
    for col = 0, leftColLimit do
      local startX = colBreak * col
      local leftRect = hs.geometry.rect(startX, MENU_HEIGHT, colBreak, frame.h)
      positions["left"][col] = leftRect
      for row = 0, rows - 1 do
        local key = string.format("row%dleft", row)
        if (positions[key] == nil) then positions[key] = {} end

        local rect = hs.geometry.rect(
          startX,
          MENU_HEIGHT + ((frame.h / rows) * row),
          colBreak,
          frame.h / rows
        )
        positions[key][col] = rect
      end
    end
    -----------------------------
    --- Set LEFT _full_/_third_ position
    -----------------------------
    local fullLeftRect = hs.geometry.rect(0.0, MENU_HEIGHT, halfScreen, frame.h)
    local thirdLeftRect = hs.geometry.rect(
      0.0,
      MENU_HEIGHT,
      (halfScreen) * (2 / 3),
      frame.h
    )
    positions["left"][#positions["left"] + 1] = thirdLeftRect
    positions["left"][#positions["left"] + 1] = fullLeftRect

    for row = 0, rows - 1 do
      local key = string.format("row%dleft", row)
      -- Create full section, half screen ROW
      local fullRect = hs.geometry.rect(
        0.0,
        MENU_HEIGHT + ((frame.h / rows) * row),
        halfScreen,
        frame.h / rows
      )
      -- Create third section, half screen ROW
      local thirdRect = hs.geometry.rect(
        0.0,
        MENU_HEIGHT + ((frame.h / rows) * row),
        (halfScreen) * (2 / 3),
        frame.h / rows
      )
      positions[key][#positions[key] + 1] = thirdRect
      positions[key][#positions[key] + 1] = fullRect
    end

    -----------------------------
    -- Set RIGHT position
    -----------------------------
    ctx.log.d("GENERATING RIGHT POSITIONS")
    local rightColLimit = columns / 2

    -- col = 2, col = 3
    -- idx = 0, idx = 1
    -- dif = 2, dif = 2
    for col = (columns - 1), rightColLimit, -1 do
      -- if COLUMNS was 6
      -- col = 5, col = 4, col = 3
      -- idx = 0, idx = 1, idx = 2
      -- dif = 5, dif = 3, dif = 1
      -- C'  = 5, C'  = 5, C'  = 5
      -- C'c = 0, C'c = 1, C'c = 2
      local index = (columns - 1) - col
      local startX = colBreak * col
      local rightRect = hs.geometry.rect(startX, MENU_HEIGHT, colBreak, frame.h)
      positions["right"][index] = rightRect
      for row = 0, rows - 1 do
        local key = string.format("row%dright", row)
        if (positions[key] == nil) then positions[key] = {} end

        local rect = hs.geometry.rect(
          startX,
          MENU_HEIGHT + ((frame.h / rows) * row),
          colBreak,
          frame.h / rows
        )
        positions[key][index] = rect
      end
    end
    -----------------------------
    --- Set RIGHT _full_/_third_ position
    -----------------------------
    local fullRightStart = halfScreen
    local fullRightRect = hs.geometry.rect(
      halfScreen,
      MENU_HEIGHT,
      halfScreen,
      frame.h
    )
    local thirdRightRect = hs.geometry.rect(
      fullRightStart + ((halfScreen) * (1 / 3)),
      MENU_HEIGHT,
      (halfScreen) * (2 / 3),
      frame.h
    )
    positions["right"][#positions["right"] + 1] = thirdRightRect
    positions["right"][#positions["right"] + 1] = fullRightRect

    for row = 0, rows - 1 do
      local key = string.format("row%dright", row)
      -- Create full section, half screen ROW
      local fullRect = hs.geometry.rect(
        fullRightStart,
        MENU_HEIGHT + ((frame.h / rows) * row),
        halfScreen,
        frame.h / rows
      )
      -- Create third section, half screen ROW
      local thirdRect = hs.geometry.rect(
        fullRightStart + ((halfScreen) * (1 / 3)),
        MENU_HEIGHT + ((frame.h / rows) * row),
        (halfScreen) * (2 / 3),
        frame.h / rows
      )
      positions[key][#positions[key] + 1] = thirdRect
      positions[key][#positions[key] + 1] = fullRect
    end

    -----------------------------
    -- Set CENTER position
    -----------------------------
    local horizontalCenter = frame.w / 2
    local verticalCenter = (frame.h / 2) + MENU_HEIGHT
    ctx.log.d("coords:", horizontalCenter, verticalCenter)
    local centerPoint = hs.geometry.point(horizontalCenter, verticalCenter)
    positions["center"] = centerPoint

    -----------------------------
    -- Set FULL position
    -----------------------------
    local fullScreenRect = hs.geometry.rect(0.0, MENU_HEIGHT, frame.w, frame.h)
    positions["full"] = fullScreenRect

    return positions
  end

  return m
end
