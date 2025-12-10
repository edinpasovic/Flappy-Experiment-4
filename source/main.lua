import "Corelibs/graphics"
import "Corelibs/sprites"
import "Corelibs/animation"

import "treeSpawner"
import "player"
import "scoreDisplay"

local pd = playdate
local gfx = playdate.graphics
local screenWidth = playdate.display.getWidth()

GameSpeed = 1
GameState = "titlescreen"

--Title Screen
local titleScreen = gfx.image.new("images/wingingit.png")

function updateTitleScreen()
  assert(titleScreen) -- make sure TitleScreen image exists
  titleScreen:draw(0,0)
  -- gfx.drawText("*Press A to start the game*", 10, 210)
  if pd.buttonJustPressed(pd.kButtonA) or pd.buttonJustPressed(pd.kButtonB) then
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
    cloudSpritesArray[i].x -= GameSpeed + cloudSpeed
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
    spriteArray[i].x -= GameSpeed + speed
    if spriteArray[i].x <= -spriteWidth then
      spriteArray[i].x += screenWidth + 2 * spriteWidth
    end
    spriteArray[i].sprite:moveTo(spriteArray[i].x, spriteArray[i].y)
  end
end

spawnTrees()
local bird = Player(80, 100)

function resetGameState()
  clearTrees() -- remove previous trees
  spawnTrees() -- add trees back to initial x positions
  bird:remove()
  bird = Player(80, 100)
  resetScore()
  resetGameSpeed()
end

function playdate.update()
  if GameState == "titlescreen" then
    gfx.clear()
    updateTitleScreen()
  end
  if GameState == "gameplay" then
    gfx.sprite.update()
    moveBgSprites(roadSprites, 10, 2)
    moveBgSprites(bushSprites, 20, 2)
    moveBgSprites(forestSprites, 20, 1)
    moveClouds(smallCloudSprites, 0, 20, 90)
    moveClouds(bigCloudSprites, 0, 30, 100)
    updateScore()
  end
end