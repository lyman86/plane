/**
 * Boss 类 - 游戏中的强力敌人
 * 具有多阶段战斗、特殊攻击模式和复杂AI
 */
class Boss extends GameObject {
    constructor(x, y) {
        console.log('Boss构造函数被调用, x:', x, 'y:', y);
        console.log('GameObject类型:', typeof GameObject);
        
        try {
            super(x, y);
            console.log('super()调用成功');
        } catch (error) {
            console.error('super()调用失败:', error);
            throw error;
        }
        this.type = 'boss';
        this.width = 120;
        this.height = 80;
        this.maxHealth = 5000;
        this.health = this.maxHealth;
        this.speed = 30;
        this.attackPower = 50;
        this.scoreValue = 10000;
        
        // Boss专属属性
        this.phase = 1; // 当前阶段 (1-3)
        this.maxPhases = 3;
        this.attackTimer = 0;
        this.attackCooldown = 2.0; // 2秒攻击间隔
        this.specialAttackTimer = 0;
        this.specialAttackCooldown = 8.0; // 8秒特殊攻击间隔
        this.invulnerableTimer = 0; // 无敌时间
        this.warningTimer = 0; // 警告显示时间
        
        // 移动模式
        this.movementPattern = 'entrance'; // entrance, patrol, charge, retreat
        this.movementTimer = 0;
        this.targetX = x;
        this.targetY = y;
        this.originalX = x;
        this.originalY = 100;
        
        // 攻击模式
        this.attackModes = [
            'straightShot',    // 直线射击
            'spreadShot',      // 散射
            'circularShot',    // 环形射击
            'laserBeam',       // 激光束
            'missileBarrage',  // 导弹齐射
            'shockwave',       // 冲击波
            'teleport'         // 瞬移攻击
        ];
        this.currentAttackMode = 0;
        
        // 视觉效果
        this.glowIntensity = 0;
        this.shakeOffset = { x: 0, y: 0 };
        this.warningFlash = false;
        this.deathAnimation = {
            active: false,
            timer: 0,
            explosions: []
        };
        
        // 音效控制
        this.lastAttackSound = Date.now();
        this.appearancePlayed = false;
        
        this.active = false;
        this.inGameArea = false;
    }
    
    /**
     * X坐标的getter和setter
     */
    get x() {
        return this.position.x;
    }
    
    set x(value) {
        this.position.x = value;
    }
    
    /**
     * Y坐标的getter和setter
     */
    get y() {
        return this.position.y;
    }
    
    set y(value) {
        this.position.y = value;
    }
    
    /**
     * 重置Boss状态
     */
    reset(x, y, bossType = 'standard') {
        super.reset(x, y);
        this.type = 'boss';
        this.phase = 1;
        this.health = this.maxHealth;
        this.attackTimer = 0;
        this.specialAttackTimer = 0;
        this.invulnerableTimer = 0;
        this.warningTimer = 5.0; // 5秒警告时间
        this.movementPattern = 'entrance';
        this.movementTimer = 0;
        this.targetX = x;
        this.targetY = 100;
        this.originalX = x;
        this.originalY = 100;
        this.currentAttackMode = 0;
        this.glowIntensity = 0;
        this.shakeOffset = { x: 0, y: 0 };
        this.warningFlash = false;
        this.deathAnimation.active = false;
        this.deathAnimation.timer = 0;
        this.deathAnimation.explosions = [];
        this.appearancePlayed = false;
        this.active = true;
        this.inGameArea = false;
        
        // 根据Boss类型调整属性
        this.setBossType(bossType);
    }
    
