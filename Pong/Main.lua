push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

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

    paddle1 = 30
    paddle2 = VIRTUAL_HEIGHT - 50
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        paddle1 = paddle1 - dt*PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        paddle1 = paddle1 + dt*PADDLE_SPEED
    end

    if love.keyboard.isDown('up') then
        paddle2 = paddle2 - dt*PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        paddle2 = paddle2 + dt*PADDLE_SPEED
    end
end

function love.draw()
    push:apply('start')

    love.graphics.clear(34/225, 38/225, 46/225, 255)
    love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')
    love.graphics.rectangle('fill', 10, paddle1, 5, 20)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH-10, paddle2, 5, 20)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH/2 - 2, VIRTUAL_HEIGHT/2 - 2, 4, 4)

    push:apply('end')           
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end
