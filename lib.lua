------------------------------------------------------------------------
-- Spore Bounce
-- Juego hecho en lua con love2d.org
-- 2014 - MdeMoUcH
-- mdemouch@gmail.com - http://www.lagranm.com
------------------------------------------------------------------------


function beginContact(a, b, coll)
	x,y = coll:getNormal()
	
	if a:getUserData() == "Character" or b:getUserData() == "Character" then
		if (a:getUserData() == "muerte" or b:getUserData() == "muerte") and character.vivo and win_flag == false then
			character:die()
		elseif (a:getUserData() == "floor" or b:getUserData() == "floor") then
			character.volando = false
			character.efecto = false
			if math.floor(character.pos) == math.floor(character.pos_1) then
				 --para que no escale por las paredes
				character.saltando = true
				character.volando = true
			end
		elseif (a:getUserData() == "flag" or b:getUserData() == "flag") and win_flag == false then
			win_flag = true
			win_time = os.time()
			character.efecto = false
			character.volando = false
			if level == total_levels then
				sonidos.aplausos:play()
			else
				sonidos.victoria:play()
			end
		elseif a:getUserData() == "efecto" or b:getUserData() == "efecto" then
			character.volando = false
			character.efecto = true
		else
			character.volando = false
			character.efecto = false
		end
	end
end

function endContact(a, b, coll)
	persisting = 0
	if a:getUserData() == "Character" or b:getUserData() == "Character" then
		if a:getUserData() == "Wall" or b:getUserData() == "Wall" then
		elseif a:getUserData() == "Ball" or b:getUserData() == "Ball" then
		elseif a:getUserData() == "floor" or b:getUserData() == "floor" then
			if math.floor(character.pos_y) < math.floor(character.pos_y_1) then
				character.volando = true
			end
		else
			character.volando = true
		end
	end
end

function preSolve(a, b, coll)
	if persisting == 0 then    -- only say when they first start touching
	elseif persisting < 20 then    -- then just start counting
	end
	persisting = persisting + 1    -- keep track of how many updates they've been touching for
end

function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
end





function distancia ( x1, y1, x2, y2 )
	local dx = x1 - x2
	local dy = y1 - y2
	return math.sqrt ( dx * dx + dy * dy )
end





function restart_game()
	single_game(level, mundo_actual,false)
end


function single_game(level, mundo_actual,b_single_match)
	mensaje = "" 
	mapa:cargar(level, mundo_actual)
	world:setCallbacks(beginContact, endContact, preSolve, postSolve)
	character:cargar()
	camera.x = 0
	camera.y = 0
	win_flag = false
	s_win = ""
	start_time = os.time()
	
	if b_single_match == false then
		tiempos_pantallas[level] = 0
		flecha_posicion = 0
	end
	tiempo_actual_bak = 0
	
	estado_juego = "jugando"
	total_levels = mundo.total_levels
	
	b_save_win = true
	b_record = false
	b_world_record = false
end


function continue()
--comprobamos archivos guardados
	b_lastlevel = exist_file("lastlevel")

	if b_lastlevel then
		load_data("lastlevel")
		level = lastlevel.lastlevel
		mundo_actual = lastlevel.lastworld
	end	
	if exist_file("time"..mundo_actual) then
		load_data("time"..mundo_actual)
		eval_loadstring("tiempos_pantallas = time"..mundo_actual)
		b_puntuaciones = true
	else
		tiempos_pantallas = {}
		for i=1, total_levels, 1 do
			tiempos_pantallas[i] = 0
		end
		score = {}
		b_puntuaciones = false
	end
	
	restart_game()
	
	if exist_file("lastlevelv") then
		load_data("lastlevelv")
		character.num_muertes = lastlevelv.lastlevelv
	end
	
end



function eval_loadstring(text)
	local chunk, err = loadstring(text)
	
	if not chunk then -- say(channel, "Could not load code: ".. err)
	else
		local ok, res = pcall(chunk)
		if ok then -- say(channel, "Code executed!")
		else -- say(channel, "Error occurred: " ..res)
		end
	end

