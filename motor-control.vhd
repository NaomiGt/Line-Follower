library ieee;
use ieee.std_logic_1164.all;

entity motor_controller is
port( clk : in std_logic;
      reset : in std_logic;
      sensor : in std_logic;
      motor : out std_logic
    );
end entity motor_controller;

architecture behavioural of motor_controller is
    type motor_controller_state is (motor_off,
                                    motor_on);
    signal state, new_state: motor_controller_state;

begin
    process(clk)
    begin
        if(rising_edge(clk)) then
            if(reset = '1') then
                state <= motor_off;
            else
                state <= motor_on;
            end if;
        end if;
    end process;

    process(state, sensor)
    begin
        case state is
            when motor_off =>
                motor <= '0';

                if(sensor = '1') then
                    new_state <= motor_on;
                else
                    new_state <= motor_off;
                end if;
            when motor_on =>
                motor <= '1';

                if(sensor = '0') then
                    new_state <= motor_off;
                else
                    new_state <= motor_on;
                end if;
        end case;
    end process;
end architecture behavioural;