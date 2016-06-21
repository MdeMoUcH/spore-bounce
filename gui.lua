------------------------------------------------------------------------
-- Spore Bounce
-- Juego hecho en lua con love2d.org
-- 2014 - MdeMoUcH
-- mdemouch@gmail.com - http://www.lagranm.com
------------------------------------------------------------------------


gui = {}


function gui:cargar_imagenes()

	imagenes = {}
	imagenes.splashscreen = love.graphics.newImage("img/splash.jpg")
	imagenes.menu = love.graphics.newImage("img/menu.jpg")
	imagenes.opciones = love.graphics.newImage("img/opciones.jpg")
	imagenes.wasted = love.graphics.newImage("img/wasted.png")
	imagenes.win = love.graphics.newImage("img/win.png")
	imagenes.hud = love.graphics.newImage("img/hud.png")
	
	imagenes.scale = {}
	imagenes.scale.x = 1
	imagenes.scale.y = 1
	
	if ventana.width ~= 1920 or ventana.height ~= 1080 then
		imagenes.scale.x = ventana.width/1920
		imagenes.scale.y = ventana.height/1080
	end
end

--[[
function gui:actualizar_escala()
	imagenes.scale.x = 1
	imagenes.scale.y = 1

	if ventana.width ~= 1920 or ventana.height ~= 1080 then
		imagenes.scale.x = ventana.width/1920
		imagenes.scale.y = ventana.height/1080
	end
end ]]--


--GUI IN-GAME
function gui:pintar_ingame()
	
			
	if win_flag then
		love.graphics.setFont(font_small)
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(imagenes.win, ventana.width/2-225, ventana.height/2-75)
		love.graphics.print("En "..tiempo_actual.." segundos\n\nPulsa 'Espacio' para\n continuar", ventana.width/2-100, ventana.height/2+40)
		
		if b_record then
			love.graphics.print("NUEVO\nRECORD", ventana.width/2-100, ventana.height/2-100)
		end
	end

	love.graphics.setFont(font_small)
	love.graphics.setColor(0, 0, 0)
	
	s_interface = "FPS: "..love.timer.getFPS().."\n"
				--.."Velocidad: "..math.floor(character.velocidad_real).."\n"
			
	love.graphics.print(s_interface, 10, 10)
	--love.graphics.print(mensaje, ventana.width-200, 10)
	
	if character.vivo == false then
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(imagenes.wasted, ventana.width/2-225, ventana.height/2-75)
	end
	
	if win_flag and level == total_levels and b_single_match == false then
		love.graphics.setColor(0, 0, 0)
		love.graphics.setFont(font_big)
		i_total = 0
		s_win = "TE HAS PASADO TODOS LOS NIVELES\n"
		for i=1, total_levels, 1 do
			s_win = s_win.."\t\tNivel "..i..": "..tiempos_pantallas[i].." segundos\n"
			i_total = i_total + tiempos_pantallas[i]
		end
		s_win = s_win.."\n\tTiempo total: "..i_total.." segundos\n"
		s_win = s_win.."\nHas muerto un total de "..character.num_muertes.." veces\n"
		
		if b_world_record then
			s_win = s_win.."\nNUEVO\nRECORD"
		end
		
		love.graphics.print(s_win, ventana.width/3, 10)
	else
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(imagenes.hud, ventana.width/2-90, 0)
		love.graphics.setColor(0, 67, 0)
		love.graphics.setFont(font_30)
		if b_single_match then
			love.graphics.print(mundo_actual_menu.."."..flecha_posicion, ventana.width/2-65, 24)
		else
			love.graphics.print(mundo_actual.."."..level, ventana.width/2-65, 24)
		end
		love.graphics.setFont(font_20)
		if tiempo_actual < 10 then
			love.graphics.print(" "..tiempo_actual.."''", ventana.width/2+24, 32)
		else
			love.graphics.print(tiempo_actual.."''", ventana.width/2+24, 32)
		end
		
	end
	love.graphics.setColor(255, 255, 255)
end


function gui:pintar_bienvenida()
	---------
	--INICIO
	---------

	
	if tiempo_de_inicio > 1 then
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(imagenes.splashscreen, 0, 0, 0, imagenes.scale.x, imagenes.scale.y)
	else
		love.graphics.setBackgroundColor(0, 0, 0)
		love.graphics.setColor(255, 255, 255)
		love.graphics.setFont(font_subtitle)
		love.graphics.print("Un juego de MdeMoUcH", ventana.width/3+70, ventana.height/2)
	end
	--love.graphics.setColor(255, 255, 255)
	--love.graphics.print(tiempo_de_inicio, 0, 0)
	