end




file_extension = ".sav"

function exist_file(name)
	return love.filesystem.exists(name..file_extension)
end

function save_data(data, name)
	--s_debug = love.filesystem.getSaveDirectory()
	if love.filesystem.exists(name..file_extension) == false then
		love.filesystem.newFile(name..file_extension)
	end
	
	love.filesystem.write(name..file_extension,table.show(data,name))
end

function load_data(name)
	if love.filesystem.exists(name..file_extension) then
		chunk = love.filesystem.load(name..file_extension)
		chunk()
		
		return true
	else
		return false
	end
end



function cargar_ventana()
	ventana = {}
	ventana.width = options.width
	ventana.height = options.height
	love.window.setMode(ventana.width, ventana.height) 
	if options.fullscreen then
		love.window.setFullscreen(true, "normal")--Para poner en pantalla completa
		width, height, flags = love.window.getMode()
		if ventana.width ~= width or ventana.height ~= height then
			ventana.width = width
			ventana.height = height
			love.window.setMode(ventana.width, ventana.height) 
			love.window.setFullscreen(true, "normal")--Para poner en pantalla completa
		end
	else
		love.window.setFullscreen(false)
	end
	gui:cargar_imagenes()
end


function cargar_sonidos()
	sonidos = {}
	
	sonidos.aplausos = love.audio.newSource("sounds/applause.mp3", "static")
	sonidos.aplausos:setVolume(options.volumen_sonidos+0.3)
	sonidos.victoria = love.audio.newSource("sounds/victory.mp3", "static")
	sonidos.victoria:setVolume(options.volumen_sonidos+0.3)
	sonidos.grito = love.audio.newSource("sounds/scream.mp3", "static")
	sonidos.grito:setVolume(options.volumen_sonidos)
	sonidos.salto = love.audio.newSource("sounds/jump.mp3", "static")
	sonidos.salto:setVolume(options.volumen_sonidos)
	
	sonidos.start = love.audio.newSource("sounds/start.mp3")
	sonidos.start:setVolume(options.volumen_musica)
	
	sonidos.music = love.audio.newSource("sounds/music.mp3")
	sonidos.music:setVolume(options.volumen_musica)
	sonidos.music:setLooping(true)

end



