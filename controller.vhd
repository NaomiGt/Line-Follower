library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller is
    port (
        clk   : in std_logic;
        rst : in std_logic; --internal rst
        sens_in_ctrl : in std_logic_vector(2 downto 0);
        count_in : in std_logic_vector(19 downto 0);
        dir_l : out std_logic;
        rst_l : out std_logic;
        dir_r : out std_logic;
        rst_r : out std_logic;
        rst_t : out std_logic
    );
end entity;

architecture behavioural of controller is
        type controller_state is (
            decide,
            forward,
            gen_right, --gentle right
            right,
            gen_left, --gentle left
            left
            );
    
        signal state, new_state : controller_state;
        signal rst_r_i, rst_l_i, dir_l_i, dir_r_i: std_logic;

begin

process(clk)
begin
    if(rising_edge(clk)) then
        if(rst = '1') then
            state <= decide; --decide direction if rst
            rst_t <= '1';
        elsif(to_integer(unsigned(count_in)) >= 100000) then
            state <= decide;
            rst_t <= '1';
       
        else
            state <= new_state; --Assign new state to current state
	        rst_t <= '0';
        end if;

       
    end if;

end process;


process(state, sens_in_ctrl, clk)  --sens_in_ctrl = '1' -> black sens_in_ctrl = '0' -> white && cw/forward = '1' and ccw/backward = '0'
begin    
    case state is
        when decide =>
            dir_l_i <= '0';
            dir_r_i <= '0';
            rst_l_i <= '0';
            rst_r_i <= '0';

            if (sens_in_ctrl =  "000") then --0
                new_state <= forward;
            elsif(sens_in_ctrl = "010" ) then --2
                new_state <= forward;
            elsif (sens_in_ctrl = "101" ) then --5
                new_state <= forward;
            elsif(sens_in_ctrl = "111" ) then --7
                new_state <= forward;
            elsif(sens_in_ctrl = "001") then --1
                new_state <= gen_left;
            elsif (sens_in_ctrl = "011") then --3
                new_state <= left;
            elsif (sens_in_ctrl = "100") then --4
                new_state <= gen_right;
            elsif (sens_in_ctrl = "110") then --6
                new_state <= right;
            end if;
            
        when forward =>
            dir_l_i <= '1';
            dir_r_i <= '1';
            rst_l_i <= '0';
            rst_r_i <= '0';

        when gen_right =>
            dir_l_i <= '1';
            rst_r_i <= '1';
            rst_l_i <= '0';
            dir_r_i <= '0';

        when right =>
            dir_l_i <= '1';
            dir_r_i <= '0';
            rst_r_i <= '0';
            rst_l_i <= '0';

        when gen_left =>
            rst_l_i <= '1';
            dir_r_i <= '1';
            rst_r_i <= '0';
            dir_l_i <= '0';

        when left =>
            dir_l_i <= '0';
            dir_r_i <= '1';
            rst_r_i <= '0';
            rst_l_i <= '0';

    end case;

end process;

rst_l <= rst_l_i;
rst_r <= rst_r_i;
dir_l <= dir_l_i;
dir_r <= dir_r_i;

end architecture; 