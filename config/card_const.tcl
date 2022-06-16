# card_const.tcl: Default parameters for card
# Copyright (C) 2022 CESNET, z. s. p. o.
# Author(s): Jakub Cabal <cabal@cesnet.cz>
#
# SPDX-License-Identifier: BSD-3-Clause

# WARNING: The user should not deliberately change parameters in this file. For
# the description of this file, visit the Parametrization section in the
# documentation of the NDK-CORE repostiory

set CARD_NAME "IA-420F"
# Achitecture of Clock generator (INTEL or USP)
set CLOCK_GEN_ARCH "INTEL"
# Achitecture of PCIe module (P_TILE, R_TILE or USP)
set PCIE_MOD_ARCH "P_TILE"
# Achitecture of Network module (E_TILE, F_TILE, CMAC or EMPTY)
set NET_MOD_ARCH "E_TILE"
# Achitecture of SDM/SYSMON module
set SDM_SYSMON_ARCH "INTEL_SDM"
# Total number of DMA modules/streams in FW
set DMA_MODULES 2

# Total number of QSFP cages
set QSFP_CAGES       1
# I2C address of each QSFP cage
set QSFP_I2C_ADDR(0) "0xA0"

# ------------------------------------------------------------------------------
# Other parameters:
# ------------------------------------------------------------------------------
if {$ETH_PORT_SPEED(0) == 10} {
    set TSU_FREQUENCY 161132812
} else {
    # 100GE and 25GE in E-Tile
    set TSU_FREQUENCY 402832031
}
