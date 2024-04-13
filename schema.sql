# create DB
CREATE DATABASE IF NOT EXISTS db_name;
USE db_name;

# create privileged user of db
CREATE USER IF NOT EXISTS 'db_user'@'%' identified by 'db_password';
grant all privileges on *.* to 'db_user'@'%';
flush privileges;

# 案主
create table client (
    `s_num` int(10) UNSIGNED NOT NULL ,
    `ct_name` varchar(20) NOT NULL ,
    `ct_lastname` varchar(20) NOT NULL ,
    `ct_gender` varchar(20) NOT NULL ,
    `ct_address` varbinary(300) DEFAULT NULL ,
    `ct_lon` double DEFAULT NULL ,
    `ct_lat` double DEFAULT NULL ,
    `status` int(1) DEFAULT '1'
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

# 案主路徑
create table client_route(
    `s_num` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `ct_s_num` int(10) UNSIGNED NOT NULL,
    `ct_order` int(5) NOT NULL ,
    `reh_s_num` int(10) UNSIGNED NOT NULL,
    PRIMARY KEY (`s_num`) USING BTREE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

# 每天的送餐總表
CREATE TABLE `daily_shipment` (
    `s_num` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `dp_s_num` int(10) NOT NULL ,
  `ct_s_num` int(10) UNSIGNED NOT NULL ,
  `sec_s_num` int(10) UNSIGNED NOT NULL ,
  `reh_s_num` int(4) NOT NULL ,
  `ct_name` varchar(20) NOT NULL ,
  `dys01` date NOT NULL ,
  `dys02` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL ,
  `dys03` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL ,
  `dys04` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL ,
  `dys05` char(1) COLLATE utf8mb4_unicode_ci NOT NULL ,
  `dys05_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL ,
  `dys06` int(4) NOT NULL ,
  `reh_name` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL ,
  `ct_order` int(1) NOT NULL ,
  `dys09` int(1) NOT NULL ,
  `dys10` char(1) COLLATE utf8mb4_unicode_ci NOT NULL ,
  `dys11` int(1) NOT NULL DEFAULT '2' ,
  `dys12` datetime DEFAULT NULL ,
  `dys13` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL ,
  PRIMARY KEY (`s_num`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ;

# 送餐員
create table delivery_person (
    `s_num` int(10) UNSIGNED NOT NULL ,
    `dp_nickname` varchar(20) DEFAULT NULL ,
    `dp_img` varchar(300) DEFAULT NULL ,
    `dp_reason` varchar(300) DEFAULT NULL ,
    `dp01` varchar(20) NOT NULL ,
    `dp02` varchar(20) NOT NULL ,
    `dp_experience` varchar(300) DEFAULT NULL,
    `status` int(1) DEFAULT '0'
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ;

# 紀錄距離table
CREATE TABLE `distance` (
    `dp_s_num` int(10) NOT NULL ,
    `reh_s_num` int(4) NOT NULL ,
    `lon` double DEFAULT NULL ,
    `lat` double DEFAULT NULL ,
    `km` double DEFAULT NULL ,
    `insert_time` date NOT NULL,
  PRIMARY KEY (`reh_s_num`, `insert_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ;

# 紀錄gps
create table gps (
    `s_num` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `reh_s_num` int(10) UNSIGNED NOT NULL COMMENT '路徑編號',
    `gps_time` datetime NOT NULL COMMENT '紀錄時間',
    `gps_lon` double DEFAULT NULL COMMENT 'gps經度',
    `gps_lat` double DEFAULT NULL COMMENT 'gps緯度',
    `dp_s_num` int(10) UNSIGNED NOT NULL COMMENT '外送員編號',
    PRIMARY KEY (`s_num`) USING BTREE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

# 紀錄gps
create table gps_list (
    `reh_s_num` int(10) UNSIGNED NOT NULL COMMENT '路徑編號',
    `gpsstring` longtext,
    `date` date NOT NULL,
    PRIMARY KEY (`reh_s_num`, `date`) 
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

# 送餐打卡
create table punch (
    `s_num` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `dp_s_num` int(10) UNSIGNED NOT NULL ,
    `reh_s_num` int(10) NOT NULL DEFAULT '0' ,
    `ph_time` datetime NOT NULL ,
    `ph_inorout` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL ,
    `ph_lon` double DEFAULT NULL ,
    `ph_lat` double DEFAULT NULL ,
    `ph_wifi` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL ,
    `ct_s_num` int(10) UNSIGNED NOT NULL ,
    PRIMARY KEY (`s_num`) USING BTREE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

# 路徑資料
create table route (
    `s_num` int(10) UNSIGNED NOT NULL COMMENT '序號',
    `reh_name` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '路線名稱',
    `reh_category` int(1) DEFAULT NULL COMMENT '路線類別(1=山線，2=海線，3=屯線)',
    `reh_time` int(1) DEFAULT NULL COMMENT '路線適用時段(1=午餐/午晚餐，2=晚餐)',
    `status` int(1) DEFAULT '0'
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

# app 沒有 gps 資料
create table error_gps (
    `s_num` INT PRIMARY KEY AUTO_INCREMENT,
    `error_num` int(10) UNSIGNED NOT NULL COMMENT '錯誤種類編號',
    `dp_s_num` int(10) UNSIGNED NOT NULL COMMENT '外送員編號',
    `reh_s_num` int(10) UNSIGNED NOT NULL COMMENT '路徑編號',
    `time` datetime NOT NULL COMMENT '紀錄時間'
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

# 警告資訊
create table warning_info (
    `s_num` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `reh_s_num` int(10) UNSIGNED NOT NULL COMMENT '路徑編號',
    `gps_time` datetime NOT NULL COMMENT '紀錄時間',
    `gps_lon` double DEFAULT NULL COMMENT 'gps經度',
    `gps_lat` double DEFAULT NULL COMMENT 'gps緯度',
    `dp_s_num` int(10) UNSIGNED NOT NULL COMMENT '外送員編號',
    `warning_s_num` int(2) UNSIGNED NOT NULL COMMENT '警告編號',
    `dp_name` varchar(20) NOT NULL COMMENT '外送員名稱' ,
    PRIMARY KEY (`s_num`) USING BTREE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

# carbon data
create table carbon_emission (
    `s_num` INT PRIMARY KEY AUTO_INCREMENT,
    `reh_s_num` int(10) UNSIGNED NOT NULL COMMENT '路徑編號',
    `time` date NOT NULL COMMENT '紀錄時間',
    `carbon` int(10) UNSIGNED NOT NULL COMMENT '碳排放'
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

# 60 天的送餐總表
CREATE TABLE `daily_shipment_second` (
    `s_num` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `dp_s_num` int(10) NOT NULL ,
  `ct_s_num` int(10) UNSIGNED NOT NULL ,
  `sec_s_num` int(10) UNSIGNED NOT NULL ,
  `reh_s_num` int(4) NOT NULL ,
  `ct_name` varchar(20) NOT NULL ,
  `dys01` date NOT NULL ,
  `dys02` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL ,
  `dys03` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL ,
  `dys04` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL ,
  `dys05` char(1) COLLATE utf8mb4_unicode_ci NOT NULL ,
  `dys05_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL ,
  `dys06` int(4) NOT NULL ,
  `reh_name` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL ,
  `ct_order` int(1) NOT NULL ,
  `dys09` int(1) NOT NULL ,
  `dys10` char(1) COLLATE utf8mb4_unicode_ci NOT NULL ,
  `dys11` int(1) NOT NULL DEFAULT '2' ,
  `dys12` datetime DEFAULT NULL ,
  `dys13` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL ,
  PRIMARY KEY (`s_num`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ;

# 剩餘天數的送餐總表
CREATE TABLE `daily_shipment_third` (
    `s_num` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `dp_s_num` int(10) NOT NULL ,
  `ct_s_num` int(10) UNSIGNED NOT NULL ,
  `sec_s_num` int(10) UNSIGNED NOT NULL ,
  `reh_s_num` int(4) NOT NULL ,
  `ct_name` varchar(20) NOT NULL ,
  `dys01` date NOT NULL ,
  `dys02` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL ,
  `dys03` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL ,
  `dys04` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL ,
  `dys05` char(1) COLLATE utf8mb4_unicode_ci NOT NULL ,
  `dys05_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL ,
  `dys06` int(4) NOT NULL ,
  `reh_name` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL ,
  `ct_order` int(1) NOT NULL ,
  `dys09` int(1) NOT NULL ,
  `dys10` char(1) COLLATE utf8mb4_unicode_ci NOT NULL ,
  `dys11` int(1) NOT NULL DEFAULT '2' ,
  `dys12` datetime DEFAULT NULL ,
  `dys13` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL ,
  PRIMARY KEY (`s_num`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ;

# 剩餘天數的 gps
create table gps_second (
    `s_num` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `reh_s_num` int(10) UNSIGNED NOT NULL COMMENT '路徑編號',
    `gps_time` datetime NOT NULL COMMENT '紀錄時間',
    `gps_lon` double DEFAULT NULL COMMENT 'gps經度',
    `gps_lat` double DEFAULT NULL COMMENT 'gps緯度',
    `dp_s_num` int(10) UNSIGNED NOT NULL COMMENT '外送員編號',
    PRIMARY KEY (`s_num`) USING BTREE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

# 15 天的gps
create table gps_list_second (
    `reh_s_num` int(10) UNSIGNED NOT NULL COMMENT '路徑編號',
    `gpsstring` longtext,
    `date` date NOT NULL,
    PRIMARY KEY (`reh_s_num`, `date`) 
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

# 30 天的gps
create table gps_list_third (
    `reh_s_num` int(10) UNSIGNED NOT NULL COMMENT '路徑編號',
    `gpsstring` longtext,
    `date` date NOT NULL,
    PRIMARY KEY (`reh_s_num`, `date`) 
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

# 剩餘天數的gps
create table gps_list_fourth (
    `reh_s_num` int(10) UNSIGNED NOT NULL COMMENT '路徑編號',
    `gpsstring` longtext,
    `date` date NOT NULL,
    PRIMARY KEY (`reh_s_num`, `date`) 
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

# 60 天的送餐打卡
create table punch_second (
    `s_num` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `dp_s_num` int(10) UNSIGNED NOT NULL ,
    `reh_s_num` int(10) NOT NULL DEFAULT '0' ,
    `ph_time` datetime NOT NULL ,
    `ph_inorout` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL ,
    `ph_lon` double DEFAULT NULL ,
    `ph_lat` double DEFAULT NULL ,
    `ph_wifi` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL ,
    `ct_s_num` int(10) UNSIGNED NOT NULL ,
    PRIMARY KEY (`s_num`) USING BTREE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

# 剩餘天數的送餐打卡
create table punch_third (
    `s_num` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `dp_s_num` int(10) UNSIGNED NOT NULL ,
    `reh_s_num` int(10) NOT NULL DEFAULT '0' ,
    `ph_time` datetime NOT NULL ,
    `ph_inorout` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL ,
    `ph_lon` double DEFAULT NULL ,
    `ph_lat` double DEFAULT NULL ,
    `ph_wifi` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL ,
    `ct_s_num` int(10) UNSIGNED NOT NULL ,
    PRIMARY KEY (`s_num`) USING BTREE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
