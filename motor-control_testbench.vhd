library ieee;
use ieee.std_logic_1164.all;

entity mc_testbench is
end entity mc_testbench;

architecture structural of mc_testbench is
    component motor_controller is
        port (clk : in std_logic;
        reset : in std_logic;
        sensor : in std_logic;
        motor : out std_logic
        );
    end component motor_controller;

    signal clk : std_logic;
    signal reset : std_logic;
    signal sensor : std_logic;
    signal motor : std_logic;

begin
    clk <= '1' after 0 ms,
           '0' after 10 ms when clk /= '0' else '1' after 10 ms;
    reset <= '1' after 0 ms,
             '0' after 10 ms;
    sensor <= '1' after 0 ms,
              '0' after 20 ms,
              '1' after 40 ms,
              '1' after 50 ms,
              '0' after 60 ms;

    l0: motor_controller port map ( clk => clk,
                                    reset => reset,
                                    sensor => sensor,
                                    motor => motor
    );
end architecture structural;