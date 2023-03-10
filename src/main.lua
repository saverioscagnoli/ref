table.unpack = table.unpack or unpack
require("image")

function love.load()
    images = {}

    local t7 = 37 / 255
    love.graphics.setBackgroundColor(t7, t7, t7)    
end 

function love.update()
    for _, img in pairs(images) do
        img:update()
    end
end

function love.draw()
    for _, img in pairs(images) do
        img:draw()
    end
end

function love.filedropped(file)	
	local filename = file:getFilename()
	local ext = filename:match("%.%w+$")

	if ext == ".png" or ".jpg" or ".jpeg" then
		file:open("r")
		local fileData = file:read("data")
		local src = love.image.newImageData(fileData)
        local img = Image(src, love.mouse.getX(), love.mouse.getY())
        table.insert(images, img)
	end
end

function love.mousepressed(x, y, button)
    for _, img in pairs(images) do
        if button == 1 and x > img.pos.x and x < img.edge.x and y > img.pos.y and y < img.edge.y then
            img.dragging = true
            img.offset.x = x - img.pos.x
            img.offset.y = y - img.pos.y
        end
    end
end

function love.mousereleased(x, y, button)
    for _, img in pairs(images) do
        if button == 1 then
            img.dragging = false
        end
    end
end