local pd = playdate
local gfx = playdate.graphics

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

function getScore()
  return score
end

-- function saveHighScore(num)
--   pd.datastore.write({highScore = num})
-- end

-- function resetHighScore()
--   local menu = pd.getSystemMenu()
--   menu:addMenuItem("reset score", function()
--     pd.datastore.write({highScore = 0})
--   end)
-- end

-- function checkHighScore()
--   if score > highScore then
--     highScore = score
--     saveHighScore(score)
--   end
-- end