push = require 'push'
Class = require 'class'

require 'Paddle'
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    smallFont = love.graphics.newFont('font.ttf', 8)
    scoreFont = love.graphics.newFont('font.ttf',32)

    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true,
    })

    p1score = 0
    p2score = 0

    paddle1 = Paddle(10, 30, 5, 25)
    paddle2 = Paddle(VIRTUAL_WIDTH-10, VIRTUAL_HEIGHT - 30, 5, 25)

    ball = Ball(VIRTUAL_WIDTH/2 - 3, VIRTUAL_HEIGHT/2 - 3, 6, 6)

    gameState='start'
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        paddle1.dy = -PADDLE_SPEED

    elseif love.keyboard.isDown('s') then
        paddle1.dy = PADDLE_SPEED
    else
        paddle1.dy = 0
    end

    if love.keyboard.isDown('up') then
        paddle2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        paddle2.dy = PADDLE_SPEED
    else
        paddle2.dy = 0
    end

    if gameState == 'play' then
        ball:update(dt)
    end

    paddle1:update(dt)
    paddle2:update(dt)
end

function love.draw()
    push:apply('start')

    love.graphics.clear(34/225, 38/225, 46/225, 255)

    love.graphics.setFont(smallFont)
    love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')

    paddle1:render()
    paddle2:render()
    
    ball:render()

    love.graphics.setFont(scoreFont)

    love.graphics.print(tostring(p1score), VIRTUAL_WIDTH / 2 - 80, 
        40)
    love.graphics.print(tostring(p2score), VIRTUAL_WIDTH / 2 + 60,
        40)

    push:apply('end')           
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'
            ball:reset()
        end
    end
end
