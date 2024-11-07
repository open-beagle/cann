import torch
import torch_npu

print(torch.__version__)
print(torch_npu.npu.device_count()) 