    /**
     * 设置Boss类型
     */
    setBossType(bossType) {
        switch (bossType) {
            case 'heavy':
                this.maxHealth = 8000;
                this.health = this.maxHealth;
                this.width = 150;
                this.height = 100;
                this.speed = 20;
                this.attackCooldown = 1.5;
                this.scoreValue = 15000;
                break;
            case 'fast':
                this.maxHealth = 3000;
                this.health = this.maxHealth;
                this.width = 100;
                this.height = 60;
                this.speed = 50;
                this.attackCooldown = 1.0;
                this.scoreValue = 8000;
                break;
            case 'ultimate':
                this.maxHealth = 12000;
                this.health = this.maxHealth;
                this.width = 200;
                this.height = 120;
                this.speed = 25;
                this.attackCooldown = 0.8;
                this.specialAttackCooldown = 5.0;
                this.scoreValue = 25000;
                this.maxPhases = 4;
                break;
            default: // standard
                break;
        }
    }
    
    /**
     * 更新Boss状态
     */
    onUpdate(deltaTime) {
        if (!this.active) return;
        
        // 更新计时器
        this.updateTimers(deltaTime);
        
        // 检查阶段转换
        this.checkPhaseTransition();
        
        // 更新移动模式
        this.updateMovement(deltaTime);
        
        // 更新攻击
        this.updateAttacks(deltaTime);
        
        // 更新视觉效果
        this.updateVisualEffects(deltaTime);
        
        // 播放出现音效
        if (!this.appearancePlayed && this.warningTimer <= 0) {
            if (window.game && window.game.audioManager) {
                window.game.audioManager.playSound('boss_appear');
            }
            this.appearancePlayed = true;
        }
    }
    
    /**
     * 更新计时器
     */
    updateTimers(deltaTime) {
        if (this.warningTimer > 0) {
            this.warningTimer -= deltaTime;
            this.warningFlash = Math.floor(this.warningTimer / 0.2) % 2 === 0;
            return; // 警告期间不进行其他更新
        }
        
        this.attackTimer -= deltaTime;
        this.specialAttackTimer -= deltaTime;
        this.movementTimer += deltaTime;
        
        if (this.invulnerableTimer > 0) {
            this.invulnerableTimer -= deltaTime;
        }
        
        if (this.deathAnimation.active) {
            this.deathAnimation.timer += deltaTime;
        }
    }
    
    /**
     * 检查阶段转换
     */
    checkPhaseTransition() {
        const healthPercentage = this.health / this.maxHealth;
        const newPhase = Math.ceil(healthPercentage * this.maxPhases);
        
        if (newPhase < this.phase && newPhase >= 1) {
            this.enterNewPhase(newPhase);
        }
    }
    
    /**
     * 进入新阶段
     */
    enterNewPhase(phase) {
        this.phase = phase;
        this.invulnerableTimer = 2.0; // 2秒无敌时间
        this.glowIntensity = 1;
        
        // 每个阶段提升攻击频率
        this.attackCooldown = Math.max(0.5, this.attackCooldown - 0.3);
        this.specialAttackCooldown = Math.max(3.0, this.specialAttackCooldown - 1.0);
        
        // 播放阶段转换音效
        if (window.game && window.game.audioManager) {
            window.game.audioManager.playSound('boss_phase_change');
        }
        
        // 显示阶段提示
        if (window.game) {
            window.game.showMessage(`Boss进入第${phase}阶段！`, 2000);
        }
    }
    
    /**
     * 更新移动模式
     */
    updateMovement(deltaTime) {
        if (this.warningTimer > 0) return;
        
        switch (this.movementPattern) {
            case 'entrance':
                this.handleEntranceMovement(deltaTime);
                break;
            case 'patrol':
                this.handlePatrolMovement(deltaTime);
                break;
            case 'charge':
                this.handleChargeMovement(deltaTime);
                break;
            case 'retreat':
                this.handleRetreatMovement(deltaTime);
                break;
        }
    }
    
    /**
     * 处理入场移动
     */
    handleEntranceMovement(deltaTime) {
        const targetY = this.originalY;
        const moveSpeed = this.speed * deltaTime;
        
        if (this.y > targetY) {
            this.y = Math.max(targetY, this.y - moveSpeed);
        } else {
            this.movementPattern = 'patrol';
            this.movementTimer = 0;
            this.inGameArea = true;
        }
    }
    
