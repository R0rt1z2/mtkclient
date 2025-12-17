<div align="right">
  Language:
  <a title="English" href="./README.md">🇺🇸</a>
  🇨🇳
</div>

# MTKClient
![Logo](mtkclient/gui/images/logo_256.png)

这是一款用于联发科芯片的调试工具，支持读写分区、利用漏洞对设备进行底层操作。
在Windows系统下使用需要安装MTK串口驱动和UsbDk驱动 (详见下方说明)。
在Linux系统下，如果你使用的是旧版的kamakiri内核则需要使用内核补丁 (参见Setup目录)，但读写分区等操作则不需要补丁。

打开 MTKClient, 在设备完全关机的情况下按住音量上键+电源键或音量下键+电源键进入Brom模式，待工具检测到设备后松手。

## MT6781, MT6789, MT6855, MT6886, MT6895, MT6983, MT8985
- 这些联发科处理器用的是 V6 协议且 Bootrom 漏洞已被修复，需使用 ``--loader`` 指定有效的 DA 文件。
- 在部分设备上，预引导程序 preloader 被禁用了，但是你仍可以通过执行 ``adb reboot edl`` 来使用它。
- 当前仅支持未熔断的设备 (UNFUSED)。
- 对于所有已启用 DAA、SLA 和远程验证 的设备，目前尚无公开解决方案 (原因多种多样)。

## 致谢
- kamakiri [xyzz]
- linecode exploit [chimera]
- Chaosmaster
- Geert-Jan Kreileman (GUI 设计及优化)
- 所有贡献者

## 安装

### 使用 Re LiveDVD (基于 Ubuntu, 开箱即用):
用户: user, 密码: user (基于 Ubuntu 22.04 LTS)

