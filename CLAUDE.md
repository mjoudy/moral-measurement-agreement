# Project context (local file, not committed: listed in .gitignore)

## Goal
A small, independent, honest GitHub project for a postdoc application at ZPID
(Leibniz Institute for Psychology, Moral Computing Lab, Prof. Frederic Hopp).
The position is about fine-tuning and evaluating LLMs for modelling human behaviour.
Application deadline: 24 November 2026. Target: finish in 3-4 working days
(roughly 13-16 Nov), leaving 17-23 Nov as buffer.

The user: PhD in computational neuroscience (physicist), thesis submitted Sept 2026.
Comfortable with Python and PyTorch, has fine-tuned BERT for text classification and
worked with RAG. LoRA fine-tuning of generative LLMs is new; the goal is also to learn it.

## Research question
How well do three ways of detecting moral content in text agree with trained human
coders, and with each other, for each moral foundation?
1. Dictionary: eMFD (built by Hopp's group), via eMFDscore
2. A small open LLM (1-3B params), zero-shot
3. The same LLM after LoRA fine-tuning on the training split, evaluated on unseen comments

Context: Stecker & Hopp (Political Analysis, 2025) showed that moral-foundation
measurement tools (dictionaries, embeddings, MoralBERT) agree poorly, but did not test
LLMs. Links to the user's own interest: how reliable word counting vs LLM coding is
for measuring psychological constructs from language.

Framing for honesty: the project measures agreement, not validity. Human labels are
a reference, not ground truth.

Draft abstract (README):
> This project tests whether a word-count dictionary (eMFD), a small open LLM used
> zero-shot, and the same LLM fine-tuned with LoRA agree with trained human coders,
> and with each other, when detecting five moral foundations in Reddit comments (MFRC).
> [Finding: one sentence with the actual numbers, written after the results.]

## Data: MFRC (USC-MOLA-Lab/MFRC on Hugging Face, CC BY 4.0)
From the HF page (still to verify by loading):
- One split `train_dedup`, ~53.8k rows. Each row = one annotator's label for one comment.
- Columns: text, subreddit, bucket, annotator, annotation, confidence, __index_level_0__
- `annotation` is a comma-separated string, e.g. "Loyalty,Equality". Labels: Care, Equality,
  Proportionality, Loyalty, Authority, Purity, Thin Morality, Non-Moral.
- Same text appears 2-5 times (once per annotator). Paper says 16,123 comments from
  12 subreddits; the HF viewer shows 11 subreddits. Check.
- Mapping to eMFD's five foundations: Equality + Proportionality -> Fairness; Purity -> Sanctity.
- A few thousand comments are enough.

## Environments
One codebase in `src/`, used by all environments.

Local (VS Code): editing, git, light exploration.

NEMO2 (bwForCluster, Uni Freiburg), checked on 2026-11-13:
- Workspace: `ws_find mfrc` -> /work/classic/<user>-mfrc (60 days, extendable)
- Partition `l40s`: 9 nodes, 4x L40S per node, max time 2 days. Tested: L40S 46 GB,
  driver CUDA 13.4. GPU partitions are single-node; default job time is 1 h (always set
  --time); jobs on a GPU partition without a GPU request are held.
- Compute nodes have internet (HTTP 200 from huggingface.co), so jobs can download models.
- Conda: module `lang/miniforge3/24.11.3-0`; Python 3.11 env at $WS/env;
  `scripts/nemo/env.sh` loads module, sets HF_HOME/PIP_CACHE_DIR/CONDA_PKGS_DIRS in the
  workspace, activates env.
- Workflow: edit locally -> git push -> on NEMO2 `git pull` -> `sbatch scripts/nemo/...`.
  Run sbatch from the repo root.

Colab (free T4, 16 GB, no bf16): step-by-step exploration and the final demo notebook,
which must run without NEMO2 (loads results/*.csv from the repo and the LoRA adapter
from the HF Hub).

## How we work
- Step by step. Code in small cells/scripts; the user runs them and pastes the output.
- Explain every step in simple Persian, as if to someone outside the field.
- Before building anything, check assumptions by loading and looking at the data or output
  (MFRC structure, eMFD output).
- No exaggeration in README or CV: independent project, not a collaboration or freelance work.

## Plan
- Day 0: GitHub repo, HF token, NEMO2 workspace + env, GPU/internet test.
- Day 1: load MFRC, aggregate labels per comment, inter-annotator agreement (ceiling),
  fixed train/val/test split by unique text, run eMFDscore (Python >= 3.11, spaCy;
  in Colab restart runtime after install; keep it out of the main NEMO2 env for now).
- Day 2: pick model (1-3B) with a 20-example test; yes/no prompt per foundation,
  keep P(yes); develop on a subsample, full run via sbatch on NEMO2.
- Day 3: LoRA training data in the same prompt format; short training on Colab to learn,
  main training on NEMO2 L40S; evaluate on test. Optional: hold out one subreddit.
- Day 4: per foundation F1, Cohen's kappa, AUC vs humans; correlation matrix of
  human / eMFD / zero-shot / LoRA; one figure; README; short summary; one CV line
  matching the repo exactly; run the Colab notebook from scratch.
- Optional: unsupervised "discover first, then check" clustering vs human categories.

Time estimates (~2B model, 3000 train comments x 5 foundations, 1500 test comments):
zero-shot on test ~3-10 min on L40S (15-30 on T4); one LoRA epoch ~15-30 min on L40S
(1-2 h on T4, so Colab trains on a subsample only).

## Methodological decisions (provisional, finalize after seeing the data)
- Split by unique text, fixed seed; same test set for every method.
- Human label: proportion of annotators per foundation (continuous) + majority (binary).
- LLM output: P("yes") per foundation, same format for zero-shot and LoRA, so we get both
  continuous scores (correlations) and binary labels (F1, kappa). LoRA trains the model to
  generate the answer token; loss only on the answer.
- eMFD threshold chosen on train/val, never on test; also report threshold-free metrics
  (AUC, Spearman).
- Thin Morality and Non-Moral have no eMFD counterpart; decide after seeing frequencies.

## Status (2026-11-13)
- Done: NEMO2 checks (sinfo, workspace, modules, GPU + internet).
- In progress: creating the conda env on NEMO2 and the GPU import test
  (`scripts/nemo/test_gpu.sbatch`).
- Next: run `notebooks/01_explore_mfrc.ipynb` (load MFRC, show structure), send output,
  then aggregate labels per comment.
