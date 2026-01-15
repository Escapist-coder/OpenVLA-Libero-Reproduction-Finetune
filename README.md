# OpenVLA Finetune and Evaluation on Libero Benchmark: A Reproduction Journey

## 🎥 Demos 
- Task 1

| 视频演示 | 视频说明 | Success | 视频演示 | 视频说明 | Success |
| :------- | :------- | :------- | :------- | :------- | :------- |
| ![完美](https://github.com/user-attachments/assets/6ba2b912-38ad-4956-ae12-b97c9d6f8a0e)| 抓取一次成功 | True | ![碰到没夹起来](https://github.com/user-attachments/assets/4c6e5f0e-992d-40cb-9b29-2ffdf8aaa502)| 碰到但未抓取成功 | False |
| ![夹两次成功](https://github.com/user-attachments/assets/c4d155a3-4cd2-4a1c-a5c9-7ddbc6ab50c7)| 抓取两次成功 | True | ![进去但是翻了](https://github.com/user-attachments/assets/7c7d2f62-708b-4037-8f52-8d4fe1f37d08)| 放进盘中但翻出来 | False |
| ![夹空](https://github.com/user-attachments/assets/b02a18f5-7a59-4848-a552-ae8c726c2d10)| 抓空 | False | ![进去一部分](https://github.com/user-attachments/assets/ee3ce256-d9af-4eb1-ac0d-a492342e25a6)| 部分放入盘中 | False |

- Task 2

| 视频演示 | 视频说明 | Success |
| :------- | :------- | :------- |
| ![2完美](https://github.com/user-attachments/assets/cfc53b0e-e18a-45cd-a768-6cacb226ea37)| 抓取一次成功 | True |
| ![2碰到](https://github.com/user-attachments/assets/0d1360af-b4d1-4009-a574-5ef0e6f25369)| 碰到但未抓取成功 | False |
| ![2差一点完全成功](https://github.com/user-attachments/assets/edd325f8-5fc9-41fd-aecb-4bb9cefc9b58)| 未完全放入盘中 | False |




| 图表演示 | 指标含义 | 数据解读 |
| :------- | :------- | :------- |
| <img width="500" height="300" alt="W B Chart 2026_1_12 09_37_51" src="https://github.com/user-attachments/assets/795ed370-92df-42f4-91f2-c993c61cd866" /> | 训练损失，这是衡量模型整体表现的最重要指标 | 曲线呈现出“L”型走势。从最开始的 12 左右迅速下降，在前 1000 步稳定在 3 左右，随后缓慢且持续地下降到 2-3 之间。因此可以分为1. 快速下降期：说明模型很快就学会了任务的基本规则（比如图像和动作的大致对应关系）；2. 平稳下降期：后期的缓慢下降说明模型在进行“微调”，学习更细腻的操作细节；3. 震荡：曲线上的小锯齿是完全正常的（因为每个 Batch 的数据难易程度不同），只要整体趋势是向下的就是健康的。|
| <img width="500" height="300" alt="W B Chart 2026_1_12 09_38_06" src="https://github.com/user-attachments/assets/877059e6-1a44-495b-b1f1-8784161d7f28" /> | L1 动作误差，这是指标专门衡量机器人动作预测的精准度 | 从 0.4+ 降到了 0.1 左右。这意味着模型预测的动作越来越精准。如果把这个想象成机械臂抓取物体，一开始它可能偏离目标 40cm，现在误差可能只有 10cm 或更小 |
| <img width="500" height="300" alt="W B Chart 2026_1_12 09_38_15" src="https://github.com/user-attachments/assets/ff87d5cc-44e0-4167-b355-75c1f7824a07" /> | 动作准确率，这是一个离散化的准确率指标 | 曲线呈现明显的上升趋势。从最初的 ~10% (0.1) 迅速爬升，最后稳定在 40%-50% (0.4-0.5) 之间震荡。在机器人连续控制任务中，准确率通常是基于阈值计算的（比如“预测值和真实值极其接近才算对”）。在 OpenVLA 这类任务中，40%-50% 的 Action Accuracy 通常已经是非常不错的表现了，并不像图像分类那样需要达到 90% 才算好。对于震荡，这个指标比 Loss 震荡更剧烈是正常的，只要整体趋势向上就说明模型变聪明了。|

- 额外观察：GPU 状态
<img width="1825" height="635" alt="ScreenShot_2026-01-12_112904_665" src="https://github.com/user-attachments/assets/92ffc0cc-1724-469b-8261-9cffa31492af" />

  - GPU Power Usage (%)：全程保持在 80%-90% 左右的高位，非常稳定。

  - 显存：没有出现剧烈波动或溢出。 说明训练过程硬件利用率很高，没有遇到数据加载瓶颈，计算非常高效。

✅ 结论
- 模型训练得非常健康，收敛良好。 从图表看，没有任何过拟合（Loss 反弹）或不收敛（Loss 降不下去）的迹象。

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

The whole process was recorded on [OpenVLA-Learning](https://blog.csdn.net/2303_77547168/article/details/156364335?spm=1011.2415.3001.5331).

## 📊 Evaluation Results

| Task Suite | Episodes | Auto-Eval Success Rate | Human-Eval Success Rate |
| :--- | :--- | :--- | :--- |
| Libero Spatial Task1 | 50 | ~14% | ~26%  |
| Libero Spatial Task2 | 8 | ~13% | ~63%  |

**Analysis of "False Negatives":**
Upon manual inspection of the replay videos, the robot successfully completed the task (e.g., picking up the red mug) in many episodes marked as "Fail". 
- **Reason:** The strict geometric threshold of the simulation environment (height/zone tolerance) often rejects valid manipulations that would be considered successful in the real world. At the same time, the number of training rounds is still insufficient.

## Acknowledgements 
This project is based on the OpenVLA codebase. Special thanks to the original authors for their open-source contribution.
