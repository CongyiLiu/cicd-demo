# VPS SSH Key Setup Script
# 运行此脚本会将你的公钥添加到 VPS

param(
    [string]$VpsIp = "149.28.21.68",
    [string]$VpsUser = "root",
    [string]$VpsPassword = "{4VuvTaS@UJq[SxW",
    [int]$VpsPort = 22
)

$ErrorActionPreference = "Stop"
$sshKey = "$env:USERPROFILE\.ssh\id_ed25519.pub"
$sshPrivateKey = "$env:USERPROFILE\.ssh\id_ed25519"

Write-Host "╔═══════════════════════════════════════════════════╗"
Write-Host "║  VPS SSH Public Key Setup                         ║"
Write-Host "╚═══════════════════════════════════════════════════╝"
Write-Host ""

# 验证本地公钥是否存在
if (-not (Test-Path $sshKey)) {
    Write-Host "❌ Error: SSH public key not found at $sshKey" -ForegroundColor Red
    exit 1
}

Write-Host "✓ SSH public key found" -ForegroundColor Green
Write-Host ""
Write-Host "VPS Configuration:"
Write-Host "  IP: $VpsIp"
Write-Host "  User: $VpsUser"
Write-Host "  Port: $VpsPort"
Write-Host ""

# 读取公钥
$pubKey = Get-Content $sshKey

Write-Host "Public Key:"
Write-Host "  $pubKey"
Write-Host ""

# 创建远程执行的命令
$remoteCmd = @'
mkdir -p ~/.ssh
chmod 700 ~/.ssh
cat >> ~/.ssh/authorized_keys << 'EOF'
{PUBLIC_KEY}
EOF
chmod 600 ~/.ssh/authorized_keys
echo "✓ Public key added successfully"
ls -la ~/.ssh/
'@

$remoteCmd = $remoteCmd -replace "{PUBLIC_KEY}", $pubKey

Write-Host "Executing on VPS..." -ForegroundColor Cyan
Write-Host ""

# 使用 ssh 命令直接执行（PowerShell 5.1+ 内置 SSH）
try {
    $cmdToExecute = $remoteCmd -replace "`r`n", "; "
    
    # 尝试直接 SSH 连接（会提示输入密码）
    Write-Host "Trying password-based SSH connection..." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "When prompted, enter the VPS password:" -ForegroundColor Yellow
    
    # 创建临时文件保存命令
    $tempScript = [System.IO.Path]::GetTempFileName() + ".sh"
    $remoteCmd | Out-File -FilePath $tempScript -Encoding UTF8 -NoNewline
    
    # 使用 scp 和 ssh 分步执行（需要交互式输入密码）
    & ssh -p $VpsPort "$VpsUser@$VpsIp" $cmdToExecute
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "╔═══════════════════════════════════════════════════╗"
        Write-Host "║  ✓ Setup Successful!                             ║"
        Write-Host "╚═══════════════════════════════════════════════════╝"
        Write-Host ""
        Write-Host "Next steps:"
        Write-Host "  1. Test SSH key-based connection:"
        Write-Host "     ssh -p $VpsPort $VpsUser@$VpsIp 'uname -a'"
        Write-Host ""
        Write-Host "  2. Provide this info for deployment setup:"
        Write-Host "     VPS_HOST=$VpsIp"
        Write-Host "     VPS_PORT=$VpsPort"
        Write-Host "     VPS_USER=$VpsUser"
        Write-Host "     SSH_PRIVATE_KEY=[content of $sshPrivateKey]"
        Write-Host ""
    } else {
        Write-Host ""
        Write-Host "❌ SSH command failed. Check password and VPS connectivity." -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting:"
    Write-Host "  1. Verify VPS IP is correct: $VpsIp"
    Write-Host "  2. Verify SSH password is correct"
    Write-Host "  3. Ensure port $VpsPort is open on VPS"
    exit 1
}

# 清理临时文件
if (Test-Path $tempScript) { Remove-Item $tempScript -Force -ErrorAction SilentlyContinue }
