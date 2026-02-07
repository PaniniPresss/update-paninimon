# Minecraft Mods and Resource Packs Installer
Write-Host "Starting Minecraft mods and resource packs installation..." -ForegroundColor Green

# Load required assembly for URL decoding
try {
    Add-Type -AssemblyName System.Web
}
catch {
    Write-Host "Warning: Could not load System.Web assembly for URL decoding. Using raw filenames." -ForegroundColor Yellow
}

# Define paths
$instanceName = "Panini-Academy-2.0"
$prismAppData = Join-Path ([Environment]::GetFolderPath("ApplicationData")) "PrismLauncher"
$minecraftPath = Join-Path $prismAppData "instances" $instanceName "minecraft"
$modsPath = Join-Path $minecraftPath "mods"
$resourcePacksPath = Join-Path $minecraftPath "resourcepacks"

# List of mods to verify and download if missing (replace with your list)
$mods = @(
    "https://cdn.modrinth.com/data/9jxwkYQL/versions/ZLVrtF0Q/sophisticatedcore-1.21.1-1.2.9.21.168.jar",
    "https://cdn.modrinth.com/data/ouNrBQtq/versions/nHhuPdda/sophisticatedbackpacks-1.21.1-3.23.4.3.106.jar"
)

# List of mods to remove if present (replace with your list)
$modsToRemove = @(
   
)

# List of resource packs to verify and download if missing (replace with your list)
$resourcePacks = @(
 
)
# List of resource packs to remove if present (replace with your list)
$resourcePacksToRemove = @(
    
)

# Function to decode URL-encoded filename
function Get-DecodedFilename {
    param($url)
    $fileName = Split-Path $url -Leaf
    try {
        if ([Type]::GetType("System.Web.HttpUtility")) {
            return [System.Web.HttpUtility]::UrlDecode($fileName)
        }
        else {
            Write-Host "URL decoding not available, using raw filename: $fileName" -ForegroundColor Yellow
            return $fileName
        }
    }
    catch {
        Write-Host "Error decoding URL $fileName, using raw filename: $_" -ForegroundColor Yellow
        return $fileName
    }
}

# Function to download a file
function Download-File {
    param($url, $outputPath)
    try {
        Write-Host "Downloading $(Split-Path $outputPath -Leaf)..." -ForegroundColor Cyan
        $ProgressPreference = 'SilentlyContinue'  # Suppress progress bar for cleaner output
        Invoke-WebRequest -Uri $url -OutFile $outputPath -ErrorAction Stop
        Write-Host "Successfully downloaded $(Split-Path $outputPath -Leaf)" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "Error downloading $(Split-Path $outputPath -Leaf): $_" -ForegroundColor Red
        return $false
    }
}

# Handle mods folder
try {
    Write-Host "Checking for mods folder at $modsPath..." -ForegroundColor Yellow
    if (-not (Test-Path $modsPath)) {
        Write-Host "Creating mods folder..." -ForegroundColor Yellow
        New-Item -Path $modsPath -ItemType Directory -Force | Out-Null
        Write-Host "Created mods folder" -ForegroundColor Green
    }
    else {
        Write-Host "Mods folder already exists" -ForegroundColor Green
    }

    # Remove unwanted mods
    foreach ($mod in $modsToRemove) {
        $fileName = Get-DecodedFilename -url $mod
        $filePath = Join-Path $modsPath $fileName
        if (Test-Path $filePath) {
            Write-Host "Removing unwanted mod $fileName..." -ForegroundColor Yellow
            Remove-Item -Path $filePath -Force -ErrorAction Stop
            Write-Host "Removed $fileName" -ForegroundColor Green
        }
        else {
            Write-Host "Mod $fileName not found in mods folder, no removal needed" -ForegroundColor Green
        }
    }

    # Check and download mods
    foreach ($mod in $mods) {
        $fileName = Get-DecodedFilename -url $mod
        $outputPath = Join-Path $modsPath $fileName
        if (Test-Path $outputPath) {
            Write-Host "Mod $fileName already exists, skipping download..." -ForegroundColor Green
        }
        else {
            Write-Host "Mod $fileName not found, downloading..." -ForegroundColor Yellow
            if (-not (Download-File -url $mod -outputPath $outputPath)) {
                Write-Host "Failed to download mod $fileName. Continuing with next mod..." -ForegroundColor Red
            }
        }
    }
}
catch {
    Write-Host "Error handling mods folder: $_" -ForegroundColor Red
    Write-Host "Press any key to exit..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

# Handle resource packs folder
try {
    Write-Host "Checking for resource packs folder at $resourcePacksPath..." -ForegroundColor Yellow
    if (-not (Test-Path $resourcePacksPath)) {
        Write-Host "Creating resource packs folder..." -ForegroundColor Yellow
        New-Item -Path $resourcePacksPath -ItemType Directory -Force | Out-Null
        Write-Host "Created resource packs folder" -ForegroundColor Green
    }
    else {
        Write-Host "Resource packs folder already exists" -ForegroundColor Green
    }

    # Remove unwanted resource packs
    foreach ($pack in $resourcePacksToRemove) {
        $fileName = $pack.Name
        $filePath = Join-Path $resourcePacksPath $fileName
        if (Test-Path $filePath) {
            Write-Host "Removing unwanted resource pack $fileName..." -ForegroundColor Yellow
            Remove-Item -Path $filePath -Force -ErrorAction Stop
            Write-Host "Removed $fileName" -ForegroundColor Green
        }
        else {
            Write-Host "Resource pack $fileName not found in resource packs folder, no removal needed" -ForegroundColor Green
        }
    }

    # Check and download resource packs
    foreach ($pack in $resourcePacks) {
        $fileName = $pack.Name
        $outputPath = Join-Path $resourcePacksPath $fileName
        if (Test-Path $outputPath) {
            Write-Host "Resource pack $fileName already exists, skipping download..." -ForegroundColor Green
        }
        else {
            Write-Host "Resource pack $fileName not found, downloading..." -ForegroundColor Yellow
            if (-not (Download-File -url $pack.Url -outputPath $outputPath)) {
                Write-Host "Failed to download resource pack $fileName. Continuing with next pack..." -ForegroundColor Red
            }
        }
    }
}
catch {
    Write-Host "Error handling resource packs folder: $_" -ForegroundColor Red
    Write-Host "Press any key to exit..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

Write-Host "Installation completed successfully!" -ForegroundColor Green
Write-Host "Press any key to exit..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
