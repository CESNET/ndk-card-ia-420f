-- fpga.vhd: IA-420F board top level entity and architecture
-- Copyright (C) 2022 CESNET z. s. p. o.
-- Author(s): Daniel Kříž <xkrizd01@vutbr.cz.cz>
--
-- SPDX-License-Identifier: BSD-3-Clause

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.combo_const.all;
use work.combo_user_const.all;

use work.math_pack.all;
use work.type_pack.all;

entity FPGA is
port (
    -- FPGA system clock
    USR_CLK_33M        : in    std_logic;
    SYS_CLK_50M        : in    std_logic;
    -- User LEDs
    USER_LED_G         : out   std_logic;
    USER_LED_R         : out   std_logic;

    -- =========================================================================
    -- PCIe
    -- =========================================================================
    PCIE_REFCLK0       : in    std_logic;
    PCIE_REFCLK1       : in    std_logic;
    PCIE_SYSRST_N      : in    std_logic;
    PCIE_RX_P          : in    std_logic_vector(15 downto 0);
    PCIE_RX_N          : in    std_logic_vector(15 downto 0);
    PCIE_TX_P          : out   std_logic_vector(15 downto 0);
    PCIE_TX_N          : out   std_logic_vector(15 downto 0);

    -- =========================================================================
    -- QSFP
    -- =========================================================================
    QSFP_REFCLK_156M   : in    std_logic;
    QSFP_RX_P          : in    std_logic_vector(8-1 downto 0);
    QSFP_RX_N          : in    std_logic_vector(8-1 downto 0);
    QSFP_TX_P          : out   std_logic_vector(8-1 downto 0);
    QSFP_TX_N          : out   std_logic_vector(8-1 downto 0);

    -- =========================================================================
    -- DDR4
    -- =========================================================================
    --I2C_DDR4_DIMM_SDA : inout std_logic;
    --I2C_DDR4_DIMM_SCL : inout std_logic;

    -- DDR4 CH0 interface
    --DDR4_CH0_REFCLK_P  : in    std_logic;
    --DDR4_CH0_REFCLK_N  : in    std_logic;
    --DDR4_CH0_CLK_P     : out   std_logic;
    --DDR4_CH0_CLK_N     : out   std_logic;
--
    --DDR4_CH0_A         : out   std_logic_vector(17-1 downto 0);
    --DDR4_CH0_ACT_L     : out   std_logic_vector(0 downto 0);
    --DDR4_CH0_BA        : out   std_logic_vector(2-1 downto 0);
    --DDR4_CH0_BG        : out   std_logic_vector(2-1 downto 0);
    --DDR4_CH0_CKE       : out   std_logic_vector(0 downto 0);
    --DDR4_CH0_CS_L      : out   std_logic_vector(0 downto 0);
    --DDR4_CH0_ODT       : out   std_logic_vector(0 downto 0);
    --DDR4_CH0_RESET_L   : out   std_logic_vector(0 downto 0);
    --DDR4_CH0_PAR       : out   std_logic_vector(0 downto 0);
    --DDR4_CH0_ALERT_L   : in    std_logic_vector(0 downto 0);
    --DDR4_CH0_DQS_P     : inout std_logic_vector(9-1 downto 0);
    --DDR4_CH0_DQS_N     : inout std_logic_vector(9-1 downto 0);
    --DDR4_CH0_DQ        : inout std_logic_vector(72-1 downto 0);
    ----DDR4_CH0_RZQ       : inout std_logic;
    --DDR4_CH0_RZQ       : in    std_logic;
    
    --DDR4_CH0_C2        : out   std_logic;  --Module rank address (select of the whole memory?)
    --DDR4_CH0_EVENT_N   : in    std_logic;  --Asserted on critical temperature
    --DDR4_CH0_SAVE_N    : in    std_logic;

    -- DDR4 CH1 interface
    --DDR4_CH1_REFCLK_P  : in    std_logic;
    --DDR4_CH1_REFCLK_N  : in    std_logic;
    --DDR4_CH1_CLK_P     : out   std_logic;
    --DDR4_CH1_CLK_N     : out   std_logic;
--
    --DDR4_CH1_A         : out   std_logic_vector(17-1 downto 0);
    --DDR4_CH1_ACT_L     : out   std_logic_vector(0 downto 0);
    --DDR4_CH1_BA        : out   std_logic_vector(2-1 downto 0);
    --DDR4_CH1_BG        : out   std_logic_vector(2-1 downto 0);
    --DDR4_CH1_CKE       : out   std_logic_vector(0 downto 0);
    --DDR4_CH1_CS_L      : out   std_logic_vector(0 downto 0);
    --DDR4_CH1_ODT       : out   std_logic_vector(0 downto 0);
    --DDR4_CH1_RESET_L   : out   std_logic_vector(0 downto 0); 
    --DDR4_CH1_PAR       : out   std_logic_vector(0 downto 0); 
    --DDR4_CH1_ALERT_L   : in    std_logic_vector(0 downto 0); 
    --DDR4_CH1_DQS_P     : inout std_logic_vector(9-1 downto 0);
    --DDR4_CH1_DQS_N     : inout std_logic_vector(9-1 downto 0);
    --DDR4_CH1_DQ        : inout std_logic_vector(72-1 downto 0);
    ----DDR4_CH1_RZQ       : inout std_logic;
    --DDR4_CH1_RZQ       : in    std_logic;     
  
    -- =========================================================================
    -- I2C
    -- =========================================================================
    FPGA_I2C_SCL         : inout std_logic;
    FPGA_I2C_SDA         : inout std_logic;
    FPGA_I2C_MUX_GNT     : in    std_logic;
    FPGA_I2C_REQ_L       : out   std_logic;

    -- =========================================================================
    -- BMC SPI
    -- =========================================================================
    FPGA2BMC_IRQ         : out   std_logic;
    FPGA2BMC_MST_EN_N    : out   std_logic;
    BMC2FPGA_RST_N       : in    std_logic;
    BMC2FPGA_SPI_SCK     : in    std_logic;
    BMC2FPGA_SPI_MOSI    : in    std_logic;
    BMC2FPGA_SPI_CS      : in    std_logic;
    BMC2FPGA_SPI_MISO    : inout std_logic
);
end entity;

