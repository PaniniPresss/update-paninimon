[CmdletBinding()]
param(
    [string]$InstanceName = "Panini-Academy-2.0"
)

# Minecraft Mods and Resource Packs Installer for PrismLauncher
Write-Host "Starting Minecraft mods and resource packs installation..." -ForegroundColor Green
Write-Host "Target instance: $InstanceName" -ForegroundColor Cyan
Write-Host ""

# Load required assembly for URL decoding
try {
    Add-Type -AssemblyName System.Web
}
catch {
    Write-Host "Warning: Could not load System.Web assembly. Using raw filenames." -ForegroundColor Yellow
}

# ── Define paths ─────────────────────────────────────────────────────────────
$prismAppData     = Join-Path ([Environment]::GetFolderPath("ApplicationData")) "PrismLauncher"
$minecraftPath = Join-Path $prismAppData "instances" | Join-Path -ChildPath $InstanceName | Join-Path -ChildPath "minecraft"
$modsPath         = Join-Path $minecraftPath "mods"
$resourcePacksPath = Join-Path $minecraftPath "resourcepacks"

# Check if the instance exists
if (-not (Test-Path $minecraftPath)) {
    Write-Host "Error: Instance '$InstanceName' not found at:" -ForegroundColor Red
    Write-Host "       $minecraftPath" -ForegroundColor Red
    Write-Host ""
    Write-Host "Press any key to exit..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

# ── Your mod & resource pack lists ──────────────────────────────────────────
$mods = @(
    "https://cdn.modrinth.com/data/9jxwkYQL/versions/ZLVrtF0Q/sophisticatedcore-1.21.1-1.2.9.21.168.jar",
    "https://cdn.modrinth.com/data/ouNrBQtq/versions/nHhuPdda/sophisticatedbackpacks-1.21.1-3.23.4.3.106.jar".
    "https://www.dropbox.com/scl/fi/lcoqv22fml5zmr2s23uzn/cobbleemi-fabric-1.0.3-for-cobblemon-1.7.1.jar?rlkey=43vi615octaw6q2qrh74to1uk&st=0pffxbm7&dl=1"
    # Add more mod URLs here
)

$modsToRemove = @(
    # "unwanted-mod.jar",
    # "another-bad-mod.jar"
)

$resourcePacks = @(
    # "https://example.com/cool-texture-pack.zip",
    # "https://example.com/another-pack.zip"
)

$resourcePacksToRemove = @(
    # "old-pack.zip",
    # "default-removal.zip"
)

# ── Helper Functions ────────────────────────────────────────────────────────
function Get-DecodedFilename {
    param([string]$url)
    $fileName = Split-Path $url -Leaf
    try {
        if ([Type]::GetType("System.Web.HttpUtility")) {
            return [System.Web.HttpUtility]::UrlDecode($fileName)
        }
    }
    catch {}
    # Fallback
    Write-Host "URL decoding not available or failed → using raw name: $fileName" -ForegroundColor Yellow
    return $fileName
}

function Download-File {
    param([string]$url, [string]$outputPath)
    try {
        $fileName = Split-Path $outputPath -Leaf
        Write-Host "Downloading $fileName ..." -ForegroundColor Cyan
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $url -OutFile $outputPath -ErrorAction Stop
        Write-Host "Successfully downloaded $fileName" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "Failed to download $fileName : $_" -ForegroundColor Red
        return $false
    }
}

# ── Mods handling ───────────────────────────────────────────────────────────
try {
    Write-Host "Processing mods folder: $modsPath" -ForegroundColor Yellow
    
    if (-not (Test-Path $modsPath)) {
        New-Item -Path $modsPath -ItemType Directory -Force | Out-Null
        Write-Host "Created mods folder" -ForegroundColor Green
    }

    # Remove unwanted mods
    foreach ($url in $modsToRemove) {
        $fileName = Get-DecodedFilename $url
        $filePath = Join-Path $modsPath $fileName
        if (Test-Path $filePath) {
            Write-Host "Removing unwanted mod: $fileName" -ForegroundColor Yellow
            Remove-Item $filePath -Force
        }
    }

    # Download / check wanted mods
    foreach ($url in $mods) {
        $fileName = Get-DecodedFilename $url
        $outputPath = Join-Path $modsPath $fileName
        
        if (Test-Path $outputPath) {
            Write-Host "Already exists: $fileName" -ForegroundColor Green
            continue
        }

        Write-Host "Missing: $fileName → downloading..." -ForegroundColor Yellow
        $null = Download-File -url $url -outputPath $outputPath
    }
}
catch {
    Write-Host "Error while handling mods: $_" -ForegroundColor Red
    pause
    exit
}

# ── Resource packs handling ─────────────────────────────────────────────────
try {
    Write-Host "Processing resourcepacks folder: $resourcePacksPath" -ForegroundColor Yellow
    
    if (-not (Test-Path $resourcePacksPath)) {
        New-Item -Path $resourcePacksPath -ItemType Directory -Force | Out-Null
        Write-Host "Created resourcepacks folder" -ForegroundColor Green
    }

    # Remove unwanted packs
    foreach ($fileName in $resourcePacksToRemove) {
        $filePath = Join-Path $resourcePacksPath $fileName
        if (Test-Path $filePath) {
            Write-Host "Removing unwanted pack: $fileName" -ForegroundColor Yellow
            Remove-Item $filePath -Force
        }
    }

    # Download / check wanted packs
    foreach ($url in $resourcePacks) {
        $fileName = Get-DecodedFilename $url
        $outputPath = Join-Path $resourcePacksPath $fileName
        
        if (Test-Path $outputPath) {
            Write-Host "Already exists: $fileName" -ForegroundColor Green
            continue
        }

        Write-Host "Missing: $fileName → downloading..." -ForegroundColor Yellow
        $null = Download-File -url $url -outputPath $outputPath
    }
}
catch {
    Write-Host "Error while handling resource packs: $_" -ForegroundColor Red
    pause
    exit
}

# ── Finish ──────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "Installation completed successfully!" -ForegroundColor Green
Write-Host "Mods folder     : $modsPath" -ForegroundColor Cyan
Write-Host "Resource packs  : $resourcePacksPath" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
