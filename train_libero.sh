#!/bin/bash
export HF_ENDPOINT=https://hf-mirror.com

# 显存优化配置：如果你不想登录 wandb，可以取消下面这行的注释
export WANDB_MODE=offline

# 设置多卡/单卡端口，防止冲突
export MASTER_PORT=29505

# 启动训练
# A800 专属配置：
# 1. 不使用 --load_in_4bit (保持 BFloat16 高精度，效果更好)
# 2. batch_size 设为 16 (显存大，任性，跑得更快)

torchrun --standalone --nnodes 1 --nproc-per-node 1 vla-scripts/finetune.py \
  --vla_path "openvla/openvla-7b" \
  --data_root_dir "/datadisk/datasets/openvla-libero-spatial" \
  --dataset_name "libero_spatial_no_noops" \
  --run_root_dir "/datadisk/checkpoints" \
  --adapter_tmp_dir "/datadisk/adapter_tmp" \
  --lora_rank 32 \
  --batch_size 16 \
  --grad_accumulation_steps 1 \
  --learning_rate 5e-4 \
  --image_aug True \
  --wandb_project "openvla-finetune" \
  --wandb_entity "zsccyd" \
  --save_steps 1000 \
  --max_steps 5000
