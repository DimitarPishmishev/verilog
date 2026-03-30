#!/bin/bash

# --- DYNAMIC PATH RESOLUTION ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Move up two levels from scripts -> src -> UART
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# --- CONFIG ---
OUT_DIR_NAME="out"
VIEWER="vivado"

# --- ARGUMENT PARSING ---
while [[ $# -gt 0 ]]; do
    case "$1" in
        -s)
            VIEWER="surfer"
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [-s] [output_dir_name]"
            echo "  -s                 : Use Surfer viewer instead of Vivado"
            echo "  output_dir_name    : Custom output directory name (creates 'out_<name>')"
            exit 0
            ;;
        *)
            # Assume it's a custom folder name if it doesn't start with -
            OUT_DIR_NAME="out_$1"
            shift
            ;;
    esac
done

# --- EXECUTION ---
OUT_DIR="$ROOT_DIR/$OUT_DIR_NAME"

if [[ ! -d "$OUT_DIR" ]]; then
    echo "[ERROR] Output directory '$OUT_DIR' not found!"
    echo "Run your simulation script first."
    exit 1
fi

cd "$OUT_DIR" || exit 1

if [[ "$VIEWER" == "surfer" ]]; then
    echo "Opening Surfer for $OUT_DIR_NAME..."
    if [[ -f "dump.vcd" ]]; then
        surfer dump.vcd &
    else
        echo "[ERROR] dump.vcd not found. Did you run the simulation with the -s flag?"
        exit 1
    fi
elif [[ "$VIEWER" == "vivado" ]]; then
    echo "Opening Vivado for $OUT_DIR_NAME..."
    if [[ -f "my_snapshot.wdb" ]]; then
        vivado -source <(echo "open_wave_database my_snapshot.wdb") &
    else
        echo "[ERROR] my_snapshot.wdb not found. Did you run the simulation without the -s flag?"
        exit 1
    fi
else
    echo "[ERROR] Unknown viewer: $VIEWER"
    exit 1
fi
