# Путь к Treasury.sol
$path = ".\contracts\Treasury.sol"

# Проверка
if (!(Test-Path $path)) {
    Write-Host "❌ Treasury.sol не найден"
    exit
}

# Чтение
$content = Get-Content $path -Raw

# Добавление импорта DonorBadge
if ($content -notmatch "DonorBadge") {
    $content = $content -replace '(@openzeppelin/contracts/token/ERC20/IERC20.sol";)', '$1`nimport "./DonorBadge.sol";'
}

# Добавление переменной и события
if ($content -notmatch "DonorBadge public badge") {
    $content = $content -replace '(contract Treasury is AccessControl \{)', '$1`n    DonorBadge public badge;`n    event Funded(address indexed campaign, uint256 amount);'
}

# Инициализация badge в конструкторе
if ($content -notmatch "badge = new DonorBadge") {
    $content = $content -replace '(constructor\(address owner\) \{)', '$1`n        badge = new DonorBadge();'
}

# Модификация fundCampaign
if ($content -notmatch "badge.mint") {
    $content = $content -replace '(token\.transfer\(campaign, amount\);)', '$1`n        badge.mint(msg.sender);`n        emit Funded(campaign, amount);'
}

# Сохранение
Set-Content -Path $path -Value $content
Write-Host "✅ Treasury.sol обновлён: добавлены DonorBadge и событие Funded"