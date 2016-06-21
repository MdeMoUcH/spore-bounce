------------------------------------------------------------------------
-- Spore Bounce
-- Juego hecho en lua con love2d.org
-- 2014 - MdeMoUcH
-- mdemouch@gmail.com - http://www.lagranm.com
------------------------------------------------------------------------


character = {}
character.sonidos = {}

character.num_muertes = 0 --veces que ha muerto el personaje

function character:cargar()

		character.volando = true
		character.saltando = false
		character.vivo = true
		character.efecto = false
		character.muerte_time = os.time()
		character.velocidad = 0
		character.velocidad_y = 0
		character.velocidad_real = 0
		if ventana.width > 1280 then
			character.pos = 600 --posicion de la x para calcular la velocidad
		else
			character.pos = 400 --posicion de la x para calcular la velocidad
		end
		character.pos_1 = character.pos
		character.pos_2 = character.pos
		character.pos_y = 200 --posicion de la y para cuando el personaje muere
		character.pos_y_1 = character.pos_y
		character.pos_y_2 = character.pos_y
		
		

		character.b = love.physics.newBody(world, 400,200, "dynamic")  -- set x,y position (400,200) and let it move and hit other objects ("dynamic")
		character.b:setMass(15)                                        -- make it pretty light
		character.s = love.physics.newCircleShape(20)                  -- give it a radius of 50
		character.f = love.physics.newFixture(character.b, character.s)          -- connect body to shape
		--character.f:setRestitution(0.4)                                -- make it bouncy
		character.f:setUserData("Character")
  
		character.sprites = {}
		character.sprites.base = love.graphics.newImage("img/character-base.png")
		character.sprites.brillo = love.graphics.newImage("img/character-brillo.png")
		character.sprites.estela_1 = love.graphics.newImage("img/character-estela-1.png")
		character.sprites.estela_2 = love.graphics.newImage("img/character-estela-2.png")
		character.sprites.vivo_r = love.graphics.newImage("img/character-vivo-r.png")
		character.sprites.vivo_l = love.graphics.newImage("img/character-vivo-l.png")
		character.sprites.saltando_r = love.graphics.newImage("img/character-saltando-r.png")
		character.sprites.saltando_l = love.graphics.newImage("img/character-saltando-l.png")
		character.sprites.muerto = love.graphics.newImage("img/character-muerto.png")
		
		character.sprite = character.sprites.vivo
		
		
end


function character:mover()

		
	character.pos_2 = character.pos_1
	character.pos_1 = character.pos
	character.pos = character.b:getX()
	character.pos_y_2 = character.pos_y_1
	character.pos_y_1 = character.pos_y
	character.pos_y = character.b:getY()
	
	character.velocidad = character.pos - character.pos_1
	character.velocidad_y = character.pos_y - character.pos_y_1
	
	character.velocidad_real = distancia(character.pos, character.pos_y, character.pos_1, character.pos_y_1)
	
	
	if character.pos_y > map.height*mapa.cuadro and character.vivo and win_flag == false then
		character.b:applyForce(0, -20000)
		character:die()
	end
	
	if character.vivo then	
		if character.velocidad <= 25 then
			if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
				if character.efecto then
					character.b:applyForce(800*mundo.efecto, 0)
				else
					character.b:applyForce(800, 0)
				end
			end
		end
	   
		if character.velocidad >= -25 then
			if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
				if character.efecto then
					character.b:applyForce(-800*mundo.efecto, 0)
				else
					character.b:applyForce(-800, 0)
				end
			end
		end
		
		if love.keyboard.isDown("up") or love.keyboard.isDown("w") then 
			if character.volando == false then
				if character.saltando == false then
					if character.efecto and mundo.efecto < 1 then
						character.b:applyForce(0, -15000*mundo.efecto)
					else
						character.b:applyForce(0, -15000)
					end
					sonidos.salto:play()
					character.volando = true
					character.saltando = true
				else
					character.saltando = false
				end
			end
		end
		
		if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
			character.b:applyForce(0, 400)
		end
		
		character:mover_joystick()
		
	end
	
	
	--fuerza de rozamiento:
	if character.volando == false then
	
		efecto_aux = 1
		if character.efecto then
			if mundo.efecto < 0.5 then
				efecto_aux = 2+mundo.efecto
			end
		end
	
		if character.velocidad < 0 then
			if character.velocidad < -0.5 then
				character.b:applyForce(200*efecto_aux, 0)
			elseif character.velocidad < -0.05 then
				character.b:applyForce(100*efecto_aux, 0)
			elseif character.velocidad < -0.02 then
				character.b:applyForce(25*efecto_aux, 0)
			elseif character.velocidad < -0.01 then
				--character.b:applyForce(2, 0)
			end
		elseif character.velocidad > 0 then
			if character.velocidad > 0.5 then
				character.b:applyForce(-200*efecto_aux, 0)
			elseif character.velocidad > 0.05 then
				character.b:applyForce(-100*efecto_aux, 0)
			elseif character.velocidad > 0.02 then
				character.b:applyForce(-25*efecto_aux, 0)
			elseif character.velocidad > 0.01 then
				character.b:applyForce(-20*efecto_aux, 0)
			elseif character.velocidad > 0.005 then
				character.b:applyForce(-10*efecto_aux, 0)
			end
		end
		
	end
	
