# Do dictionary, zero-shot LLM and LoRA-tuned LLM measures of moral content agree?

This project tests whether a word-count dictionary (eMFD), a small open LLM used zero-shot, and the same LLM fine-tuned with LoRA agree with trained human coders, and with each other, when detecting five moral foundations in Reddit comments (MFRC). [Finding: one sentence, added after the results.]

Status: work in progress. Independent project.

## Data and tools

- Moral Foundations Reddit Corpus (MFRC): [USC-MOLA-Lab/MFRC](https://huggingface.co/datasets/USC-MOLA-Lab/MFRC), CC BY 4.0. Trager et al. (2022), arXiv:2208.05545.
- Extended Moral Foundations Dictionary (eMFD) via [eMFDscore](https://github.com/medianeuroscience/emfdscore). Hopp et al. (2021), Behavior Research Methods.

## Repository layout

```
src/            shared code (data, scoring, training, evaluation)
notebooks/      step-by-step exploration and the Colab demo
scripts/nemo/   Slurm scripts for the bwForCluster NEMO2
results/        per-comment scores and metrics (CSV)
figures/        final figure(s)
```
