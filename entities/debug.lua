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
    end
    
    return entity
end
