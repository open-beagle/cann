# cann

华为昇腾 GPU 镜像仓库

## 基础镜像

### ascend-infer

<https://www.hiascend.com/developer/ascendhub/detail/e02f286eef0847c2be426f370e0c2596>

```bash
# 登录华为镜像仓库
docker login -u cn-south-1@8W3MTEA1U8JSRE3WC9NF -p 1f5f0caa16c9d1a00ddce99ab007caf4f4f6faeea63bca2f1e505c7e946ba3cb swr.cn-south-1.myhuaweicloud.com

# 下载基础镜像
docker pull --platform=linux/arm64 swr.cn-south-1.myhuaweicloud.com/ascendhub/ascend-infer:24.0.RC1-ubuntu20.04
docker tag swr.cn-south-1.myhuaweicloud.com/ascendhub/ascend-infer:24.0.RC1-ubuntu20.04 registry-vpc.cn-qingdao.aliyuncs.com/wod/cann:ascend-infer-24.0.RC1-ubuntu20.04
docker push registry-vpc.cn-qingdao.aliyuncs.com/wod/cann:ascend-infer-24.0.RC1-ubuntu20.04
```

### pytorch

<https://gitee.com/ascend/pytorch>

```bash
# arm64安装torch
pip3 install torch==2.2.0

# 安装依赖
pip3 install pyyaml
pip3 install setuptools

# 安装torch_npu
pip3 install torch-npu==2.2.0

# check
python3 checktorch.py
```

### 手动下载deb包进行安装

<https://www.hiascend.com/developer/download/community/result?module=cann&cann=8.0.RC3.beta1>

需要注意cann的安装包不同型号的GPU，下载不同的包，这里是使用的910B

```bash
# cann-toolkit
mkdir -p .tmp/
curl -fL -o .tmp/Ascend-cann-toolkit_8.0.RC3.alpha003_linux-aarch64.run \
  https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/Milan-ASL/Milan-ASL%20V100R001C19SPC703/Ascend-cann-toolkit_8.0.RC3.alpha003_linux-aarch64.run?response-content-type=application/octet-stream

# cann-kernel-910
mkdir -p .tmp/
curl -fL -o .tmp/Ascend-cann-kernels-910_8.0.RC3.alpha003_linux-aarch64.run \
  https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/Milan-ASL/Milan-ASL%20V100R001C19SPC703/Ascend-cann-kernels-910_8.0.RC3.alpha003_linux-aarch64.run?response-content-type=application/octet-stream

# cann-kernel-910b
mkdir -p .tmp/
curl -fL -o .tmp/Ascend-cann-kernels-910b_8.0.RC3.alpha003_linux-aarch64.run \
  https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/Milan-ASL/Milan-ASL%20V100R001C19SPC703/Ascend-cann-kernels-910b_8.0.RC3.alpha003_linux-aarch64.run?response-content-type=application/octet-stream

docker run -it --rm \
  -v $PWD/:/go/src/gitlab.wodcloud.com/kubernetes/cann \
  -w /go/src/gitlab.wodcloud.com/kubernetes/cann \
  -e DEBIAN_FRONTEND=noninteractive \
  registry.cn-qingdao.aliyuncs.com/wod/debian:12-arm64 \
  bash -c '
  apt update && apt install python3-minimal python3-pip -y && \
  chmod +x ./.tmp/Ascend-cann-toolkit_8.0.RC3.alpha003_linux-aarch64.run && \
  ./.tmp/Ascend-cann-toolkit_8.0.RC3.alpha003_linux-aarch64.run \
  --quiet --install --install-for-all --extract=./.tmp/Ascend-cann/toolkit
  '
```

### 如何配置CANN的环境变量

toolkit ,  toolkit 提供开发工具和运行环境，是 NNAE 和 NNRT 的基础。
kernel , 扩展组件 ， kernel 是具体的计算单元，被 NNAE 和 NNRT 调用执行。
nnae&nnrt , 扩展组件 ， NNAE 和 NNRT 是 CANN 的两个引擎，分别面向训练和推理场景。

```bash
# 安装toolkit包时配置，其他软件包以实际安装路径为准
. /usr/local/Ascend/ascend-toolkit/set_env.sh
```
