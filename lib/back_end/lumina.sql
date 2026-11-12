DROP DATABASE IF EXISTS `lumina`;
CREATE DATABASE IF NOT EXISTS `lumina`;
USE `lumina`;
DROP TABLE IF EXISTS `tb_user`;
CREATE TABLE IF NOT EXISTS `tb_user` (
    `cd_id` INT NOT NULL AUTO_INCREMENT,
    `nm_user` VARCHAR(140),
    `nm_email` VARCHAR(140) NOT NULL,
    `cd_senha` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`cd_id`)
);
DROP TABLE IF EXISTS `tb_user_tokens`;
CREATE TABLE IF NOT EXISTS `user_tokens` (
    `id_token` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL UNIQUE,
    `fcm_token` TEXT NOT NULL,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`user_id`) REFERENCES `tb_user`(`cd_id`) ON DELETE CASCADE
);
DROP TABLE IF EXISTS `tb_informacoes`;
CREATE TABLE IF NOT EXISTS `tb_informacoes` (
    `cd_informacoes` INT NOT NULL AUTO_INCREMENT,
    `cd_user` INT NOT NULL,
    `ds_regularidade_ciclo` VARCHAR(10) NOT NULL DEFAULT '',
    `ds_duracao_media_ciclo` VARCHAR(50) NOT NULL DEFAULT '',
    `ds_nivel_energia_ciclo` VARCHAR(80) NOT NULL DEFAULT '',
    `ds_humor_antes_mestruacao` VARCHAR(60) NOT NULL DEFAULT '',
    `ds_duracao_media_mestruacao` VARCHAR(50) NOT NULL DEFAULT '',
    PRIMARY KEY (`cd_informacoes`),
    FOREIGN KEY (`cd_user`) REFERENCES `tb_user`(`cd_id`) ON DELETE CASCADE
);
DROP TABLE IF EXISTS `tb_calendario`;
CREATE TABLE IF NOT EXISTS `tb_calendario` (
    `cd_calendario` INT NOT NULL AUTO_INCREMENT,
    `cd_user` INT NOT NULL,
    `dt_dias_mestruacao` DATE NOT NULL,
    PRIMARY KEY (`cd_calendario`),
    FOREIGN KEY (`cd_user`) REFERENCES `tb_user`(`cd_id`) ON DELETE CASCADE
);
DROP TABLE IF EXISTS `tb_autocuidado`;
CREATE TABLE IF NOT EXISTS `tb_autocuidado` (
    `cd_autocuidado` INT NOT NULL AUTO_INCREMENT,
    `cd_user` INT NOT NULL,
    `dt_data` DATE NOT NULL,
    `ds_sintomas` TEXT DEFAULT '',    
    `ds_humores` TEXT DEFAULT '',      
    `ds_fluxo` VARCHAR(20) DEFAULT '', 
    `ds_anotacao` TEXT DEFAULT '',
    PRIMARY KEY (`cd_autocuidado`),
    FOREIGN KEY (`cd_user`) REFERENCES `tb_user`(`cd_id`) ON DELETE CASCADE,
    UNIQUE KEY `unico_autocuidado` (`cd_user`, `dt_data`)
);