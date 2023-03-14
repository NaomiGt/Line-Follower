library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity motor_controller is
port( clk       	: in std_logic;
      reset     	: in std_logic;
      direction 	: in std_logic; --'0' == ccw, '1' == cw.
      countin   	: in std_logic_vector(19 downto 0);
      timebase_rst 	: out std_logic; -- Signal to timebase for reseting counter
      pwm       	: out std_logic -- Pulse width modulation
    );

end entity motor_controller;

architecture behavioural of motor_controller is
    type motor_controller_state is (motor_off,
                                    motor_moving,
                                    motor_passive);
    signal state, new_state: motor_controller_state;
    signal pwm_internal : std_logic;
begin
    process(clk)
    begin
        if(rising_edge(clk)) then
		 if(reset = '1') then
                	state <= motor_off;
            	else
                	state <= new_state;
            	end if;
	    end if;
    end process;

    process(state, direction)
    begin
	    report "The current state is " &motor_controller_state'image(state);
        case state is
            when motor_off =>
                pwm_internal <= '0';
                
                if (direction = '0') then --ccw
                    new_state <= motor_moving;
                elsif (direction = '1') then --cw
                    new_state <= motor_moving;
		        else
		            new_state <= motor_off;
                end if;

            when motor_moving => --move motor cw or ccw
                pwm_internal <= '1';
                
                if (direction = '0') then --ccw
                    new_state <= motor_passive after 1 ms;
                elsif (direction = '1') then --cw
                    new_state <= motor_passive after 2 ms;
		        else
		            new_state <= motor_off;
                end if;
            
            when motor_passive =>
                pwm_internal <= '0';

                if (direction = '0') then --ccw
                    new_state <= motor_moving after 19 ms;
                elsif (direction = '1') then --cw
                    new_state <= motor_moving after 18 ms;
		else
		    new_state <= motor_off;
                end if;
        end case;
    end process;

	pwm <= std_logic(pwm_internal); --pwm output is the internal pwm (working)
end architecture behavioural;