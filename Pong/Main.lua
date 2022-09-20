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
    largeFont = love.graphics.newFont('font.ttf', 16)

    love.graphics.setFont(smallFont)

    sounds = {
        ['paddle_hit'] = love.audio.newSource('sound/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sound/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sound/wall_hit.wav', 'static')
    }

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true,
    })

    p1score = 0
    p2score = 0

    servingPlayer = 1

    winner = 0

    paddle1 = Paddle(10, 30, 5, 25)
    paddle2 = Paddle(VIRTUAL_WIDTH-10, VIRTUAL_HEIGHT - 30, 5, 25)

    ball = Ball(VIRTUAL_WIDTH/2 - 3, VIRTUAL_HEIGHT/2 - 3, 6, 6)

    fps = 'not show'

    gameState='start'
end

function love.update(dt)
    
    if gameState == 'serve' then
        ball.dy = math.random(-50,50)
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end

    elseif gameState == 'play' then

        if ball:collides(paddle1) then
            ball.dx = -ball.dx * 1.03
            ball.x = paddle1.x + paddle1.width
            sounds['paddle_hit']:play()

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
            sounds['paddle_hit']:play()
        end

        if ball.y >= VIRTUAL_HEIGHT - ball.height then
            ball.y = VIRTUAL_HEIGHT - ball.height
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end
    

        if ball.x < 0 then
            p2score = p2score + 1
            servingPlayer = 2
            sounds['score']:play()
            if p2score == 10 then
                winner = 2
                gameState = 'done'
            else
                ball:reset()
                gameState = 'serve'
            end
        end

        if ball.x > VIRTUAL_WIDTH then
            p1score = p1score + 1
            servingPlayer = 1
            sounds['score']:play()
            if p1score == 10 then
                winner = 1
                gameState = 'done'
            else
                ball:reset()
                gameState = 'serve'
            end
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

    paddle1:render()
    paddle2:render()
    
    ball:render()

    displayScore()

    if fps == 'show' then
        displayFPS()
    end

    if gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.setColor(255/255, 255/255, 255/255, 255)
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. ' serves', 0, VIRTUAL_HEIGHT - 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.setColor(255/255, 255/255, 255/255, 255)
        love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin', 0, 30, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'done' then
        love.graphics.setFont(largeFont)
        love.graphics.setColor(255/255, 255/255, 255/255, 255)
        love.graphics.printf('Player '..tostring(winner)..' wins!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to restart', 0, 30, VIRTUAL_WIDTH, 'center')
    end

    push:apply('end')           
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'play' then
            gameState = 'serve'
            ball:reset()
        elseif gameState == 'done' then
            gameState = 'serve'
            ball:reset()

            p1score = 0
            p2score = 0

            if winner == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        else
            gameState = 'play'
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

function displayScore()
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(p1score), VIRTUAL_WIDTH / 2 - 80, 40)
    love.graphics.print(tostring(p2score), VIRTUAL_WIDTH / 2 + 60, 40)
end

function love.resize(w, h)
    push:resize(w, h)
end