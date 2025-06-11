/**
 * 调试命令系统 - 用于测试和调试游戏功能
 */
class DebugCommands {
    constructor() {
        this.setupCommands();
    }

    /**
     * 设置调试命令
     */
    setupCommands() {
        // 在控制台添加全局调试函数
        if (typeof window !== 'undefined') {
            // 生成特定类型的敌机
            window.spawnEnemy = (type = 'basic', x = 400, y = 50) => {
                if (window.game) {
                    console.log(`生成敌机: ${type} at (${x}, ${y})`);
                    return window.game.createEnemy(x, y, type);
                }
            };

            // 生成所有类型的敌机用于测试
            window.spawnAllEnemyTypes = () => {
                if (!window.game) return;
                
                const types = ['basic', 'scout', 'fighter', 'heavy', 'elite', 'interceptor', 'bomber'];
                const spacing = 80;
                const startX = 80;
                
                types.forEach((type, index) => {
                    const x = startX + (index % 4) * spacing;
                    const y = 100 + Math.floor(index / 4) * 80;
                    console.log(`生成 ${type} at (${x}, ${y})`);
                    window.game.createEnemy(x, y, type);
                });
            };

            // 生成Boss
            window.spawnBoss = (type = 'standard', x = 400, y = 100) => {
                if (window.game) {
                    console.log(`生成Boss: ${type} at (${x}, ${y})`);
                    return window.game.createBoss(x, y, type);
                }
            };

            // 生成所有类型的Boss
            window.spawnAllBossTypes = () => {
                if (!window.game) return;
                
                const types = ['standard', 'fast', 'heavy', 'ultimate'];
                const spacing = 150;
                const startX = 150;
                
                types.forEach((type, index) => {
                    const x = startX + index * spacing;
                    const y = 100 + index * 20;
                    console.log(`生成Boss ${type} at (${x}, ${y})`);
                    setTimeout(() => {
                        window.game.createBoss(x, y, type);
                    }, index * 1000); // 延迟生成，避免重叠
                });
            };

            // 切换图片渲染模式
            window.toggleImageRender = () => {
                if (!window.game) return;
                
                const useImage = !window.game.player?.useImageRender;
                console.log(`切换图片渲染模式: ${useImage ? '开启' : '关闭'}`);
                
                // 切换玩家
                if (window.game.player) {
                    window.game.player.useImageRender = useImage;
                }
                
                // 切换敌机
                window.game.enemies.forEach(enemy => {
                    enemy.useImageRender = useImage;
                });
                
                // 切换Boss
                if (window.game.boss) {
                    window.game.boss.useImageRender = useImage;
                }
                
                // 切换僚机
                if (window.game.player?.wingmen) {
                    window.game.player.wingmen.forEach(wingman => {
                        wingman.useImageRender = useImage;
                    });
                }
            };

            // 重新加载图片
            window.reloadImages = () => {
                const imageManager = window.ImageManager?.getInstance();
                if (imageManager) {
                    console.log('重新加载图片资源...');
                    imageManager.clear();
                    imageManager.loadAllImages().then(() => {
                        console.log('图片重新加载完成');
                    });
                } else {
                    console.error('ImageManager未找到');
                }
            };

            // 设置敌机生成概率
            window.setEnemySpawnRate = (type, probability) => {
                if (!window.game?.enemySpawner) return;
                
                const oldProb = window.game.enemySpawner.spawnProbabilities[type];
                window.game.enemySpawner.spawnProbabilities[type] = probability;
                console.log(`${type} 生成概率从 ${oldProb} 调整为 ${probability}`);
            };

            // 显示当前敌机生成概率
            window.showSpawnRates = () => {
                if (!window.game?.enemySpawner) return;
                
                console.log('当前敌机生成概率:');
                console.table(window.game.enemySpawner.spawnProbabilities);
            };

            // 增加轰炸机出现率（用于测试）
            window.increaseBomberRate = () => {
                if (!window.game?.enemySpawner) return;
                
                const spawner = window.game.enemySpawner;
                spawner.spawnProbabilities.bomber = 0.3; // 30%概率
                spawner.spawnProbabilities.basic = 0.2;
                spawner.spawnProbabilities.scout = 0.2;
                spawner.spawnProbabilities.fighter = 0.15;
                spawner.spawnProbabilities.heavy = 0.1;
                spawner.spawnProbabilities.elite = 0.05;
                
                console.log('轰炸机出现率已增加到30%');
                console.table(spawner.spawnProbabilities);
            };

            // 显示调试帮助
            window.debugHelp = () => {
                console.log(`
=== 飞机大战调试命令 ===

基础命令:
• spawnEnemy(type, x, y) - 生成指定类型敌机
• spawnAllEnemyTypes() - 生成所有类型敌机用于测试
• spawnBoss(type, x, y) - 生成指定类型Boss
• spawnAllBossTypes() - 生成所有类型Boss

图片相关:
• toggleImageRender() - 切换图片/几何图形渲染模式
• reloadImages() - 重新加载图片资源

生成控制:
• setEnemySpawnRate(type, probability) - 设置敌机生成概率
• showSpawnRates() - 显示当前生成概率
• increaseBomberRate() - 增加轰炸机出现率(测试用)

敌机类型: basic, scout, fighter, heavy, elite, interceptor, bomber
Boss类型: standard, fast, heavy, ultimate

示例:
spawnEnemy('bomber', 400, 100)  // 生成轰炸机
increaseBomberRate()            // 增加轰炸机出现率
toggleImageRender()             // 切换渲染模式
                `);
            };

            console.log('调试命令已加载！输入 debugHelp() 查看帮助');
        }
    }
}

// 创建调试命令实例
if (typeof window !== 'undefined') {
    window.debugCommands = new DebugCommands();
} 