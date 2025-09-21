# Path to DAO.sol
$path = ".\contracts\DAO.sol"

# Check if file exists
if (!(Test-Path $path)) {
    Write-Host "❌ DAO.sol not found"
    exit
}

# Read content
$content = Get-Content $path -Raw

# Remove import of GovernorCountingSimple
$content = $content -replace 'import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";\r?\n?', ''

# Remove GovernorCountingSimple from inheritance
$content = $content -replace 'GovernorCountingSimple,?\s*', ''

# Remove super._countVote(...) call
$content = $content -replace 'super\._countVote\(.*?\);\r?\n?', ''

# Save updated content
Set-Content -Path $path -Value $content
Write-Host "✅ DAO.sol cleaned: removed GovernorCountingSimple and conflicting calls"