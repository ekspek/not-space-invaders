local state = require 'state'

return function()
    local entity = {
        fps = 0,
    }
    
    entity.update = function(self, dt)
        self.fps = math.floor(1/dt)
    end
    
    entity.draw = function(self)
        love.graphics.setColor(1,1,1,1)
        love.graphics.print("fps = " .. self.fps, 0, love.graphics.getHeight() - 15)
        love.graphics.print("frame = " .. state.frame_double, 0, love.graphics.getHeight() - 30)
        love.graphics.print("invaders = " .. state.invader.count, 0, love.graphics.getHeight() - 45)
        love.graphics.print("direction = " .. state.invader.direction, 0, love.graphics.getHeight() - 60)
    end
    
    return entity
end
