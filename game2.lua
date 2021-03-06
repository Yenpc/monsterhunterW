-----------------------------------------------------------------------------------------
--
-- Unit5.1
--這章會將整個結構幾乎大改,我們先將需要的函式庫以及自字型檔之類的直接放到最前端
-----------------------------------------------------------------------------------------

--呼叫composer函式庫
local composer = require( "composer" )
collectgarbage("collect")
local bgm = audio.loadSound ("fd2.mp3")
local bgm2 = audio.loadSound ("coronamenu.mp3")
audio.stop(2)
local playBgm = audio.play(bgm,{channel=1,loops=-1,fadeim=1000})

--導入土星
local sheetInfo = require("saturn")

--呼叫BitmapFont函式庫
local BFont = require("BitmapFont")
--導入字型
local titleFont = BFont.new("GameTitle.png")
local menuFont = BFont.new("Menu.png")
--創建新場景
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
-- 然後將一些公共參數先打出來
-- -----------------------------------------------------------------------------------
--設定Ｘ中心點
local centerX = display.contentCenterX
--設定Ｙ中心點
local centerY = display.contentCenterY
--建立background群組
local backgroundGroup = display.newGroup()
--建立menu群組
local menu=display.newGroup()
--建立layer群組
local layerGroup = display.newGroup()
--定義計時器
local tPrevious = system.getTimer()

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
-- -----------------------------------------------------------------------------------
-- 這里以下才是場景開始時要出現的畫面
-- -----------------------------------------------------------------------------------
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
   
    local layer1 = display.newImageRect( "100.png", 480, 320 )
    local layer2 = display.newImageRect( "100.png", 480, 320 )
       layer1.anchorX = 0
       layer1.x = 0
       layer1.y = centerY
       layer1.speed = 0
       layer2.anchorX = 0
       layer2.x = 480
       layer2.y=centerY
       layer2.speed = 0
       layerGroup:insert(display.newGroup(layer1,layer2))
       sceneGroup:insert(layerGroup)  

    --土星
    

    --標題Ｘ位置,Ｙ位置,內容
    title = titleFont:newBitmapString(centerX,0, "   " )
  
    sceneGroup:insert(title)
    
    --Menu
    
    local menuPlay= menuFont:newBitmapString(0,centerY*9.9, "play game" )
    menuPlay.name="play game"
    local menuUse= menuFont:newBitmapString(0,centerY*9.9, "Use menu")
    menuUse.name ="Use menu"
    local menuExit= menuFont:newBitmapString(140,centerY*1.9, "backmenu" )
    menuExit.name="exit game"

    menu:insert(menuPlay)--menu群組加入menuPlay
    menu:insert(menuUse)
    menu:insert(menuExit)--menu群組加入menuExit
    
    sceneGroup:insert(menu)
end --這個end是scene:create的
-- -----------------------------------------------------------------------------------
-- 然後將移動function寫在場景以外的部分
-- -----------------------------------------------------------------------------------
--設置移動功能
local function move(event)
    local tDelta = event.time - tPrevious
    tPrevious = event.time
local i
--背景的移動功能,並檢測背景是否完全超出左側螢幕,如果是擇立即移動到畫面右側螢幕
    for i = 1, backgroundGroup.numChildren do
        backgroundGroup[i][1].x = backgroundGroup[i][1].x - backgroundGroup[i][1].speed / 10*tDelta
        backgroundGroup[i][2].x = backgroundGroup[i][2].x - backgroundGroup[i][2].speed / 10*tDelta
        if (backgroundGroup[i][1].x +backgroundGroup[i][1].contentWidth) < 0 then
            backgroundGroup[i][1]:translate( 480 * 2, 0)
        end
         if (backgroundGroup[i][2].x +backgroundGroup[i][2].contentWidth) < 0 then
            backgroundGroup[i][2]:translate( 480 * 2, 0)
        end     
    end
    for i = 1, layerGroup.numChildren do
        layerGroup[i][1].x =layerGroup[i][1].x-layerGroup[i][1].speed /10*tDelta
        layerGroup[i][2].x =layerGroup[i][2].x-layerGroup[i][2].speed /10*tDelta
        if (layerGroup[i][1].x +layerGroup[i][1].contentWidth) < 0 then
            layerGroup[i][1]:translate( 480 * 2, 0)

        end
        if (layerGroup[i][2].x +layerGroup[i][2].contentWidth) < 0 then
            layerGroup[i][2]:translate( 480 * 2, 0)

        end
    end
 end