end


function gui:pintar_puntuaciones()
	---------
	--PUNTUACIONES
	---------	
	love.graphics.setBackgroundColor(0, 0, 0)
	love.graphics.setColor(255, 255, 255)
	love.graphics.setFont(font_big)
	if b_puntuaciones then
		s_win = "TÚ MEJOR PARTIDA: MUNDO "..mundo_actual_menu.."\n\n"
		for i=1, total_levels_menu, 1 do
			s_win = s_win.."\t\tNivel "..mundo_actual_menu.."."..i..": "..score.tiempos_pantallas[i].." segundos\n"
		end
		s_win = s_win.."\n\tTiempo total: "..score.tiempo.." segundos\n"
		s_win = s_win.."\nNúmero de muertes: "..score.muertes.."\n"
		
		love.graphics.print(s_win, ventana.width/3, 10)
		
	else
		love.graphics.print("NO HAY PUNTUACIONES", ventana.width/3, 10)
		love.graphics.print("Primero tienes que acabar todos los niveles", ventana.width/3, 50)
	end

	love.graphics.setFont(font_small)
	love.graphics.print("Pulsa 'espacio' o 'Esc' para volver.", ventana.width/3, ventana.height-25)

end


------------------------------------
	--PANTALLA DE PUNTUACIONES
	------------------------------------
function gui:update_puntuaciones()

	tiempo_de_inicio = os.difftime(os.time(),start_time)
	if tiempo_de_inicio >= 1 and (love.keyboard.isDown(' ') or love.keyboard.isDown('escape') or joystick:isGamepadDown("start") or joystick:isGamepadDown("a") or joystick:isGamepadDown("b")) then
		start_time = os.time()
		estado_juego = "menu"
	end
	
	--Mundo
	if  os.difftime(os.time(),cambio_mundo) > 1 then
		if love.keyboard.isDown("right") or love.keyboard.isDown("d") or joystick:isGamepadDown("dpright") or joystick:getGamepadAxis("leftx") > 0.1 then
			if mundo_actual_menu < total_mundos then
				mundo_actual_menu = mundo_actual_menu + 1
				mundo_bak = mapa:cargar_mundo(mundo_actual_menu)
				total_levels_menu = mundo_bak.total_levels
				
				b_puntuaciones = exist_file("score"..mundo_actual_menu)
				
				if b_puntuaciones then
					load_data("score"..mundo_actual_menu)
					eval_loadstring("score = score"..mundo_actual_menu)
				else
					score = {}
				end
				cambio_mundo = os.time()
			end
		end
		if love.keyboard.isDown("left") or love.keyboard.isDown("a") or joystick:isGamepadDown("dpleft") or joystick:getGamepadAxis("leftx") < -0.1 then
			if mundo_actual_menu > 1 then
				mundo_actual_menu = mundo_actual_menu - 1
				mundo_bak = mapa:cargar_mundo(mundo_actual_menu)
				total_levels_menu = mundo_bak.total_levels
				
				b_puntuaciones = exist_file("score"..mundo_actual_menu)
				
				if b_puntuaciones then
					load_data("score"..mundo_actual_menu)
					eval_loadstring("score = score"..mundo_actual_menu)
				else
					score = {}
				end
				cambio_mundo = os.time()
			end
		end
	end
end

------------------------------------------------------
--MENU---------------------------------------------
------------------------------------------------------

menu_max = 5