    /**
     * 处理巡逻移动
     */
    handlePatrolMovement(deltaTime) {
        const amplitude = 200;
        const frequency = 0.001;
        const centerX = this.originalX;
        
        this.x = centerX + Math.sin(this.movementTimer * frequency) * amplitude;
        
        // 偶尔切换到冲锋模式
        if (this.movementTimer > 10.0 && Math.random() < 0.3) {
            this.movementPattern = 'charge';
            this.movementTimer = 0;
            this.targetY = Math.min(300, this.y + 150);
        }
    }
    
    /**
     * 处理冲锋移动
     */
    handleChargeMovement(deltaTime) {
        const moveSpeed = this.speed * 2 * deltaTime;
        
        if (this.y < this.targetY) {
            this.y = Math.min(this.targetY, this.y + moveSpeed);
        } else {
            this.movementPattern = 'retreat';
            this.movementTimer = 0;
        }
    }
    
    /**
     * 处理撤退移动
     */
    handleRetreatMovement(deltaTime) {
        const moveSpeed = this.speed * deltaTime;
        
        if (this.y > this.originalY) {
            this.y = Math.max(this.originalY, this.y - moveSpeed);
        } else {
            this.movementPattern = 'patrol';
            this.movementTimer = 0;
        }
    }
    
    /**
     * 更新攻击
     */
    updateAttacks(deltaTime) {
        if (this.warningTimer > 0 || !this.inGameArea) return;
        
        // 普通攻击
        if (this.attackTimer <= 0) {
            this.performNormalAttack();
            this.attackTimer = this.attackCooldown;
        }
        
        // 特殊攻击
        if (this.specialAttackTimer <= 0) {
            this.performSpecialAttack();
            this.specialAttackTimer = this.specialAttackCooldown;
        }
    }
    
    /**
     * 执行普通攻击
     */
    performNormalAttack() {
        const attackMode = this.attackModes[this.currentAttackMode];
        
        switch (attackMode) {
            case 'straightShot':
                this.fireStraightShot();
                break;
            case 'spreadShot':
                this.fireSpreadShot();
                break;
            case 'circularShot':
                this.fireCircularShot();
                break;
        }
        
        // 循环攻击模式
        this.currentAttackMode = (this.currentAttackMode + 1) % Math.min(3, this.attackModes.length);
        
        // 播放攻击音效
        if (window.game && window.game.audioManager) {
            window.game.audioManager.playSound('boss_attack');
        }
    }
    
    /**
     * 执行特殊攻击
     */
    performSpecialAttack() {
        const specialAttacks = ['laserBeam', 'missileBarrage', 'shockwave'];
        const attackType = specialAttacks[Math.floor(Math.random() * specialAttacks.length)];
        
        switch (attackType) {
            case 'laserBeam':
                this.fireLaserBeam();
                break;
            case 'missileBarrage':
                this.fireMissileBarrage();
                break;
            case 'shockwave':
                this.fireShockwave();
                break;
        }
        
        // 播放特殊攻击音效
        if (window.game && window.game.audioManager) {
            window.game.audioManager.playSound('boss_special_attack');
        }
    }
    
    /**
     * 直线射击
     */
    fireStraightShot() {
        if (!window.game) return;
        
        const bulletCount = 3;
        const spacing = 30;
        const startX = this.x - (bulletCount - 1) * spacing / 2;
        
        for (let i = 0; i < bulletCount; i++) {
            const bullet = window.game.createBullet(
                startX + i * spacing,
                this.y + this.height / 2,
                0, 300, 'enemyBoss'
            );
            if (bullet) {
                bullet.damage = this.attackPower;
            }
        }
    }
    
    /**
     * 散射
     */
    fireSpreadShot() {
        if (!window.game) return;
        
        const bulletCount = 5;
        const angleSpread = Math.PI / 3; // 60度散射
        const speed = 250;
        
        for (let i = 0; i < bulletCount; i++) {
            const angle = -angleSpread / 2 + (angleSpread / (bulletCount - 1)) * i;
            const vx = Math.sin(angle) * speed;
            const vy = Math.cos(angle) * speed;
            
            const bullet = window.game.createBullet(
                this.x,
                this.y + this.height / 2,
                vx, vy, 'enemyBoss'
            );
            if (bullet) {
                bullet.damage = this.attackPower * 0.8;
            }
        }
    }
    
