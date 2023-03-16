library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller is
    port (
        clk   : in std_logic;
        rst : in std_logic; --internal rst
        sens_l : in std_logic;
        sens_m : in std_logic;
        sens r : in std_logic;
        count_in : in std_logic_vector(19 downto 0);
        dir_l : out std_logic;
        rst_l : out std_logic;
        dir_r : out std_logic;
        rst_r : out std_logic;
        rst_t : out std_logic
    );
end entity;

architecture behavioural of controller is
        type controller_state is (decide,
            forward,
            gen_right, --gentle right
            right,
            gen_left, --gentle left
            left
            );
    
        signal state, new_state : controller_state;
        signal sens : std_logic_vector(2 downto 0); --sensor input representation l-m-r

begin

process(sens_l, sens_m, sens_r) --create sens logic vector from different logic signals
begin
    sens(2) <= sens_l;
    sens(1) <= sens_m;
    sens(0) <= sens_r;
end process;

process(clk)
begin
    if(rising_edge(clk)) then
        if(rst = '1') then
                   state <= decide; --decide direction if rst
               else
                   state <= new_state; --Assign new state to current state
               end if;
       end if;
end process;

process(state, sens)  --sens = '1' -> black sens = '0' -> white && cw/forward = '1' and ccw/backward = '0'
begin
    case state is
        when decide =>
            rst_t <= '0';
            rst_l <= '0';
            rst_r <= '0';
            if (to_integer(unsigned(sens)) = '0' or to_integer(unsigned(sens)) = '2' or to_integer(unsigned(sens)) = '5' or to_integer(unsigned(sens)) = '7') then
                new_state <= forward;
            elsif (to_integer(unsigned(sens)) = '1') then
                new_state <= gen_left;
            elsif (to_integer(unsigned(sens)) = '3') then
                new_state <= left;
            elsif (to_integer(unsigned(sens)) = '4') then
                new_state <= gen_right;
            else
                new_state <= right;
            end if;

        when forward =>
            dir_l <= '1';
            dir_r <= '1';
            if(to_integer(unsigned(count_in)) >= 1000000) then
                new_state <= decide;
                rst_t <= '1';
            end if;

        when gen_right =>
            dir_l <= '1';
            rst_r <= '1';
            if(to_integer(unsigned(count_in)) >= 1000000) then
                new_state <= decide;
                rst_t <= '1';
            end if;

        when right =>
            dir_l <= '1';
            dir_r <= '0';
            if(to_integer(unsigned(count_in)) >= 1000000) then
                new_state <= decide;
                rst_t <= '1';
            end if;

        when gen_left =>
            rst_l <= '1';
            dir_r <= '1';
            if(to_integer(unsigned(count_in)) >= 1000000) then
                new_state <= decide;
                rst_t <= '1';
            end if;

        when left =>
            dir_l <= '0';
            dir_r <= '1';
            if(to_integer(unsigned(count_in)) >= 1000000) then
                new_state <= decide;
                rst_t <= '1';
            end if;

    end case;
    
end process;
end architecture; 