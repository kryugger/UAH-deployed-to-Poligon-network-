# Очистка проекта Hardhat/Node.js

Write-Host "🚀 Начинаем очистку..."

# Удаляем папку node_modules
if (Test-Path "node_modules") {
    Remove-Item -Recurse -Force "node_modules"
    Write-Host "✅ Удалено: node_modules"
} else {
    Write-Host "⚠ node_modules не найдено"
}

# Удаляем package-lock.json
if (Test-Path "package-lock.json") {
    Remove-Item -Force "package-lock.json"
    Write-Host "✅ Удалено: package-lock.json"
} else {
    Write-Host "⚠ package-lock.json не найден"
}

# Удаляем кэш Hardhat
if (Test-Path "cache") {
    Remove-Item -Recurse -Force "cache"
    Write-Host "✅ Удалено: cache"
} else {
    Write-Host "⚠ cache не найден"
}

# Удаляем артефакты компиляции
if (Test-Path "artifacts") {
    Remove-Item -Recurse -Force "artifacts"
    Write-Host "✅ Удалено: artifacts"
} else {
    Write-Host "⚠ artifacts не найдены"
}

Write-Host "🎉 Очистка завершена! Теперь запускаем npm install..."
npm install
