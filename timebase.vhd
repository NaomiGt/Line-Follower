library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timebase is 
    port(clk    : in std_logic;
         reset  : in std_logic;
         countout : out std_logic_vector (19 downto 0)
         );
end entity timebase;

architecture behavioural of timebase is 
    signal newcount, count: unsigned (19 downto 0);

begin
    process (clk)
    begin 
        if (rising_edge (clk)) then 
            if (reset = '1') then
                count <= (others => '0');
            else
                count <= newcount;
            end if;
        end if;
    end process;

    process(count)
    begin
        newcount <= count + 1;
    end process;

    countout <= std_logic_vector(count);
end architecture behavioural;