function gui:update_menu(dt)

	tiempo_de_inicio = os.difftime(os.time(),start_time)
	
	
	if tiempo_de_inicio >= 1 and love.keyboard.isDown('escape') then
		love.event.push("quit")
	end
	
	
	if love.keyboard.isDown("up") or love.keyboard.isDown("w") or joystick:isGamepadDown("dpup")or joystick:getGamepadAxis("lefty") < -0.1 then
		if repeat_timer_up >= repeat_delay then
			if flecha_posicion > 0 then
				flecha_posicion = flecha_posicion - 1
			end
			 repeat_timer_up = 0
		else
			 repeat_timer_up = repeat_timer_up + dt
		end
	else
		repeat_timer_up = 0
	end
	
	if love.keyboard.isDown("down") or love.keyboard.isDown("s") or joystick:isGamepadDown("dpdown") or joystick:getGamepadAxis("lefty") > 0.1 then
		if repeat_timer >= repeat_delay then
			if flecha_posicion < menu_max then
				flecha_posicion = flecha_posicion + 1
			end
			 repeat_timer = 0
		else
			 repeat_timer = repeat_timer + dt
		end
	else
		repeat_timer = 0
	end
	
	if (love.keyboard.isDown('return') or love.keyboard.isDown(' ') or joystick:isGamepadDown("a")) and tiempo_de_inicio >= 1 then
	
		if flecha_posicion == 0 then 
			--CONTINUAR
			continue()
		elseif flecha_posicion == 1 then
			--EMPEZAR
			level = 1
			mundo_actual = 1
			restart_game()
		elseif flecha_posicion == 2 then
			--ELEGIR NIVEL
			start_time = os.time()
			flecha_posicion = 0
			s_mundo = "Mundo "..mundo_actual
			s_niveles = ":)"
			
			total_levels_menu = total_levels
			mundo_actual_menu = mundo_actual
			mundo_bak = mundo
			--total_levels_menu = total_levels
			total_levels_menu = 1
			if load_data("scores") then
				if scores[mundo_actual_menu] ~= nil then
					for index,value in ipairs(scores[mundo_actual_menu]) do
						total_levels_menu = index
					end
				end
			end
			cambio_mundo = os.time()
			b_single_match = true
			estado_juego = "menu-nivel"
		elseif flecha_posicion == 3 then
			--PUNTUACIONES
			b_puntuaciones = exist_file("score"..mundo_actual)
	
			if b_puntuaciones then
				load_data("score"..mundo_actual)
				eval_loadstring("score = score"..mundo_actual)
			else
				score = {}
			end
			
			total_levels_menu = total_levels
			mundo_actual_menu = mundo_actual
			start_time = os.time()
			cambio_mundo = os.time()
			estado_juego = "puntuaciones"
		elseif flecha_posicion == 4 then
			--OPCIONES
			s_resolucion = options.height
			if options.fullscreen then
				s_fullscreen = "Si"
			else
				s_fullscreen = "No"
			end
			s_musica = options.volumen_musica
			s_sonido = options.volumen_sonidos
			start_time = os.time()
			flecha_posicion = 0
			b_guardado = false
			estado_juego = "opciones"
		else
			--SALIR
			love.event.push("quit")
		end
		
	end


end



function gui:pintar_menu()
	
	love.graphics.draw(imagenes.opciones, 0, 0, 0, imagenes.scale.x, imagenes.scale.y)
	
	x = 350
	y = 150
	
	love.graphics.setColor(255, 255, 255)
	--[[
	love.graphics.setFont(font_super)
	love.graphics.print("Menú", ventana.width/4+x, ventana.height/3+y)
	love.graphics.setFont(font_subtitle)
	
	if b_lastlevel == false then
		love.graphics.setColor(115, 115, 115)
	end
	love.graphics.print("Continuar", ventana.width/4+x, ventana.height/2+y)
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Empezar partida", ventana.width/4+x, ventana.height/2+40+y)
	if b_puntuaciones == false then
		love.graphics.setColor(115, 115, 115)
	end
	love.graphics.print("Puntuaciones", ventana.width/4+x, ventana.height/2+80+y)
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Salir (Esc)", ventana.width/4+x, ventana.height/2+120+y)
	
	love.graphics.draw(love.graphics.newImage("img/flecha.png"), ventana.width/4+x-50, ventana.height/2+flecha_posicion*40+y)
	
	]]--
	
	love.graphics.setFont(font_super)
	love.graphics.print("Menú", ventana.width/4+150, ventana.height/3)
	love.graphics.setFont(font_subtitle)
	
	if b_lastlevel == false then
		love.graphics.setColor(115, 115, 115)
	end
	love.graphics.print("Continuar", ventana.width/4+150, ventana.height/2)
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Empezar partida", ventana.width/4+150, ventana.height/2+40)
	love.graphics.print("Elegir nivel", ventana.width/4+150, ventana.height/2+80)
	if b_puntuaciones == false then
		love.graphics.setColor(115, 115, 115)
	end
	love.graphics.print("Puntuaciones", ventana.width/4+150, ventana.height/2+120)
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Opciones", ventana.width/4+150, ventana.height/2+160)
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Salir", ventana.width/4+150, ventana.height/2+200)
	
	
	love.graphics.draw(love.graphics.newImage("img/flecha.png"), ventana.width/4+115, ventana.height/2+flecha_posicion*40)
	
	
