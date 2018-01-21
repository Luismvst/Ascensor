
library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use ieee.std_logic_arith.ALL;
    use ieee.std_logic_unsigned.ALL;
    

entity FSM is
PORT (
	clk, reset : in std_logic; 
	f_carrera_puerta : in std_logic_vector (1 downto 0); -- 01 cerrado, 10 abierto 
	boton_stop : in std_logic;
	sensor_apertura : in std_logic;	--Nos indica que se encuentra en un piso adecuado para parar ( nosotros lo paramos como sensor externo)
	sensor_presencia : in std_logic;
	boton: in std_logic_vector (2 downto 0);
	piso : in std_logic_vector (2 downto 0);
	--El boton tiene un estado de reposo que es el 000 (no hay nada pulsandolo)
	destino : out std_logic_vector (2 downto 0);
	accion_motor: out std_logic_vector (1 downto 0); --10 subir, 01 bajar 
	accion_motor_puerta: out std_logic_vector (1 downto 0) -- 10 abrir, 01 cerrar
	);
end FSM;

architecture Behavioral of FSM is 

	type estado is ( inicio, cerrar, abrir, marcha, reposo, emergencia);
	signal presente: estado:=inicio;
	shared variable boton_memoria: std_logic_vector (2 downto 0);	--Guarda el boton que hemos pulsado
	begin
	MaquinaEstados : process (reset, clk)	--FSM
		begin
		if reset = '0' then presente <= inicio;
		elsif rising_edge (clk) then
			case presente is
				when inicio => --Por si al empezar tenemos que ajustar el ascensor
					if piso = "001" and f_carrera_puerta = "01"  then
						presente <= abrir;
                    end if;
				when reposo => --Ascensor parado
					if boton/="000" and boton/=piso then
						boton_memoria := boton;	
						presente <= cerrar;
					end if;
				when cerrar => --cerrando puertas
					if sensor_presencia = '1' then
						presente <= abrir;
					elsif f_carrera_puerta = "01" then 
						presente <= marcha; 	--Se puede emprender el movimiento
					end if;
				when marcha => --Moviendose
					if boton_memoria = piso and sensor_apertura = '1' then 
						presente <= abrir;
					elsif boton_stop = '1' then
						presente <= emergencia;
					end if;
				when abrir => --Abriendo puertas
					if f_carrera_puerta = "10" then
						boton_memoria := (others => '0');
						presente <= reposo;
					end if;
				when emergencia => --Estado de stop
					if boton_stop = '0' then
						presente <= marcha;
					end if;
			end case;
		end if;
	end process;

	MaquinaAcciones : process (presente)	--SALIDA -> Solo cuando cambia el estado (lista de sensibilidad)
		begin					
		case presente is

			when inicio => --Cuando iniciamos el ascensor por primera vez				
				accion_motor_puerta <= "00";	--Puerta cerrada
				if f_carrera_puerta /= "01" then
					accion_motor_puerta <= "01";
				elsif piso /= "001" and f_carrera_puerta = "01" then 		--Piso supuesto inicial
					accion_motor <= "01";	--Bajamos al piso inicial
					accion_motor_puerta <= "00";
				else 
					accion_motor <= "00";
					accion_motor_puerta <= "00"; 	--Parado
				end if;

			when marcha => 
				accion_motor_puerta <= "00";	--Puerta cerrada
				if (boton_memoria > piso) then
					accion_motor <= "10";	--Subir
				elsif (boton_memoria < piso ) then
					accion_motor <= "01"; 	--Bajar
				else
					accion_motor <= "00"; 	--Parado por seguridad... no llegaremos a este estado en principio. No estaríamos en marcha
				end if;		

			when abrir => 
				accion_motor_puerta <= "10"; 		--Abrir puerta
				accion_motor <=  "00"; 		       --Parado

			when cerrar => 
				accion_motor_puerta <= "01";	     --Cerrar puerta;
				accion_motor <= "00";		     --Parado

			when reposo => 
				accion_motor_puerta <= "00"; 	--Puerta quieta
				accion_motor <= "00";  --motor quieto

			when others => 	--Por seguridad
				accion_motor <= "00";
				accion_motor_puerta <= "00";
		end case;
	end process;

	destino <= boton_memoria;

	--Aqui podriamos instanciar la memoria para que si pulsas un boton a lo largo del trayecto, guarde una ruta hacia el siguiente piso objetivo. No lo implemento ahora mismo.
end architecture Behavioral;
