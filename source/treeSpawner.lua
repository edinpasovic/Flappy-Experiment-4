import 'trees'

local pd = playdate
local gfx = playdate.graphics

function spawnTrees()
  Tree(300, 'up', 2)
  Tree(520, 'down', 2) 
end

function clearTrees()
  local allSprites = gfx.sprite.getAllSprites()
  for index, sprite in ipairs(allSprites) do
    if sprite:isa(Tree) then
      sprite:remove()
    end
  end
end