library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity motor_controller is
port( clk       : in std_logic;
      reset     : in std_logic;
      direction : in std_logic; --'0' == ccw, '1' == cw.
      countin   : in std_logic_vector(19 downto 0);
      pwm       : out std_logic
    );

end entity motor_controller;

architecture behavioural of motor_controller is
    type motor_controller_state is (motor_off,
                                    motor_ccw,
                                    motor_cw);
    signal state, new_state: motor_controller_state;

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

    process(state, direction, clk)
    begin
        case state is
            when motor_off =>
                pwm <= '0';

                if(direction = '1') then
                    new_state <= motor_cw;
                else
                    new_state <= motor_ccw;
                end if;

            when motor_ccw =>
                pwm <= '1';
		        pwm <= '0' after 1 ns;

                if(direction = '1') then
                    new_state <= motor_cw;
                else
                    new_state <= motor_ccw;
                end if;
            
            when motor_cw =>
                pwm <= '1';
		        pwm <= '0' after 2 ns;

                if(direction = '1') then
                    new_state <= motor_cw;
                else
                    new_state <= motor_ccw;
                end if;
        end case;
    end process;
end architecture behavioural;