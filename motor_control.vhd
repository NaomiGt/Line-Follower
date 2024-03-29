library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity motor_controller is
port( clk       	: in std_logic;
      reset     	: in std_logic;
      direction 	: in std_logic; --'0' == ccw, '1' == cw.
      count_in   	: in std_logic_vector(19 downto 0); -- count input from timebase
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

    process(state, direction, count_in)
    begin
        case state is
            when motor_off =>
                pwm <= '0';
                new_state <= motor_active;

            when motor_active => --move motor cw or ccw
                pwm <= '1';

                if (direction = '0') then --if ccw
                    if(unsigned(count_in) >= to_unsigned(50000, 20)) then
                        new_state <= motor_passive;
                    else
                        new_state <= motor_active;
                    end if;
                elsif (direction = '1') then --if cw
                    if(unsigned(count_in) >= to_unsigned(100000, 20)) then
                        new_state <= motor_passive;
                    else
                        new_state <= motor_active;
                    end if;
		        end if;
            
            when motor_passive =>
                pwm <= '0';
                new_state <= motor_passive;

        end case;
    end process;

end architecture behavioural;