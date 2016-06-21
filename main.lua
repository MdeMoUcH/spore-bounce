------------------------------------------------------------------------
-- Spore Bounce
-- Juego hecho en lua con love2d.org
-- 2014 - MdeMoUcH
-- mdemouch@gmail.com - http://www.lagranm.com
------------------------------------------------------------------------


require ("lib")
require ("gui")
require ("camera")
require ("character")
require ("maps")

loader = require ("Advanced-Tiled-Loader/Loader")





function love.load()

	love.physics.setMeter(64) --the height of a meter our worlds will be 64px
	
	
	--Cargamos el archivo de configuración o lo creamos si no existe
	if exist_file("options") then
		load_data("options")
	else
		options = {}
		options.width = 1280
		options.height = 720
		options.fullscreen = false
		options.volumen_musica = 0.3
		options.volumen_sonidos = 0.4
		save_data(options,"options")
	end
	
	--Configuramos la ventana
	cargar_ventana()
	
	
	
	
	--cargamos fuentes
	font_super = love.graphics.newFont("fonts/driftfont.ttf", 56)--64)
	font_subtitle = love.graphics.newFont("fonts/driftfont.ttf", 16)--24)
	font_big = love.graphics.newFont("fonts/driftfont.ttf", 28)--32)
	font_small = love.graphics.newFont("fonts/driftfont.ttf", 15)--18)
	
	font_15 = love.graphics.newFont("fonts/driftfont.ttf", 15)
	font_20 = love.graphics.newFont("fonts/driftfont.ttf", 20)
	font_30 = love.graphics.newFont("fonts/driftfont.ttf", 30)
	
	
	--cargamos las imágenes
	gui:cargar_imagenes()
	
	
	--cargamos sonidos
	cargar_sonidos()
	
	sonidos.start:play()
	
	
	
	--configuración niveles:
	mundo_actual = 1
	total_mundos = 2
	level = 1
	total_levels = 1 --se actualiza en el restart game
	
	
	--inicializamos variables
	text = ""
	mensaje = ""
	s_win = ""
	s_interface = ""
	s_debug = ""
	persisting = 0
	
	win_flag = false
	win_time = os.time()
	start_time = os.time()
	tiempo_actual = 0
	tiempo_actual_bak = 0
	b_save_win = true
	b_record = false
	b__world_record = false
	
	b_single_match = false
	
	estado_juego = "inicio"
	
	flecha_posicion = 0
	flecha_posicion_pausa = 0
	
	repeat_timer = 0
	repeat_timer_up = 0
	repeat_delay = 0.1 -- seconds
	repeat_timer_aux = 0
	repeat_timer_up_aux = 0
	repeat_delay_aux = 0.1 -- seconds
	
	
	
	--comprobamos archivos guardados
	b_lastlevel = exist_file("lastlevel")
	b_puntuaciones = exist_file("score"..mundo_actual)
	
	--cargamos los tiempos de pantallas
	tiempos_pantallas = {}
	for i=1, total_levels, 1 do
		tiempos_pantallas[i] = 0
	end
	
	
	
	
	--Para el joystick
	
	local joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1]
    
    if joystick == nil then
		joystick = {}
		
		function joystick:isGamepadDown() return false end
		function joystick:getGamepadAxis() return 0 end
		
		b_joystick = false
	else
		b_joystick = true
	end
	
	
	
	
		--width, height, flags = love.window.getMode()
		--s_debug = width.."x"..height.." - "..ventana.width.."x"..ventana.height.." ==> "..imagenes.scale.x.." - "..imagenes.scale.y
		
		
	
end







function love.update(dt)
	
	if estado_juego == "inicio" then
		---------
		--INICIO
		---------
		
		tiempo_de_inicio = os.difftime(os.time(),start_time)
		if tiempo_de_inicio >= 5 or love.keyboard.isDown('return') or love.keyboard.isDown(' ') or love.keyboard.isDown('escape') or joystick:isGamepadDown("a") or joystick:isGamepadDown("start") then
			continue()
			estado_juego = "menu"
			sonidos.music:play()
		end
		
		
	elseif estado_juego == "menu" then
		---------
		--MENU
		---------
		gui:update_menu(dt)
		
		
		
	elseif estado_juego == "menu-nivel" then
		---------
		--MENU-NIVEL
		---------
		gui:update_menu_level(dt)
		
	
		
		
	elseif estado_juego == "opciones" then
		---------
		--OPCIONES
		---------
		gui:update_opciones(dt)
		
	elseif estado_juego == "puntuaciones" then
		------------------------------------
		--PANTALLA DE PUNTUACIONES
		------------------------------------
		gui:update_puntuaciones()
		
		
	elseif estado_juego == "pausa" then
		---------
		--PAUSA
		---------
		gui:update_pausa(dt)
		
		
	elseif estado_juego == "jugando" then	
	
		------------------------------------------------------------------------
		--JUGANDO---------------------------------------------------------------
		------------------------------------------------------------------------
		
		if love.keyboard.isDown('escape') or (joystick:isGamepadDown("start") and win_flag == false) then
			pausa_time = os.time()
			estado_juego = "pausa"
		end
		
		world:update(dt) --this puts the world into motion
	  
		character:mover()
		
		camera:followCharacter()
		
		if character.vivo == false then
			tiempo_de_muerte = os.difftime(os.time(),character.muerte_time)
			if tiempo_de_muerte >= 2 then
				if b_single_match then
					single_game(flecha_posicion,mundo_actual_menu,true)
				else
					restart_game()
				end
			end
		end	
		
		
		if win_flag then
			pantalla_completa()
		else
			tiempo_actual = os.difftime(os.time(),start_time) + tiempo_actual_bak
		end
		
	end
		
end






function love.draw()

	if estado_juego == "inicio" then
		---------
		--INICIO
		---------
		gui:pintar_bienvenida()
		
		
	elseif estado_juego == "menu" then	
		--------
		--MENU
		--------
		gui:pintar_menu()
		
		
	elseif estado_juego == "menu-nivel" then
		---------
		--MENU-NIVEL
		---------
		gui:pintar_menu_level()
		
		
	elseif estado_juego == "opciones" then	
		--------
		--OPCIONES
		--------
		gui:pintar_opciones()
		
	elseif estado_juego == "puntuaciones" then
		---------------------------
		--PANTALLA DE PUNTUACIONES
		---------------------------
		gui:pintar_puntuaciones()
	
	elseif estado_juego == "pausa" then
		--------
		--PAUSA
		--------
		--pintamos el juego de fondo
		camera:set()
		mapa:pintar_fondo()
		mapa:pintar()
		character:pintar()
		camera:unset()
		--pintamos ventana de pausa
		gui:pintar_pausa()
		
		
	elseif estado_juego == "jugando" then
		---------
		--JUGANDO
		---------
		camera:set()
		mapa:pintar_fondo()
		mapa:pintar()
		character:pintar()
		camera:unset()
		gui:pintar_ingame()
		
		
	end
	
	
	--pintamos debug, desde cualquier sitio...
	love.graphics.print(s_debug, ventana.width/2, ventana.height-50)
	
end












