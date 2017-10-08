-- Copyright (C) 2017  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel MegaCore Function License Agreement, or other 
-- applicable license agreement, including, without limitation, 
-- that your use is for the sole purpose of programming logic 
-- devices manufactured by Intel and sold by Intel or its 
-- authorized distributors.  Please refer to the applicable 
-- agreement for further details.

-- VENDOR "Altera"
-- PROGRAM "Quartus Prime"
-- VERSION "Version 17.0.0 Build 595 04/25/2017 SJ Lite Edition"

-- DATE "09/21/2017 15:44:16"

-- 
-- Device: Altera EP4CE115F29C7 Package FBGA780
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY CYCLONEIVE;
LIBRARY IEEE;
USE CYCLONEIVE.CYCLONEIVE_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	hard_block IS
    PORT (
	devoe : IN std_logic;
	devclrn : IN std_logic;
	devpor : IN std_logic
	);
END hard_block;

-- Design Ports Information
-- ~ALTERA_ASDO_DATA1~	=>  Location: PIN_F4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_FLASH_nCE_nCSO~	=>  Location: PIN_E2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_DCLK~	=>  Location: PIN_P3,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_DATA0~	=>  Location: PIN_N7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_nCEO~	=>  Location: PIN_P28,	 I/O Standard: 2.5 V,	 Current Strength: 8mA


ARCHITECTURE structure OF hard_block IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL \~ALTERA_ASDO_DATA1~~padout\ : std_logic;
SIGNAL \~ALTERA_FLASH_nCE_nCSO~~padout\ : std_logic;
SIGNAL \~ALTERA_DATA0~~padout\ : std_logic;
SIGNAL \~ALTERA_ASDO_DATA1~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_FLASH_nCE_nCSO~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_DATA0~~ibuf_o\ : std_logic;

BEGIN

ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
END structure;


LIBRARY CYCLONEIVE;
LIBRARY IEEE;
USE CYCLONEIVE.CYCLONEIVE_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	leddcd IS
    PORT (
	data_in : IN std_logic_vector(3 DOWNTO 0);
	segments_out : BUFFER std_logic_vector(6 DOWNTO 0)
	);
END leddcd;

-- Design Ports Information
-- segments_out[0]	=>  Location: PIN_G18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- segments_out[1]	=>  Location: PIN_F22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- segments_out[2]	=>  Location: PIN_E17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- segments_out[3]	=>  Location: PIN_L26,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- segments_out[4]	=>  Location: PIN_L25,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- segments_out[5]	=>  Location: PIN_J22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- segments_out[6]	=>  Location: PIN_H22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- data_in[2]	=>  Location: PIN_AC27,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- data_in[1]	=>  Location: PIN_AC28,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- data_in[0]	=>  Location: PIN_AB28,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- data_in[3]	=>  Location: PIN_AD27,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF leddcd IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_data_in : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_segments_out : std_logic_vector(6 DOWNTO 0);
SIGNAL \segments_out[0]~output_o\ : std_logic;
SIGNAL \segments_out[1]~output_o\ : std_logic;
SIGNAL \segments_out[2]~output_o\ : std_logic;
SIGNAL \segments_out[3]~output_o\ : std_logic;
SIGNAL \segments_out[4]~output_o\ : std_logic;
SIGNAL \segments_out[5]~output_o\ : std_logic;
SIGNAL \segments_out[6]~output_o\ : std_logic;
SIGNAL \data_in[1]~input_o\ : std_logic;
SIGNAL \data_in[2]~input_o\ : std_logic;
SIGNAL \data_in[3]~input_o\ : std_logic;
SIGNAL \data_in[0]~input_o\ : std_logic;
SIGNAL \segments_out~0_combout\ : std_logic;
SIGNAL \segments_out~1_combout\ : std_logic;
SIGNAL \segments_out~2_combout\ : std_logic;
SIGNAL \segments_out~3_combout\ : std_logic;
SIGNAL \segments_out~4_combout\ : std_logic;
SIGNAL \segments_out~5_combout\ : std_logic;
SIGNAL \segments_out~6_combout\ : std_logic;
SIGNAL \ALT_INV_segments_out~6_combout\ : std_logic;
SIGNAL \ALT_INV_segments_out~2_combout\ : std_logic;

