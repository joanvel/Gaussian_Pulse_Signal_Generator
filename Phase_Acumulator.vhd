library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Phase_Acumulator is
	generic
			(g_lines:integer:=8);
	port
			(i_Clk:in std_logic
			;i_Reset:in std_logic
			;i_Data:in std_logic_vector(g_lines-1 downto 0)
			;i_UP:in std_logic
			;o_Data:out std_logic_vector(g_lines-1 downto 0)
			;o_Cout:out std_logic
			);
end Phase_Acumulator;

Architecture RTL of Phase_Acumulator is
	signal s_Temp0:std_logic_vector(g_lines downto 0);
	signal s_Temp1:std_logic_vector(g_lines-1 downto 0);
begin
	s_Temp0 <= std_logic_vector(to_unsigned(to_integer(unsigned(i_Data)) + to_integer(unsigned(s_Temp1)),g_lines+1));
	o_Cout <= s_Temp0(g_lines);
	process(i_Clk, i_Reset)
	begin
		if i_Reset = '0' then
			s_Temp1 <= (others=>'0');
		else
			if rising_edge(i_Clk) then
				if i_UP = '1' then
					s_Temp1 <= s_Temp0(g_lines-1 downto 0);
				end if;
			end if;
		end if;
	end process;
	o_Data <= s_Temp1;
end RTL;