-- -----------------------------------------------------------------------------------
-- 5.2新增換場景的功能
-- -----------------------------------------------------------------------------------
--換場景的功能
local function changeScene3()
  print("changeScene3")
  audio.stop(1)
  playBgm = audio.play(bgm2,{channel=2,loops=-1,fadeim=1000})
   composer.gotoScene("game_menu",{effect ="fade",time=400})
 --變換場景至game
end

local function changeScene2()
  print("changeScene2")
   composer.gotoScene("game2",{effect ="fade",time=400}) --變換場景至game
end

local function changeScene()
  print("changeScene")
   composer.gotoScene("game",{effect ="fade",time=400}) --變換場景至game
end
local function removExplode( obj )
    return function()
    obj:removeSelf() 
    obj=nil
    --print("explosionGroup numChildren".. explosionGroup.numChildren)
end 
end
local function explode( x,y )
    local explosionOptions =
    {   
        width = 55,
        height = 55,
        numFrames = 15,
        sheetContentWidth = 825,  
        sheetContentHeight = 55  
    }
    local explosionSheet = graphics.newImageSheet( "explosion1.png", explosionOptions )
    local explosion = display.newSprite( explosionSheet, { name="explosion", start=1, count=15, time=1000 ,loopCount = 1 } )
    explosion.blendMode = "add"
    explosion.x=x
    explosion.y=y
    explosion:play()
    explosionGroup:insert(explosion)
    --print("explosionGroup numChildren".. explosionGroup.numChildren)
    audio.play( sounds.explosion )
math.random (-500, -100)
end
local function onCollision( event )
    if ( event.phase == "began" ) then
            if  event.object1.name == "enemy" and event.object2.name == "bullet"  then

                --子彈碰到敵人,敵人消失
                print( "began: " .. event.object1.name .. " and " .. event.object2.name )
                removeBullet(event.object1) 
                
                --消失同時呼叫爆炸，爆炸位置=敵人消失位置
                local x,y =event.object1.x,event.object1.y
                explode(x,y)
                score = score + 50
                scoreText.text = score
                if score > 50 then changeScene()
                end
                

                 
                 
            end

    end
end
--觸碰事件
local function menuTouch(event)
  if event.phase=="began" then
    print("touch_"..event.target.name)
    if event.target.name == "play game" then
      --追加下列這行會在點擊play後,將play移走然後呼叫換場景的功能
      transition.to(menu,  {time = 400, x = 480+event.target.contentWidth/2,onComplete = changeScene})
    elseif event.target.name == "Use menu" then
      transition.to(menu,  {time= 400, x = 480+event.target.contentWidth/2,onComplete = changeScene2})
    elseif
      event.target.name == "exit game" then
      transition.to(menu,  {time= 400, x = 480+event.target.contentWidth/2,onComplete = changeScene3})
    end
    for i = 1, menu.numChildren do
          --新增這條以避免重複點擊
          menu[i]:removeEventListener("touch",menuTouch)
        end
  end
end

--將menu群組中的兩個圖(menuPlay,menuExit)加上touch監聽事件
local function addTouch( )
  for i = 1, menu.numChildren do
          menu[i]:addEventListener("touch",menuTouch)
    end
end


-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        Runtime:addEventListener( "enterFrame", move )
        transition.to(title,  {time = 400, y = centerY*0.6})
        --將menu群組的x座標移往centerX,移動完成呼叫addTouch函式
        transition.to(menu,  {time = 400, x = centerX,onComplete = addTouch})
    elseif ( phase == "did" ) then

        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        Runtime:removeEventListener( "enterFrame", move )
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    print("destroy_menu")
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene


