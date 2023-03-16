library ieee;
use ieee.std_logic_1164.all;

entity input_buffer_testbench is
end entity input_buffer_testbench;

architecture structural of input_buffer is
    component input_buffer is
        port (clk : in std_logic;
        rst: in std_logic;
        sensor_l : in std_logic;
        sensor_m : in std_logic;
        sensor_r : in std_logic;
        sensor_l_o : out std_logic;
        sensor_m_o : out std_logic;
        sensor_r_o : out std_logic
        );
    end component motor_controller;

    signal clk, reset: std_logic;

begin
    l0: input_buffer port map (
        clk => clk;
        rst => rst;
        sensor_l => sensor_l;
        sensor_m => sensor_m;
        sensor_r => sensor_r;
        sensor_l_o => sensor_l_o;
        sensor_m_o => sensor_m_o;
        sensor_r_o => sensor_m_o;
        );

    clk         	<=  '0' after 0 ns,
                        '1' after 10 ns when clk /= '1' else '0' after 10 ns;
    reset       	<=  '1' after 0 ns,
                        '0' after 20 ns;
        sensor_l    <=  '0' after 0 ns,
                        '1' after 25 ns,
                        '0' after 40 ns,
                        '1' after 55 ns,
                        '0' after 65 ns,
                        '1' after 95 ns,
                        '0' after 100 ns;
        sensor_m    <=  '0' after 0 ns;
        sensor_r    <=  '0' after 0 ns;    
                    	    
end architecture structural;