end







---------------------------------------------
--PAUSA------------------------------------
---------------------------------------------


function gui:update_pausa(dt)
	tiempo_actual_bak = tiempo_actual
	
	tiempo_de_pausa = os.difftime(os.time(),pausa_time)
	if tiempo_de_pausa >= 2 then		
	
		if love.keyboard.isDown('escape') or joystick:isGamepadDown("b") then
			if b_single_match then
				start_time = os.time()
				estado_juego = "menu-nivel"
			else
				flecha_posicion = 0
				continue()
				estado_juego = "menu"
			end
			--love.event.push("quit")
		end
	end
	
	if love.keyboard.isDown(' ') then
		start_time = os.time()
		estado_juego = "jugando"
	end
	
	if love.keyboard.isDown("up") or love.keyboard.isDown("w") or joystick:isGamepadDown("dpup") or joystick:getGamepadAxis("lefty") < -0.1 then
		flecha_posicion_pausa = 0
	end
	
	if love.keyboard.isDown("down") or love.keyboard.isDown("s") or joystick:isGamepadDown("dpdown") or joystick:getGamepadAxis("lefty") > 0.1 then
		flecha_posicion_pausa = 1
	end
	
	
	if love.keyboard.isDown("return") or joystick:isGamepadDown("a") then
		if flecha_posicion_pausa == 0 then
			start_time = os.time()
			estado_juego = "jugando"
		else
			if b_single_match then
				start_time = os.time()
				estado_juego = "menu-nivel"
			else
				flecha_posicion = 0
				continue()
				estado_juego = "menu"
			end
		end
			
	end	
	
end



function gui:pintar_pausa()

	love.graphics.setColor(0, 0, 0)
	if ventana.width > 1280 then
		love.graphics.rectangle( "fill", ventana.width/2-750/2, ventana.height/2-500/2, 650, 360 )
	else
		love.graphics.rectangle( "fill", ventana.width/2-500/2, ventana.height/2-400/2, 500, 280 )
	end
	
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(character.sprites.base, ventana.width/2+120, ventana.height/3-30,0,2,2)
	love.graphics.draw(character.sprite, ventana.width/2+120, ventana.height/3-30,0,2,2)
	
	love.graphics.setFont(font_subtitle)
	love.graphics.print("Super MoUcH Boy", ventana.width/4+150, ventana.height/3-50)
	love.graphics.setFont(font_super)
	love.graphics.print("Pausa", ventana.width/4+150, ventana.height/3)
	love.graphics.setFont(font_subtitle)
	love.graphics.print("Continuar jugando", ventana.width/4+150, ventana.height/2)
	love.graphics.print("Salir de la partida", ventana.width/4+150, ventana.height/2+40)
	
	love.graphics.draw(love.graphics.newImage("img/flecha.png"), ventana.width/4+115, ventana.height/2+flecha_posicion_pausa*40)
	
end






------------------------------------------------------
--OPCIONES---------------------------------------------
------------------------------------------------------

opciones_max = 5


