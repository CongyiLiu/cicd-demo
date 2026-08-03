#!/bin/bash
# 在 VPS 上运行此脚本来添加你的 SSH 公钥

SSH_PUB_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHED1FBKUha/XWEjfio6Xw50vFfHbk59bujiEqK0ErCr cicd-deploy"

echo "╔═══════════════════════════════════════════════════════╗"
echo "║  VPS SSH Public Key Setup                             ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo ""

# 创建 .ssh 目录
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# 添加公钥
echo "$SSH_PUB_KEY" >> ~/.ssh/authorized_keys

# 设置权限
chmod 600 ~/.ssh/authorized_keys

echo "✓ SSH public key added to ~/.ssh/authorized_keys"
echo ""
echo "Verification:"
tail -n 1 ~/.ssh/authorized_keys
echo ""
echo "Next: You can now SSH without password:"
echo "  ssh root@149.28.21.68"
