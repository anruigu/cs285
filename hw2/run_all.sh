#!/usr/bin/env bash
set -u
log() { echo -e "\n===== [$(date '+%H:%M:%S')] $* ====="; }

log "1/8 cheetah (no baseline)"
uv run src/scripts/run.py --env_name HalfCheetah-v4 -n 100 -b 5000 -eb 3000 -rtg \
  --discount 0.95 -lr 0.01 --exp_name cheetah

log "2/8 cheetah_baseline"
uv run src/scripts/run.py --env_name HalfCheetah-v4 -n 100 -b 5000 -eb 3000 -rtg \
  --discount 0.95 -lr 0.01 --use_baseline -blr 0.01 -bgs 5 --exp_name cheetah_baseline

log "3/8 pendulum"
uv run src/scripts/run.py --env_name InvertedPendulum-v4 -n 100 -b 5000 -eb 1000 \
  --exp_name pendulum

for L in 0 0.95 0.98 0.99 1; do
  log "lunar_lander_lambda${L}"
  uv run src/scripts/run.py --env_name LunarLander-v2 --ep_len 1000 --discount 0.99 \
    -n 200 -b 2000 -eb 2000 -l 3 -s 128 -lr 0.001 --use_reward_to_go --use_baseline \
    --gae_lambda ${L} --exp_name lunar_lander_lambda${L}
done

log "ALL DONE"