end




--Para mover con el mando....
function character:mover_joystick()

	if not joystick then return end
	
	--s_debug = joystick:getGamepadAxis("leftx").." | "..joystick:getGamepadAxis("lefty")
	left_x = joystick:getGamepadAxis("leftx")

	if character.velocidad <= 25 then
		if joystick:isGamepadDown("dpright") then 
			if character.efecto then
				character.b:applyForce(800*mundo.efecto, 0)
			else
				character.b:applyForce(800, 0)
			end
		end
		if left_x > 0 then 
			if character.efecto then
				character.b:applyForce(800*left_x*mundo.efecto, 0)
			else
				character.b:applyForce(800*left_x, 0)
			end
		end
	end
   
	if character.velocidad >= -25 then
		if joystick:isGamepadDown("dpleft") then
			if character.efecto then
				character.b:applyForce(-800*mundo.efecto, 0)
			else
				character.b:applyForce(-800, 0)
			end
		end
		if left_x < 0 then 
			if character.efecto then
				character.b:applyForce(800*left_x*mundo.efecto, 0)
			else
				character.b:applyForce(800*left_x, 0)
			end
		end
	end
	
	if joystick:isGamepadDown("a") or joystick:isGamepadDown("b") or joystick:isGamepadDown("x") or joystick:isGamepadDown("y") then 
		if character.volando == false then
			if character.saltando == false then
				character.b:applyForce(0, -15000)
				sonidos.salto:play()
				character.volando = true
				character.saltando = true
			else
				character.saltando = false
			end
		end
	end
	
	if joystick:isGamepadDown("dpdown") then
		--character.b:applyForce(0, 400)
	end
	
	
end




function character:pintar()

	if character.vivo == false then
		character.sprite = character.sprites.muerto
	elseif character.volando then
		if character.velocidad >= 0 then
			character.sprite = character.sprites.saltando_r
		else
			character.sprite = character.sprites.saltando_l
		end
	else
		if character.velocidad >= 0 then
			character.sprite = character.sprites.vivo_r
		else
			character.sprite = character.sprites.vivo_l
		end
	end
	
	love.graphics.setColor(255, 255, 255)
	--love.graphics.circle("fill", character.b:getX(), character.b:getY(), character.s:getRadius())
	
	--para pintar la estela, no va muy bien la cosa, habría que apañarlo
	if character.vivo then
		love.graphics.draw(character.sprites.estela_2, character.pos_2, character.pos_y_2,character.velocidad, 1, 1, 20, 20)
		love.graphics.draw(character.sprites.estela_1, character.pos_1, character.pos_y_1,character.velocidad, 1, 1, 20, 20)
		--[[
		dif_x = character.pos - character.pos_1
		dif_y = character.pos_y - character.pos_y_1
		if dif_x > 8 or dif_y > 8 then
			if dif_x > 0 then dif_x = -dif_x end
			if dif_y > 0 then dif_y = -dif_y end
			love.graphics.draw(character.sprites.estela, character.pos_1-dif_x/2, character.pos_y_1-dif_y/2,character.velocidad, 1, 1, 20, 20)
		elseif dif_x < -8 or dif_y < -8 then
			if dif_x < 0 then dif_x = -dif_x end
			if dif_y < 0 then dif_y = -dif_y end
			love.graphics.draw(character.sprites.estela, character.pos_1-dif_x/2, character.pos_y_1-dif_y/2,character.velocidad, 1, 1, 20, 20)
		end
		]]--
	end
	
	
	
	love.graphics.draw(character.sprites.base, character.b:getX(), character.b:getY(),-character.velocidad/4, 1, 1, 20, 20)
	love.graphics.draw(character.sprites.brillo, character.b:getX()-20, character.b:getY()-20)
	love.graphics.draw(character.sprite, character.b:getX()-20, character.b:getY()-20)
	
end



function character:die()
	sonidos.grito:play()
	character.vivo = false
	character.muerte_time = os.time()
	if b_single_match == false then
		character.num_muertes = character.num_muertes + 1
	end
end




