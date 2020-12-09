library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;
entity fenpin is
port (clk:in std_logic;
reset : in std_logic;
clk_1hz : out std_logic
);
end fenpin;
architecture Behavioral of fenpin is
signal q :integer range 0 to 25000000;
signal clkr :std_logic;
begin
process (clk)
--此进程产生一个持续时间为一秒的的闸门信号
begin
if reset='1' then q<=0; clk_1hz<='0'; clkr<='0' ;
elsif clk'event and clk='1' then
if q<24999999 then q<=q+1;
elsif q=24999999 then
q<=0;
clkr<=not clkr;
end if;
end if;
clk_1hz<=clkr ;
end process ;
end Behavioral;
--分频模块