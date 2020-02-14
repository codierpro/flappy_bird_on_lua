Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')

function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH + 64
    self.y = y
    self.orientation = orientation
    self.scored = false
end

function Pipe:update(dt)
    
end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, math.floor(self.x + 0.5), math.floor((self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y) + 0.5), 
        0, 1, self.orientation == 'top' and -1 or 1)
end