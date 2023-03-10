function Anchor(x, y, imgW, imgH, n)
  local anchor = {}
  local dims = 7
  local offset = dims * 0.5

  anchor.pos = { x = x, y = y }
  anchor.edge = { x = x + dims, y = y + dims }

  function anchor:update(newX, newY)
    self:set_pos(newX, newY)
  end

  function anchor:draw()
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, dims, dims)
  end

  function anchor:set_pos(newX, newY)
    if n == 1 then
      self.pos.x = newX - offset
      self.pos.y = newY - offset
    elseif n == 2 then
      self.pos.x = newX + imgW - offset
      self.pos.y = newY - offset
    elseif n == 3 then
      self.pos.x = newX - offset
      self.pos.y = newY + imgH - offset
    else
      self.pos.x = newX + imgW - offset
      self.pos.y = newY + imgH - offset
    end
    self.edge.x = self.pos.x + dims
    self.edge.y = self.pos.y + dims
  end
 
  return anchor
end

function Image(src, x, y)
  local img = {}
  local line_color = { 56 / 255, 178 / 255, 172 / 255 }
  local line_thickness = 2

  img.src = love.graphics.newImage(src)
  img.pos = { x = x, y = y }
  img.width = img.src:getWidth()
  img.height = img.src:getHeight()
  img.dragging = false
  img.offset = { x = 0, y = 0 }
  img.edge = { x = x + img.width, y = y + img.height }
  img.scale = { x = 1, y = 1 }
  img.anchors = {  
    Anchor(x, y, img.width, img.height, 1),
    Anchor(x, y, img.width, img.height, 2),
    Anchor(x, y, img.width, img.height, 3),
    Anchor(x, y, img.width, img.height, 4)
  }

  function img:update()
    if img.dragging then
      img.pos.x = love.mouse.getX() - img.offset.x
      img.pos.y = love.mouse.getY() - img.offset.y
      img.edge.x = img.pos.x + img.width
      img.edge.y = img.pos.y + img.height
    end

    local cursor = love.mouse.getSystemCursor("arrow")
    love.mouse.setCursor(cursor)

    for i = 1, 4 do
      local a = self.anchors[i]
      local mX, mY = love.mouse.getPosition()
      a:update(self.pos.x, self.pos.y)

      local collX = a.pos.x < mX and mX < a.edge.x
      local collY = a.pos.y < mY and mY < a.edge.y

      if collX and collY then
        cursor = love.mouse.getSystemCursor("hand")
        love.mouse.setCursor(cursor)
      end

    end
  end

  function img:draw()
    love.graphics.draw(self.src, self.pos.x, self.pos.y, nil, self.scale.x, self.scale.y)
    love.graphics.setColor(table.unpack(line_color))
    love.graphics.setLineWidth(line_thickness)
    love.graphics.rectangle("line", self.pos.x, self.pos.y, self.width, self.height)
    for i = 1, 4 do
      local a = self.anchors[i]
      a:draw()
    end
    love.graphics.setColor(1, 1, 1)
  end

  return img
end

