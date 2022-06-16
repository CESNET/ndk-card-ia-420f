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

begin

    FPGA_I2C_SCL      <= '1';
    FPGA_I2C_SDA      <= '1';
    FPGA_I2C_REQ_L    <= '1';

    FPGA2BMC_IRQ      <= '1';
    FPGA2BMC_MST_EN_N <= '1';
    BMC2FPGA_SPI_MISO <= '1';
    
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
        
        QSFP_I2C_SCL         => open,
        QSFP_I2C_SDA         => open,

        QSFP_MODSEL_N        => open,
        QSFP_LPMODE          => open,
        QSFP_RESET_N         => open,
        QSFP_MODPRS_N        => (others => '0'), -- fake module is present
        QSFP_INT_N           => (others => '1'), -- TODO

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

        STATUS_LED_G         => status_led_g,
        STATUS_LED_R         => status_led_r,

        MISC_IN              => (others => '0'),
        MISC_OUT             => open
    );

    USER_LED_G <= status_led_g(0);
    USER_LED_R <= status_led_r(0);

end architecture;
