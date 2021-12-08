-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema youtube
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `youtube` ;

-- -----------------------------------------------------
-- Schema youtube
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `youtube` DEFAULT CHARACTER SET utf8 ;
USE `youtube` ;

-- -----------------------------------------------------
-- Table `youtube`.`usuaris`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`usuaris` (
  `usuari_id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `username` VARCHAR(45) NOT NULL,
  `data_naixament` DATE NOT NULL,
  `sexe` ENUM('Masculí', 'Femení') NOT NULL,
  `pais` VARCHAR(45) NOT NULL,
  `codi_postal` VARCHAR(45) NULL,
  PRIMARY KEY (`usuari_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`videos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`videos` (
  `video_id` INT NOT NULL AUTO_INCREMENT,
  `publicat_per_usuari_id` INT NOT NULL,
  `titol` VARCHAR(45) NOT NULL,
  `descripcio` VARCHAR(50) NOT NULL,
  `grandaria` VARCHAR(45) NOT NULL,
  `nom_arxiu` VARCHAR(45) NOT NULL,
  `duracio_milisegons` INT UNSIGNED NOT NULL,
  `thumbnail` BLOB NOT NULL,
  `data_hora_publicacio` DATETIME NOT NULL,
  `visibilitat` ENUM('públic', 'ocult', 'privat') NOT NULL,
  `nombre_reproduccions` INT UNSIGNED NULL,
  `likes` INT UNSIGNED NULL,
  `dislikes` INT UNSIGNED NULL,
  PRIMARY KEY (`video_id`),
  INDEX `fk_videos_usuaris1_idx` (`publicat_per_usuari_id` ASC) VISIBLE,
  CONSTRAINT `fk_videos_usuaris1`
    FOREIGN KEY (`publicat_per_usuari_id`)
    REFERENCES `youtube`.`usuaris` (`usuari_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`canal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`canal` (
  `canal_id` INT NOT NULL AUTO_INCREMENT,
  `usuari_id` INT NOT NULL,
  `nom` VARCHAR(45) NOT NULL,
  `descripcio` VARCHAR(500) NOT NULL,
  `data_creacio` DATETIME NOT NULL,
  PRIMARY KEY (`canal_id`),
  INDEX `fk_canal_usuaris1_idx` (`usuari_id` ASC) VISIBLE,
  UNIQUE INDEX `usuari_id_UNIQUE` (`usuari_id` ASC) VISIBLE,
  CONSTRAINT `fk_canal_usuaris1`
    FOREIGN KEY (`usuari_id`)
    REFERENCES `youtube`.`usuaris` (`usuari_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`etiquetes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`etiquetes` (
  `etiqueta_id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`etiqueta_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`comentaris`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`comentaris` (
  `comentari_id` INT NOT NULL AUTO_INCREMENT,
  `video_id` INT NOT NULL,
  `usuari_id` INT NOT NULL,
  `text_comentari` VARCHAR(500) NOT NULL,
  `data_hora` DATETIME NOT NULL,
  PRIMARY KEY (`comentari_id`),
  INDEX `fk_comentaris_usuaris1_idx` (`usuari_id` ASC) VISIBLE,
  INDEX `fk_comentaris_videos1_idx` (`video_id` ASC) VISIBLE,
  CONSTRAINT `fk_comentaris_usuaris1`
    FOREIGN KEY (`usuari_id`)
    REFERENCES `youtube`.`usuaris` (`usuari_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_comentaris_videos1`
    FOREIGN KEY (`video_id`)
    REFERENCES `youtube`.`videos` (`video_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`suscripcions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`suscripcions` (
  `usuari_id` INT NOT NULL,
  `canal_id` INT NOT NULL,
  INDEX `fk_suscripcions_usuaris1_idx` (`usuari_id` ASC) VISIBLE,
  INDEX `fk_suscripcions_canal1_idx` (`canal_id` ASC) VISIBLE,
  PRIMARY KEY (`usuari_id`, `canal_id`),
  CONSTRAINT `fk_suscripcions_usuaris1`
    FOREIGN KEY (`usuari_id`)
    REFERENCES `youtube`.`usuaris` (`usuari_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_suscripcions_canal1`
    FOREIGN KEY (`canal_id`)
    REFERENCES `youtube`.`canal` (`canal_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`playlists`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`playlists` (
  `playlist_id` INT NOT NULL AUTO_INCREMENT,
  `usuari_id` INT NOT NULL,
  `nom` VARCHAR(45) NOT NULL,
  `data_creacio` DATETIME NOT NULL,
  `estat` ENUM('pública', 'privada') NOT NULL,
  INDEX `fk_playlists_usuaris1_idx` (`usuari_id` ASC) VISIBLE,
  PRIMARY KEY (`playlist_id`),
  CONSTRAINT `fk_playlists_usuaris1`
    FOREIGN KEY (`usuari_id`)
    REFERENCES `youtube`.`usuaris` (`usuari_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`comentaris_likes_dislikes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`comentaris_likes_dislikes` (
  `comentari_id` INT NOT NULL,
  `usuari_id` INT NOT NULL,
  `like_o_dislike` ENUM('like', 'dislike') NOT NULL,
  `data_hora` DATETIME NOT NULL,
  PRIMARY KEY (`comentari_id`, `usuari_id`),
  INDEX `fk_comentaris_likes_dislikes_usuaris1_idx` (`usuari_id` ASC) VISIBLE,
  INDEX `fk_comentaris_likes_dislikes_comentaris1_idx` (`comentari_id` ASC) VISIBLE,
  CONSTRAINT `fk_comentaris_likes_dislikes_usuaris1`
    FOREIGN KEY (`usuari_id`)
    REFERENCES `youtube`.`usuaris` (`usuari_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_comentaris_likes_dislikes_comentaris1`
    FOREIGN KEY (`comentari_id`)
    REFERENCES `youtube`.`comentaris` (`comentari_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`videos_likes_dislikes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`videos_likes_dislikes` (
  `video_id` INT NOT NULL,
  `usuari_id` INT NOT NULL,
  `like_o_dislike` ENUM('like', 'dislike') NOT NULL,
  `data_hora` DATETIME NOT NULL,
  PRIMARY KEY (`video_id`, `usuari_id`),
  INDEX `fk_videos_likes_dislikes_videos1_idx` (`video_id` ASC) VISIBLE,
  INDEX `fk_videos_likes_dislikes_usuaris1_idx` (`usuari_id` ASC) VISIBLE,
  CONSTRAINT `fk_videos_likes_dislikes_videos1`
    FOREIGN KEY (`video_id`)
    REFERENCES `youtube`.`videos` (`video_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_videos_likes_dislikes_usuaris1`
    FOREIGN KEY (`usuari_id`)
    REFERENCES `youtube`.`usuaris` (`usuari_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`videos_in_playlist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`videos_in_playlist` (
  `playlist_id` INT NOT NULL,
  `video_id` INT NOT NULL,
  INDEX `fk_videos_in_playlist_playlists1_idx` (`playlist_id` ASC) VISIBLE,
  INDEX `fk_videos_in_playlist_videos1_idx` (`video_id` ASC) VISIBLE,
  CONSTRAINT `fk_videos_in_playlist_playlists1`
    FOREIGN KEY (`playlist_id`)
    REFERENCES `youtube`.`playlists` (`playlist_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_videos_in_playlist_videos1`
    FOREIGN KEY (`video_id`)
    REFERENCES `youtube`.`videos` (`video_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`videos_amb_etiquetes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`videos_amb_etiquetes` (
  `video_id` INT NOT NULL,
  `etiqueta_id` INT NOT NULL,
  INDEX `fk_videos_has_etiquetes_etiquetes1_idx` (`etiqueta_id` ASC) VISIBLE,
  INDEX `fk_videos_has_etiquetes_videos1_idx` (`video_id` ASC) VISIBLE,
  CONSTRAINT `fk_videos_has_etiquetes_videos1`
    FOREIGN KEY (`video_id`)
    REFERENCES `youtube`.`videos` (`video_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_videos_has_etiquetes_etiquetes1`
    FOREIGN KEY (`etiqueta_id`)
    REFERENCES `youtube`.`etiquetes` (`etiqueta_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