function gui:update_opciones(dt)

	tiempo_de_inicio = os.difftime(os.time(),start_time)
	
	b_press_key = (love.keyboard.isDown('return') or love.keyboard.isDown(' ') or joystick:isGamepadDown("a")) and tiempo_de_inicio >= 1
	
	
	if tiempo_de_inicio >= 1 and love.keyboard.isDown('escape') then
			start_time = os.time()
			estado_juego = "menu"
	end
	
	if b_guardado then
		if b_press_key then 
			start_time = os.time()
			b_guardado = false
		end
	else
		
		if love.keyboard.isDown("up") or love.keyboard.isDown("w") or joystick:isGamepadDown("dpup") or joystick:getGamepadAxis("lefty") < -0.1 then
			if repeat_timer_up >= repeat_delay then
				if flecha_posicion > 0 then
					flecha_posicion = flecha_posicion - 1
				end
				 repeat_timer_up = 0
			else
				 repeat_timer_up = repeat_timer_up + dt
			end
		else
			repeat_timer_up = 0
		end
		
		if love.keyboard.isDown("down") or love.keyboard.isDown("s") or joystick:isGamepadDown("dpdown") or joystick:getGamepadAxis("lefty") > 0.1 then
			if repeat_timer >= repeat_delay then
				if flecha_posicion < opciones_max then
					flecha_posicion = flecha_posicion + 1
				end
				 repeat_timer = 0
			else
				 repeat_timer = repeat_timer + dt
			end
		else
			repeat_timer = 0
		end
		
		
		
		
		if flecha_posicion == 0 then 
			--Resolución
			if (love.keyboard.isDown("right") or love.keyboard.isDown("d") or joystick:isGamepadDown("dpright") or joystick:getGamepadAxis("leftx") > 0.1)  and s_resolucion == 720 then
				s_resolucion = 1080
				options.width = 1920
				options.height = 1080
			end
			if (love.keyboard.isDown("left") or love.keyboard.isDown("a") or joystick:isGamepadDown("dpleft") or joystick:getGamepadAxis("leftx") < -0.1)  and s_resolucion == 1080 then
				s_resolucion = 720
				options.width = 1280
				options.height = 720
			end
		elseif flecha_posicion == 1 then
			--fullscreen
			if (love.keyboard.isDown("right") or love.keyboard.isDown("d") or joystick:isGamepadDown("dpright") or joystick:getGamepadAxis("leftx") > 0.1)  and s_fullscreen == "No" then
				s_fullscreen = "Si"
				options.fullscreen = true
			end
			if (love.keyboard.isDown("left") or love.keyboard.isDown("a") or joystick:isGamepadDown("dpleft") or joystick:getGamepadAxis("leftx") < -0.1)  and s_fullscreen == "Si" then
				s_fullscreen = "No"
				options.fullscreen = false
			end
		elseif flecha_posicion == 2 then
			--musica
			if (love.keyboard.isDown("right") or love.keyboard.isDown("d") or joystick:isGamepadDown("dpright") or joystick:getGamepadAxis("leftx") > 0.1)  and options.volumen_musica <= 0.9 then
				if repeat_timer_aux >= repeat_delay_aux then
					if flecha_posicion < opciones_max then
						options.volumen_musica = options.volumen_musica + 0.1
						if options.volumen_musica > 1 then options.volumen_musica = 1 end
						s_musica = options.volumen_musica
						sonidos.music:setVolume(options.volumen_musica)
					end
					 repeat_timer_aux = 0
				else
					 repeat_timer_aux = repeat_timer_aux + dt
				end
			elseif (love.keyboard.isDown("left") or love.keyboard.isDown("a") or joystick:isGamepadDown("dpleft") or joystick:getGamepadAxis("leftx") < -0.1)  and options.volumen_musica >= 0.1 then
				if repeat_timer_aux >= repeat_delay_aux then
					if flecha_posicion < opciones_max then
						options.volumen_musica = options.volumen_musica - 0.1
						if options.volumen_musica < 0 then options.volumen_musica = 0
						elseif options.volumen_musica > 1 then options.volumen_musica = 1
						elseif options.volumen_musica < 0.1 then options.volumen_musica = 0 end
						s_musica = options.volumen_musica
						sonidos.music:setVolume(options.volumen_musica)
					end
					 repeat_timer_aux = 0
				else
					 repeat_timer_aux = repeat_timer_aux + dt
				end
			else
				repeat_timer_aux = 0
			end
		elseif flecha_posicion == 3 then
			--efectos
			if (love.keyboard.isDown("right") or love.keyboard.isDown("d") or joystick:isGamepadDown("dpright") or joystick:getGamepadAxis("leftx") > 0.1)  and options.volumen_sonidos <= 0.9 then
				if repeat_timer_aux >= repeat_delay_aux then
					if flecha_posicion < opciones_max then
						options.volumen_sonidos = options.volumen_sonidos + 0.1
						if options.volumen_sonidos > 1 then options.volumen_sonidos = 1 end
						s_sonido = options.volumen_sonidos
						sonidos.salto:setVolume(options.volumen_sonidos)
						sonidos.salto:play()
					end
					 repeat_timer_aux = 0
				else
					 repeat_timer_aux = repeat_timer_aux + dt
				end
			elseif (love.keyboard.isDown("left") or love.keyboard.isDown("a") or joystick:isGamepadDown("dpleft") or joystick:getGamepadAxis("leftx") < -0.1)  and options.volumen_sonidos >= 0.1 then
				if repeat_timer_aux >= repeat_delay_aux then
					if flecha_posicion < opciones_max then
						options.volumen_sonidos = options.volumen_sonidos - 0.1
						if options.volumen_sonidos < 0 then options.volumen_sonidos = 0
						elseif options.volumen_sonidos > 1 then options.volumen_sonidos = 1
						elseif options.volumen_sonidos < 0.1 then options.volumen_sonidos = 0 end
						s_sonido = options.volumen_sonidos
						sonidos.salto:setVolume(options.volumen_sonidos)
						sonidos.salto:play()
					end
					 repeat_timer_aux = 0
				else
					 repeat_timer_aux = repeat_timer_aux + dt
				end
			else
				repeat_timer_aux = 0
			end
			
			
			
			
		elseif flecha_posicion == 4 then
			--guardar
			if b_press_key then
				save_data(options,"options")
				cargar_ventana()
				gui:cargar_imagenes()
				cargar_sonidos()
				b_guardado = true
				start_time = os.time()
			end
		else
			--volver al Menú
			if b_press_key then
				start_time = os.time()
				flecha_posicion = 0
				estado_juego = "menu"
			end
		end
	
	end
	
			


