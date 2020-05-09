	component mpu_ss is
		port (
			clk_clk                              : in  std_logic                     := 'X';             -- clk
			reset_reset_n                        : in  std_logic                     := 'X';             -- reset_n
			tx_mac_misc_connection_ff_tx_crc_fwd : out std_logic;                                        -- ff_tx_crc_fwd
			tx_mac_misc_connection_ff_tx_septy   : in  std_logic                     := 'X';             -- ff_tx_septy
			tx_mac_misc_connection_ff_tx_uflow   : in  std_logic                     := 'X';             -- ff_tx_uflow
			tx_mac_misc_connection_ff_tx_a_full  : in  std_logic                     := 'X';             -- ff_tx_a_full
			tx_mac_misc_connection_ff_tx_a_empty : in  std_logic                     := 'X';             -- ff_tx_a_empty
			transmit_data                        : out std_logic_vector(31 downto 0);                    -- data
			transmit_endofpacket                 : out std_logic;                                        -- endofpacket
			transmit_error                       : out std_logic;                                        -- error
			transmit_ready                       : in  std_logic                     := 'X';             -- ready
			transmit_startofpacket               : out std_logic;                                        -- startofpacket
			transmit_valid                       : out std_logic;                                        -- valid
			transmit_empty                       : out std_logic_vector(1 downto 0);                     -- empty
			rx_mac_misc_connection_ff_rx_dsav    : in  std_logic                     := 'X';             -- ff_rx_dsav
			rx_mac_misc_connection_ff_rx_a_empty : in  std_logic                     := 'X';             -- ff_rx_a_empty
			rx_mac_misc_connection_ff_rx_a_full  : in  std_logic                     := 'X';             -- ff_rx_a_full
			rx_mac_misc_connection_rx_err_stat   : in  std_logic_vector(17 downto 0) := (others => 'X'); -- rx_err_stat
			rx_mac_misc_connection_rx_frm_type   : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- rx_frm_type
			receive_startofpacket                : in  std_logic                     := 'X';             -- startofpacket
			receive_valid                        : in  std_logic                     := 'X';             -- valid
			receive_ready                        : out std_logic;                                        -- ready
			receive_error                        : in  std_logic_vector(5 downto 0)  := (others => 'X'); -- error
			receive_data                         : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- data
			receive_endofpacket                  : in  std_logic                     := 'X';             -- endofpacket
			receive_empty                        : in  std_logic_vector(1 downto 0)  := (others => 'X')  -- empty
		);
	end component mpu_ss;

	u0 : component mpu_ss
		port map (
			clk_clk                              => CONNECTED_TO_clk_clk,                              --                    clk.clk
			reset_reset_n                        => CONNECTED_TO_reset_reset_n,                        --                  reset.reset_n
			tx_mac_misc_connection_ff_tx_crc_fwd => CONNECTED_TO_tx_mac_misc_connection_ff_tx_crc_fwd, -- tx_mac_misc_connection.ff_tx_crc_fwd
			tx_mac_misc_connection_ff_tx_septy   => CONNECTED_TO_tx_mac_misc_connection_ff_tx_septy,   --                       .ff_tx_septy
			tx_mac_misc_connection_ff_tx_uflow   => CONNECTED_TO_tx_mac_misc_connection_ff_tx_uflow,   --                       .ff_tx_uflow
			tx_mac_misc_connection_ff_tx_a_full  => CONNECTED_TO_tx_mac_misc_connection_ff_tx_a_full,  --                       .ff_tx_a_full
			tx_mac_misc_connection_ff_tx_a_empty => CONNECTED_TO_tx_mac_misc_connection_ff_tx_a_empty, --                       .ff_tx_a_empty
			transmit_data                        => CONNECTED_TO_transmit_data,                        --               transmit.data
			transmit_endofpacket                 => CONNECTED_TO_transmit_endofpacket,                 --                       .endofpacket
			transmit_error                       => CONNECTED_TO_transmit_error,                       --                       .error
			transmit_ready                       => CONNECTED_TO_transmit_ready,                       --                       .ready
			transmit_startofpacket               => CONNECTED_TO_transmit_startofpacket,               --                       .startofpacket
			transmit_valid                       => CONNECTED_TO_transmit_valid,                       --                       .valid
			transmit_empty                       => CONNECTED_TO_transmit_empty,                       --                       .empty
			rx_mac_misc_connection_ff_rx_dsav    => CONNECTED_TO_rx_mac_misc_connection_ff_rx_dsav,    -- rx_mac_misc_connection.ff_rx_dsav
			rx_mac_misc_connection_ff_rx_a_empty => CONNECTED_TO_rx_mac_misc_connection_ff_rx_a_empty, --                       .ff_rx_a_empty
			rx_mac_misc_connection_ff_rx_a_full  => CONNECTED_TO_rx_mac_misc_connection_ff_rx_a_full,  --                       .ff_rx_a_full
			rx_mac_misc_connection_rx_err_stat   => CONNECTED_TO_rx_mac_misc_connection_rx_err_stat,   --                       .rx_err_stat
			rx_mac_misc_connection_rx_frm_type   => CONNECTED_TO_rx_mac_misc_connection_rx_frm_type,   --                       .rx_frm_type
			receive_startofpacket                => CONNECTED_TO_receive_startofpacket,                --                receive.startofpacket
			receive_valid                        => CONNECTED_TO_receive_valid,                        --                       .valid
			receive_ready                        => CONNECTED_TO_receive_ready,                        --                       .ready
			receive_error                        => CONNECTED_TO_receive_error,                        --                       .error
			receive_data                         => CONNECTED_TO_receive_data,                         --                       .data
			receive_endofpacket                  => CONNECTED_TO_receive_endofpacket,                  --                       .endofpacket
			receive_empty                        => CONNECTED_TO_receive_empty                         --                       .empty
		);

