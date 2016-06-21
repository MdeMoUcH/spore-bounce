------------------------------------------------------------------------
-- Spore Bounce
-- Juego hecho en lua con love2d.org
-- 2014 - MdeMoUcH
-- mdemouch@gmail.com - http://www.lagranm.com
------------------------------------------------------------------------


camera = {}
camera.x = 0
camera.y = 0
camera.scaleX = 1
camera.scaleY = 1
camera.rotation = 0

function camera:set()
	love.graphics.push()
	love.graphics.rotate(-self.rotation)
	love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
	love.graphics.translate(-self.x, -self.y)
end

function camera:unset()
	love.graphics.pop()
end

function camera:move(dx, dy)
	self.x = self.x + (dx or 0)
	self.y = self.y + (dy or 0)
end

function camera:rotate(dr)
	self.rotation = self.rotation + dr
end

function camera:scale(sx, sy)
	sx = sx or 1
	self.scaleX = self.scaleX * sx
	self.scaleY = self.scaleY * (sy or sx)
end

function camera:setPosition(x, y)
	self.x = x or self.x
  self.y = y or self.y
end

function camera:setScale(sx, sy)
	self.scaleX = sx or self.scaleX
	self.scaleY = sy or self.scaleY
end




function camera:followCharacter()

	move_x = 0
	move_y = 0
	
	if character.b:getX() > camera.x+50+ventana.width/2 then
		if character.b:getX() > camera.x+ventana.width then
			--camera:move(100,0)
			move_x = 100
		elseif character.b:getX() > camera.x+ventana.width*0.7 then
			--camera:move(character.velocidad,0)
			move_x = character.velocidad
		end
	elseif character.b:getX() < camera.x-50+ventana.width/2 then
		if character.b:getX() < camera.x then
			--camera:move(-100,0)
			move_x = -100
		elseif character.b:getX() < camera.x+ventana.width*0.3 then
			--camera:move(character.velocidad,0)
			move_x = character.velocidad
		end
	end
	
	if character.b:getY() > camera.y+ventana.height/2 then
		if character.b:getY() > camera.y+ventana.width then
			--camera:move(100,0)
			move_y = -100
		elseif character.b:getY() > camera.y+ventana.height*0.8 then
			--camera:move(character.velocidad,0)
			move_y = character.velocidad_y
		end
	elseif character.b:getY() < camera.y-50+ventana.height/3 then
		if character.b:getY() < camera.y then
			--camera:move(-100,0)
			move_y = 100
		elseif character.b:getY() < camera.y+ventana.height*0.2 then
			--camera:move(character.velocidad,0)
			move_y = character.velocidad_y
		end
	end
	
	mapa.fondo.move_x = move_x
	mapa.fondo.move_y = move_y
	
	camera:move(move_x, move_y)
end

