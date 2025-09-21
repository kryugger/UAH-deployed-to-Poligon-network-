param(
    [string]$InputPath = "original-icon.png",
    [string]$OutputDir = "assets/images/"
)

Write-Output "Р—Р°РїСѓСЃРє РєРѕРЅРІРµСЂС‚Р°С†РёРё РёРєРѕРЅРѕРє..."

# РЎРѕР·РґР°РµРј РїР°РїРєСѓ РµСЃР»Рё РЅРµС‚
New-Item -ItemType Directory -Path $OutputDir -Force

# РџСЂРѕРІРµСЂСЏРµРј С‡С‚Рѕ РёСЃС…РѕРґРЅС‹Р№ С„Р°Р№Р» СЃСѓС‰РµСЃС‚РІСѓРµС‚
if (-not (Test-Path $InputPath)) {
    Write-Output "РћС€РёР±РєР°: РСЃС…РѕРґРЅС‹Р№ С„Р°Р№Р» РЅРµ РЅР°Р№РґРµРЅ: $InputPath"
    Write-Output "РџРѕР»РѕР¶РёС‚Рµ РІР°С€Сѓ РёРєРѕРЅРєСѓ РІ РєРѕСЂРµРЅСЊ РїСЂРѕРµРєС‚Р° Рё РЅР°Р·РѕРІРёС‚Рµ 'original-icon.png'"
    exit 1
}

# Р Р°Р·РјРµСЂС‹ РґР»СЏ РєРѕРЅРІРµСЂС‚Р°С†РёРё
$sizes = @(
    @{Name="logo.png"; Size="512x512"},
    @{Name="icon.png"; Size="256x256"},
    @{Name="favicon.ico"; Size="32x32"},
    @{Name="logo-128.png"; Size="128x128"},
    @{Name="logo-64.png"; Size="64x64"}
)

Write-Output "РЎРѕР·РґР°СЋ РёРєРѕРЅРєРё РІ СЂР°Р·РјРµСЂР°С…:"

foreach ($item in $sizes) {
    $outputPath = Join-Path $OutputDir $item.Name
    Write-Output "   $($item.Name) ($($item.Size))"
    
    try {
        if (Get-Command magick -ErrorAction SilentlyContinue) {
            magick $InputPath -resize $item.Size $outputPath
        } else {
            # РџСЂРѕСЃС‚РѕР№ РІР°СЂРёР°РЅС‚ С‡РµСЂРµР· .NET
            Add-Type -AssemblyName System.Drawing
            $original = [System.Drawing.Image]::FromFile((Get-Item $InputPath).FullName)
            $bitmap = New-Object System.Drawing.Bitmap($original, $item.Size -split 'x')
            $bitmap.Save($outputPath)
            $original.Dispose()
            $bitmap.Dispose()
        }
    }
    catch {
        Write-Output "   РћС€РёР±РєР° РїСЂРё СЃРѕР·РґР°РЅРёРё $($item.Name): $($_.Exception.Message)"
    }
}

Write-Output "Р“РѕС‚РѕРІРѕ! РРєРѕРЅРєРё СЃРѕР·РґР°РЅС‹ РІ РїР°РїРєРµ: $OutputDir"