end




function gui:pintar_opciones()
	
	love.graphics.draw(imagenes.menu, 0, 0, 0, imagenes.scale.x, imagenes.scale.y)
	
	--x = 350
	--y = 150
	
	love.graphics.setColor(255, 255, 255)
	
	love.graphics.setFont(font_super)
	love.graphics.print("Opciones", ventana.width/4+150, ventana.height/3)
	
	love.graphics.setFont(font_subtitle)
	
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Resolución:", ventana.width/4+150, ventana.height/2)
	love.graphics.setColor(155, 155, 155)
	love.graphics.print(s_resolucion.."p", ventana.width/4+400, ventana.height/2)
	
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Pantalla completa:", ventana.width/4+150, ventana.height/2+40)
	love.graphics.setColor(155, 155, 155)
	love.graphics.print(s_fullscreen, ventana.width/4+420, ventana.height/2+40)
	
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Volumen Música:", ventana.width/4+150, ventana.height/2+80)
	love.graphics.setColor(155, 155, 155)
	love.graphics.print(s_musica, ventana.width/4+420, ventana.height/2+80)
	
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Volumen Efectos:", ventana.width/4+150, ventana.height/2+120)
	love.graphics.setColor(155, 155, 155)
	love.graphics.print(s_sonido, ventana.width/4+420, ventana.height/2+120)
	
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Guardar", ventana.width/4+150, ventana.height/2+160)
	love.graphics.print("Volver", ventana.width/4+150, ventana.height/2+200)
	
	love.graphics.draw(love.graphics.newImage("img/flecha.png"), ventana.width/4+115, ventana.height/2+flecha_posicion*40)
	
	
	
	if b_guardado then
		love.graphics.setColor(0, 0, 0)
		if ventana.width > 1280 then
			love.graphics.rectangle( "fill", ventana.width/2-750/2, ventana.height/2-500/2, 650, 360 )
		else
			love.graphics.rectangle( "fill", ventana.width/2-500/2, ventana.height/2-400/2, 500, 280 )
		end
		
		love.graphics.setColor(255, 255, 255)
		--love.graphics.draw(character.sprite, ventana.width/2+120, ventana.height/3-30,0,2,2)
		
		love.graphics.setFont(font_subtitle)
		love.graphics.print("Super MoUcH Boy", ventana.width/4+150, ventana.height/3-50)
		love.graphics.setFont(font_super)
		love.graphics.print("Cambios salvados\ncorrectamente", ventana.width/4+150, ventana.height/3)
		love.graphics.setFont(font_subtitle)
		love.graphics.print("Aceptar (espacio)", ventana.width/4+150, ventana.height/2)
	end
	
end









------------------------------------------------------
--MENU-NIVEL---------------------------------------------
------------------------------------------------------


