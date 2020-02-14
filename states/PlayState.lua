PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 430

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
    self.score = 0
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    if self.timer > 2 then

        local y = math.max(-PIPE_HEIGHT + 10, math.min(self.lastY + math.random(-20, 20), PIPE_HEIGHT / 3))

        table.insert(self.pipePairs, {
            scored = false,
            pipes = {
                Pipe('top', y),
                Pipe('bottom', y + PIPE_HEIGHT + 90)
            }
        })

        -- reset timer
        self.timer = 0
    end

    for k, pair in pairs(self.pipePairs) do
        local doRemove = false

        for l, pipe in pairs(pair.pipes) do
            if not pair.scored then
                if pipe.x + PIPE_WIDTH < self.bird.x then
                    self.score = self.score + 1
                    pair.scored = true
                    sounds['score']:play()
                end
            end

            if pipe.x > -72 then
                pipe.x = pipe.x - PIPE_SPEED * dt
            else
                doRemove = true
            end
        end

        if doRemove then
            table.remove(self.pipePairs, k)
        end
    end

    self.timer = self.timer + dt

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('title')
    end

    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if (self.bird.x + 2) + (BIRD_WIDTH - 4) >= pipe.x and self.bird.x + 2 <= pipe.x + PIPE_WIDTH then
                if (self.bird.y + 2) + (BIRD_HEIGHT - 4) >= pipe.y and self.bird.y + 2 <= pipe.y + PIPE_HEIGHT then
                    sounds['explosion']:play()
                    sounds['hurt']:play()

                    gStateMachine:change('score', {
                        score = self.score
                    })
                end
            end
        end
    end

    -- reset if we get to the ground
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        gStateMachine:change('score', {
            score = self.score
        })
    end

    self.bird:update(dt)
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            pipe:render()
        end
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()
end

function PlayState:enter()
    scrolling = true
end

function PlayState:exit()

    scrolling = false
end