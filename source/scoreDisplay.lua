local pd = playdate
local gfx = playdate.graphics

-- local scoreSprite
-- local score

-- function createScoreDisplay()
--   scoreSprite = gfx.sprite.new()
--   score = 0
--   updateDisplay()
--   scoreSprite:setCenter(0,0)
--   scoreSprite:moveTo(0, 220)
--   scoreSprite:add()
-- end

-- function updateDisplay()
--   local scoreText = "Score: " .. score
--   local textWidth, textHeight = gfx.getTextSize(scoreText)
--   local scoreImage = gfx.image.new(textWidth, textHeight)
--   gfx.pushContext(scoreImage)
--     gfx.drawText(scoreText, 0, 0)
--   gfx.popContext()
--   scoreSprite:setImage(scoreImage)
-- end

-- function incrementScore()
--   score += 1
--   updateDisplay()
-- end

-- function resetScore()
--   score = 0
--   updateDisplay()
-- end

local score = 0

function updateScore()
  gfx.fillRoundRect(-5, 218, 88, 25, 5)
  gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
  gfx.drawText("Score: " .. score, 2, 222)
  gfx.setImageDrawMode(gfx.kDrawModeCopy)
end

function incrementScore()
  score += 1
  if score % 5 == 0 and score ~= 0 then
    incrementGameSpeed()
  end
end

function resetScore()
  score = 0
end

function incrementGameSpeed()
  GameSpeed += 1
end

function resetGameSpeed()
  GameSpeed = 1
end