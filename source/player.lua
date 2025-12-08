local pd = playdate
local gfx = playdate.graphics

class('Player').extends(gfx.sprite)

function Player:init(x, y)
  Player.super.init(self)
  local birdImg = gfx.image.new("images/bird.png")
  assert(birdImg)
  self:setImage(birdImg)
  self:moveTo(x, y)
  self:add()

  self:setCollideRect(2, 2, 18, 18)
  self.velocity = 0
end

function Player:update()
  -- controls
  local crankChange, _ = pd.getCrankChange()
  self.velocity -= crankChange * 0.05
  if self.velocity > 12 then
    self.velocity = 12
  elseif self.velocity < -12 then
    self.velocity = -12
  end
  self:moveBy(0, self.velocity)
  if self.y < 10 then
    self.velocity = 0
    self:moveTo(80, 10)
  elseif self.y > 230 then
    self.velocity = 0
    self:moveTo(80, 230)
  end

  --checking for collisions
  local _actualX, _actualY, _collisions, length = self:checkCollisions(self.x, self.y)
  if length > 0 then
    GameState = "titlescreen"
    resetGameState()
  end
end