library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity line_follower is
    port (
        clk : in std_logic;
        rst : in std_logic;
        
        sens_in_lf : in std_logic_vector(2 downto 0);

        motor_l_pwm : out std_logic;
        motor_r_pwm : out std_logic
    );
end entity;

    
architecture structural of line_follower is

    component input_buffer is
        port (
            clk : in std_logic;
            rst : in std_logic;
            sens_in : in std_logic_vector(2 downto 0);
            sens_out : out std_logic_vector(2 downto 0)
        );
    end component;

    component controller is 
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
    end component;

    component timebase is
        port(
            clk    : in std_logic;
            reset  : in std_logic;
            count_out : out std_logic_vector(19 downto 0)
         );
    end component;

    component motor_controller is 
        port(
            clk       	: in std_logic;
            reset     	: in std_logic;
            direction 	: in std_logic; --'0' == ccw, '1' == cw.
            count_in   	: in std_logic_vector(19 downto 0); -- count input from timebase
            pwm       	: out std_logic -- Pulse width modulation
    	);
    end component;

    signal dir_l_i, dir_r_i, pwm_l, pwm_r : std_logic;
    signal rst_r_i, rst_l_i, rst_t_i : std_logic;
    signal count_o : std_logic_vector(19 downto 0);
    signal sens_i : std_logic_vector(2 downto 0);

begin
    timebase_lf : timebase port map(
        clk => clk,
        reset => rst_t_i,
        count_out => count_o
     );

    in_buf: input_buffer port map(
        clk => clk,
        rst => rst,
        sens_in => sens_in_lf,
        sens_out => sens_i
    );

    ctrl: controller port map(
        clk => clk,
        rst => rst,
        sens_in_ctrl => sens_i,
        count_in => count_o,
        dir_l => dir_l_i,
        rst_l => rst_l_i,
        dir_r => dir_r_i,
        rst_r => rst_r_i,
        rst_t => rst_t_i
        );

    motor_control_l: motor_controller port map(
            clk => clk,
            reset => rst_l_i,
            direction => dir_l_i,
            count_in => count_o,
            pwm =>  motor_l_pwm
        );

    motor_control_r: motor_controller port map
        (
            clk => clk,
            reset => rst_r_i,
            direction => dir_r_i,
            count_in => count_o,
            pwm => motor_r_pwm
        );

end architecture;
