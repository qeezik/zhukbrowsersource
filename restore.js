const fs = require('fs');
const path = require('path');

// Файлы для восстановления
const filesToRestore = [
    'main.js',
    'renderer.js',
    'preload.js',
    'updater.js',
    'proxy-fixes.js',
    'temp-proxies.js'
];

// Функция для восстановления файла
function restoreFile(filePath) {
    try {
        const backupPath = filePath + '.backup';
        
        if (fs.existsSync(backupPath)) {
            console.log(`Восстановление файла: ${filePath}`);
            
            // Читаем резервную копию
            const backupCode = fs.readFileSync(backupPath, 'utf8');
            
            // Восстанавливаем исходный код
            fs.writeFileSync(filePath, backupCode, 'utf8');
            console.log(`Файл восстановлен: ${filePath}`);
            
        } else {
            console.log(`Резервная копия не найдена: ${backupPath}`);
        }
        
    } catch (error) {
        console.error(`Ошибка при восстановлении ${filePath}:`, error.message);
    }
}

// Восстанавливаем все файлы
console.log('Начинаем восстановление...');
filesToRestore.forEach(file => {
    if (fs.existsSync(file)) {
        restoreFile(file);
    } else {
        console.log(`Файл не найден: ${file}`);
    }
});

console.log('Восстановление завершено!'); 