architecture FULL of FPGA is

    -- DMA debug parameters
    constant DMA_GEN_LOOP_EN : boolean := true;

    constant PCIE_LANES     : natural := 16;
    constant PCIE_CLKS      : natural := 2;
    constant PCIE_CONS      : natural := 1;
    constant MISC_IN_WIDTH  : natural := 4;
    constant MISC_OUT_WIDTH : natural := 4;
    constant ETH_LANES      : natural := 4;
    constant DMA_MODULES    : natural := ETH_PORTS;
    constant DMA_ENDPOINTS  : natural := tsel(PCIE_ENDPOINT_MODE=1,PCIE_ENDPOINTS,2*PCIE_ENDPOINTS);
    constant STATUS_LEDS    : natural := 4;

    signal status_led_g : std_logic_vector(STATUS_LEDS-1 downto 0);
    signal status_led_r : std_logic_vector(STATUS_LEDS-1 downto 0);  
    -- IO Expander
    signal io_reset     : std_logic;
	 signal io_reset_sync: std_logic;
    signal ioexp_o      : std_logic_vector(8-1 downto 0);
    signal ioexp_i      : std_logic_vector(8-1 downto 0);
    signal ioexp_req    : std_logic;
    signal ioexp_gnt    : std_logic;
    signal ioexp_busy   : std_logic;
    signal ioexp_done   : std_logic;
    signal sda_o        : std_logic;
    signal sda_oen      : std_logic;
    signal scl_o        : std_logic;
    signal scl_oen      : std_logic;
    -- QSFP I2C
    signal qsfp_sda     : std_logic;
    signal qsfp_scl     : std_logic;
    signal qsfp_sda_o   : std_logic;
    signal qsfp_scl_o   : std_logic;
    signal qsfp_sda_oe  : std_logic;
    signal qsfp_scl_oe  : std_logic;
    -- I2C arbitration
    signal qsfp_idle_timer  : unsigned(12 downto 0); -- 80 us timer
    signal qsfp_scl_oe_sync : std_logic;
    signal qsfp_i2c_idle    : std_logic;

