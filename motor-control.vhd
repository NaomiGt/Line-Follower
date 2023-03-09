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
            else
            end if;
        end if;
    end process;
end architecture behavioural;