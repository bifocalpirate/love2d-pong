function love.conf(t)    
    t.title = "Pong"
    t.version = "11.5"              -- LOVE version compatibility
    t.window.width = 800
    t.window.height = 600
    t.window.resizable = false
    t.window.vsync = 1
    t.window.msaa = 4               -- Anti-aliasing samples
    t.window.fullscreen = false
    t.window.fullscreentype = "desktop"
    
    -- Modules (disable unused ones for performance)
    t.modules.joystick = false
    t.modules.physics = false
    t.modules.audio = false
    t.modules.video = false          -- Disable if not needed
end