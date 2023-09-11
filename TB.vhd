library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;

entity TB is
	generic (g_bits:integer:=16
				;g_lines:integer:=8);
end TB;

Architecture RTL of TB is
	component GaussianP is
		generic
				(g_lines:integer:=8
				;g_bits:integer:=16
				);
		port
				(i_Clk:in std_logic
				;i_sta:in std_logic
				;i_reset:in std_logic
				;i_Data:in std_logic_vector(g_lines-1 downto 0)
				;i_WData:in std_logic
				;i_ResetData:in std_logic
				;o_finish:out std_logic
				;o_Data:out std_logic_vector(g_bits-1 downto 0)
				);
	end component;
	
	signal s_Clk:std_logic;
	signal s_sta:std_logic;
	signal s_reset:std_logic;
	signal s_DataIn:std_logic_vector(g_lines-1 downto 0);
	signal s_WData:std_logic;
	signal s_ResetData:std_logic;
	signal s_finish:std_logic;
	signal s_DataOut:std_logic_vector(g_bits-1 downto 0);
	file f_Data:text;
begin
	--Señal de frecuencia de control
	s_DataIn<="00000001";
	--Señal de reinicio
	process
	begin
		s_reset<='0';
		s_ResetData<='0';
		wait for 5 ns;
		s_reset<='1';
		s_ResetData<='1';
		wait;
	end process;
	--señal de reloj
	process
	begin
		s_clk<='1';
		wait for 5 ns;
		s_clk<='0';
		wait for 5 ns;
	end process;
	--Señal de escritura en DataIn
	process
	begin
		s_WData<='0';
		wait for 10 ns;
		s_WData<='1';
		wait for 10 ns;
		s_WData<='0';
		wait;
	end process;
	--Señal de inicio
	process
	begin
		s_sta<='0';
		wait for 20 ns;
		s_sta<='1';
		wait for 20 ns;
		s_sta<='0';
		wait;
	end process;
	--Almacenamiento de datos
	process(s_Clk)
		variable l:line;
		variable status:file_open_status;
	begin
		if (rising_edge(s_Clk) and s_finish='0') then
			file_open(status,f_Data,"C:\Users\Joan\Documents\TG\Senales\Gaussian_Pulse\GP1.txt",append_mode);
			assert status=open_ok
				report "No se pudo crear GP.txt"
				severity failure;
			write(l,to_integer(signed(s_DataOut)));
			writeline(f_Data,l);
			file_close(f_Data);
		end if;
	end process;
	--llamo al componente
	GP:	GaussianP	port map (s_clk,s_sta,s_reset,s_DataIn,s_WData,s_ResetData,s_finish,s_DataOut);
end RTL;
	
	