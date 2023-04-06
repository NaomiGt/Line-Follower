library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity line_follower_tb is
end entity line_follower_tb;

architecture structural of line_follower_tb is

  component line_follower
    port (
      clk : in std_logic;
      rst : in std_logic;

      sens_in_lf : in std_logic_vector(2 downto 0);

      motor_l_pwm : out std_logic;
      motor_r_pwm : out std_logic
    );

  end component line_follower;

  signal clk, rst : std_logic;
  signal sens_in : std_logic_vector(2 downto 0);
  signal motor_l_pwm, motor_r_pwm : std_logic;

begin

  lbl0 : line_follower port map(
    clk => clk,
    rst => rst,
    sens_in_lf => sens_in,
    motor_l_pwm => motor_l_pwm,
    motor_r_pwm => motor_r_pwm
  ); --20ns=50MHz

  clk <= '0' after 0 ns,
    '1' after 10 ns when clk /= '1' else '0' after 10 ns;

  rst <= '1' after 0 ns,
    '0' after 40 ns;

  sens_in <= "000" after 0 ns, --bbb
    "001" after 100 ms, --bbw
    "010" after 200 ms, --bwb
    "011" after 300 ms, --bww
    "100" after 400 ms, --wbb
    "101" after 500 ms, --wbw
    "110" after 600 ms, --wwb
    "111" after 700 ms;--www

end architecture structural;