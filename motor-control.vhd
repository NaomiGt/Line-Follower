library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity motor_controller is
port( clk       	: in std_logic;
      reset     	: in std_logic;
      direction 	: in std_logic; --'0' == ccw, '1' == cw.
      countin   	: in std_logic_vector(19 downto 0); -- count input from timebase
      timebase_rst 	: out std_logic; -- Signal to timebase for reseting counter (defunct)
      pwm       	: out std_logic -- Pulse width modulation
    );

end entity motor_controller;

architecture behavioural of motor_controller is
    type motor_controller_state is (motor_off, --State off is when the motor is fully turned off -> pwm = '0'
                                    motor_moving, --State moving is when the motor is generating a pwm signal -> pwm = '1'
                                    motor_passive); --State passive is when the motor is waiting for the next pwm -> pwm = '0'
    signal state, new_state: motor_controller_state;
    signal pwm_internal : std_logic; -- Internal pwm signal = pwm but internally
begin
    process(clk)
    begin
        if(rising_edge(clk)) then
		 if(reset = '1') then
                	state <= motor_off; --Turn motor off if reset is on
            	else
                	state <= new_state; --Assign new state to current state
            	end if;
	    end if;
    end process;

    process(state, direction)
    begin
	    report "The current state is " &motor_controller_state'image(state); --print current state on change of dir
        case state is
            when motor_off =>
                pwm_internal <= '0';
                
                if (direction = '0') then --if ccw
                    new_state <= motor_moving;
                elsif (direction = '1') then --if cw
                    new_state <= motor_moving;
		        else
		            new_state <= motor_off;
                end if;

            when motor_moving => --move motor cw or ccw
                pwm_internal <= '1';
                
                if (direction = '0') then --if ccw
                    new_state <= motor_passive after 1 ms;
                elsif (direction = '1') then --if cw
                    new_state <= motor_passive after 2 ms;
		        else
		            new_state <= motor_off;
                end if;
            
            when motor_passive =>
                pwm_internal <= '0';

                if (direction = '0') then --if ccw
                    new_state <= motor_moving after 19 ms;
                elsif (direction = '1') then --if cw
                    new_state <= motor_moving after 18 ms;
                else
                    new_state <= motor_off;
                end if;
        end case;
    end process;

	pwm <= std_logic(pwm_internal); --pwm output is the internal pwm 
end architecture behavioural;