
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Host "Please run this script as an Administrator!"
    exit
}


Write-Host "Installing Chocolatey..."
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))


$chocoInstalled = Get-Command choco -ErrorAction SilentlyContinue
if ($null -eq $chocoInstalled) {
    Write-Host "Chocolatey failed to install. Please check the installation script or permissions."
    exit
} else {
    Write-Host "Chocolatey installed successfully."
}


Write-Host "Installing .NET 8 SDK..."
choco install dotnet-8.0-sdk -y


Write-Host "Installing Node.js LTS..."
choco install nodejs-lts -y

Write-Host "Software installation complete."