function gui:update_menu_level(dt)

	tiempo_de_inicio = os.difftime(os.time(),start_time)
	
	b_press_key = (love.keyboard.isDown('return') or love.keyboard.isDown(' ') or joystick:isGamepadDown("a")) and tiempo_de_inicio >= 1
	
	
	if tiempo_de_inicio >= 1 and love.keyboard.isDown('escape') then
		start_time = os.time()
		flecha_posicion = 0
		estado_juego = "menu"
	end
	
	
	
	if love.keyboard.isDown("up") or love.keyboard.isDown("w") or joystick:isGamepadDown("dpup")or joystick:getGamepadAxis("lefty") < -0.1 then
		if repeat_timer_up >= repeat_delay then
			if flecha_posicion > 0 then
				flecha_posicion = flecha_posicion - 1
			end
			 repeat_timer_up = 0
		else
			 repeat_timer_up = repeat_timer_up + dt
		end
	else
		repeat_timer_up = 0
	end
	
	if love.keyboard.isDown("down") or love.keyboard.isDown("s") or joystick:isGamepadDown("dpdown") or joystick:getGamepadAxis("lefty") > 0.1 then
		if repeat_timer >= repeat_delay then
			if flecha_posicion < (total_levels_menu+1) then
				flecha_posicion = flecha_posicion + 1
			end
			 repeat_timer = 0
		else
			 repeat_timer = repeat_timer + dt
		end
	else
		repeat_timer = 0
	end
	
	
	
	if flecha_posicion == 0 then 
		--Mundo
		if  os.difftime(os.time(),cambio_mundo) > 1 then
			if love.keyboard.isDown("right") or love.keyboard.isDown("d") or joystick:isGamepadDown("dpright") or joystick:getGamepadAxis("leftx") > 0.1 then
				if mundo_actual_menu < total_mundos then
					if scores ~= nil then
						if scores[mundo_actual_menu+1] ~= nil then						
							mundo_actual_menu = mundo_actual_menu + 1
							s_mundo = "Mundo "..mundo_actual_menu
							mundo_bak = mapa:cargar_mundo(mundo_actual_menu)
							total_levels_menu = mundo_bak.total_levels
							for index,value in ipairs(scores[mundo_actual_menu]) do
								total_levels_menu = index
							end
						end
						cambio_mundo = os.time()
					end
				end		
			end
			if love.keyboard.isDown("left") or love.keyboard.isDown("a") or joystick:isGamepadDown("dpleft") or joystick:getGamepadAxis("leftx") < -0.1 then
				if mundo_actual_menu > 1 then					
					if scores ~= nil then
						if scores[mundo_actual_menu-1] ~= nil then
							mundo_actual_menu = mundo_actual_menu - 1
							s_mundo = "Mundo "..mundo_actual_menu
							mundo_bak = mapa:cargar_mundo(mundo_actual_menu)
							total_levels_menu = mundo_bak.total_levels
							for index,value in ipairs(scores[mundo_actual_menu]) do
								total_levels_menu = index
							end
						end
						cambio_mundo = os.time()
					end
				end
			end
		end
		
	elseif flecha_posicion == (total_levels_menu+1) then
		--volver al Menú
		if b_press_key then
			start_time = os.time()
			flecha_posicion = 0
			estado_juego = "menu"
			b_single_match = false
		end
	else
		if b_press_key then
			single_game(flecha_posicion,mundo_actual_menu,true)
		end
		--s_debug = "goto:"..flecha_posicion
	end
	
	--s_debug = total_levels_menu
	


end



function gui:pintar_menu_level()

love.graphics.draw(imagenes.menu, 0, 0, 0, imagenes.scale.x, imagenes.scale.y)
	
	x = ventana.width/4+150
	y = ventana.height/3+60
	
	love.graphics.setColor(255, 255, 255)
	
	love.graphics.setFont(font_super)
	love.graphics.print("ELEGIR NIVEL", x, y-70)
	
	love.graphics.setFont(font_subtitle)
	
	love.graphics.setColor(255, 255, 255)
	love.graphics.print(s_mundo, x, y)
	
	--love.graphics.print(s_niveles, ventana.width/4+150, ventana.height/2+50)
	pos = 0
	if scores ~=nil then
		if scores[mundo_actual_menu] ~=nil then
			for i=1,total_levels_menu,1 do
				love.graphics.print("Nivel "..mundo_actual_menu.."."..i.." ("..scores[mundo_actual_menu][i].." segundos)", x, y+(i*40))
				pos = pos + 40
			end
		else
			love.graphics.print("Nivel "..mundo_actual_menu..".1", x, y+40)
			pos = pos + 40
		end
	elseif pos == 0 then
		love.graphics.print("Nivel "..mundo_actual_menu..".1", x, y+40)
		pos = pos + 40
	end
	
	
	love.graphics.print("Atrás", x, y+pos+40)
	
	love.graphics.draw(love.graphics.newImage("img/flecha.png"), x-35, y+flecha_posicion*40)
	
	
end