COMPONENT hard_block
    PORT (
	devoe : IN std_logic;
	devclrn : IN std_logic;
	devpor : IN std_logic);
END COMPONENT;

BEGIN

ww_data_in <= data_in;
segments_out <= ww_segments_out;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
\ALT_INV_segments_out~6_combout\ <= NOT \segments_out~6_combout\;
\ALT_INV_segments_out~2_combout\ <= NOT \segments_out~2_combout\;
auto_generated_inst : hard_block
PORT MAP (
	devoe => ww_devoe,
	devclrn => ww_devclrn,
	devpor => ww_devpor);

-- Location: IOOBUF_X69_Y73_N23
\segments_out[0]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \segments_out~0_combout\,
	devoe => ww_devoe,
	o => \segments_out[0]~output_o\);

-- Location: IOOBUF_X107_Y73_N23
\segments_out[1]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \segments_out~1_combout\,
	devoe => ww_devoe,
	o => \segments_out[1]~output_o\);

-- Location: IOOBUF_X67_Y73_N23
\segments_out[2]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \ALT_INV_segments_out~2_combout\,
	devoe => ww_devoe,
	o => \segments_out[2]~output_o\);

-- Location: IOOBUF_X115_Y50_N2
\segments_out[3]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \segments_out~3_combout\,
	devoe => ww_devoe,
	o => \segments_out[3]~output_o\);

-- Location: IOOBUF_X115_Y54_N16
\segments_out[4]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \segments_out~4_combout\,
	devoe => ww_devoe,
	o => \segments_out[4]~output_o\);

-- Location: IOOBUF_X115_Y67_N16
\segments_out[5]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \segments_out~5_combout\,
	devoe => ww_devoe,
	o => \segments_out[5]~output_o\);

-- Location: IOOBUF_X115_Y69_N2
\segments_out[6]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \ALT_INV_segments_out~6_combout\,
	devoe => ww_devoe,
	o => \segments_out[6]~output_o\);

-- Location: IOIBUF_X115_Y14_N1
\data_in[1]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_data_in(1),
	o => \data_in[1]~input_o\);

-- Location: IOIBUF_X115_Y15_N8
\data_in[2]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_data_in(2),
	o => \data_in[2]~input_o\);

-- Location: IOIBUF_X115_Y13_N8
\data_in[3]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_data_in(3),
	o => \data_in[3]~input_o\);

-- Location: IOIBUF_X115_Y17_N1
\data_in[0]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_data_in(0),
	o => \data_in[0]~input_o\);

-- Location: LCCOMB_X114_Y54_N16
\segments_out~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \segments_out~0_combout\ = (\data_in[2]~input_o\ & (!\data_in[1]~input_o\ & (\data_in[3]~input_o\ $ (!\data_in[0]~input_o\)))) # (!\data_in[2]~input_o\ & (\data_in[0]~input_o\ & (\data_in[1]~input_o\ $ (!\data_in[3]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110000100000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \data_in[1]~input_o\,
	datab => \data_in[2]~input_o\,
	datac => \data_in[3]~input_o\,
	datad => \data_in[0]~input_o\,
	combout => \segments_out~0_combout\);