begin

    FPGA_I2C_REQ_L    <= '0';

    FPGA2BMC_IRQ      <= '1';
    FPGA2BMC_MST_EN_N <= '1';
    BMC2FPGA_SPI_MISO <= '1';

    ioreset_sync_i : entity work.ASYNC_RESET
    generic map (
        TWO_REG  => false,
        OUT_REG  => true,
        REPLICAS => 1
    )
    port map (
        CLK        => SYS_CLK_50M,
        ASYNC_RST  => io_reset,
        OUT_RST(0) => io_reset_sync
    );

    -- TCS5455 IO expander for QSFP control
    -- O(4): lp_mode; O(7): reset_n; I(5): int_n, I(6): mod_prs_n
    i2c_io_exp_i: entity work.i2c_io_exp
    generic map (
        IIC_CLK_CNT    => X"0080",   -- Clock dividier
        IIC_DEV_ADDR   => "0100000", -- 0x20
        REFRESH_CYCLES => 16#100000# -- ~21 ms @ 50 MHz
    )
    port map (
        --
        RESET      => io_reset_sync,
        CLK        => SYS_CLK_50M,
        -- Remote I/O interface
        DIR        => "01100000",
        O          => ioexp_o,
        I          => ioexp_i,
        -- Control
        REFRESH    => '0', -- Do not refresh maually, use auto-refresh each REFRESH_CYCLES
        CONFIG     => '0', -- Do not configure maually, config on powerup and when DIR or O port changes
        ERROR      => open,
        -- I2C bus arbitration
        I2C_REQ    => ioexp_req,
        I2C_GNT    => ioexp_gnt,
        I2C_BUSY   => ioexp_busy,
        I2C_DONE   => ioexp_done,
        -- I2C interface
        SCL_I      => FPGA_I2C_SCL,
        SCL_O      => scl_o,
        SCL_OEN    => scl_oen,
        SDA_I      => FPGA_I2C_SDA,
        SDA_O      => sda_o,
        SDA_OEN    => sda_oen
    );

    sync_qsfp_i2c_i: entity work.ASYNC_OPEN_LOOP
    generic map (
        IN_REG   => false,
        TWO_REG  => true
    )
    port map (
        ADATAIN  => qsfp_scl_oe,
        BCLK     => SYS_CLK_50M,
        BDATAOUT => qsfp_scl_oe_sync
    );
    --
    arbit_p: process(SYS_CLK_50M)
    begin
        if rising_edge(SYS_CLK_50M) then
            if (ioexp_req = '1') and (qsfp_i2c_idle = '1') then
                ioexp_gnt <= not FPGA_I2C_MUX_GNT;
            elsif ioexp_done = '1' then
                ioexp_gnt <= '0';
            end if;
            -- Detect activity on QSFP I2C
            if qsfp_scl_oe_sync = '1' then
                qsfp_idle_timer <= (others => '0');
            elsif qsfp_idle_timer(qsfp_idle_timer'high) = '0' then
                qsfp_idle_timer <= qsfp_idle_timer + 1;
            end if;
        end if;
    end process;

    qsfp_i2c_idle <= qsfp_idle_timer(qsfp_idle_timer'high);

    FPGA_I2C_SCL <= scl_o      when (scl_oen = '0' and ioexp_busy = '1')     else
                    qsfp_scl_o when (qsfp_scl_oe = '1' and ioexp_busy = '0') else
                   'Z';

    FPGA_I2C_SDA <= sda_o      when (sda_oen = '0' and ioexp_busy = '1')     else
                    qsfp_sda_o when (qsfp_sda_oe = '1' and ioexp_busy = '0') else
                   'Z';

    -- Clock stretching - hold SCL low when the bus is busy
    qsfp_scl <= '0' when (ioexp_busy = '1') else FPGA_I2C_SCL;
    qsfp_sda <= '0' when (ioexp_busy = '1') else FPGA_I2C_SDA;

    cm_i : entity work.FPGA_COMMON
    generic map (
        SYSCLK_FREQ             => 50,
        USE_PCIE_CLK            => false,

        PCIE_LANES              => PCIE_LANES,
        PCIE_CLKS               => PCIE_CLKS,
        PCIE_CONS               => PCIE_CONS,

        ETH_CORE_ARCH           => NET_MOD_ARCH,
        ETH_PORTS               => ETH_PORTS, -- one QSFP-DD cage as two ETH ports
        ETH_PORT_SPEED          => ETH_PORT_SPEED,
        ETH_PORT_CHAN           => ETH_PORT_CHAN,
        ETH_PORT_LEDS           => 1, -- fake, this board has no ETH LEDs
        ETH_LANES               => ETH_LANES,
        
        QSFP_PORTS              => 1,
        QSFP_I2C_PORTS          => 1,
        QSFP_I2C_TRISTATE       => false,

        STATUS_LEDS             => STATUS_LEDS,
        MISC_IN_WIDTH           => MISC_IN_WIDTH,
        MISC_OUT_WIDTH          => MISC_OUT_WIDTH,
        
        PCIE_ENDPOINTS          => PCIE_ENDPOINTS,
        PCIE_ENDPOINT_TYPE      => PCIE_MOD_ARCH,
        PCIE_ENDPOINT_MODE      => PCIE_ENDPOINT_MODE,
        
        DMA_ENDPOINTS           => DMA_ENDPOINTS,
        DMA_MODULES             => DMA_MODULES,
        
        DMA_RX_CHANNELS         => DMA_RX_CHANNELS/DMA_MODULES,
        DMA_TX_CHANNELS         => DMA_TX_CHANNELS/DMA_MODULES,
        
        --MEM_PORTS               => MEM_PORTS,
        --MEM_ADDR_WIDTH          => MEM_ADDR_WIDTH,
        --MEM_DATA_WIDTH          => MEM_DATA_WIDTH,
        --MEM_BURST_WIDTH         => MEM_BURST_WIDTH,
        --AMM_FREQ_KHZ            => 266660,

        BOARD                   => "IA-420F",
        DEVICE                  => "AGILEX",
        
        DMA_GEN_LOOP_EN         => DMA_GEN_LOOP_EN
    )
    port map(
        SYSCLK               => SYS_CLK_50M,
        SYSRST               => '0',

        PCIE_SYSCLK_P        => PCIE_REFCLK1 & PCIE_REFCLK0,
        PCIE_SYSCLK_N        => (others => '0'),
        PCIE_SYSRST_N(0)     => PCIE_SYSRST_N,

        PCIE_RX_P            => PCIE_RX_P,
        PCIE_RX_N            => PCIE_RX_N,
        PCIE_TX_P            => PCIE_TX_P,
        PCIE_TX_N            => PCIE_TX_N,
        
        ETH_REFCLK_P         => QSFP_REFCLK_156M & QSFP_REFCLK_156M,
        ETH_REFCLK_N         => (others => '0'),
        
        ETH_RX_P             => QSFP_RX_P,
        ETH_RX_N             => QSFP_RX_N,
        ETH_TX_P             => QSFP_TX_P,
        ETH_TX_N             => QSFP_TX_N,

        ETH_LED_R            => open,
        ETH_LED_G            => open,
        
        QSFP_I2C_SCL_I(0)    => qsfp_scl,
        QSFP_I2C_SDA_I(0)    => qsfp_sda,
        QSFP_I2C_SCL_O(0)    => qsfp_scl_o,
        QSFP_I2C_SCL_OE(0)   => qsfp_scl_oe,
        QSFP_I2C_SDA_O(0)    => qsfp_sda_o,
        QSFP_I2C_SDA_OE(0)   => qsfp_sda_oe,

        QSFP_MODSEL_N        => open,
        QSFP_LPMODE(0)       => ioexp_o(4),
        QSFP_RESET_N(0)      => ioexp_o(7),
        QSFP_MODPRS_N        => (others => ioexp_i(6)),
        QSFP_INT_N           => (others => ioexp_i(5)),

        --MEM_CLK                 => mem_clk,
        --MEM_RST                 => not mem_rst_n,
--
        --MEM_AVMM_READY          => mem_avmm_ready,
        --MEM_AVMM_READ           => mem_avmm_read,
        --MEM_AVMM_WRITE          => mem_avmm_write,
        --MEM_AVMM_ADDRESS        => mem_avmm_address,
        --MEM_AVMM_BURSTCOUNT     => mem_avmm_burstcount,
        --MEM_AVMM_WRITEDATA      => mem_avmm_writedata,
        --MEM_AVMM_READDATA       => mem_avmm_readdata,
        --MEM_AVMM_READDATAVALID  => mem_avmm_readdatavalid,
--
        --EMIF_RST_REQ            => emif_rst_req,
        --EMIF_RST_DONE           => emif_rst_done,
        --EMIF_ECC_USR_INT        => emif_ecc_usr_int,
        --EMIF_CAL_SUCCESS        => emif_cal_success,
        --EMIF_CAL_FAIL           => emif_cal_fail,
        BOOT_MI_RESET           => io_reset,


        STATUS_LED_G         => status_led_g,
        STATUS_LED_R         => status_led_r,

        MISC_IN              => (others => '0'),
        MISC_OUT             => open
    );

    USER_LED_G <= status_led_g(0);
    USER_LED_R <= status_led_r(0);

end architecture;

