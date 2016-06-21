------------------------------------------------------------------------
-- Spore Bounce
-- Juego hecho en lua con love2d.org
-- 2014 - MdeMoUcH
-- mdemouch@gmail.com - http://www.lagranm.com
------------------------------------------------------------------------


mapa = {}
mapa.cuadro = 32


function mapa:cargar(level, mundo_actual)
  
	world = love.physics.newWorld(0, 25.81*64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
	
	--mundo = mundo:cargarmapa(level)
	
	mundo = mapa:cargar_mundo(mundo_actual)
	
	loader.path = "worlds/"..mundo.num.."/"
	mundo.map = loader.load("map"..level..".tmx")
	
	map = mundo.map
	
	mapa:procesar("platform")
	mapa:procesar("efecto")
	mapa:procesar("muerte")
	
	b_halo = true
	mapa:procesar("flag")
	
	mapa.fondo = mundo.fondo
	mapa.fondo.pos = 0
	mapa.fondo.pos_y = 0
	mapa.fondo.move_x = 0
	mapa.fondo.move_y = 0
	
	mapa.fondo.pos_1 = 0
	mapa.fondo.pos_2 = 0
	mapa.fondo.pos_3 = 0
	mapa.fondo.move_x_1 = 0
	
	mapa.fondo.pos_y_1 = 0
	mapa.fondo.pos_y_2 = 0
	mapa.fondo.pos_y_3 = 0
	
  
	--mapa:cargar_bandera()
    
end 



function mapa:cargar_mundo(i_mundo)

	mundo = {}
	mundo.num = i_mundo
	mundo.fondo = {}
	mundo.fondo.img = love.graphics.newImage("worlds/"..i_mundo.."/background.jpg")
	mundo.fondo.img_2 = love.graphics.newImage("worlds/"..i_mundo.."/parallax1.png")
	mundo.fondo.img_3 = love.graphics.newImage("worlds/"..i_mundo.."/parallax2.png")
	mundo.fondo.img_4 = love.graphics.newImage("worlds/"..i_mundo.."/parallax3.png")
	mundo.fondo.halo = love.graphics.newImage("worlds/"..i_mundo.."/halo.png")
	mundo.fondo.width = 1920
	mundo.fondo.height = 1080
	mundo.fondo.color = {}
	mundo.fondo.color.bottom = {}
	mundo.fondo.color.bottom.r = 91
	mundo.fondo.color.bottom.g = 56
	mundo.fondo.color.bottom.b = 31
	mundo.fondo.color.top = {}
	mundo.fondo.color.top.r = 1
	mundo.fondo.color.top.g = 23
	mundo.fondo.color.top.b = 108
	
	mundo.halo_pos = 0
	mundo.efecto = 1
	
	if i_mundo == 1 then
		mundo.total_levels = 7
		mundo.efecto = 0.2
	elseif i_mundo == 2 then
		mundo.total_levels = 1
		mundo.efecto = 2
	end
	
	
	return mundo
end







function mapa:procesar(tipo)
	layer = map.layers[tipo]
	for tileX=1, map.width do
		for tileY=1, map.height do
			local tile = layer(tileX-1, tileY-1)
			if tile then
				name = tipo.."_x"..tileX.."_y"..tileY
				newground = name.." = {}\n"..
					name..".b = love.physics.newBody(world, ("..tileX.."-1)*"..mapa.cuadro.."+"..mapa.cuadro.."/2, ("..tileY.."-1)*"..mapa.cuadro.."+"..mapa.cuadro.."/2,'static')\n"..
					name..".s = love.physics.newRectangleShape(0, 0, "..mapa.cuadro..", "..mapa.cuadro..")\n"..
					name..".f = love.physics.newFixture("..name..".b, "..name..".s)\n"
				if tipo == "platform" then
					newground = newground..name..".f:setUserData('floor')\n"
				elseif tipo == "efecto" then
					newground = newground..name..".f:setUserData('efecto')\n"
				elseif tipo == "muerte" then
					newground = newground..name..".f:setUserData('muerte')\n"
				elseif tipo == "flag" then
					newground = newground..name..".f:setUserData('flag')\n"
					if b_halo then
						mundo.halo_pos = tileX*mapa.cuadro - 90
						b_halo = false
					end
				end
				
				eval_loadstring(newground)
			end
		end
	end
end     





function mapa:pintar(level)
	--mapa:pintar_bandera()
	
	--map:setDrawRange(math.floor(camera.x),math.floor(camera.y),ventana.width,ventana.height)
	map:setDrawRange(camera.x,camera.y,ventana.width,ventana.height)
	
	map:draw()

end





function mapa:pintar_fondo()
	love.graphics.setColor(255, 255, 255)
	
	if mapa.fondo.move_x ~= 0 and estado_juego == "jugando" then
		mapa.fondo.pos = mapa.fondo.pos - mapa.fondo.move_x/5
		mapa.fondo.pos_1 = mapa.fondo.pos_1 - mapa.fondo.move_x/4
		mapa.fondo.pos_2 = mapa.fondo.pos_2 - mapa.fondo.move_x/3
		mapa.fondo.pos_3 = mapa.fondo.pos_3 - mapa.fondo.move_x/2
	end
	
	if mapa.fondo.move_y ~= 0 and estado_juego == "jugando" then
		mapa.fondo.pos_y = mapa.fondo.pos_y - mapa.fondo.move_y/2
		mapa.fondo.pos_y_1 = mapa.fondo.pos_y_1 - mapa.fondo.move_y/4
		mapa.fondo.pos_y_2 = mapa.fondo.pos_y_2 - mapa.fondo.move_y/12
		--mapa.fondo.pos_y_3 = mapa.fondo.pos_y_3 - mapa.fondo.move_y
		if mapa.fondo.pos_y < 0 then
			mapa.fondo.pos_y = 0
		end
		if mapa.fondo.pos_y_1 < 0 then
			mapa.fondo.pos_y_1 = 0
		end
		if mapa.fondo.pos_y_2 < 0 then
			mapa.fondo.pos_y_2 = 0
		end
		if mapa.fondo.pos_y_3 < 0 then
			mapa.fondo.pos_y_3 = 0
		end
	end
	
	if mapa.fondo.pos < (-mapa.fondo.width) then
		mapa.fondo.pos = mapa.fondo.pos + mapa.fondo.width
	elseif mapa.fondo.pos > mapa.fondo.width then
		mapa.fondo.pos = mapa.fondo.pos - mapa.fondo.width
	end
	
	if mapa.fondo.pos_1 < (-mapa.fondo.width) then
		mapa.fondo.pos_1 = mapa.fondo.pos_1 + mapa.fondo.width
	elseif mapa.fondo.pos_1 > mapa.fondo.width then
		mapa.fondo.pos_1 = mapa.fondo.pos_1 - mapa.fondo.width
	end
	
	if mapa.fondo.pos_2 < (-mapa.fondo.width) then
		mapa.fondo.pos_2 = mapa.fondo.pos_2 + mapa.fondo.width
	elseif mapa.fondo.pos_2 > mapa.fondo.width then
		mapa.fondo.pos_2 = mapa.fondo.pos_2 - mapa.fondo.width
	end
	
	if mapa.fondo.pos_3 < (-mapa.fondo.width) then
		mapa.fondo.pos_3 = mapa.fondo.pos_3 + mapa.fondo.width
	elseif mapa.fondo.pos_3 > mapa.fondo.width then
		mapa.fondo.pos_3 = mapa.fondo.pos_3 - mapa.fondo.width
	end
	
	love.graphics.draw(mapa.fondo.img, camera.x+mapa.fondo.pos-mapa.fondo.width, map.height*mapa.cuadro-mapa.fondo.height-mapa.fondo.pos_y)
	love.graphics.draw(mapa.fondo.img, camera.x+mapa.fondo.pos, map.height*mapa.cuadro-mapa.fondo.height-mapa.fondo.pos_y)
	love.graphics.draw(mapa.fondo.img, camera.x+mapa.fondo.pos+mapa.fondo.width, map.height*mapa.cuadro-mapa.fondo.height-mapa.fondo.pos_y)
	
	
	love.graphics.draw(mapa.fondo.img_2, camera.x+mapa.fondo.pos_1-mapa.fondo.width, map.height*mapa.cuadro-mapa.fondo.height-mapa.fondo.pos_y_1)
	love.graphics.draw(mapa.fondo.img_2, camera.x+mapa.fondo.pos_1,                    map.height*mapa.cuadro-mapa.fondo.height-mapa.fondo.pos_y_1)
	love.graphics.draw(mapa.fondo.img_2, camera.x+mapa.fondo.pos_1+mapa.fondo.width, map.height*mapa.cuadro-mapa.fondo.height-mapa.fondo.pos_y_1)
	
	love.graphics.draw(mapa.fondo.img_3, camera.x+mapa.fondo.pos_2-mapa.fondo.width, map.height*mapa.cuadro-mapa.fondo.height-mapa.fondo.pos_y_2)
	love.graphics.draw(mapa.fondo.img_3, camera.x+mapa.fondo.pos_2,                    map.height*mapa.cuadro-mapa.fondo.height-mapa.fondo.pos_y_2)
	love.graphics.draw(mapa.fondo.img_3, camera.x+mapa.fondo.pos_2+mapa.fondo.width, map.height*mapa.cuadro-mapa.fondo.height-mapa.fondo.pos_y_2)
	
	love.graphics.draw(mapa.fondo.img_4, camera.x+mapa.fondo.pos_3-mapa.fondo.width, map.height*mapa.cuadro-mapa.fondo.height-mapa.fondo.pos_y_3)
	love.graphics.draw(mapa.fondo.img_4, camera.x+mapa.fondo.pos_3,                    map.height*mapa.cuadro-mapa.fondo.height-mapa.fondo.pos_y_3)
	love.graphics.draw(mapa.fondo.img_4, camera.x+mapa.fondo.pos_3+mapa.fondo.width, map.height*mapa.cuadro-mapa.fondo.height-mapa.fondo.pos_y_3)
	
	
	love.graphics.draw(mapa.fondo.halo, mundo.halo_pos, camera.y)
	
	
	--fintamos el fake-background del suelo del color del mapa.fondo.bottom --pero lo pintamos bien
	love.graphics.setColor(mapa.fondo.color.bottom.r, mapa.fondo.color.bottom.g, mapa.fondo.color.bottom.b)
	love.graphics.rectangle("fill", camera.x, map.height*mapa.cuadro-mapa.fondo.pos_y, ventana.width, ventana.height*8)
	
	--fintamos el cielo del color del mapa.fondo.top
	love.graphics.setBackgroundColor(mapa.fondo.color.top.r, mapa.fondo.color.top.g, mapa.fondo.color.top.b)
end







--esto ya no se usa
function mapa:pintar_montanas()
	love.graphics.setBackgroundColor(104, 136, 248) --set the background color to a nice blue
	i = 0 - ventana.width*3
	
	while i < (map.width*mapa.cuadro+ventana.width*3) do
		love.graphics.setColor(255, 255, 255)
		love.graphics.polygon("fill", i+1, map.height*mapa.cuadro, i+400, map.height*mapa.cuadro, i+200, map.height*mapa.cuadro*0.3)
		love.graphics.setColor(95, 75, 75)
		love.graphics.polygon("fill", i-10, map.height*mapa.cuadro, i+250, map.height*mapa.cuadro, i+150, map.height*mapa.cuadro*0.6)
		love.graphics.polygon("fill", i+151, map.height*mapa.cuadro, i+410, map.height*mapa.cuadro, i+250, map.height*mapa.cuadro*0.6)
		i = i + 400
	end
	love.graphics.rectangle("fill", (0 - ventana.width*3 ), map.height*mapa.cuadro, map.width*mapa.cuadro+ventana.width*3, ventana.height*5)
end







--para debugear el mapa
function mapa:pintar_debug(tipo)
	love.graphics.setColor(50, 50, 50)
	for tileX=1, map.width do
		for tileY=1, map.height do
			local tile = layer(tileX-1, tileY-1)
			if tile then
				name = tipo.."_x"..tileX.."_y"..tileY
				drawground = "love.graphics.polygon('fill', "..name..".b:getWorldPoints("..name..".s:getPoints()))"
				
				eval_loadstring(drawground)
			end
		end
	end
end





function mapa:cargar_bandera()

	mapa.position_blocks = map.width*mapa.cuadro+600
    
    
    ground = {}
		ground.b = love.physics.newBody(world, mapa.position_blocks+ventana.width/2, map.height*mapa.cuadro-120)
		ground.s = love.physics.newRectangleShape(ventana.width*2, 50)
		ground.f = love.physics.newFixture(ground.b, ground.s)
		ground.f:setUserData("Ground")


	block3 = {}
		block3.b = love.physics.newBody(world, mapa.position_blocks,map.height*mapa.cuadro-550, "dynamic")
		block3.s = love.physics.newRectangleShape(0, 0, 100, 50)    
		block3.f = love.physics.newFixture(block3.b, block3.s)
		block3.f:setUserData("block")
		
	mapa.position_blocks = mapa.position_blocks + 100    
	block4 = {}
		block4.b = love.physics.newBody(world, mapa.position_blocks,map.height*mapa.cuadro-400, "dynamic")
		block4.s = love.physics.newRectangleShape(0, 0, 100, 50)      
		block4.f = love.physics.newFixture(block4.b, block4.s)
		block4.f:setUserData("block")   
	block5 = {}
		block5.b = love.physics.newBody(world, mapa.position_blocks,map.height*mapa.cuadro-550, "dynamic")
		block5.s = love.physics.newRectangleShape(0, 0, 100, 50)    
		block5.f = love.physics.newFixture(block5.b, block5.s)
		block5.f:setUserData("block")
	
	mapa.position_blocks = mapa.position_blocks + 100
	block6 = {}
		block6.b = love.physics.newBody(world, mapa.position_blocks,map.height*mapa.cuadro-400, "dynamic")
		block6.s = love.physics.newRectangleShape(0, 0, 100, 50)      
		block6.f = love.physics.newFixture(block6.b, block6.s)
		block6.f:setUserData("block") 
	block7 = {}
		block7.b = love.physics.newBody(world, mapa.position_blocks,map.height*mapa.cuadro-550, "dynamic")
		block7.s = love.physics.newRectangleShape(0, 0, 100, 50)    
		block7.f = love.physics.newFixture(block7.b, block7.s)
		block7.f:setUserData("block")
	block8 = {}
		block8.b = love.physics.newBody(world, mapa.position_blocks,map.height*mapa.cuadro-700, "dynamic")
		block8.s = love.physics.newRectangleShape(0, 0, 100, 50)    
		block8.f = love.physics.newFixture(block8.b, block8.s)
		block8.f:setUserData("block") 
	
	mapa.position_blocks = mapa.position_blocks + 100
	block9 = {}
		block9.b = love.physics.newBody(world, mapa.position_blocks,map.height*mapa.cuadro-140, "dynamic")
		block9.s = love.physics.newRectangleShape(0, 0, 100, 50)      
		block9.f = love.physics.newFixture(block9.b, block9.s)
		block9.f:setUserData("block") 
	block10 = {}
		block10.b = love.physics.newBody(world, mapa.position_blocks,map.height*mapa.cuadro-300, "dynamic")
		block10.s = love.physics.newRectangleShape(0, 0, 100, 50)    
		block10.f = love.physics.newFixture(block10.b, block10.s)
		block10.f:setUserData("block")
	block11 = {}
		block11.b = love.physics.newBody(world, mapa.position_blocks,map.height*mapa.cuadro-500, "dynamic")
		block11.s = love.physics.newRectangleShape(0, 0, 100, 50)    
		block11.f = love.physics.newFixture(block11.b, block11.s)
		block11.f:setUserData("block")  
	block12 = {}
		block12.b = love.physics.newBody(world, mapa.position_blocks,map.height*mapa.cuadro-700, "dynamic")
		block12.s = love.physics.newRectangleShape(0, 0, 100, 50)    
		block12.f = love.physics.newFixture(block12.b, block12.s)
		block12.f:setUserData("block")  
	 
	 
	 
	bandera = {}
		bandera.b = love.physics.newBody(world, mapa.position_blocks+200,map.height*mapa.cuadro-700, "dynamic")
		--bandera.b = love.physics.newBody(world, 200,100, "dynamic")
		bandera.s = love.physics.newRectangleShape(0, 0, 20, 550)    
		bandera.f = love.physics.newFixture(bandera.b, bandera.s)
		bandera.f:setUserData("flag") 
		
		
end



function mapa:pintar_bandera()

	love.graphics.setColor(72, 160, 14) -- set the drawing color to green for the ground
	love.graphics.polygon("fill", ground.b:getWorldPoints(ground.s:getPoints()))

	love.graphics.setColor(50, 50, 50) -- set the drawing color to grey for the blocks
	love.graphics.polygon("fill", block3.b:getWorldPoints(block3.s:getPoints()))
	love.graphics.polygon("fill", block4.b:getWorldPoints(block4.s:getPoints()))
	love.graphics.polygon("fill", block5.b:getWorldPoints(block5.s:getPoints()))
	love.graphics.polygon("fill", block6.b:getWorldPoints(block6.s:getPoints()))
	love.graphics.polygon("fill", block7.b:getWorldPoints(block7.s:getPoints()))
	love.graphics.polygon("fill", block8.b:getWorldPoints(block8.s:getPoints()))
	love.graphics.polygon("fill", block9.b:getWorldPoints(block9.s:getPoints()))
	love.graphics.polygon("fill", block10.b:getWorldPoints(block10.s:getPoints()))
	love.graphics.polygon("fill", block11.b:getWorldPoints(block11.s:getPoints()))
	love.graphics.polygon("fill", block12.b:getWorldPoints(block12.s:getPoints()))


	--pintamos la bandera
	--love.graphics.setColor(255, 255, 255)
	love.graphics.setColor(193, 47, 14) --set the drawing color to red 
	love.graphics.polygon("fill", bandera.b:getWorldPoints(bandera.s:getPoints()))
	
end
