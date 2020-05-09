	component qsys_top is
		port (
			clk_clk                                       : in  std_logic                     := 'X';             -- clk
			eth_tse_0_mac_mdio_connection_mdc             : out std_logic;                                        -- mdc
			eth_tse_0_mac_mdio_connection_mdio_in         : in  std_logic                     := 'X';             -- mdio_in
			eth_tse_0_mac_mdio_connection_mdio_out        : out std_logic;                                        -- mdio_out
			eth_tse_0_mac_mdio_connection_mdio_oen        : out std_logic;                                        -- mdio_oen
			eth_tse_0_mac_misc_connection_xon_gen         : in  std_logic                     := 'X';             -- xon_gen
			eth_tse_0_mac_misc_connection_xoff_gen        : in  std_logic                     := 'X';             -- xoff_gen
			eth_tse_0_mac_misc_connection_ff_tx_crc_fwd   : in  std_logic                     := 'X';             -- ff_tx_crc_fwd
			eth_tse_0_mac_misc_connection_ff_tx_septy     : out std_logic;                                        -- ff_tx_septy
			eth_tse_0_mac_misc_connection_tx_ff_uflow     : out std_logic;                                        -- tx_ff_uflow
			eth_tse_0_mac_misc_connection_ff_tx_a_full    : out std_logic;                                        -- ff_tx_a_full
			eth_tse_0_mac_misc_connection_ff_tx_a_empty   : out std_logic;                                        -- ff_tx_a_empty
			eth_tse_0_mac_misc_connection_rx_err_stat     : out std_logic_vector(17 downto 0);                    -- rx_err_stat
			eth_tse_0_mac_misc_connection_rx_frm_type     : out std_logic_vector(3 downto 0);                     -- rx_frm_type
			eth_tse_0_mac_misc_connection_ff_rx_dsav      : out std_logic;                                        -- ff_rx_dsav
			eth_tse_0_mac_misc_connection_ff_rx_a_full    : out std_logic;                                        -- ff_rx_a_full
			eth_tse_0_mac_misc_connection_ff_rx_a_empty   : out std_logic;                                        -- ff_rx_a_empty
			eth_tse_0_mac_rgmii_connection_rgmii_in       : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- rgmii_in
			eth_tse_0_mac_rgmii_connection_rgmii_out      : out std_logic_vector(3 downto 0);                     -- rgmii_out
			eth_tse_0_mac_rgmii_connection_rx_control     : in  std_logic                     := 'X';             -- rx_control
			eth_tse_0_mac_rgmii_connection_tx_control     : out std_logic;                                        -- tx_control
			eth_tse_0_mac_status_connection_set_10        : in  std_logic                     := 'X';             -- set_10
			eth_tse_0_mac_status_connection_set_1000      : in  std_logic                     := 'X';             -- set_1000
			eth_tse_0_mac_status_connection_eth_mode      : out std_logic;                                        -- eth_mode
			eth_tse_0_mac_status_connection_ena_10        : out std_logic;                                        -- ena_10
			eth_tse_0_pcs_mac_rx_clock_connection_clk     : in  std_logic                     := 'X';             -- clk
			eth_tse_0_pcs_mac_tx_clock_connection_clk     : in  std_logic                     := 'X';             -- clk
			mpu_ss_0_rx_mac_misc_connection_ff_rx_dsav    : in  std_logic                     := 'X';             -- ff_rx_dsav
			mpu_ss_0_rx_mac_misc_connection_ff_rx_a_empty : in  std_logic                     := 'X';             -- ff_rx_a_empty
			mpu_ss_0_rx_mac_misc_connection_ff_rx_a_full  : in  std_logic                     := 'X';             -- ff_rx_a_full
			mpu_ss_0_rx_mac_misc_connection_rx_err_stat   : in  std_logic_vector(17 downto 0) := (others => 'X'); -- rx_err_stat
			mpu_ss_0_rx_mac_misc_connection_rx_frm_type   : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- rx_frm_type
			mpu_ss_0_tx_mac_misc_connection_ff_tx_crc_fwd : out std_logic;                                        -- ff_tx_crc_fwd
			mpu_ss_0_tx_mac_misc_connection_ff_tx_septy   : in  std_logic                     := 'X';             -- ff_tx_septy
			mpu_ss_0_tx_mac_misc_connection_ff_tx_uflow   : in  std_logic                     := 'X';             -- ff_tx_uflow
			mpu_ss_0_tx_mac_misc_connection_ff_tx_a_full  : in  std_logic                     := 'X';             -- ff_tx_a_full
			mpu_ss_0_tx_mac_misc_connection_ff_tx_a_empty : in  std_logic                     := 'X';             -- ff_tx_a_empty
			reset_reset_n                                 : in  std_logic                     := 'X'              -- reset_n
		);
	end component qsys_top;

	u0 : component qsys_top
		port map (
			clk_clk                                       => CONNECTED_TO_clk_clk,                                       --                                   clk.clk
			eth_tse_0_mac_mdio_connection_mdc             => CONNECTED_TO_eth_tse_0_mac_mdio_connection_mdc,             --         eth_tse_0_mac_mdio_connection.mdc
			eth_tse_0_mac_mdio_connection_mdio_in         => CONNECTED_TO_eth_tse_0_mac_mdio_connection_mdio_in,         --                                      .mdio_in
			eth_tse_0_mac_mdio_connection_mdio_out        => CONNECTED_TO_eth_tse_0_mac_mdio_connection_mdio_out,        --                                      .mdio_out
			eth_tse_0_mac_mdio_connection_mdio_oen        => CONNECTED_TO_eth_tse_0_mac_mdio_connection_mdio_oen,        --                                      .mdio_oen
			eth_tse_0_mac_misc_connection_xon_gen         => CONNECTED_TO_eth_tse_0_mac_misc_connection_xon_gen,         --         eth_tse_0_mac_misc_connection.xon_gen
			eth_tse_0_mac_misc_connection_xoff_gen        => CONNECTED_TO_eth_tse_0_mac_misc_connection_xoff_gen,        --                                      .xoff_gen
			eth_tse_0_mac_misc_connection_ff_tx_crc_fwd   => CONNECTED_TO_eth_tse_0_mac_misc_connection_ff_tx_crc_fwd,   --                                      .ff_tx_crc_fwd
			eth_tse_0_mac_misc_connection_ff_tx_septy     => CONNECTED_TO_eth_tse_0_mac_misc_connection_ff_tx_septy,     --                                      .ff_tx_septy
			eth_tse_0_mac_misc_connection_tx_ff_uflow     => CONNECTED_TO_eth_tse_0_mac_misc_connection_tx_ff_uflow,     --                                      .tx_ff_uflow
			eth_tse_0_mac_misc_connection_ff_tx_a_full    => CONNECTED_TO_eth_tse_0_mac_misc_connection_ff_tx_a_full,    --                                      .ff_tx_a_full
			eth_tse_0_mac_misc_connection_ff_tx_a_empty   => CONNECTED_TO_eth_tse_0_mac_misc_connection_ff_tx_a_empty,   --                                      .ff_tx_a_empty
			eth_tse_0_mac_misc_connection_rx_err_stat     => CONNECTED_TO_eth_tse_0_mac_misc_connection_rx_err_stat,     --                                      .rx_err_stat
			eth_tse_0_mac_misc_connection_rx_frm_type     => CONNECTED_TO_eth_tse_0_mac_misc_connection_rx_frm_type,     --                                      .rx_frm_type
			eth_tse_0_mac_misc_connection_ff_rx_dsav      => CONNECTED_TO_eth_tse_0_mac_misc_connection_ff_rx_dsav,      --                                      .ff_rx_dsav
			eth_tse_0_mac_misc_connection_ff_rx_a_full    => CONNECTED_TO_eth_tse_0_mac_misc_connection_ff_rx_a_full,    --                                      .ff_rx_a_full
			eth_tse_0_mac_misc_connection_ff_rx_a_empty   => CONNECTED_TO_eth_tse_0_mac_misc_connection_ff_rx_a_empty,   --                                      .ff_rx_a_empty
			eth_tse_0_mac_rgmii_connection_rgmii_in       => CONNECTED_TO_eth_tse_0_mac_rgmii_connection_rgmii_in,       --        eth_tse_0_mac_rgmii_connection.rgmii_in
			eth_tse_0_mac_rgmii_connection_rgmii_out      => CONNECTED_TO_eth_tse_0_mac_rgmii_connection_rgmii_out,      --                                      .rgmii_out
			eth_tse_0_mac_rgmii_connection_rx_control     => CONNECTED_TO_eth_tse_0_mac_rgmii_connection_rx_control,     --                                      .rx_control
			eth_tse_0_mac_rgmii_connection_tx_control     => CONNECTED_TO_eth_tse_0_mac_rgmii_connection_tx_control,     --                                      .tx_control
			eth_tse_0_mac_status_connection_set_10        => CONNECTED_TO_eth_tse_0_mac_status_connection_set_10,        --       eth_tse_0_mac_status_connection.set_10
			eth_tse_0_mac_status_connection_set_1000      => CONNECTED_TO_eth_tse_0_mac_status_connection_set_1000,      --                                      .set_1000
			eth_tse_0_mac_status_connection_eth_mode      => CONNECTED_TO_eth_tse_0_mac_status_connection_eth_mode,      --                                      .eth_mode
			eth_tse_0_mac_status_connection_ena_10        => CONNECTED_TO_eth_tse_0_mac_status_connection_ena_10,        --                                      .ena_10
			eth_tse_0_pcs_mac_rx_clock_connection_clk     => CONNECTED_TO_eth_tse_0_pcs_mac_rx_clock_connection_clk,     -- eth_tse_0_pcs_mac_rx_clock_connection.clk
			eth_tse_0_pcs_mac_tx_clock_connection_clk     => CONNECTED_TO_eth_tse_0_pcs_mac_tx_clock_connection_clk,     -- eth_tse_0_pcs_mac_tx_clock_connection.clk
			mpu_ss_0_rx_mac_misc_connection_ff_rx_dsav    => CONNECTED_TO_mpu_ss_0_rx_mac_misc_connection_ff_rx_dsav,    --       mpu_ss_0_rx_mac_misc_connection.ff_rx_dsav
			mpu_ss_0_rx_mac_misc_connection_ff_rx_a_empty => CONNECTED_TO_mpu_ss_0_rx_mac_misc_connection_ff_rx_a_empty, --                                      .ff_rx_a_empty
			mpu_ss_0_rx_mac_misc_connection_ff_rx_a_full  => CONNECTED_TO_mpu_ss_0_rx_mac_misc_connection_ff_rx_a_full,  --                                      .ff_rx_a_full
			mpu_ss_0_rx_mac_misc_connection_rx_err_stat   => CONNECTED_TO_mpu_ss_0_rx_mac_misc_connection_rx_err_stat,   --                                      .rx_err_stat
			mpu_ss_0_rx_mac_misc_connection_rx_frm_type   => CONNECTED_TO_mpu_ss_0_rx_mac_misc_connection_rx_frm_type,   --                                      .rx_frm_type
			mpu_ss_0_tx_mac_misc_connection_ff_tx_crc_fwd => CONNECTED_TO_mpu_ss_0_tx_mac_misc_connection_ff_tx_crc_fwd, --       mpu_ss_0_tx_mac_misc_connection.ff_tx_crc_fwd
			mpu_ss_0_tx_mac_misc_connection_ff_tx_septy   => CONNECTED_TO_mpu_ss_0_tx_mac_misc_connection_ff_tx_septy,   --                                      .ff_tx_septy
			mpu_ss_0_tx_mac_misc_connection_ff_tx_uflow   => CONNECTED_TO_mpu_ss_0_tx_mac_misc_connection_ff_tx_uflow,   --                                      .ff_tx_uflow
			mpu_ss_0_tx_mac_misc_connection_ff_tx_a_full  => CONNECTED_TO_mpu_ss_0_tx_mac_misc_connection_ff_tx_a_full,  --                                      .ff_tx_a_full
			mpu_ss_0_tx_mac_misc_connection_ff_tx_a_empty => CONNECTED_TO_mpu_ss_0_tx_mac_misc_connection_ff_tx_a_empty, --                                      .ff_tx_a_empty
			reset_reset_n                                 => CONNECTED_TO_reset_reset_n                                  --                                 reset.reset_n
		);

