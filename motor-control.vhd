library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity motor_controller is
port( clk       	: in std_logic;
      reset     	: in std_logic;
      direction 	: in std_logic; --'0' == ccw, '1' == cw.
      countin   	: in std_logic_vector(19 downto 0); -- count input from timebase
      pwm       	: out std_logic -- Pulse width modulation
    );

end entity motor_controller;

architecture behavioural of motor_controller is
    type motor_controller_state is (motor_off, --State off is when the motor is fully turned off -> pwm = '0'
                                    motor_active, --State moving is when the motor is generating a pwm signal -> pwm = '1'
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

    process(state, direction, countin)
    begin
        case state is
            when motor_off =>
                pwm_internal <= '0';

                if (direction = '0' or direction = '1') then --if ccw or cw
                    new_state <= motor_active;
		        else
		            new_state <= motor_off;
                end if;

            when motor_active => --move motor cw or ccw
                pwm_internal <= '1';

                if (direction = '0') then --if ccw
                    if(to_integer(unsigned(countin)) >= 50000) then
                        new_state <= motor_passive;
                    end if;
                elsif (direction = '1') then --if cw
                    if(to_integer(unsigned(countin)) >= 100000) then
                        new_state <= motor_passive;
                    end if;
		        else
		            new_state <= motor_off;
                end if;
            
            when motor_passive =>
                pwm_internal <= '0';
                if(to_integer(unsigned(countin)) >= 1000000) then
                    new_state <= motor_active;
                end if;
        end case;
    end process;

	pwm <= std_logic(pwm_internal); --pwm output is the internal pwm 
end architecture behavioural;