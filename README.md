# OpenVLA Finetune and Evaluation on Libero Benchmark: A Reproduction Journey

## 🎥 Demos 
- Task 1

| 视频演示 | 视频说明 | Success |
| :------- | :------- | :------- |
| ![完美](https://github.com/user-attachments/assets/6ba2b912-38ad-4956-ae12-b97c9d6f8a0e)| 抓取一次成功 | True |
| ![夹两次成功](https://github.com/user-attachments/assets/c4d155a3-4cd2-4a1c-a5c9-7ddbc6ab50c7)| 抓取两次成功 | True |
| ![夹空](https://github.com/user-attachments/assets/b02a18f5-7a59-4848-a552-ae8c726c2d10)| 抓空 | False |
| ![碰到没夹起来](https://github.com/user-attachments/assets/4c6e5f0e-992d-40cb-9b29-2ffdf8aaa502)| 碰到但未抓取成功 | False |
| ![进去但是翻了](https://github.com/user-attachments/assets/7c7d2f62-708b-4037-8f52-8d4fe1f37d08)| 放进盘中但翻出来 | False |
| ![进去一部分](https://github.com/user-attachments/assets/ee3ce256-d9af-4eb1-ac0d-a492342e25a6)| 部分放入盘中 | False |

- Task 2

| 视频演示 | 视频说明 | Success |
| :------- | :------- | :------- |
| ![2完美](https://github.com/user-attachments/assets/cfc53b0e-e18a-45cd-a768-6cacb226ea37)| 抓取一次成功 | True |
| ![2碰到](https://github.com/user-attachments/assets/0d1360af-b4d1-4009-a574-5ef0e6f25369)| 碰到但未抓取成功 | False |
| ![2差一点完全成功](https://github.com/user-attachments/assets/b55e16b8-c5f1-453b-86fb-b795e14ef25e)| 未完全放入盘中 | False |





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
