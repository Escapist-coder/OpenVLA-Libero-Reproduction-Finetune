# OpenVLA Evaluation on Libero Benchmark: A Reproduction Journey

## 📖 Project Overview
This project documents the deployment and evaluation of the OpenVLA (7B) model on the Libero-Spatial robot manipulation benchmark. The goal was to validate the model's visual-motor control capabilities in a simulated MuJoCo environment.

## 🛠️ Environment Setup (The Tricky Part)
Successfully running the evaluation required solving several dependency conflicts between legacy `gym` and modern `gymnasium` environments.

**Key Dependencies:**
- Python 3.10
- CUDA 12.x / PyTorch
- `gym < 0.26` (Crucial for Libero compatibility)
- `robosuite` & `libero`
- `openvla`

## 🐛 Issues & Fixes Log (My Debugging Journey)
During the reproduction, I encountered and resolved the following critical issues:

### 1. Dependency Hell: Gym vs. Gymnasium
- **Error:** `ModuleNotFoundError: No module named 'gym'`
- **Solution:** Downgraded to legacy gym explicitly.
- **Insight:** Libero relies on the old Gym API, while OpenVLA's newer environment tries to pull Gymnasium.

### 2. Codebase Errors
- **Error:** `NameError: name 'dataclass' is not defined`
- **Fix:** Patched `run_libero_eval.py` to fix import statements (`from dataclasses import dataclass`).

### 3. Center Crop & Spatial Awareness
- **Hypothesis:** Low success rate was caused by image cropping.
- **Experiment:** Modified inference code (bypassing assertions) to test `center_crop=False`.
- **Result:** Success rate dropped from 14% to ~7%. 
- **Conclusion:** OpenVLA relies on `center_crop` for correct spatial alignment; disabling it causes "blind" grasping.

## 📊 Evaluation Results

| Task Suite | Episodes | Auto-Eval Success Rate | Human-Eval Success Rate |
| :--- | :--- | :--- | :--- |
| Libero Spatial | 50+ | ~14% | ~30% (Estimated) |

**Analysis of "False Negatives":**
Upon manual inspection of the replay videos, the robot successfully completed the task (e.g., picking up the red mug) in many episodes marked as "Fail". 
- **Reason:** The strict geometric threshold of the simulation environment (height/zone tolerance) often rejects valid manipulations that would be considered successful in the real world.

## 🎥 Demos
(这里放一两个你下载下来的 .mp4 动图或视频链接，展示成功的抓取)

## Acknowledgements 
This project is based on the OpenVLA codebase. Special thanks to the original authors for their open-source contribution.
