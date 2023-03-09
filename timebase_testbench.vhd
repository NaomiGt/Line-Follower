library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench is
end entity testbench;

architecture structural of testbench is
    component timebase is
        port (clk : in std_logic;
        reset : in std_logic;
        countout : out std_logic_vector (19 downto 0)
        );
    end component timebase;

    signal clk : std_logic;
    signal reset : std_logic;
    signal countout : std_logic_vector (19 downto 0);

begin
    clk <= '1' after 0 us,
           '0' after 0.01 us when clk /= '0' else '1' after 0.01 us;
    reset <= '1' after 0 us,
             '0' after 10 us;

    l0: timebase port map ( clk => clk,
                            reset => reset,
                            countout => countout
    );
end architecture structural;