-- Location: LCCOMB_X114_Y54_N18
\segments_out~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \segments_out~1_combout\ = (\data_in[1]~input_o\ & ((\data_in[0]~input_o\ & ((\data_in[3]~input_o\))) # (!\data_in[0]~input_o\ & (\data_in[2]~input_o\)))) # (!\data_in[1]~input_o\ & (\data_in[2]~input_o\ & (\data_in[3]~input_o\ $ (\data_in[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010011001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \data_in[1]~input_o\,
	datab => \data_in[2]~input_o\,
	datac => \data_in[3]~input_o\,
	datad => \data_in[0]~input_o\,
	combout => \segments_out~1_combout\);

-- Location: LCCOMB_X114_Y54_N12
\segments_out~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \segments_out~2_combout\ = (\data_in[2]~input_o\ & (((!\data_in[1]~input_o\ & \data_in[0]~input_o\)) # (!\data_in[3]~input_o\))) # (!\data_in[2]~input_o\ & (((\data_in[3]~input_o\) # (\data_in[0]~input_o\)) # (!\data_in[1]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111111100111101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \data_in[1]~input_o\,
	datab => \data_in[2]~input_o\,
	datac => \data_in[3]~input_o\,
	datad => \data_in[0]~input_o\,
	combout => \segments_out~2_combout\);

-- Location: LCCOMB_X114_Y54_N30
\segments_out~3\ : cycloneive_lcell_comb
-- Equation(s):
-- \segments_out~3_combout\ = (\data_in[1]~input_o\ & ((\data_in[2]~input_o\ & ((\data_in[0]~input_o\))) # (!\data_in[2]~input_o\ & (\data_in[3]~input_o\ & !\data_in[0]~input_o\)))) # (!\data_in[1]~input_o\ & (!\data_in[3]~input_o\ & (\data_in[2]~input_o\ $ 
-- (\data_in[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000100100100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \data_in[1]~input_o\,
	datab => \data_in[2]~input_o\,
	datac => \data_in[3]~input_o\,
	datad => \data_in[0]~input_o\,
	combout => \segments_out~3_combout\);

-- Location: LCCOMB_X114_Y54_N8
\segments_out~4\ : cycloneive_lcell_comb
-- Equation(s):
-- \segments_out~4_combout\ = (\data_in[1]~input_o\ & (((!\data_in[3]~input_o\ & \data_in[0]~input_o\)))) # (!\data_in[1]~input_o\ & ((\data_in[2]~input_o\ & (!\data_in[3]~input_o\)) # (!\data_in[2]~input_o\ & ((\data_in[0]~input_o\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001111100000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \data_in[1]~input_o\,
	datab => \data_in[2]~input_o\,
	datac => \data_in[3]~input_o\,
	datad => \data_in[0]~input_o\,
	combout => \segments_out~4_combout\);

-- Location: LCCOMB_X114_Y54_N26
\segments_out~5\ : cycloneive_lcell_comb
-- Equation(s):
-- \segments_out~5_combout\ = (\data_in[1]~input_o\ & (!\data_in[3]~input_o\ & ((\data_in[0]~input_o\) # (!\data_in[2]~input_o\)))) # (!\data_in[1]~input_o\ & (\data_in[0]~input_o\ & (\data_in[2]~input_o\ $ (!\data_in[3]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100101100000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \data_in[1]~input_o\,
	datab => \data_in[2]~input_o\,
	datac => \data_in[3]~input_o\,
	datad => \data_in[0]~input_o\,
	combout => \segments_out~5_combout\);

-- Location: LCCOMB_X114_Y54_N28
\segments_out~6\ : cycloneive_lcell_comb
-- Equation(s):
-- \segments_out~6_combout\ = (\data_in[0]~input_o\ & ((\data_in[3]~input_o\) # (\data_in[1]~input_o\ $ (\data_in[2]~input_o\)))) # (!\data_in[0]~input_o\ & ((\data_in[1]~input_o\) # (\data_in[2]~input_o\ $ (\data_in[3]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111011010111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \data_in[1]~input_o\,
	datab => \data_in[2]~input_o\,
	datac => \data_in[3]~input_o\,
	datad => \data_in[0]~input_o\,
	combout => \segments_out~6_combout\);

ww_segments_out(0) <= \segments_out[0]~output_o\;

ww_segments_out(1) <= \segments_out[1]~output_o\;

ww_segments_out(2) <= \segments_out[2]~output_o\;

ww_segments_out(3) <= \segments_out[3]~output_o\;

ww_segments_out(4) <= \segments_out[4]~output_o\;

ww_segments_out(5) <= \segments_out[5]~output_o\;

ww_segments_out(6) <= \segments_out[6]~output_o\;
END structure;


