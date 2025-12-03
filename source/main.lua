import "Corelibs/graphics"
import "Corelibs/sprites"
import "Corelibs/animation"

gfx = playdate.graphics
screenWidth = playdate.display.getWidth()
screenHeight = playdate.display.getHeight()

local gameSpeed = 1
GameState = "titlescreen"

--Title Screen
local titleScreen = gfx.image.new("images/title-page.png")

function updateTitleScreen()
  assert(titleScreen) -- make sure TitleScreen image exists
  titleScreen:draw(0,0)
  gfx.drawText("*Press A to start the game*", 10, 210)
  if playdate.buttonJustPressed(playdate.kButtonA) or playdate.buttonJustPressed(playdate.kButtonB) then
    GameState = "gameplay"
  end
end

--Big Cloud sprite
local bigCloudImg = gfx.image.new("images/bg-bigcloud.png")
assert(bigCloudImg)
local bigCloudSpr = gfx.sprite.new(bigCloudImg)
local bigCloudSprites = {}
for i = 1, 3 do
  local bigCloudSprite = {
    x = 130 * i - 70,
    y = math.random(30, 100),
    sprite = bigCloudSpr:copy()
  }
  table.insert(bigCloudSprites, bigCloudSprite)
end
for i = 1, #bigCloudSprites do
  bigCloudSprites[i].sprite:moveTo(bigCloudSprites[i].x, bigCloudSprites[i].y)
  bigCloudSprites[i].sprite:add()
end

--Small Cloud sprite
local smallCloudImg = gfx.image.new("images/bg-smallcloud.png")
assert(smallCloudImg)
local smallCloudSpr = gfx.sprite.new(smallCloudImg)
local smallCloudSprites = {}
for i = 1, 3 do
  local smallCloudSprite = {
    x = 130 * i - 10,
    y = math.random(20, 90),
    sprite = smallCloudSpr:copy()
  }
  table.insert(smallCloudSprites, smallCloudSprite)
end
for i = 1, #smallCloudSprites do
  smallCloudSprites[i].sprite:moveTo(smallCloudSprites[i].x, smallCloudSprites[i].y)
  smallCloudSprites[i].sprite:add()
end

--move clouds
function moveClouds(cloudSpritesArray, cloudSpeed, randomUp, randomDown)
  for i = 1, #cloudSpritesArray do
    cloudSpritesArray[i].x -= gameSpeed + cloudSpeed
    if cloudSpritesArray[i].x == - 10 then
      cloudSpritesArray[i].x += 430
      cloudSpritesArray[i].y = math.random(randomUp, randomDown)
    end
    cloudSpritesArray[i].sprite:moveTo(cloudSpritesArray[i].x, cloudSpritesArray[i].y)
  end
end

--Forest background sprite
local forestBgImg = gfx.image.new("images/bg-forest.png")
assert(forestBgImg)
local forestBgSpr = gfx.sprite.new(forestBgImg)
local forestSprites = {}
for i = 1, 11 do
  local forestSprite = {
    x = 40 * i - 20,
    y = 180,
    sprite = forestBgSpr:copy()
  }
  table.insert(forestSprites, forestSprite)
end
for i = 1, #forestSprites do
  forestSprites[i].sprite:moveTo(forestSprites[i].x, forestSprites[i].y)
  forestSprites[i].sprite:add()
end

--Bush background sprite
local bushBgImg = gfx.image.new("images/bg-bushes.png")
assert(bushBgImg)
local bushBgSpr = gfx.sprite.new(bushBgImg)
local bushSprites = {}
for i = 1, 11 do
  local bushSprite = {
    x = 40 * i - 20,
    y = 210,
    sprite = bushBgSpr:copy()
  }
  table.insert(bushSprites, bushSprite)
end
for i = 1, #bushSprites do
  bushSprites[i].sprite:moveTo(bushSprites[i].x, bushSprites[i].y)
  bushSprites[i].sprite:add()
end

--Road background sprites
local roadBgImg = gfx.image.new("images/bg-road.png")
assert(roadBgImg)
local roadBgSpr = gfx.sprite.new(roadBgImg)
local roadSprites = {}
--create a row of 21 road sprites
for i=1, 21 do
  local roadSprite = {
    x = 20*i - 10,
    y = 230,
    sprite = roadBgSpr:copy()
  }
  table.insert(roadSprites, roadSprite)
end
for i = 1, #roadSprites do
  roadSprites[i].sprite:moveTo(roadSprites[i].x, roadSprites[i].y)
  roadSprites[i].sprite:add()
end

--Move road, bushes, forest
function moveBgSprites(spriteArray, spriteWidth, speed)
  for i = 1, #spriteArray do
    spriteArray[i].x -= gameSpeed + speed
    if spriteArray[i].x <= -spriteWidth then
      spriteArray[i].x += screenWidth + 2 * spriteWidth
    end
    spriteArray[i].sprite:moveTo(spriteArray[i].x, spriteArray[i].y)
  end
end

--Trees
local treeImg = gfx.image.new("images/treetrunk.png")
assert(treeImg)
--Upper Tree
local upperTree = gfx.sprite.new(treeImg)
upperTree:setCollideRect(1, 2, 24, 153)
upperTree:moveTo(300, math.random(0,70))
upperTree:add()
--Lower Tree
local lowerTree = gfx.sprite.new(treeImg)
lowerTree:setCollideRect(1, 2, 24, 153)
lowerTree:moveTo(520, math.random(170, screenHeight))
lowerTree:add()

--Move Trees
function moveTrees(tree, randomUp, randomDown)
  tree:moveBy(-2 - gameSpeed, 0)
  if tree.x <= -15 then
    tree:moveTo(415, math.random(randomUp, randomDown))
  end
end

--Player
local birdImage = gfx.image.new("images/bird.png")
local birdSprite = gfx.sprite.new(birdImage)

local birdVelocity = 0
local bird = birdSprite:copy()
bird:setCollideRect(2,2,18,18)
bird:moveTo(80, 100)
bird:add()

function updateBird()
  local crankChange, _ = playdate.getCrankChange()
  birdVelocity -= crankChange * 0.05
  if birdVelocity > 12 then
    birdVelocity = 12
  elseif birdVelocity < -12 then
    birdVelocity = -12
  end
  bird:moveBy(0, birdVelocity)
  if bird.y < 10 then
    birdVelocity = 0
    bird:moveTo(80, 10)
  elseif bird.y > 230 then
    birdVelocity = 0
    bird:moveTo(80, 230)
  end
  --checking for collisions
  local _actualX, _actualY, _collisions, length = bird:checkCollisions(bird.x, bird.y)
  if length > 0 then
    GameState = "titlescreen"
    resetGameState()
  end
end

function resetGameState()
  bird:moveTo(80, 100)
  birdVelocity = 0
  upperTree:moveTo(300, math.random(0,70))
  lowerTree:moveTo(520, math.random(170, screenHeight))
end

function playdate.update()
  if GameState == "titlescreen" then
    gfx.clear()
    updateTitleScreen()
  end
  if GameState == "gameplay" then
    gfx.clear()
    gfx.sprite.update()
    moveBgSprites(roadSprites, 10, 2)
    moveBgSprites(bushSprites, 20, 2)
    moveBgSprites(forestSprites, 20, 1)
    moveClouds(smallCloudSprites, 0, 20, 90)
    moveClouds(bigCloudSprites, 0, 30, 100)
    moveTrees(upperTree, 0, 70)
    moveTrees(lowerTree, 170, screenHeight)
    updateBird()
  end
end