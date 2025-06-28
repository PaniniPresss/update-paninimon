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
$appdata = [Environment]::GetFolderPath("ApplicationData")
$minecraftPath = Join-Path $appdata ".minecraft"
$modsPath = Join-Path $minecraftPath "mods"
$resourcePacksPath = Join-Path $minecraftPath "resourcepacks"

# List of mods to verify and download if missing (replace with your list)
$mods = @(
    "https://cdn.modrinth.com/data/9NM0dXub/versions/g0SNjiMq/AdvancementPlaques-1.21.1-fabric-1.6.8.jar",
    "https://cdn.modrinth.com/data/EsAfCjCV/versions/b5ZiCjAr/appleskin-fabric-mc1.21-3.0.6.jar",
    "https://cdn.modrinth.com/data/lhGA9TYQ/versions/Wto0RchG/architectury-13.0.8-fabric.jar",
    "https://cdn.modrinth.com/data/b1ZV3DIJ/versions/7PcGW9Vp/athena-fabric-1.21-4.0.2.jar",
    "https://cdn.modrinth.com/data/MBAkmtvl/versions/CuNotPQG/balm-fabric-1.21.1-21.0.46.jar",
    "https://cdn.modrinth.com/data/fALzjamp/versions/RVFHfo1D/Chunky-Fabric-1.4.23.jar",
    "https://cdn.modrinth.com/data/LPuJjiQz/versions/QdTuWWkk/cobblemon-spawn-notification-1.6-fabric-1.3.5.jar",
    "https://cdn.modrinth.com/data/s7N7AsqL/versions/cqsHXSXe/CobbleDollars-fabric-2.0.0%2BBeta-5.1%2B1.21.1.jar",
    "https://cdn.modrinth.com/data/AXY1OO9m/versions/GlSuS3y6/CobbleFurnies-fabric-0.5.jar",
    "https://cdn.modrinth.com/data/8EoIMfd7/versions/TPq9hUyK/cobblemon-droploottables-1.6-fabric-1.4.1.jar",
    "https://cdn.modrinth.com/data/ulX7Vdlf/versions/y1wWWvnI/cobblemon-shearems-1.6-fabric-1.1.2.jar",
    "https://cdn.modrinth.com/data/dba1h0rW/versions/erJT1NJf/cobblemon_knowlogy-fabric-1.4.0-1.21.1.jar",
    "https://cdn.modrinth.com/data/SszvX85I/versions/DDtAlGOQ/Cobblemon_MegaShowdown-9.7.11-release-fabric.jar",
    "https://cdn.modrinth.com/data/MdwFAVRL/versions/v77SHSXW/Cobblemon-fabric-1.6.1%2B1.21.1.jar",
    "https://cdn.modrinth.com/data/u8TYP2M6/versions/uXlfWFQv/CobblemonRepel-1.6-1.2.jar",
    "https://cdn.modrinth.com/data/bI8Nt3uA/versions/aB3cwrFJ/cobblenav-fabric-2.2.3.jar",
    "https://cdn.modrinth.com/data/vXREhDPP/versions/SvjVoDMg/cobbleride-fabric-0.3.2%2B1.21.1.jar",
    "https://cdn.modrinth.com/data/ItmVb4zY/versions/WWub8t6L/Cobbreeding-fabric-1.9.0.jar",
    "https://cdn.modrinth.com/data/1IjD5062/versions/kSPJ4hQv/continuity-3.0.0%2B1.21.jar",
    "https://cdn.modrinth.com/data/ziOp6EO8/versions/kXccSi03/Corgilib-Fabric-1.21.1-5.0.0.4.jar",
    "https://cdn.modrinth.com/data/z2XEADmE/versions/CpSbR8Mk/Data_Anchor-fabric-1.21.1-2.0.0.12.jar",
    "https://cdn.modrinth.com/data/4I1XuqiY/versions/9t01xL7K/entity_model_features_fabric_1.21.1-2.4.1.jar",
    "https://cdn.modrinth.com/data/BVzZfTc1/versions/zzyLrMkD/entity_texture_features_fabric_1.21.1-6.2.9.jar",
    "https://cdn.modrinth.com/data/NNAgCjsB/versions/wZSIbKbB/entityculling-fabric-1.8.0-mc1.21.jar",
    "https://cdn.modrinth.com/data/P7dR8mSH/versions/jCGlnFJS/fabric-api-0.116.3%2B1.21.1.jar",
    "https://cdn.modrinth.com/data/Ha28R6CL/versions/iqWDz8qt/fabric-language-kotlin-1.13.3%2Bkotlin.2.1.21.jar",
    "https://cdn.modrinth.com/data/ohNO6lps/versions/NqVx7ywO/ForgeConfigAPIPort-v21.1.3-1.21.1-Fabric.jar",
    "https://cdn.modrinth.com/data/cTdIg5HZ/versions/WOOVacnh/fightorflight-fabric-0.8.1.jar",
    "https://cdn.modrinth.com/data/8BmcQJ2H/versions/aHSu8jaP/geckolib-fabric-1.21.1-4.7.6.jar",
    "https://cdn.modrinth.com/data/s3dmwKy5/versions/lbSHOhee/GlitchCore-fabric-1.21.1-2.1.0.0.jar",
    "https://cdn.modrinth.com/data/5KWlJ2HC/versions/6YnYg20B/MoreCobblemonTweaks-fabric-1.0.3.jar",
    "https://cdn.modrinth.com/data/5faXoLqX/versions/7ITFAyW8/Iceberg-1.21.1-fabric-1.3.2.jar",
    "https://cdn.modrinth.com/data/5ZwdcRci/versions/UDgEo3mK/ImmediatelyFast-Fabric-1.6.5%2B1.21.1.jar",
    "https://cdn.modrinth.com/data/YL57xq9U/versions/zsoi0dso/iris-fabric-1.8.8%2Bmc1.21.1.jar",
    "https://cdn.modrinth.com/data/nvQzSEkH/versions/aYVY3zTC/Jade-1.21.1-Fabric-15.10.1.jar",
    "https://cdn.modrinth.com/data/fThnVRli/versions/xtWiiv5X/JadeAddons-1.21.1-Fabric-6.0.3.jar",
    "https://cdn.modrinth.com/data/u6dRKJwZ/versions/PtFzlS3P/jei-1.21.1-fabric-19.21.2.313.jar",
    "https://cdn.modrinth.com/data/V4OTaHaq/versions/iI7iVA6Z/knowlogy-fabric-0.8.1-1.21.1.jar",
    "https://cdn.modrinth.com/data/D5h9NKNI/versions/gdB0WW0x/lavender-0.1.15%2B1.21.jar",
    "https://cdn.modrinth.com/data/gvQqBUqZ/versions/MM5BBBOK/lithium-fabric-0.15.0%2Bmc1.21.1.jar",
    "https://cdn.modrinth.com/data/mOgUt4GM/versions/YIfqIJ8q/modmenu-11.0.3.jar",
    "https://cdn.modrinth.com/data/ccKDOlHs/versions/JB1fLQnc/owo-lib-0.12.15.4%2B1.21.jar",
    "https://cdn.modrinth.com/data/hnOfcjSq/versions/AMYJbQsk/pokeblocks-1.4.0-1.21.1.jar",
    "https://cdn.modrinth.com/data/nCQRBEiR/versions/MGosc5Yb/raised-fabric-1.21.1-4.0.1.jar",
    "https://cdn.modrinth.com/data/e0bNACJD/versions/UqA7miTT/SereneSeasons-fabric-1.21.1-10.1.0.1.jar",
    "https://cdn.modrinth.com/data/zV5r3pPn/versions/LwC0oDNc/skinlayers3d-fabric-1.8.0-mc1.21.jar",
    "https://cdn.modrinth.com/data/AANobbMI/versions/u1OEbNKx/sodium-fabric-0.6.13%2Bmc1.21.1.jar",
    "https://cdn.modrinth.com/data/5aaWibi9/versions/JagCscwi/trinkets-3.10.0.jar",
    "https://cdn.modrinth.com/data/9eGKb6K1/versions/d0ufppyc/voicechat-fabric-1.21.1-2.5.30.jar",
    "https://cdn.modrinth.com/data/LOpKHB2A/versions/5QbmQMeD/waystones-fabric-1.21.1-21.1.19.jar",
    "https://cdn.modrinth.com/data/1bokaNcj/versions/BKURGnp1/Xaeros_Minimap_25.2.6_Fabric_1.21.jar",
    "https://cdn.modrinth.com/data/1eAoo2KR/versions/kVxtKPT4/yet_another_config_lib_v3-3.7.1%2B1.21.1-fabric.jar",
    "https://cdn.modrinth.com/data/w7ThoJFB/versions/BTXkmTHl/Zoomify-2.14.4%2B1.21.1.jar",
    "https://cdn.modrinth.com/data/yFqR0DNc/versions/2fmwJrAr/SimpleTMs-fabric-2.1.2.jar",
    "https://cdn.modrinth.com/data/75Ons9AY/versions/oFr92fLC/cobbleboom-fabric-1.4.jar",
    "https://cdn.modrinth.com/data/TrneBt3p/versions/QrenW0p3/livelierpokemon-fabric-2.0.4%2B1.21.1.jar",
    "https://cdn.modrinth.com/data/ouNrBQtq/versions/zBk8Jjya/sophisticatedbackpacks-1.21.1-3.23.4.2.103.jar",
    "https://cdn.modrinth.com/data/9jxwkYQL/versions/qXLdXcsD/sophisticatedcore-1.21.1-1.2.9.14.154.jar",
    "https://cdn.modrinth.com/data/dwxBClup/versions/WQEhxo44/cobblemon-fixedstarterivs-1.6-fabric-1.0.0.jar",
    "https://cdn.modrinth.com/data/NPCfuUI4/versions/YAT9TObm/cobblemonintegrations-fabric-1.21.1-1.1.2.jar",
    "https://cdn.modrinth.com/data/MqcGBDhG/versions/NzRyqZFk/CobblemonMoveInspector-fabric-1.2.0.jar",
    "https://cdn.modrinth.com/data/lRwTUnD7/versions/U2M56SeG/rctmod-fabric-1.21.1-0.16.4-beta.jar",
    "https://cdn.modrinth.com/data/CBfM2yw7/versions/ws0S1A3X/rctapi-fabric-1.21.1-0.13.6-beta.jar",
    "https://cdn.modrinth.com/data/GcWjdA9I/versions/xTezyq2N/malilib-fabric-1.21-0.21.9.jar",
    "https://cdn.modrinth.com/data/XP2jcAo0/versions/HroTTOh2/pastureLoot-1.0.2%2B1.21.1.jar",
    "https://cdn.modrinth.com/data/AufMZTuI/versions/umkXHWa8/cobblemon-pasturecollector-1.6-fabric-1.2.0.jar",
    "https://cdn.modrinth.com/data/5ibSyLAz/versions/Y0KUoPqY/InventorySorter-1.9.0-1.21.jar",
    "https://cdn.modrinth.com/data/AP8rDDLS/versions/QvoJWaYG/HMI%204.3%20-%201.21.%281%29.jar",
    "https://cdn.modrinth.com/data/67dS28p4/versions/OFkWcFfg/gachamachine-1.1.1.jar",
    "https://cdn.modrinth.com/data/fPetb5Kh/versions/9W2MUsnU/NaturesCompass-1.21.1-2.2.7-fabric.jar",
    "https://cdn.modrinth.com/data/t1VgucWo/versions/IhWfYqZC/chunkloaders-1.2.8b-fabric-mc1.21.jar",
    "https://cdn.modrinth.com/data/rOUBggPv/versions/XMcUxulR/supermartijn642corelib-1.1.18a-fabric-mc1.21.jar",
    "https://cdn.modrinth.com/data/VSNURh3q/versions/oXr69pco/c2me-fabric-mc1.21.1-0.3.0%2Balpha.0.320.jar",
    "https://cdn.modrinth.com/data/Ps1zyz6x/versions/Oh80nTJ5/ScalableLux-0.1.0%2Bfabric.26c6e72-all.jar",
    "https://cdn.modrinth.com/data/JygyCSA4/versions/UfoXF5yo/itemscroller-fabric-1.21-0.24.59.jar",
    "https://cdn.modrinth.com/data/wh0wnzrT/versions/9DQtuwLO/cobblemon-unchained-1.6-fabric-1.2.1.jar",
    "https://cdn.modrinth.com/data/BAscRYKm/versions/6h2mVZcb/chipped-fabric-1.21.1-4.0.2.jar",
    "https://cdn.modrinth.com/data/G1hIVOrD/versions/Hf91FuVF/resourcefullib-fabric-1.21-3.0.12.jar",
    "https://cdn.modrinth.com/data/rj8uLYP4/versions/loRaF5XK/cobblemon-counter-1.6-fabric-1.5.0.jar",
    "https://cdn.modrinth.com/data/m6RyHSbV/versions/9JhIuvGv/LegendaryMonuments-6.0.jar",
    "https://cdn.modrinth.com/data/ni4SrKmq/versions/3MLcSYh8/chesttracker-2.6.7%2B1.21.1.jar"
)

