local pd = playdate
local gfx = playdate.graphics

class('Tree').extends(gfx.sprite)

function Tree:init(x, upOrDown, velocity)
  local treeImg = gfx.image.new("images/treetrunk.png")
  assert(treeImg)
  self:setImage(treeImg)
  self:moveTo(x, treeYPos(upOrDown))
  self:add()

  self:setCollideRect(1, 2, 24, 153)
  self.velocity = velocity
  self.upOrDown = upOrDown
end

function Tree:update()
  self:moveBy(-self.velocity - GameSpeed, 0)
  if self.x < -15 then
    self:moveTo(415, treeYPos(self.upOrDown))
  end
end

function treeYPos(upOrDown)
  if upOrDown == 'up' then
    return math.random(0, 70)
  elseif upOrDown == 'down' then
    return math.random(170, 240)
  end
end