    /**
     * 环形射击
     */
    fireCircularShot() {
        if (!window.game) return;
        
        const bulletCount = 12;
        const speed = 200;
        
        for (let i = 0; i < bulletCount; i++) {
            const angle = (Math.PI * 2 / bulletCount) * i;
            const vx = Math.cos(angle) * speed;
            const vy = Math.sin(angle) * speed;
            
            const bullet = window.game.createBullet(
                this.x,
                this.y + this.height / 2,
                vx, vy, 'enemyBoss'
            );
            if (bullet) {
                bullet.damage = this.attackPower * 0.6;
            }
        }
    }
    
    /**
     * 激光束攻击
     */
    fireLaserBeam() {
        if (!window.game) return;
        
        // 创建激光预警
        window.game.showMessage('激光充能中...', 1000);
        
        // 1秒后发射激光
        setTimeout(() => {
            if (this.active && window.game) {
                const laserCount = 3;
                const spacing = 100;
                const startX = this.x - spacing;
                
                for (let i = 0; i < laserCount; i++) {
                    // 创建激光柱
                    const laser = window.game.createBullet(
                        startX + i * spacing,
                        this.y + this.height,
                        0, 800, 'laser'
                    );
                    if (laser) {
                        laser.damage = this.attackPower * 1.5;
                        laser.width = 20;
                        laser.height = 600;
                    }
                }
            }
        }, 1000);
    }
    
    /**
     * 导弹齐射
     */
    fireMissileBarrage() {
        if (!window.game) return;
        
        const missileCount = 8;
        let delay = 0;
        
        for (let i = 0; i < missileCount; i++) {
            setTimeout(() => {
                if (this.active && window.game) {
                    const angle = Math.random() * Math.PI / 3 - Math.PI / 6; // ±30度
                    const speed = 300;
                    const vx = Math.sin(angle) * speed;
                    const vy = Math.cos(angle) * speed;
                    
                    const missile = window.game.createBullet(
                        this.x + (Math.random() - 0.5) * this.width,
                        this.y + this.height,
                        vx, vy, 'missile'
                    );
                    if (missile) {
                        missile.damage = this.attackPower * 1.2;
                    }
                }
            }, delay);
            delay += 200; // 0.2秒间隔
        }
    }
    
    /**
     * 冲击波攻击
     */
    fireShockwave() {
        if (!window.game) return;
        
        // 创建环形冲击波
        const waveCount = 20;
        const speed = 150;
        
        for (let i = 0; i < waveCount; i++) {
            const angle = (Math.PI * 2 / waveCount) * i;
            const vx = Math.cos(angle) * speed;
            const vy = Math.sin(angle) * speed;
            
            const wave = window.game.createBullet(
                this.x,
                this.y + this.height / 2,
                vx, vy, 'shockwave'
            );
            if (wave) {
                wave.damage = this.attackPower * 0.8;
                wave.width = 15;
                wave.height = 15;
            }
        }
    }
    
    /**
     * 更新视觉效果
     */
    updateVisualEffects(deltaTime) {
        // 发光效果
        if (this.glowIntensity > 0) {
            this.glowIntensity = Math.max(0, this.glowIntensity - deltaTime);
        }
        
        // 受伤震动
        if (this.shakeOffset.x !== 0 || this.shakeOffset.y !== 0) {
            this.shakeOffset.x *= 0.9;
            this.shakeOffset.y *= 0.9;
            
            if (Math.abs(this.shakeOffset.x) < 0.1) this.shakeOffset.x = 0;
            if (Math.abs(this.shakeOffset.y) < 0.1) this.shakeOffset.y = 0;
        }
        
        // 死亡动画
        if (this.deathAnimation.active) {
            if (this.deathAnimation.timer > 3.0) {
                this.active = false;
            }
        }
    }
    