[Live DVD V6](https://www.androidfilehost.com/?fid=1109791587270922802)


## 安装步骤

### Linux - (推荐使用 Ubuntu, 除了 Kamakiri 内核外，无需其他修补过补丁的内核)

#### 安装 python >=3.8、git 和其他依赖项

#### Debian/Ubuntu
```
sudo apt install python3 git libusb-1.0-0 python3-pip libfuse2
```
#### ArchLinux
```
sudo pacman -S  python python-pip python-pipenv git libusb fuse2
```
或者
```
yay -S python python-pip git libusb fuse2
```

#### Fedora
```
sudo dnf install python3 git libusb1 fuse
```

#### 获取文件
```
git clone https://github.com/bkerler/mtkclient
cd mtkclient
pip3 install -r requirements.txt
pip3 install .
```

### 使用 venv
```
python3 -m venv ~/.venv
git clone https://github.com/bkerler/mtkclient
cd mtkclient
. ~/.venv/bin/activate
pip install -r requirements.txt
pip install .
```

#### 安装规则
```
sudo usermod -a -G plugdev $USER
sudo usermod -a -G dialout $USER
sudo cp mtkclient/Setup/Linux/*.rules /etc/udev/rules.d
sudo udevadm control -R
sudo udevadm trigger
```
将用户添加到 dialout/plugdev 后，请务必重启系统。如果设备有厂商接口 0xFF (例如 LG)，需添加 ``blacklist qcaux`` 到配置文件 ``/etc/modprobe.d/blacklist.conf``。

---------------------------------------------------------------------------------------------------------------

### macOS

#### 安装 brew, macFUSE, OpenSSL

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install macfuse openssl
```

安装完后可能需要 **重启**

#### 获取文件
```
git clone https://github.com/bkerler/mtkclient
cd mtkclient
```

#### 创建 python 3.9 venv 虚拟环境并安装依赖
```
python3.9 -m venv mtk_venv
source mtk_venv/bin/activate
pip3 install --pre --no-binary capstone capstone
pip3 install PySide6 libusb
pip3 install -r requirements.txt
```

---------------------------------------------------------------------------------------------------------------

### Windows

#### 安装 python + git
- 安装 [python](https://www.python.org/downloads/) >= 3.9 和 [git](https://git-scm.com/downloads/win)
- 如果你是从 Microsoft Store 安装的 python，执行 "python setup.py install" 可能会失败，但这一步并非必须。
- 通过按下 WIN+R 键, 输入 ``cmd`` 并回车来打开终端

#### 安装 Winfsp (用于 fuse)
下载并安装 [此处](https://winfsp.dev/rel/)

#### 安装 OpenSSL 1.1.1（用于 Python scrypt 依赖项）

下载并安装 [此处](https://sourceforge.net/projects/openssl-for-windows/files/)

#### 获取文件并安装
```
git clone https://github.com/bkerler/mtkclient
cd mtkclient
pip3 install -r requirements.txt
```

#### 获取最新的 UsbDk 64位 驱动
- 安装 MTK 串口驱动 (或使用默认的 Windows COM 端口驱动程序，请确保没有感叹号显示)
- 下载 [UsbDk驱动 安装程序 (.msi) ](https://github.com/daynix/UsbDk/releases/) 并手动安装。
- 使用 "UsbDkController -n" 命令测试设备连接，如果看到设备地址为 0x0E8D 0x0003
- 在 Windows 10 和 11 系统上完美运行 :D

#### 解决编译 wheel 报错的问题 (感谢 @Oyoh-Edmond)
##### 下载并安装构建工具:
- 前往 Visual Studio 生成工具[下载](https://visualstudio.microsoft.com/visual-cpp-build-tools)页面。
- 下载安装程序并运行它。
    
###### 选择必要的构建组件包:
- 在安装程序中，选择 "使用 C++ 进行桌面开发" 组件。
- 确保已选中 "MSVC v142 - VS 2019 C++ x64/x86 生成工具"（或更高版本）组件。
- 如果尚未选中“Windows 10 SDK”，你也可以选中它。

###### 完成安装:
- 点击 "安装" 按钮开始安装。
- 按照提示完成安装。
- 如有需要，请重启电脑。

---------------------------------------------------------------------------------------------------------------
### 使用 kamakiri (可选，仅适用于 mt6260 或更早的处理器)

- 对于 linux (kamakiri 内核), 你需要使用此内核补丁来重新编译 Linux 内核:
```
sudo apt-get install build-essential libncurses-dev bison flex libssl-dev libelf-dev libdw-dev
git clone https://git.kernel.org/pub/scm/devel/pahole/pahole.git
cd pahole && mkdir build && cd build && cmake .. && make && sudo make install
sudo mv /usr/local/libdwarves* /usr/local/lib/ && sudo ldconfig
```

```
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-`uname -r`.tar.xz
tar xvf linux-`uname -r`.tar.xz
cd linux-`uname -r`
patch -p1 < ../Setup/kernelpatches/disable-usb-checks-5.10.patch
cp -v /boot/config-$(uname -r) .config
make menuconfig
make
sudo make modules_install 
sudo make install
```

- 注: 这些对于当前的 Ubuntu 系统来说并不需要 (因为 make install 就可以完成，仅供参考)：

```
sudo update-initramfs -c -k `uname -r`
sudo update-grub
```

你可以在 ``Setup/kernels`` 目录中获取开箱即用的内核配置。


- 重启

```
sudo reboot
```


---------------------------------------------------------------------------------------------------------------

## 使用方法

### 通过图形用户界面使用 MTKTools:
对于基本操作，你可以使用图形用户界面。目前，它支持转储分区或整个闪存。运行以下命令：
```
python mtk_gui.py
```

### 不使用漏洞，直接使用MTK自带功能：
```
python mtk.py --stock
```

### 运行多个命令
```bash
python mtk.py script examples/run.example
```
或
```
python mtk.py multi "cmd1;cmd2"
```
请参阅文件 [run.example](https://github.com/bkerler/mtkclient/blob/main/examples/run.example)，了解如何构建脚本文件。

### 在 venv 虚拟环境中使用
你创建了一个虚拟环境文件夹，所以你需要用它来让 Python 找到正确的包，并且避免任何冲突。
```
. ~/.venv/bin/activate
```
你应该能看到类似这样的东西……
```
(.venv) [user@hostname]$ 
```
这意味着你当前位于虚拟环境文件夹中！

* 以下是一些示例命令……

```
./mtk.py r boot,vbmeta boot.img,vbmeta.img
./mtk.py payload
./mtk.py reset
```
或者更简单
```
mtk r boot,vbmeta boot.img,vbmeta.img
mtk payload
mtk reset
```

### 获取手机 Root 权限 (已在Android 9-12上测试)

1. 提取 boot、vbmeta 分区
```
python mtk.py r boot,vbmeta boot.img,vbmeta.img
```

2. 重启设备
```
python mtk.py reset
```

3.下载 Magisk 面具：
下载最新的 Magisk [此处](https://github.com/topjohnwu/Magisk/releases/latest)

4. 通过 ADB 在设备上安装
- 打开系统设置，进入关于
- 连续点击多次 **构建版本** 后直到显示类似 **你现在处于开发者模式** 的提示
- 在开发者选项下，启用 **OEM解锁** (解锁Bootloader需要) 和 **USB调试**
- 通过命令安装 Magisk 面具
```
adb install app-release.apk
```
- 此时设备上会出现 **是否允许调试** 的对话框，勾选 **总是允许** 后确认

5. 上传提取的 boot 镜像到 /sdcard/Download
```
adb push boot.img /sdcard/Download
```

6. 打开 Magisk, 点击 **安装**, 选择 /sdcard/Download 下载目录中的 boot.img 文件, 点击 **确认**，在修补完成之后将修补后的 magisk_patched-xxxxx.img 传回电脑
```
adb pull /sdcard/Download/[这里写面具修补后的镜像文件名称]
mv [这里写面具修补后的镜像文件名称] boot.patched
```

7. 按照下方 "解锁引导程序" 部分中的步骤操作。

8. 禁用 vbmeta 的验证, 并刷入 Magisk 修补后的 boot 镜像
```
python mtk.py da vbmeta 3
python mtk.py w boot boot.patched
```

9. 重启设备
```
python mtk.py reset
```

10. 断开 USB 数据线，享受你的已 ROOT 的手机吧 :)


### 通过 payload 进入 meta 模式

例如:

```
python mtk.py payload --metamode FASTBOOT
```

### 提取 preloader 分区
```
mtk.py r preloader preloader.bin --parttype boot1
```

### 提取序列号/特殊分区
```
mtk.py r preloader preloader.bin --parttype boot2
```

### 读取 efuses

例如:

```
python mtk.py da efuse
```

### 解锁 bootloader

1. 擦除 metadata、userdata 分区 (如果 md_udc 存在，则加上 md_udc):
```
python mtk.py e metadata,userdata,md_udc
```

2. 解锁 Bootloader:
```
python mtk.py da seccfg unlock
```
如果需要回锁:
```
python mtk.py da seccfg lock
```

3. 重启设备:
```
python mtk.py reset
```

断开 USB 连接线，让手机重启。

若在 Android 11 上遇到 dm-verity 错误，只需按下电源键继续启动即可，
设备应该显示一个关于引导程序 bootloader 已解锁的黄色警告，
然后设备应该会在 5 秒内开机。

### 读取分区

通过 preloader 提取 boot 分区为 boot.bin 文件

```
python mtk.py r boot boot.bin
```

通过 bootrom 提取 boot 分区为 boot.bin 文件

```
python mtk.py r boot boot.bin [--preloader=Loader/Preloader/适用于你设备的Preloader文件.bin]
```


通过 bootrom 提取 preloader 分区为 preloader.bin 文件

```
python mtk.py r preloader preloader.bin --parttype=boot1 [--preloader=Loader/Preloader/适用于你设备的Preloader文件.bin]
```

读取整个闪存数据到文件 flash.bin 文件 (对于 BROM 模式请指定 --preloader)

```
python mtk.py rf flash.bin
```

读取整个闪存数据到文件 flash.bin 文件 (适用于 MT6261/MT2301 IoT 物联网设备) (对于 BROM 模式请指定 --preloader):

```
python mtk.py rf flash.bin --iot
```

读取 0x128000 偏移, 长度为 0x200000 的闪存数据为 flash.bin 文件 (对于 BROM 模式请指定 --preloader)

```
python mtk.py ro 0x128000 0x200000 flash.bin
```

提取所有分区到 "out" 文件夹 (对于 BROM 模式请指定 --preloader)

```
python mtk.py rl out
```

显示 gpt (对于 BROM 模式请指定 --preloader)

```
python mtk.py printgpt
```


将整个闪存挂载为文件系统

```
python mtk.py fs /mnt/mtk
```

### 写入分区
(对于 BROM 模式请指定 --preloader)

写入 boot.bin 文件到 boot 分区

```
python mtk.py w boot boot.bin
```

将文件 flash.bin 写入完整闪存 (目前仅在 DA 模式下有效)

```
python mtk.py wf flash.bin
```

写入 "out" 文件夹中的列出的所有分区文件

```
python mtk.py wl out
```

写入在 flash.bin 中偏移 0x128000 长度为 0x200000 的闪存数据 (对于 BROM 模式请指定 --preloader)

```
python mtk.py wo 0x128000 0x200000 flash.bin
```

### 擦除闪存

擦除 boot 分区
```
python mtk.py e boot
```

擦除 boot 分区的扇区
```
python mtk.py es boot [扇区计数]
```

### DA 命令:

查看内存
```
python mtk.py da peek [十六进制地址] [十六进制长度] [可选参数: -filename filename.bin 将读取的内容保存到名为 filename.bin 文件中]
```

写入内存
```
python mtk.py da poke [十六进制地址] [十六进制的字符串数据 或 -filename filename.bin 从 filename.bin 文件中读取]
```

读取 rpmb (目前仅支持 xflash)
```
python mtk.py da rpmb r [将读取到 rpmb.bin 文件]
```

写入 rpmb [目前存在问题，仅支持 xflash]
```
python mtk.py da rpmb w filename
```

生成并显示 rpmb1-3 密钥
```
python mtk.py da generatekeys
```

解锁 / 回锁 bootloader (lock=>回锁, unlock=>解锁)
```
python mtk.py da seccfg [lock 或 unlock]
```

---------------------------------------------------------------------------------------------------------------

### 绕过 SLA、DAA 和 SBC (通过 generic_patcher_payload)
``
python mtk.py payload
``
如果你想在之后使用 SP Flash Tool 工具，请确保在设置中选择的是 "UART"，而不是 "USB"。

### 提取 preloader
- 设备必须处于 bootrom 模式, 且 preloader 必须在设备上是完整的
```
python mtk.py dumppreloader [--ptype=["amonet","kamakiri","kamakiri2","hashimoto"]] [--filename=preloader.bin]
```

### 提取 brom
- 设备必须处于 bootrom 模式, 或者你可以通过让 DA 崩溃的方法然后进入 DA 模式
- 如果未指定任何选项，则将使用 Kamakiri 或 DA (DA 用于不安全目标)
- 如果将 "Kamakiri" 用作选项，则强制使用 Kamakiri 攻击
- 有效选项包括："kamakiri" (通过 usb_ctrl_handler 攻击)、"amonet" (通过 gcpu) 以及 "hashimoto" (通过 cqdma 攻击)

```
python mtk.py dumpbrom --ptype=["amonet","kamakiri","hashimoto"] [--filename=brom.bin]
```

要提取未知的 bootrom，请使用 brute 选项:
```
python mtk.py brute
```
如果成功提取，请在此处添加一个 Issue 并加上你的 bootrom 附件以添加完整的支持。

---------------------------------------------------------------------------------------------------------------

### 崩溃 DA 以进入 brom

```
python mtk.py crash [--vid=vid] [--pid=pid] [--interface=interface]
```

### 使用修补过的 preloader 读取内存
- 在 Brom 中启动或崩溃到 Brom
```
python mtk.py peek [addr] [length] --preloader=patched_preloader.bin
```

### 运行自定义的 payload

```
python mtk.py payload --payload=payload.bin [--var1=var1] [--wdt=wdt] [--uartaddr=addr] [--da_addr=addr] [--brom_addr=addr]
```

---------------------------------------------------------------------------------------------------------------
## Stage2 用法
### 运行 python mtk.py stage (brom) 或 mtk plstage (preloader)

#### 在 bootrom 模式下运行 stage2
``
python mtk.py stage
``

#### 在 preloader 模式下运行 stage2
``
python mtk.py plstage
``

#### 在 bootrom 模式下运行 stage2 plstage
- 启动到 Brom 或崩溃到 Brom 模式
```
python mtk.py plstage --preloader=preloader.bin
```

### 使用 stage2 工具


### 退出 stage2 模式并重启
``
python stage2.py reboot
``

### 在 stage2 模式下读取 rpmb
``
python stage2.py rpmb
``

### 在 stage2 模式下读取 preloader
``
python stage2.py preloader
``

### 在 stage2 模式下以十六进制数据读取内存
``
python stage2.py memread [开始地址] [数据长度]
``

### 在 stage2 模式下将内存读取到文件
``
python stage2.py memread [开始地址] [数据长度] --filename filename.bin
``

### 在 stage2 模式下将十六进制数据写入内存
``
python stage2.py memwrite [开始地址] --data [十六进制字符串形式的数据]
``

### 在 stage2 模式下将文件中的数据写入内存
``
python stage2.py memwrite [开始地址] --filename filename.bin
``

### 提取密钥
``
python stage2.py keys --mode [sej, dxcc]
``
对于 dxcc，你需要使用 plstage 而不是 stage

---------------------------------------------------------------------

### 我遇到了个问题 ....... 请发送日志和完整的控制台详细信息！

- 使用 --debugmode 选项运行 mtk 工具。日志将写入 log.txt

## 配置 / 信息

### 芯片详细信息/配置
- 转到 config/brom_config.py
- 如果 USB VID/PID 未知，请使用 `config/usb_ids.py` 进行自动检测。
# [学习资源](https://github.com/bkerler/mtkclient/blob/main/learning_resources.md)
