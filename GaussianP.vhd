library ieee;
use ieee.std_logic_1164.all;

entity GaussianP is
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
end GaussianP;

Architecture RTL of GaussianP is
	component LUT is
		generic(g_bits:integer:=g_bits
					;g_lines:integer:=g_lines);
		port
				(i_Data:in std_logic_vector(g_lines-1 downto 0)
				;o_Data:out std_logic_vector(g_bits-1 downto 0)
				);
	end component;
	
	component Phase_Acumulator is
		generic
				(g_lines:integer:=g_lines);
		port
				(i_Clk:in std_logic
				;i_Reset:in std_logic
				;i_Data:in std_logic_vector(g_lines-1 downto 0)
				;i_UP:in std_logic
				;o_Data:out std_logic_vector(g_lines-1 downto 0)
				;o_Cout:out std_logic
				);
	end component;
	
	component inv is
		generic
				(g_lines:integer:=g_lines);
		port
				(i_inv:in std_logic
				;i_Data:in std_logic_vector(g_lines-1 downto 0)
				;o_Data:out std_logic_vector(g_lines-1 downto 0)
				);
	end component;
	
	component ASM is
		port(
			i_clk		 	: in	std_logic;
			i_sta	 		: in	std_logic;
			i_reset	 	: in	std_logic;
			i_Cout		: in	std_logic;
			o_ResetPA 	: out	std_logic;
			o_UPPA		: out std_logic;
			o_finish		: out std_logic;
			o_inv			: out std_logic
		);

	end component;
	
	signal s_Temp0:std_logic_vector(g_lines-1 downto 0);--Bus de datos que conecta el registro con el Phase Acumulator
	signal s_Temp1:std_logic_vector(g_lines-1 downto 0);--Bus de datos que conecta el Phase Acumulator con el bloque inv
	signal s_Temp2:std_logic_vector(g_lines-1 downto 0);--Bus de datos que conecta el bloque inv con la LUT
	signal s_Reset:std_logic;--Señal de reinicio que conecta la ASM con el Phase Acumulator
	signal s_UP:std_logic;--Señal de aumento que conecta la ASM con el Phase Acumulator
	signal s_Cout:std_logic;--Señal de control que conecta el Phase Acumulator con la ASM
	signal s_inv:std_logic;--Señal de inversión que conecta la ASM con el bloque inv
	signal s_NClk:std_logic;--Señal de reloj invertida
	
begin
	s_NClk<=not(i_Clk);
	SM:	ASM					port map (i_Clk, i_sta, i_reset, s_Cout, s_Reset, s_UP, o_finish, s_inv);
	IV:	inv					port map (s_inv, s_Temp1, s_Temp2);
	PA:	Phase_Acumulator	port map (s_NClk, s_Reset, s_Temp0, s_UP, s_Temp1, s_Cout);
	LL:	LUT					port map (s_Temp2, o_Data);
	--Registro
	process(s_NClk, i_ResetData)
	begin
		if (i_ResetData = '0') then
			s_Temp0 <= (others=>'0');
		elsif(rising_edge(s_NClk)) then
			if (i_WData = '1') then
				s_Temp0 <= i_Data;
			end if;
		end if;
	end process;
end RTL;