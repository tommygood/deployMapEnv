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
   - 需先輸入所需資訊
   - ![image](https://github.com/tommygood/deployMapEnv/assets/96759292/6510fdff-5b36-4d37-bcd8-db19e7b0da84)
     - 機構名稱
     - 機構英文縮寫
     - 機構英文地區
     - 地圖網頁要開在的 port
     - 地圖網頁初始的緯度
     - 地圖網頁初始的經度
     - mosquitto server 的 ip
     - mosquitto server 的 port
     - github password which can clone the repo of FoodDelivery
3. 建立完成後去存取剛剛輸入的 port 號
