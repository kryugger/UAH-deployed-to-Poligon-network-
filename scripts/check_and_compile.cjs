const fs = require('fs');
const { exec } = require('child_process');

const folders = ['artifacts', 'typechain-types'];

// Функция проверки существования папки
function checkFolder(folder) {
  return fs.existsSync(folder) && fs.lstatSync(folder).isDirectory();
}

// Проверяем все папки
let missing = folders.filter(folder => !checkFolder(folder));

if (missing.length === 0) {
  console.log('✅ Все папки уже существуют: artifacts/ и typechain-types/');
  process.exit(0);
} else {
  console.log('⚠️ Не найдены папки:', missing.join(', '));
  console.log('🚀 Запускаем компиляцию Hardhat...');

  // Запуск компиляции
  const compile = exec('npx hardhat compile');

  compile.stdout.on('data', (data) => {
    process.stdout.write(data);
  });

  compile.stderr.on('data', (data) => {
    process.stderr.write(data);
  });

  compile.on('close', (code) => {
    if (code === 0) {
      console.log('✅ Компиляция завершена успешно!');
      missing.forEach(folder => {
        if (checkFolder(folder)) {
          console.log(`✅ Папка создана: ${folder}/`);
        } else {
          console.log(`❌ Папка не создана: ${folder}/`);
        }
      });
    } else {
      console.log(`❌ Компиляция завершилась с ошибкой, код: ${code}`);
    }
  });
}
