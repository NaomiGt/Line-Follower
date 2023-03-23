library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity three_bit_registry is
    port(
        clk : in std_logic;
        rst: in std_logic;
        sens_in_reg : in std_logic_vector(2 downto 0);
        sens_out_reg : out std_logic_vector(2 downto 0)
    );
end entity three_bit_registry;

architecture behavioural of three_bit_registry is
begin

process(clk)
begin 
    if(rising_edge(clk)) then
        if (rst = '1') then
            sens_out_reg <= (others => '0');
        else
            sens_out_reg <= sens_in_reg;
        end if;
    end if;
end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity input_buffer is
    port(
        clk : in std_logic;
        rst: in std_logic;
        sens_in : in std_logic_vector(2 downto 0);
        sens_out : out std_logic_vector(2 downto 0)
    );
end entity input_buffer;

architecture structural of input_buffer is

    component three_bit_registry is
        port(
            clk : in std_logic;
            rst: in std_logic;
            sens_in_reg : in std_logic_vector(2 downto 0);
            sens_out_reg : out std_logic_vector(2 downto 0)
        );
    end component;

    signal sens_i, sens_o : std_logic_vector(2 downto 0);

begin 

    lb0: three_bit_registry port map(
        clk => clk,
        rst => rst,
        sens_in_reg => sens_in,
        sens_out_reg => sens_i
        );

    lb1: three_bit_registry port map(
        clk => clk,
        rst => rst,
        sens_in_reg => sens_i,
        sens_out_reg => sens_o
        );

    sens_out <= std_logic_vector(sens_o);
end architecture;
