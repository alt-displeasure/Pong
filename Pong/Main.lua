push = require 'push'

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

    paddle1 = 30
    paddle2 = VIRTUAL_HEIGHT - 50

    ballX = VIRTUAL_WIDTH / 2 - 3
    ballY = VIRTUAL_HEIGHT / 2 - 3

    ballDX = math.random(2) == 1 and 100 or -100
    ballDY = math.random(-50, 50)

    gameState='start'
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        paddle1 = math.max(0, paddle1 - dt*PADDLE_SPEED)

    elseif love.keyboard.isDown('s') then
        paddle1 = math.min( VIRTUAL_HEIGHT-26, paddle1 + dt*PADDLE_SPEED)
    end

    if love.keyboard.isDown('up') then
        paddle2 = math.max(0, paddle2 - dt*PADDLE_SPEED)
    elseif love.keyboard.isDown('down') then
        paddle2 = math.min(VIRTUAL_HEIGHT-26, paddle2 + dt*PADDLE_SPEED)
    end

    if gameState == 'play' then
        ballX = ballX + ballDX*dt
        ballY = ballY + ballDY*dt
    end
end

function love.draw()
    push:apply('start')

    love.graphics.clear(34/225, 38/225, 46/225, 255)

    love.graphics.setFont(smallFont)
    love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')

    love.graphics.rectangle('fill', 10, paddle1, 5, 25)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH-10, paddle2, 5, 25)
    love.graphics.rectangle('fill', ballX, ballY, 6, 6)

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

            ballX = VIRTUAL_WIDTH / 2 - 3
            ballY = VIRTUAL_HEIGHT / 2 - 3

            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(-50, 50) * 1.5
        end
    end
end
