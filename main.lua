local imgs = {}

function love.filedropped(file)	
	local filename = file:getFilename()
	local ext = filename:match("%.%w+$")

	if ext == ".png" or ".jpg" or ".jpeg" then
		file:open("r")
		local fileData = file:read("data")
		local src = love.image.newImageData(fileData)
        local img = {}
        local m = { love.mouse.getX(), love.mouse.getY() }
		img.src = love.graphics.newImage(src)
        img.x = m[1]
        img.y = m[2]
        img.width = img.src:getWidth()
        img.height = img.src:getHeight()
        img.dragging = false
        img.offsetX = 0
        img.offsetY = 0
        img.intX = m[1] + img.width
        img.intY = m[2] + img.height
        img.scaleX = 1
        img.scaleY = 1
        print("X: " .. img.x .. ", Y: " .. img.y)
        print("intX: " .. img.intX .. ", intY: " .. img.intY)
        table.insert(imgs, img)
	end
end

function love.wheelmoved(x, y)
    for _, img in pairs(imgs) do
        if y > 0 then
            img.scaleX = img.scaleX + 0.1
            img.scaleY = img.scaleY + 0.1
        elseif y < 0 then
            img.scaleX = img.scaleX - 0.1
            img.scaleY = img.scaleY - 0.1
            img.width = img.width - 0.1
            img.height = img.height - 0.1
            if img.scaleX < 0.1 then
                img.scaleX = 0.1
                img.scaleY = 0.1
            end
        end
    end
end
    

function love.load()
    local t7 = 37 / 255
    love.graphics.setBackgroundColor(t7, t7, t7)
    
end 

function love.update()
    for _, img in pairs(imgs) do
        if img.dragging then
            img.x = love.mouse.getX() - img.offsetX
            img.y = love.mouse.getY() - img.offsetY
            img.intX = img.x + img.width
            img.intY = img.y + img.height
        end
    end
end

function love.draw()
    for _, img in pairs(imgs) do
        love.graphics.draw(img.src, img.x, img.y, nil, img.scaleX, img.scaleY)
    end
end

function love.mousepressed(x, y, button)
    for _, img in pairs(imgs) do
        if button == 1 and x > img.x and x < img.intX and y > img.y and y < img.intY then
            img.dragging = true
            img.offsetX = x - img.x
            img.offsetY = y - img.y
        end
    end
end

function love.mousereleased(x, y, button)
    for _, img in pairs(imgs) do
        if button == 1 then
            img.dragging = false
        end
    end
end