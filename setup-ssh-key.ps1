# Setup SSH Public Key on VPS
# When prompted for password, enter: {4VuvTaS@UJq[SxW

$pubKey = Get-Content "$env:USERPROFILE\.ssh\id_ed25519.pub"
$vpsIp = "149.28.21.68"
$vpsUser = "root"
$vpsPort = 22

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "  SSH Public Key Setup for VPS" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Step 1: Preparing public key" -ForegroundColor Green
Write-Host "Public Key: $pubKey"
Write-Host ""
Write-Host "Step 2: Connecting to VPS" -ForegroundColor Green
Write-Host "  Server: $($vpsUser)@$($vpsIp):$vpsPort"
Write-Host "  Action: Adding public key to ~/.ssh/authorized_keys"
Write-Host ""
Write-Host "Step 3: Enter password when prompted" -ForegroundColor Yellow
Write-Host "  Password: {4VuvTaS@UJq[SxW"
Write-Host ""
Write-Host "Executing command..." -ForegroundColor Green
Write-Host ""

# Execute command: add public key to VPS
$sshCommand = "mkdir -p ~/.ssh; cat >> ~/.ssh/authorized_keys; chmod 600 ~/.ssh/authorized_keys; chmod 700 ~/.ssh; echo ''; echo 'Public key added successfully!'; echo 'Verification:'; tail -1 ~/.ssh/authorized_keys"

$pubKey | ssh -p $vpsPort "$($vpsUser)@$($vpsIp)" $sshCommand

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "SUCCESS! SSH public key has been added to VPS" -ForegroundColor Green
    Write-Host ""
    Write-Host "Testing passwordless login..." -ForegroundColor Cyan
    Write-Host ""
    ssh -p $vpsPort "$($vpsUser)@$($vpsIp)" "echo 'OK'"
} else {
    Write-Host ""
    Write-Host "ERROR: Please check password or network connection" -ForegroundColor Red
    exit 1
}
