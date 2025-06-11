# 飞机大战游戏 - 国内服务器部署指南

## 🎯 快速部署方案对比

| 方案 | 费用 | 部署时间 | 难度 | 推荐指数 |
|------|------|----------|------|----------|
| 阿里云OSS | 5-20元/月 | 5分钟 | ⭐ | ⭐⭐⭐⭐⭐ |
| 腾讯云静态托管 | 5-20元/月 | 5分钟 | ⭐ | ⭐⭐⭐⭐⭐ |
| Gitee Pages | 免费 | 10分钟 | ⭐⭐ | ⭐⭐⭐⭐ |
| 云服务器 | 50-200元/月 | 30分钟 | ⭐⭐⭐ | ⭐⭐⭐ |

## 🚀 方案一：阿里云OSS部署（推荐）

### 准备工作
1. 注册阿里云账号：https://www.aliyun.com
2. 完成实名认证
3. 开通OSS服务

### 详细步骤

#### 1. 创建OSS Bucket
```bash
# 登录阿里云控制台
# 选择"对象存储OSS"
# 点击"创建Bucket"
# 填写以下信息：
Bucket名称: plane-game-[随机数字]
地域: 华东1(杭州) 或 华北2(北京)
存储类型: 标准存储
读写权限: 公共读
```

#### 2. 配置静态网站托管
```bash
# 进入创建的Bucket
# 点击"基础设置" -> "静态页面"
# 开启静态网站托管
# 默认首页: index.html
# 默认404页: index.html
```

#### 3. 上传项目文件
```bash
# 方式1: 网页上传
# 在Bucket文件管理中，直接拖拽上传所有文件

# 方式2: 使用ossutil命令行工具
# 下载ossutil: https://help.aliyun.com/document_detail/120075.html
# 配置ossutil
ossutil config
# 上传文件
ossutil cp -r ./ oss://your-bucket-name/ --include="*"
```

#### 4. 绑定自定义域名（可选）
```bash
# 在Bucket设置中选择"传输管理" -> "域名管理"
# 添加CNAME记录
# 开启HTTPS证书（推荐使用免费SSL证书）
```

### 访问地址
部署完成后，您的游戏地址为：
```
http://plane-game-[随机数字].oss-cn-hangzhou.aliyuncs.com
```

## 🚀 方案二：腾讯云静态网站托管

### 步骤
1. 注册腾讯云账号：https://cloud.tencent.com
2. 开通静态网站托管服务
3. 创建环境
4. 上传文件
5. 配置域名

### 特点
- 与OSS类似的操作流程
- 价格相近
- 提供CDN加速

## 🚀 方案三：Gitee Pages部署（免费方案）

### 步骤

#### 1. 创建Gitee仓库
```bash
# 访问 https://gitee.com
# 注册并完成实名认证
# 创建新仓库，名称建议为: plane-game
```

#### 2. 上传代码
```bash
# 在项目目录执行
git init
git add .
git commit -m "初始化飞机大战游戏"
git remote add origin https://gitee.com/你的用户名/plane-game.git
git push -u origin master
```

#### 3. 开启Pages服务
```bash
# 进入仓库页面
# 点击"服务" -> "Gitee Pages"
# 选择分支: master
# 部署目录: / (根目录)
# 点击"启动"
```

### 访问地址
```
https://你的用户名.gitee.io/plane-game
```

## 🚀 方案四：云服务器部署

### 推荐配置
- CPU: 1核心
- 内存: 1GB
- 带宽: 1-3Mbps
- 系统: CentOS 7.6 或 Ubuntu 18.04

### 快速部署脚本
创建nginx配置：

```nginx
server {
    listen 80;
    server_name 你的域名或IP;
    root /var/www/plane-game;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    # 静态文件缓存
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # 音频文件
    location ~* \.(mp3|wav|ogg)$ {
        expires 30d;
        add_header Cache-Control "public";
    }
    
    # Gzip压缩
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml text/javascript;
}
```

## 📊 性能优化建议

### 1. 文件压缩
```bash
# 压缩JavaScript文件
# 压缩CSS文件
# 优化图片和音频文件大小
```

### 2. CDN加速
- 使用阿里云CDN或腾讯云CDN
- 配置缓存策略
- 开启Gzip压缩

### 3. 监控和分析
- 配置访问日志分析
- 监控网站性能
- 设置域名监控

## 🔧 常见问题解决

### 音频文件无法播放
```javascript
// 检查音频文件路径
// 确保音频文件已正确上传
// 检查浏览器兼容性
```

### 跨域问题
```javascript
// 在服务器配置中添加CORS头
// 或使用同源策略
```

### 移动端适配
```css
/* 确保viewport设置正确 */
<meta name="viewport" content="width=device-width, initial-scale=1.0">
```

## 💰 成本估算

### OSS/静态托管
- 存储费用: 2-5元/月
- 流量费用: 10-50元/月（根据访问量）
- 总计: 12-55元/月

### 云服务器
- 服务器费用: 50-200元/月
- 域名费用: 50-100元/年
- 总计: 55-210元/月

## 🎯 推荐选择

**新手推荐**: 阿里云OSS或腾讯云静态托管
**预算有限**: Gitee Pages
**需要后端功能**: 云服务器

选择哪种方案主要看您的需求和预算。对于您的飞机大战游戏，我强烈推荐使用**阿里云OSS静态网站托管**，因为：

1. ✅ 部署简单快速
2. ✅ 成本低廉
3. ✅ 国内访问速度快
4. ✅ 稳定性高
5. ✅ 自动CDN加速 