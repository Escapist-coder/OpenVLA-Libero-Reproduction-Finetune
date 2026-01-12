# OpenVLA Finetune and Evaluation on Libero Benchmark: A Reproduction Journey

## 🎥 Demos (not finished yet)
<img width="500" height="300" alt="W B Chart 2026_1_12 09_37_51" src="https://github.com/user-attachments/assets/795ed370-92df-42f4-91f2-c993c61cd866" /><img width="500" height="300" alt="W B Chart 2026_1_12 09_38_06" src="https://github.com/user-attachments/assets/877059e6-1a44-495b-b1f1-8784161d7f28" /><img width="500" height="300" alt="W B Chart 2026_1_12 09_38_15" src="https://github.com/user-attachments/assets/ff87d5cc-44e0-4167-b355-75c1f7824a07" />
<img width="1825" height="635" alt="ScreenShot_2026-01-12_112904_665" src="https://github.com/user-attachments/assets/92ffc0cc-1724-469b-8261-9cffa31492af" />

## 📖 Project Overview
This project documents the deployment and evaluation of the OpenVLA (7B) model on the Libero-Spatial robot manipulation benchmark. The goal was to validate the model's visual-motor control capabilities in a simulated MuJoCo environment. I have recorded all the related processes in CSDN, [OpenVLA-Learning](https://blog.csdn.net/2303_77547168/article/details/156364335?spm=1011.2415.3001.5331).

## 🛠️ Environment Setup
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
| Libero Spatial | 58 | ~14% | ~31%  |

**Analysis of "False Negatives":**
Upon manual inspection of the replay videos, the robot successfully completed the task (e.g., picking up the red mug) in many episodes marked as "Fail". 
- **Reason:** The strict geometric threshold of the simulation environment (height/zone tolerance) often rejects valid manipulations that would be considered successful in the real world.

## Acknowledgements 
This project is based on the OpenVLA codebase. Special thanks to the original authors for their open-source contribution.