    /**
     * 受到伤害
     */
    takeDamage(damage = 100) {
        if (this.invulnerableTimer > 0 || !this.active) return 0;
        
        const actualDamage = Math.min(damage, this.health);
        this.health -= actualDamage;
        
        // 视觉反馈
        this.glowIntensity = 0.8;
        this.shakeOffset.x = (Math.random() - 0.5) * 10;
        this.shakeOffset.y = (Math.random() - 0.5) * 10;
        
        // 播放受伤音效
        if (window.game && window.game.audioManager) {
            window.game.audioManager.playSound('boss_hit');
        }
        
        // 检查死亡
        if (this.health <= 0) {
            this.startDeathAnimation();
        }
        
        return actualDamage;
    }
    
    /**
     * 开始死亡动画
     */
    startDeathAnimation() {
        this.deathAnimation.active = true;
        this.deathAnimation.timer = 0;
        
        // 创建爆炸效果
        for (let i = 0; i < 20; i++) {
            setTimeout(() => {
                if (window.game && window.game.particleSystem) {
                    window.game.particleSystem.createExplosion(
                        this.x + (Math.random() - 0.5) * this.width,
                        this.y + (Math.random() - 0.5) * this.height,
                        {
                            color: '#ff6b35',
                            count: 15,
                            speed: 200,
                            life: 1000
                        }
                    );
                }
            }, i * 150);
        }
        
        // 播放死亡音效
        if (window.game && window.game.audioManager) {
            window.game.audioManager.playSound('boss_death');
        }
    }
    
    /**
     * 渲染Boss
     */
    onRender(ctx) {
        if (!this.active) return;
        
        // 警告阶段渲染
        if (this.warningTimer > 0) {
            this.renderWarning(ctx);
            return;
        }
        
        ctx.save();
        
        // 应用震动偏移
        ctx.translate(this.shakeOffset.x, this.shakeOffset.y);
        
        // 发光效果
        if (this.glowIntensity > 0) {
            ctx.shadowBlur = 20 * this.glowIntensity;
            ctx.shadowColor = '#ff0000';
        }
        
        // 无敌状态闪烁
        if (this.invulnerableTimer > 0 && Math.floor(this.invulnerableTimer / 0.1) % 2 === 0) {
            ctx.globalAlpha = 0.5;
        }
        
        // 渲染Boss主体
        this.renderBossBody(ctx);
        
        // 渲染血条
        this.renderHealthBar(ctx);
        
        // 渲染阶段指示器
        this.renderPhaseIndicator(ctx);
        
        ctx.restore();
    }
    
    /**
     * 渲染警告
     */
    renderWarning(ctx) {
        if (!this.warningFlash) return;
        
        ctx.save();
        
        // 背景警告
        ctx.fillStyle = 'rgba(255, 0, 0, 0.3)';
        ctx.fillRect(0, 0, ctx.canvas.width, ctx.canvas.height);
        
        // 警告文字
        ctx.fillStyle = '#ff0000';
        ctx.font = 'bold 48px Arial';
        ctx.textAlign = 'center';
        ctx.fillText('危险！Boss即将出现！', ctx.canvas.width / 2, ctx.canvas.height / 2);
        
        ctx.font = 'bold 24px Arial';
        ctx.fillText(`${this.warningTimer.toFixed(1)}秒`, ctx.canvas.width / 2, ctx.canvas.height / 2 + 60);
        
        ctx.restore();
    }
    