function pantalla_completa()

	tiempo_total = os.difftime(win_time,start_time)
	
	tiempos_pantallas[level] = tiempo_total
	
	
	if b_save_win and level <= total_levels then
		--guardamos nivel en el que estamos y los datos de la partida
		if b_single_match == false then
			data = {}
			data.lastlevel = level + 1
			data.lastworld = mundo_actual
			if level == total_levels then
				data.lastlevel = 1
				data.lastworld = mundo_actual + 1
				if data.lastworld > total_mundos then
					data.lastworld = 1
				end
			end
			save_data(data,"lastlevel")
			
			data = {}
			data.lastlevelv = 0
			save_data(data,"lastlevelv")
			save_data(tiempos_pantallas,"time"..mundo_actual)
			
		end
		
		
		-------------------------------------------------------------------------------------------------------------------
		-- !!! -- comprobar aquí si es record, en el fichero nuevo que hay que crear... y si eso se guarda.
		-------------------------------------------------------------------------------------------------------------------
		
		if b_single_match then
			mundo_actual_aux = mundo_actual_menu
			level_aux = flecha_posicion
		else
			mundo_actual_aux = mundo_actual
			level_aux = level
		end
		
		if exist_file("scores") then
			load_data("scores")
			
			if scores[mundo_actual_aux] ~= nil then
				if scores[mundo_actual_aux][level_aux] ~= nil then
					if scores[mundo_actual_aux][level_aux] > tiempo_total then
						scores[mundo_actual_aux][level_aux] = tiempo_total
						save_data(scores,"scores")
						b_record = true
					end
				else
					scores[mundo_actual_aux][level_aux] = tiempo_total
					b_record = true
				end
			else			
				scores[mundo_actual_aux] = {}
				scores[mundo_actual_aux][level_aux] = tiempo_total
				b_record = true
			end
			save_data(scores,"scores")
		else
			scores = {}
			scores[mundo_actual_aux] = {}
			scores[mundo_actual_aux][level_aux] = tiempo_total
			b_record = true
			save_data(scores,"scores")
		end
		
		
		
		
		
		if b_single_match == false then	
			if level == total_levels then
				--guardamos la puntuación de la partida
				i_total = 0
				for i=1, total_levels, 1 do
					i_total = i_total + tiempos_pantallas[i]
				end
				data = {}
				data.tiempo = i_total
				data.tiempos_pantallas = tiempos_pantallas
				data.muertes = character.num_muertes
				
				if exist_file("score"..mundo_actual) then
					load_data("score"..mundo_actual)
					eval_loadstring("score = score"..mundo_actual)
					if i_total < score.tiempo then
						save_data(data,"score"..mundo_actual)
						score = data
						b_world_record = true
					end
				else	
					save_data(data,"score"..mundo_actual)
					score = data
					b_world_record = true
				end
				b_puntuaciones = exist_file("score"..mundo_actual)
			end
		end
		b_save_win = false
	end
	
	
		
	
	
	
	
	if love.keyboard.isDown(' ') or joystick:isGamepadDown("start") then
		if b_single_match then
			start_time = os.time()
			estado_juego = "menu-nivel"
		else
			if level < total_levels then
				level = level + 1
			else
				character.num_muertes = 0
				level = 1
				if mundo_actual == total_mundos then
					mundo_actual = 1
				else
					mundo_actual = mundo_actual + 1
				end
			end
			
			b_lastlevel = true
			restart_game()
		end
	end
		
		
end














--
-- una funcion que pillé por ahí para guardar los datos de una tabla/array como texto....
-- http://lua-users.org/wiki/TableSerialization
--
function table.show(t, name, indent)
   local cart     -- a container
   local autoref  -- for self references
   
   local function isemptytable(t) return next(t) == nil end

   local function basicSerialize (o)
      local so = tostring(o)
      if type(o) == "function" then
         local info = debug.getinfo(o, "S")
         -- info.name is nil because o is not a calling level
         if info.what == "C" then
            return string.format("%q", so .. ", C function")
         else 
            -- the information is defined through lines
            return string.format("%q", so .. ", defined in (" ..
                info.linedefined .. "-" .. info.lastlinedefined ..
                ")" .. info.source)
         end
      elseif type(o) == "number" or type(o) == "boolean" then
         return so
      else
         return string.format("%q", so)
      end
   end

   local function addtocart (value, name, indent, saved, field)
      indent = indent or ""
      saved = saved or {}
      field = field or name

      cart = cart .. indent .. field

      if type(value) ~= "table" then
         cart = cart .. " = " .. basicSerialize(value) .. ";\n"
      else
         if saved[value] then
            cart = cart .. " = {}; -- " .. saved[value] 
                        .. " (self reference)\n"
            autoref = autoref ..  name .. " = " .. saved[value] .. ";\n"
         else
            saved[value] = name
            --if tablecount(value) == 0 then
            if isemptytable(value) then
               cart = cart .. " = {};\n"
            else
               cart = cart .. " = {\n"
               for k, v in pairs(value) do
                  k = basicSerialize(k)
                  local fname = string.format("%s[%s]", name, k)
                  field = string.format("[%s]", k)
                  -- three spaces between levels
                  addtocart(v, fname, indent .. "   ", saved, field)
               end
               cart = cart .. indent .. "};\n"
            end
         end
      end
   end

   name = name or "__unnamed__"
   if type(t) ~= "table" then
      return name .. " = " .. basicSerialize(t)
   end
   cart, autoref = "", ""
   addtocart(t, name, indent)
   return cart .. autoref
end


