library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;

entity liu is
port (clk:in std_logic;
s:in std_logic_vector(3 downto 0);
led7s:out std_logic_vector(6 downto 0);
zd:out std_logic;
q:out std_logic_vector(7 downto 0));
end;

architecture decl of liu is 
signal mode:std_logic_vector(2 downto 0);
signal mode1:std_logic_vector(2 downto 0);
begin
-----------------------------------------
-------彩灯--------------------
process(clk,mode)
variable qs:std_logic_vector(7 downto 0);
begin
if rising_edge(clk) then			-- 这个是上升沿的意思,一般还等价于clk' event clk='1';
--从右到左连续点亮
		if mode=0 then
			if qs=0 then
				qs:="10000000";
			elsif qs="11111111" then
				qs:="00000000";mode1<="001";
			else
				qs(6 downto 0):=qs(7 downto 1); 
		end if;
--从左到右连续点亮
		elsif mode=1 then
		if qs=0 then
			qs:="00000001";
		elsif qs="11111111" then
			qs:="00000000";mode1<="010";
		else
			qs(7 downto 1):=qs(6 downto 0);
		end if;
--从两边向中间连续点亮
		elsif mode=2 then
		if qs=0 then
			qs:="10000001";
		elsif qs="11111111" then
			qs:="00000000";mode1<="011";
		else
			qs(6 downto 4):=qs(7 downto 5);
			qs(3 downto 1):=qs(2 downto 0);
		end if;
--从中间向两边连续点亮
		elsif mode=3 then
		if qs=0 then
			qs:="00011000";
		elsif qs="11111111" then
			qs:="00000000";mode1<="100";
		else
			qs(7 downto 5):=qs(6 downto 4);
			qs(2 downto 0):=qs(3 downto 1);
		end if;
--从右到左逐个点亮
		elsif mode=4 then
		if qs=0 then
			qs:="10000000";
		elsif qs="00000001" then
			qs:="00000000";mode1<="101";
		else
			qs(6 downto 0):=qs(7 downto 1);
			qs(7):='0';
		end if;
--从左到右逐个点亮
		elsif mode=5 then
		if qs=0 then
			qs:="00000001";
		elsif qs="10000000" then
			qs:="00000000";mode1<="110";
		else
			qs(7 downto 1):=qs(6 downto 0);
			qs(0):='0';
		end if;
--从中间向两边逐个点亮
		elsif mode=6 then
		if qs=0 then
			qs:="00011000";
		elsif qs="10000001" then
			qs:="00000000";mode1<="111";
		else
			qs(7 downto 5):=qs(6 downto 4);qs(4):='0';
			qs(2 downto 0):=qs(3 downto 1);qs(3):='0';
		end if;
--从两边向中间逐个点亮
		elsif mode=7 then	
		if qs=0 then
			qs:="10000001";
		elsif qs="00011000" then
			qs:="00000000";mode1<="000";
		else
			qs(6 downto 4):=qs(7 downto 5);qs(7):='0';
			qs(3 downto 1):=qs(2 downto 0);qs(0):='0';
		end if;
	end if;
end if;
q<=qs;
end process;
process(s,mode1)
begin
if s(3)='0' then--总开关
	mode<=mode1;
else 
	mode<=s(2 downto 0);
end if;
end process;

zd<=s(3);
------译码---------------------
process(mode)
begin
case mode is

when "000" =>led7s<="1111001";--1(共阳极)

when "001" =>led7s<="0100100";--2

when "010" =>led7s<="0110000";--3

when "011" =>led7s<="0011001";--4

when "100" =>led7s<="0010010";--5

when "101" =>led7s<="0000010";--6

when "110" =>led7s<="1111000";--7

when others=>led7s<="1000000";--0

end case;
end process;
end;
--编译环境:quartus ii 13.0
--开发板:DE2-70
--作者:MOYUxiaofendui
--流水灯
--花样8种，数码管能显示当前流水灯的样式类型
--s3总控制开关相当于使能端，zd用来显示s3是否上拨
--s0-s2用来控制流水灯的花样
--s4是暂停键，用来控制时钟的停止与运行
