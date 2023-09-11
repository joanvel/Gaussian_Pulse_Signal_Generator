library ieee;
use ieee.std_logic_1164.all;

entity inv is
	generic
			(g_lines:integer:=8);
	port
			(i_inv:in std_logic
			;i_Data:in std_logic_vector(g_lines-1 downto 0)
			;o_Data:out std_logic_vector(g_lines-1 downto 0)
			);
end inv;

Architecture RTL of inv is
begin
	X:	for i in 0 to g_lines-1 generate
			o_Data(i)<= i_inv xor i_Data(i);
	end generate;
end RTL;