    /**
     * 渲染Boss主体
     */
    renderBossBody(ctx) {
        // Boss轮廓（简化版）
        const gradient = ctx.createLinearGradient(
            this.x - this.width / 2, this.y - this.height / 2,
            this.x + this.width / 2, this.y + this.height / 2
        );
        gradient.addColorStop(0, '#660000');
        gradient.addColorStop(0.5, '#cc0000');
        gradient.addColorStop(1, '#990000');
        
        ctx.fillStyle = gradient;
        ctx.fillRect(
            this.x - this.width / 2,
            this.y - this.height / 2,
            this.width,
            this.height
        );
        
        // Boss装甲细节
        ctx.strokeStyle = '#ffffff';
        ctx.lineWidth = 2;
        ctx.strokeRect(
            this.x - this.width / 2,
            this.y - this.height / 2,
            this.width,
            this.height
        );
        
        // 武器系统
        ctx.fillStyle = '#333333';
        for (let i = 0; i < 5; i++) {
            const gunX = this.x - this.width / 2 + (i + 1) * (this.width / 6);
            ctx.fillRect(gunX - 3, this.y + this.height / 2 - 5, 6, 15);
        }
    }
    
    /**
     * 渲染血条
     */
    renderHealthBar(ctx) {
        const barWidth = this.width + 40;
        const barHeight = 8;
        const barX = this.x - barWidth / 2;
        const barY = this.y - this.height / 2 - 20;
        
        // 血条背景
        ctx.fillStyle = '#333333';
        ctx.fillRect(barX, barY, barWidth, barHeight);
        
        // 血条前景
        const healthPercentage = this.health / this.maxHealth;
        const healthWidth = barWidth * healthPercentage;
        
        let healthColor = '#00ff00';
        if (healthPercentage < 0.3) healthColor = '#ff0000';
        else if (healthPercentage < 0.6) healthColor = '#ffff00';
        
        ctx.fillStyle = healthColor;
        ctx.fillRect(barX, barY, healthWidth, barHeight);
        
        // 血条边框
        ctx.strokeStyle = '#ffffff';
        ctx.lineWidth = 1;
        ctx.strokeRect(barX, barY, barWidth, barHeight);
        
        // 血量数字
        ctx.fillStyle = '#ffffff';
        ctx.font = '12px Arial';
        ctx.textAlign = 'center';
        ctx.fillText(
            `${this.health}/${this.maxHealth}`,
            this.x,
            barY - 5
        );
    }
    
    /**
     * 渲染阶段指示器
     */
    renderPhaseIndicator(ctx) {
        const indicatorY = this.y - this.height / 2 - 35;
        
        ctx.fillStyle = '#ffffff';
        ctx.font = 'bold 14px Arial';
        ctx.textAlign = 'center';
        ctx.fillText(`阶段 ${this.phase}/${this.maxPhases}`, this.x, indicatorY);
        
        // 阶段进度条
        const progressWidth = 60;
        const progressHeight = 4;
        const progressX = this.x - progressWidth / 2;
        const progressY = indicatorY + 8;
        
        const phaseProgress = 1 - (this.health / this.maxHealth - (this.phase - 1) / this.maxPhases) * this.maxPhases;
        const progressFill = progressWidth * Math.max(0, Math.min(1, phaseProgress));
        
        ctx.fillStyle = '#333333';
        ctx.fillRect(progressX, progressY, progressWidth, progressHeight);
        
        ctx.fillStyle = '#ffaa00';
        ctx.fillRect(progressX, progressY, progressFill, progressHeight);
        
        ctx.strokeStyle = '#ffffff';
        ctx.lineWidth = 1;
        ctx.strokeRect(progressX, progressY, progressWidth, progressHeight);
    }
    
    /**
     * 检查是否死亡
     */
    isDead() {
        return this.health <= 0;
    }
    
    /**
     * 获取分数值
     */
    getScoreValue() {
        return this.scoreValue + (this.maxPhases - this.phase) * 2000; // 阶段奖励
    }
    
    /**
     * 获取碰撞边界
     */
    getCollisionBounds() {
        return {
            left: this.x - this.width / 2,
            right: this.x + this.width / 2,
            top: this.y - this.height / 2,
            bottom: this.y + this.height / 2
        };
    }
}

// 导出Boss类
if (typeof module !== 'undefined' && module.exports) {
    module.exports = Boss;
} else {
    window.Boss = Boss;
}