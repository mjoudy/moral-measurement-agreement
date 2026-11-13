#!/bin/bash
#SBATCH --job-name=test-gpu
#SBATCH --partition=l40s
#SBATCH --gpus=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16gb
#SBATCH --time=00:10:00
#SBATCH --output=logs/%x-%j.out

# Run from the repo root after: mkdir -p logs
source scripts/nemo/env.sh

nvidia-smi --query-gpu=name,memory.total --format=csv
python -c "import torch, transformers, peft; print('torch', torch.__version__, 'cuda', torch.version.cuda, 'available', torch.cuda.is_available(), 'bf16', torch.cuda.is_bf16_supported()); print('transformers', transformers.__version__, 'peft', peft.__version__)"