# List of mods to remove if present (replace with your list)
$modsToRemove = @(
)

# List of resource packs to verify and download if missing (replace with your list)
$resourcePacks = @(
    @{Url="https://www.dropbox.com/scl/fi/tbdkt84e38h2x4zbeewn6/CobbledGacha-V.1.1-Resourcepack.zip?rlkey=ms0jhymm4olpsd8oknvwdl8k1&st=aok5ef0n&dl=1"; Name="CobbledGacha-V.1.1-Resourcepack.zip"},
    @{Url="https://www.dropbox.com/scl/fi/huvuoh22nicqzhtv5rk9w/CobbleFolk-Skin-Pack-for-1.6.zip?rlkey=eaggbpeqmyw5z1doo5pud60le&st=ts04xegn&dl=1"; Name="CobbleFolk-Skin-Pack-for-1.6.zip"},
    @{Url="https://www.dropbox.com/scl/fi/jfawl2grsapo3oi9mpzkd/Cobblemon-Interface-Modded-v1.9.1.zip?rlkey=3cm7h70lirn0tnlxrkroz07ee&st=b6c6s65p&dl=1"; Name="Cobblemon-Interface-Modded-v1.9.1.zip"},
    @{Url="https://www.dropbox.com/scl/fi/a7yug6xh833qig33o4h1a/Cobblemon-Interface-Recolored-v1.0.1.zip?rlkey=20xnls0hm3bsvcuagjpkzm4bl&st=24myrto7&dl=1"; Name="Cobblemon-Interface-Recolored-v1.0.1.zip"},
    @{Url="https://www.dropbox.com/scl/fi/gpholkcs245q2arjrh9v3/Cobblemon-Interface-v1.4.1.zip?rlkey=n5i4or1wfd11tn8d1u83hcpl5&st=452taz76&dl=1"; Name="Cobblemon-Interface-v1.4.1.zip"},
    @{Url="https://www.dropbox.com/scl/fi/azr95oq0bmhxs8wk3l7vj/SwapBallsReborn-1.2.zip?rlkey=u3p9ptvs6hx4q8v1fqpe1kc4d&st=vc3hw9la&dl=1"; Name="SwapBallsReborn-1.2.zip"},
    @{Url="https://www.dropbox.com/scl/fi/quv2qj3a4myvuio0wvd0h/CobbleSounds-Complete-_v1.4.1.zip?rlkey=4ohj3y41b6csa6bs1ofhx5avt&st=d9a2qgda&dl=1"; Name="CobbleSounds-Complete-_v1.4.1.zip"},
    @{Url="https://www.dropbox.com/scl/fi/m89545py2g0f78y67ijcl/1.6-Shiny-Update.zip?rlkey=9rglktpiwjgyyj4b0qb860dwg&st=6jve9ivi&dl=1"; Name="1.6 - Shiny Update.zip"},
    @{Url="https://cdn.modrinth.com/data/odZZdRCE/versions/dBmf5bHc/AllTheMons%20x%20Mega%20Showdown%20%5Bv2.5.2%5D.zip"; Name="AllTheMons x Mega Showdown v2.5.2.zip"},
    @{Url="https://cdn.modrinth.com/data/46vmrpwJ/versions/OZm5lU27/PathToLegends-1.1.0-release.zip"; Name="PathToLegends-1.1.0-release.zip"},
    @{Url="https://www.dropbox.com/scl/fi/4d2qx755jclbuvxeb4nha/XaerosCobblemon-3.0.2_stars-1.6.1.zip?rlkey=r6r5q7p52mpk9tsn8dtkzghtd&st=dnod50z3&dl=1"; Name="XaerosCobblemon-3.0.2_stars+1.6.1.zip"}
)

# List of resource packs to remove if present (replace with your list)
$resourcePacksToRemove = @(
    # Add objects for resource packs to remove, e.g., @{Url="https://www.dropbox.com/..."; Name="OldResourcePack.zip"}
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
