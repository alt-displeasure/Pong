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

    love.window.setTitle('Pong')

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

    fps = 'not show'

    gameState='start'
end

function love.update(dt)

    if gameState == 'play' then
        if ball:collides(paddle1) then
            ball.dx = -ball.dx * 1.03
            ball.x = paddle1.x + paddle1.width

            if ball.dy < 0 then
                ball.dy = -math.random(10,150)
            else
                ball.dy = math.random(10,150)
            end
        end

        if ball:collides(paddle2) then
            ball.dx = -ball.dx * 1.03
            ball.x = paddle2.x - ball.width

            if ball.dy < 0 then
                ball.dy = -math.random(10,150)
            else
                ball.dy = math.random(10,150)
            end
        end

        if ball.y >= VIRTUAL_HEIGHT - ball.height then
            ball.y = VIRTUAL_HEIGHT - ball.height
            ball.dy = -ball.dy
        end

        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
        end
    end

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

    love.graphics.print(tostring(p1score), VIRTUAL_WIDTH / 2 - 80, 40)
    love.graphics.print(tostring(p2score), VIRTUAL_WIDTH / 2 + 60, 40)

    if fps == 'show' then
        displayFPS()
    end

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
    if key == 'f' then
        if fps == 'not show' then
            fps = 'show'
        else
            fps = 'not show'
        end
    end
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255/255, 0, 255/255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end