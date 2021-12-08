-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema spotify
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `spotify` ;

-- -----------------------------------------------------
-- Schema spotify
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `spotify` DEFAULT CHARACTER SET utf8 ;
USE `spotify` ;

-- -----------------------------------------------------
-- Table `spotify`.`usuaris`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`usuaris` (
  `usuari_id` INT NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `username` VARCHAR(45) NOT NULL,
  `data_naixament` DATE NOT NULL,
  `sexe` ENUM('Masculí', 'Femení') NOT NULL,
  `pais` VARCHAR(45) NOT NULL,
  `codi_postal` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`usuari_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`targetes_credit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`targetes_credit` (
  `cc_id` INT NOT NULL,
  `numero_targeta` VARCHAR(45) NOT NULL,
  `caducitat` DATE NOT NULL,
  `cvc` VARCHAR(4) NOT NULL,
  PRIMARY KEY (`cc_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`paypal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`paypal` (
  `paypal_id` INT NOT NULL,
  `nom_usuari` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`paypal_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`pagaments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`pagaments` (
  `order_id` INT NOT NULL AUTO_INCREMENT,
  `data_pagament` DATETIME NOT NULL,
  `total` DECIMAL(5,2) UNSIGNED NOT NULL,
  `cc_id` INT NULL,
  `paypal_id` INT NULL,
  PRIMARY KEY (`order_id`),
  INDEX `fk_pagaments_targetes_credit1_idx` (`cc_id` ASC) VISIBLE,
  INDEX `fk_pagaments_paypal1_idx` (`paypal_id` ASC) VISIBLE,
  CONSTRAINT `fk_pagaments_targetes_credit1`
    FOREIGN KEY (`cc_id`)
    REFERENCES `spotify`.`targetes_credit` (`cc_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_pagaments_paypal1`
    FOREIGN KEY (`paypal_id`)
    REFERENCES `spotify`.`paypal` (`paypal_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`usuaris_premium`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`usuaris_premium` (
  `usuari_id` INT NOT NULL,
  `estat` ENUM('actiu', 'expirat') NOT NULL,
  PRIMARY KEY (`usuari_id`),
  INDEX `fk_usuaris_premium_usuaris_idx` (`usuari_id` ASC) VISIBLE,
  CONSTRAINT `fk_usuaris_premium_usuaris`
    FOREIGN KEY (`usuari_id`)
    REFERENCES `spotify`.`usuaris` (`usuari_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`suscripcions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`suscripcions` (
  `usuari_id` INT NOT NULL,
  `order_id` INT NOT NULL,
  `data_inici` DATE NOT NULL,
  `data_renovacio` DATE NOT NULL,
  `forma_pagament` ENUM('Targeta de crèdit', 'PayPal') NOT NULL,
  INDEX `fk_suscripcions_pagaments1_idx` (`order_id` ASC) VISIBLE,
  INDEX `fk_suscripcions_usuaris_premium1_idx` (`usuari_id` ASC) VISIBLE,
  CONSTRAINT `fk_suscripcions_pagaments1`
    FOREIGN KEY (`order_id`)
    REFERENCES `spotify`.`pagaments` (`order_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_suscripcions_usuaris_premium1`
    FOREIGN KEY (`usuari_id`)
    REFERENCES `spotify`.`usuaris_premium` (`usuari_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`artista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`artista` (
  `artista_id` INT NOT NULL,
  `nom` VARCHAR(45) NOT NULL,
  `imatge_artista` BLOB NOT NULL,
  PRIMARY KEY (`artista_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`usuari_seguin_artista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`usuari_seguin_artista` (
  `usuari_id` INT NOT NULL,
  `artista_id` INT NOT NULL,
  INDEX `fk_usuari_seguin_artista_usuaris1_idx` (`usuari_id` ASC) VISIBLE,
  INDEX `fk_usuari_seguin_artista_artista1_idx` (`artista_id` ASC) VISIBLE,
  PRIMARY KEY (`usuari_id`, `artista_id`),
  CONSTRAINT `fk_usuari_seguin_artista_usuaris1`
    FOREIGN KEY (`usuari_id`)
    REFERENCES `spotify`.`usuaris` (`usuari_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_usuari_seguin_artista_artista1`
    FOREIGN KEY (`artista_id`)
    REFERENCES `spotify`.`artista` (`artista_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`artistes_relacionats`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`artistes_relacionats` (
  `artista_id` INT NOT NULL,
  `relacionat_amb_artista_id` INT NOT NULL,
  INDEX `fk_artistes_relacionats_artista1_idx` (`artista_id` ASC) VISIBLE,
  INDEX `fk_artistes_relacionats_artista2_idx` (`relacionat_amb_artista_id` ASC) VISIBLE,
  PRIMARY KEY (`artista_id`, `relacionat_amb_artista_id`),
  CONSTRAINT `fk_artistes_relacionats_artista1`
    FOREIGN KEY (`artista_id`)
    REFERENCES `spotify`.`artista` (`artista_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_artistes_relacionats_artista2`
    FOREIGN KEY (`relacionat_amb_artista_id`)
    REFERENCES `spotify`.`artista` (`artista_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`album`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`album` (
  `album_id` INT NOT NULL,
  `artista_id` INT NOT NULL,
  `titol` VARCHAR(45) NOT NULL,
  `any_publicacio` DATE NOT NULL,
  `imatge_portada` BLOB NOT NULL,
  PRIMARY KEY (`album_id`),
  INDEX `fk_album_artista1_idx` (`artista_id` ASC) VISIBLE,
  CONSTRAINT `fk_album_artista1`
    FOREIGN KEY (`artista_id`)
    REFERENCES `spotify`.`artista` (`artista_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`cancons`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`cancons` (
  `canco_id` INT NOT NULL AUTO_INCREMENT,
  `album_id` INT NOT NULL,
  `titol` VARCHAR(45) NOT NULL,
  `duracio_en_milisegons` INT UNSIGNED NOT NULL,
  `vegades_reproduida` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`canco_id`),
  INDEX `fk_cancons_album1_idx` (`album_id` ASC) VISIBLE,
  CONSTRAINT `fk_cancons_album1`
    FOREIGN KEY (`album_id`)
    REFERENCES `spotify`.`album` (`album_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`playlists_actives`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`playlists_actives` (
  `playlist_id` INT NOT NULL AUTO_INCREMENT,
  `usuari_id` INT NOT NULL,
  `titol` VARCHAR(45) NOT NULL,
  `nombre_de_cancons` SMALLINT UNSIGNED NOT NULL,
  `data_creacio` DATETIME NOT NULL,
  PRIMARY KEY (`playlist_id`),
  INDEX `fk_playlists_actives_usuaris1_idx` (`usuari_id` ASC) VISIBLE,
  CONSTRAINT `fk_playlists_actives_usuaris1`
    FOREIGN KEY (`usuari_id`)
    REFERENCES `spotify`.`usuaris` (`usuari_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`playlist_compartides`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`playlist_compartides` (
  `playlist_id` INT NOT NULL,
  `added_by_usuari_id` INT NOT NULL,
  `added_canco_id` INT NOT NULL,
  `added_date` DATETIME NOT NULL,
  INDEX `fk_playlist_compartides_usuaris1_idx` (`added_by_usuari_id` ASC) VISIBLE,
  INDEX `fk_playlist_compartides_cancons1_idx` (`added_canco_id` ASC) VISIBLE,
  INDEX `fk_playlist_compartides_playlists_actives1_idx` (`playlist_id` ASC) VISIBLE,
  CONSTRAINT `fk_playlist_compartides_usuaris1`
    FOREIGN KEY (`added_by_usuari_id`)
    REFERENCES `spotify`.`usuaris` (`usuari_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_playlist_compartides_cancons1`
    FOREIGN KEY (`added_canco_id`)
    REFERENCES `spotify`.`cancons` (`canco_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_playlist_compartides_playlists_actives1`
    FOREIGN KEY (`playlist_id`)
    REFERENCES `spotify`.`playlists_actives` (`playlist_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`albums_favorits`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`albums_favorits` (
  `usuari_id` INT NOT NULL,
  `album_id` INT NOT NULL,
  INDEX `fk_albums_favorits_usuaris1_idx` (`usuari_id` ASC) VISIBLE,
  INDEX `fk_albums_favorits_album1_idx` (`album_id` ASC) VISIBLE,
  PRIMARY KEY (`usuari_id`, `album_id`),
  CONSTRAINT `fk_albums_favorits_usuaris1`
    FOREIGN KEY (`usuari_id`)
    REFERENCES `spotify`.`usuaris` (`usuari_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_albums_favorits_album1`
    FOREIGN KEY (`album_id`)
    REFERENCES `spotify`.`album` (`album_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`cancons_favorites`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`cancons_favorites` (
  `usuari_id` INT NOT NULL,
  `canco_id` INT NOT NULL,
  INDEX `fk_cancons_favorites_usuaris1_idx` (`usuari_id` ASC) VISIBLE,
  INDEX `fk_cancons_favorites_cancons1_idx` (`canco_id` ASC) VISIBLE,
  PRIMARY KEY (`usuari_id`, `canco_id`),
  CONSTRAINT `fk_cancons_favorites_usuaris1`
    FOREIGN KEY (`usuari_id`)
    REFERENCES `spotify`.`usuaris` (`usuari_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_cancons_favorites_cancons1`
    FOREIGN KEY (`canco_id`)
    REFERENCES `spotify`.`cancons` (`canco_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`playlists_esborrades`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`playlists_esborrades` (
  `playlist_id` INT NOT NULL,
  `usuari_id` INT NOT NULL,
  `titol` VARCHAR(45) NOT NULL,
  `nombre_de_cancons` SMALLINT UNSIGNED NOT NULL,
  `data_creacio` DATETIME NOT NULL,
  PRIMARY KEY (`playlist_id`),
  INDEX `fk_playlists_esborrades_usuaris1_idx` (`usuari_id` ASC) VISIBLE,
  CONSTRAINT `fk_playlists_esborrades_usuaris1`
    FOREIGN KEY (`usuari_id`)
    REFERENCES `spotify`.`usuaris` (`usuari_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`playlist_items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`playlist_items` (
  `playlist_id` INT NOT NULL,
  `canco_id` INT NOT NULL,
  INDEX `fk_playlist_items_cancons1_idx` (`canco_id` ASC) VISIBLE,
  PRIMARY KEY (`playlist_id`, `canco_id`),
  CONSTRAINT `fk_playlist_items_playlists_actives1`
    FOREIGN KEY (`playlist_id`)
    REFERENCES `spotify`.`playlists_actives` (`playlist_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_playlist_items_cancons1`
    FOREIGN KEY (`canco_id`)
    REFERENCES `spotify`.`cancons` (`canco_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
