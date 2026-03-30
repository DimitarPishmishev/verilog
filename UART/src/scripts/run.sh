#!/bin/bash

# 1. Dynamically resolve absolute paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Move up two levels from scripts -> src -> UART
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

RTL_DIR="$PROJECT_ROOT/src/rtl"
VERIF_DIR="$PROJECT_ROOT/src/verif"
FILE_LIST="$PROJECT_ROOT/files_tb.f"

# 2. Set default variables
SKIP_SCAN=0
OUT_DIR_NAME="out"
TOP_MODULE="tb_top"
GEN_VCD=0

# 3. Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -r)
            SKIP_SCAN=1
            shift
            ;;
        -s)
            GEN_VCD=1
            shift
            ;;
        -o)
            OUT_DIR_NAME="out_$2"
            shift 2
            ;;
        -t)
            TOP_MODULE="$2"
            shift 2
            ;;
        -h)
            echo "Usage: $0 [-r] [-s] [-o suffix] [-t top_module]"
            echo "  -r         : Read directly from files_tb.f without scanning for new files"
            echo "  -s         : Generate a .vcd file for Surfer instead of a Vivado .wdb"
            echo "  -o suffix  : Create a custom output dir (e.g., '-o test' creates 'out_test')"
            echo "  -t top_mod : Specify the top module name for elaboration (default: tb_top)"
            exit 0
            ;;
        *)
            echo "Unknown parameter passed: $1"
            exit 1
            ;;
    esac
done

OUT_DIR="$PROJECT_ROOT/$OUT_DIR_NAME"

if [[ $SKIP_SCAN -eq 0 ]]; then
    # Note: create_list function would need to be implemented separately
    # For now, assuming files_tb.f is already created
    echo "Scanning for files... (implement create_list function as needed)"
else
    echo "Skipping file scan (-r used). Reading directly from $FILE_LIST."
fi

# Create output directory if it doesn't exist
mkdir -p "$OUT_DIR"
cd "$OUT_DIR" || exit 1

echo "--- Starting Vivado Simulation in $OUT_DIR_NAME ---"

# Compile
echo "[1/3] Compiling..."
xvlog -sv -f "$FILE_LIST" -L uvm
if [ $? -ne 0 ]; then
    echo "Compilation failed!"
    exit 1
fi

# Elaborate
echo "[2/3] Elaborating..."
xelab -debug typical -top "$TOP_MODULE" -snapshot my_snapshot -L uvm
if [ $? -ne 0 ]; then
    echo "Elaboration failed!"
    exit 1
fi

# Simulate
echo "[3/3] Simulating..."
if [[ $GEN_VCD -eq 1 ]]; then
    echo "Generating VCD for Surfer..."
    {
        echo "open_vcd dump.vcd"
        echo "log_vcd [get_objects -r *]"
        echo "run all"
        echo "close_vcd"
        echo "exit"
    } > sim_run.tcl
else
    echo "Generating WDB for Vivado..."
    {
        echo "log_wave -recursive *"
        echo "run all"
        echo "exit"
    } > sim_run.tcl
fi

xsim my_snapshot -tclbatch sim_run.tcl
