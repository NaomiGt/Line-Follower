library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity input_buffer_testbench is
end entity input_buffer_testbench;

architecture structural of input_buffer_testbench is
    component input_buffer is
        port (clk : in std_logic;
              rst: in std_logic;
              sensor_l_in : in std_logic;
              sensor_m_in : in std_logic;
              sensor_r_in : in std_logic;
              sensor_l_out : out std_logic;
              sensor_m_out : out std_logic;
              sensor_r_out : out std_logic
        );
    end component input_buffer;

    signal clk, rst, sensor_l_in, sensor_m_in, sensor_r_in, sensor_l_out, sensor_m_out, sensor_r_out : std_logic;

begin
    lb0: input_buffer port map (
        clk,
        rst,
        sensor_l_in,
        sensor_m_in,
        sensor_r_in,
        sensor_l_out,
        sensor_m_out,
        sensor_r_out
        );

    clk         	<=     '0' after 0 ns,
                           '1' after 10 ns when clk /= '1' else '0' after 10 ns;
    rst       	<=     '1' after 0 ns,
                           '0' after 500 ns;
    sensor_l_in    <=      '0' after 0 ns,
                           '1' after 250 ns,
                           '0' after 400 ns,
                           '1' after 550 ns,
                           '0' after 650 ns,
                           '1' after 950 ns,
                           '0' after 1000 ns;
    sensor_m_in    <=      '0' after 0 ns;
    sensor_r_in    <=      '0' after 0 ns;    
                    	    
end architecture structural;