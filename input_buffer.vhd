library ieee;
use ieee.std_logic_1164.all;

entity three_bit_registry is
    port(
        clk : in std_logic;
        rst: in std_logic;
        sensor_l : in std_logic;
        sensor_m : in std_logic;
        sensor_r : in std_logic;
        sensor_l_o : out std_logic;
        sensor_m_o : out std_logic;
        sensor_r_o : out std_logic
    );
end entity three_bit_registry;

architecture behavioural of three_bit_registry is
begin

process(clk)
begin 
    if(rising_edge(clk)) then
        if (rst = '1') then
        sensor_l_o <= '0';
        sensor_m_o <= '0';  
        sensor_r_o <= '0';
        else
        sensor_l_o <= sensor_l;
        sensor_m_o <= sensor_m;  
        sensor_r_o <= sensor_r;
        end if;
    end if;
end process;
end architecture;

entity input_buffer is
    port(
        clk : in std_logic;
        rst: in std_logic;
        sensor_l : in std_logic;
        sensor_m : in std_logic;
        sensor_r : in std_logic;
        sensor_l_o : out std_logic;
        sensor_m_o : out std_logic;
        sensor_r_o : out std_logic
    );
end entity input_buffer;

architecture behavioural of input_buffer is
    signal sensor_l_i, sensor_m_i,sensor_r_i : std_logic;

begin 
    lb0: three_bit_registry port map(sensor_l <= sensor_l_i, sensor_m <= sensor_m_i,sensor_r <= sensor_r_i);
    lb0: three_bit_registry port map(sensor_l_i <= sensor_l_o, sensor_m_i <= sensor_m_o , sensor_r_i <= sensor_r_o);
end architecture;
