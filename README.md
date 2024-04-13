# 地圖網頁安裝腳本
## 說明
此專案有兩種用途：
1. 安裝且設定地圖網頁接收和處理資料的環境與套件
2. 建立新機構的地圖網頁
## 環境
已在 Rocky Liunx 9 中測試過
## 安裝流程
### 複製此專案
1. `sudo yum -y install git`
2. `git clone https://github.com/tommygood/deployMapEnv.git`
### 安裝主要環境
1. `cd deployMapEnv/setupUtilsEnv`
2. `sudo bash setupUtilsEnv.sh`
### 建立新機構的地圖網頁
1. `cd deployMapEnv/setupNewMap`
2. `sudo bash setupNewMap.sh`
