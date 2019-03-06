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
        love.graphics.print("fps = " .. self.fps)
        love.graphics.print("second = " .. state.second, 0, 10)
    end
    
    return entity
end
