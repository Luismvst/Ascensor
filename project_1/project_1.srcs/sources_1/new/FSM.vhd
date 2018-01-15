
library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use ieee.std_logic_arith.ALL;
    use ieee.std_logic_unsigned.ALL;
    
    --Fsm Es el encargado de tomar las decisiones que van a ir a prácticamente el resto de los módulos que componen el ascensor
    --Reaccionarán tal y como FSM les indica.
    --Se traslada el Ascensor que programamos originalmente a este submódulo creado para encapsular la toma de responsabilidades un nivel más

entity FSM is
PORT (
	clk, reset : in std_logic; 
	--puerta: in std_logic; 	--Puerta abierta o puerta cerrada
	abriendo_puerta : in std_logic;
	cerrando_puerta : in std_logic;
	sensor_piso : in std_logic;	--Nos indica que se encuentra en un piso adecuado para parar ( nosotros lo paramos como sensor externo)
	boton: in std_logic_vector (2 downto 0);
	piso : in std_logic_vector (2 downto 0);
	--El boton tiene un estado de reposo que es el 000 (no hay nada pulsandolo)
	boton_pulsado : out std_logic_vector (2 downto 0);
	accion_motor: out std_logic_vector (1 downto 0);
	accion_motor_puerta: out std_logic
	);
end FSM;

architecture Behavioral of FSM is 

	type estado is ( inicio, cerrar, abrir, marcha, reposo);
	signal presente: estado:=reposo;
	shared variable boton_memoria: std_logic_vector (2 downto 0):=boton;	--Guarda el boton que hemos pulsado
	begin
	MaquinaEstados : process (reset, clk)	--FSM
		begin
		if reset = '1' then presente <= inicio;
		elsif rising_edge (clk) then
			case presente is
				when inicio => --Por si al empezar tenemos que ajustar el ascensor
					if sensor_piso = '1' then
						presente <= reposo;
                    end if;
				when reposo => --Ascensor parado
					if boton/="000" and boton/=piso then
						presente <= cerrar;
						boton_pulsado <= boton;
						boton_memoria := boton;
					end if;
				when cerrar => --cerrando puertas
					if cerrando_puerta = '1' then 
						presente <= marcha; 	--Se puede emprender el movimiento
					end if;
				when marcha => --Moviendose
					if boton = piso and sensor_piso = '1' then 
						presente <= abrir;
					end if;
				when abrir => --Abriendo puertas
					if abriendo_puerta = '1' then
						presente <= reposo;
					end if;
			end case;
		end if;
	end process;

	MaquinaAcciones : process (presente)	--SALIDA -> Solo cuando cambia el estado (lista de sensibilidad)
		begin	
		case presente is

			when inicio => --Cuando iniciamos el ascensor por primera vez				
				accion_motor_puerta <= '0';	--Puerta cerrada
				if piso /= "001" then 		--Piso supuesto inicial
					accion_motor <= "01";	--Bajamos al piso inicial
				else 
					accion_motor <= "00"; 	--Parado
				end if;

			when marcha => 
				accion_motor_puerta <= '0';	--Puerta cerrada
				if (boton_memoria > piso) then
					accion_motor <= "10";	--Subir
				elsif (boton_memoria < piso ) then
					accion_motor <= "01"; 	--Bajar
				else
					accion_motor <= "00"; 	--Parado por seguridad... no llegaremos a este estado en principio. No estaríamos en marcha
				end if;		

			when abrir => 
				accion_motor_puerta <= '1'; 		--Puerta Abierta;
				accion_motor <=  "00"; 		       --Parado

			when cerrar => 
				accion_motor_puerta <= '0';	     --Puerta Cerrada;
				accion_motor <= "00";		     --Parado

			when reposo => 
				accion_motor_puerta <= '1'; 	--Puerta Abierta;
				accion_motor <= "00";

			when others => 	--Por seguridad
				accion_motor <= "00";
				accion_motor_puerta <= '0';
		end case;
	end process;

	--Aqui podriamos instanciar la memoria para que si pulsas un boton a lo largo del trayecto, guarde una ruta hacia el siguiente piso objetivo. No lo implemento ahora mismo.
end architecture Behavioral;
