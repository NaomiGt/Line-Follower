library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity input_buffer_testbench is
end entity input_buffer_testbench;

architecture structural of input_buffer_testbench is
    component input_buffer is
        port (
            clk : in std_logic;
            rst: in std_logic;
            sens_in : in std_logic_vector(2 downto 0);
            sens_out : out std_logic_vector(2 downto 0)
        );
    end component input_buffer;

    signal clk, rst : std_logic;
    signal sens_in, sens_out  : std_logic_vector(2 downto 0);

begin
    lb0: input_buffer port map (
        clk,
        rst,
        sens_in,
        sens_out
        );

    clk         	<=     '0' after 0 ns,
                           '1' after 10 ns when clk /= '1' else '0' after 10 ns;
    rst       	<=     '1' after 0 ns,
                           '0' after 10 ns;
                    	    
    sens_in <=  "000" after 0 ns,--bbb
                "001" after 70 ns,--bbw
                "010" after 110 ns,--bwb
                "011" after 150 ns,--bww
                "100" after 190 ns,--wbb
                "101" after 230 ns,--wbw
                "110" after 270 ns,--wwb
                "111" after 310 ns;--www
end architecture structural;