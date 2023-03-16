library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity line_follower is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        
        sens_l_in : in std_logic;
        sens_m_in : in std_logic;
        sens_r_in : in std_logic;

        motor_l_pwm : out std_logic;
        motor_r_pwm : out std_logic;
    );
end entity;

architecture structural of line_follower is
    component input_buffer is
        port (
            clk : in std_logic;
            rst : in std_logic;
            sensor_l_in : in std_logic;
            sensor_m_in : in std_logic;
            sensor_r_in : in std_logic;
            sensor_l_out : out std_logic;
            sensor_m_out : out std_logic;
            sensor_r_out : out std_logic
        );
    end component;

    component controller is 
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
    end component;

    component timebase is
        port(
            clk    : in std_logic;
            reset  : in std_logic;
            count_out : out std_logic_vector (19 downto 0)
         );
    end component

    component motor_control is 
        port(
            clk       	: in std_logic;
            reset     	: in std_logic;
            direction 	: in std_logic; --'0' == ccw, '1' == cw.
            count_in   	: in std_logic_vector(19 downto 0); -- count input from timebase
            pwm       	: out std_logic -- Pulse width modulation
    );
    end component;

    signal sens_l_i, sens_m_i, sens_r_i, dir_l_i, dir_r_i, rst_r_i, rst_l_i, rst_t_i, pwm_l, pwm_r : std_logic;
    signal count_o : std_logic_vector(19 downto 0);
begin

    input_buffer: input_buffer port map(
        clk <= clk,
        rst <= rst,
        sensor_l_in <= sens_l_in,
        sensor_m_in <= sens_m_in,
        sensor_r_in <= sens_r_in,
        sensor_l_out <= sens_l_i,
        sensor_m_out <= sens_m_i,
        sensor_r_out <= sens_r_i
    );

    controller: controller port map(
        clk <= clk,
        rst <= rst,
        sensor_l <= sens_l_i,
        sensor_m <= sens_m_i,
        sensor_r <= sens_r_i,
        count_in <= count_o,
        dir_l <= dir_l_i,
        rst_l <= rst_l_i,
        dir_r <= dir_r_i,
        rst_r <= rst_r_i,
        rst_t <= rst_t_i
        );

    timebase: timebase port map(
        clk <= clk,
        rst <= rst_t_i,
        count_out <= count_o
     );

    motor_control_l: motor_control port map
        (
            clk <= clk,
            rst <= rst_l_i,
            direction <= dir_l_i,
            count_in <= count_o,
            pwm <= pwm_l
        );
    end component;

    motor_control_r: motor_control port map
        (
            clk <= clk,
            rst <= rst_r_i,
            direction <= dir_r_i,
            count_in <= count_o,
            pwm <= pwm_r
        );
    end component;

end architecture;