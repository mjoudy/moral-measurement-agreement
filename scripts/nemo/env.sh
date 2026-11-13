# Source this at the top of every NEMO2 job: source scripts/nemo/env.sh
module load lang/miniforge3/24.11.3-0
export WS=$(ws_find mfrc)
export HF_HOME=$WS/hf_cache
export PIP_CACHE_DIR=$WS/pip_cache
export CONDA_PKGS_DIRS=$WS/conda_pkgs
eval "$(conda shell.bash hook)"
conda activate $WS/env 2>/dev/null
