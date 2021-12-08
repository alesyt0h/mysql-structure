-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema pizzeria
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `pizzeria` ;

-- -----------------------------------------------------
-- Schema pizzeria
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `pizzeria` DEFAULT CHARACTER SET utf8 ;
USE `pizzeria` ;

-- -----------------------------------------------------
-- Table `pizzeria`.`provincia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`provincia` (
  `provincia_id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`provincia_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`localitat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`localitat` (
  `localitat_id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `provincia_id` INT NOT NULL,
  PRIMARY KEY (`localitat_id`),
  INDEX `fk_localitat_provincia_idx` (`provincia_id` ASC) VISIBLE,
  CONSTRAINT `fk_localitat_provincia`
    FOREIGN KEY (`provincia_id`)
    REFERENCES `pizzeria`.`provincia` (`provincia_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`clients`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`clients` (
  `client_id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `cognom1` VARCHAR(45) NOT NULL,
  `cognom2` VARCHAR(45) NOT NULL,
  `adreca` VARCHAR(45) NOT NULL,
  `codi_postal` VARCHAR(45) NOT NULL,
  `localitat_id` INT NOT NULL,
  `provincia_id` INT NOT NULL,
  `telefon` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`client_id`),
  INDEX `fk_clients_provincia1_idx` (`provincia_id` ASC) VISIBLE,
  INDEX `fk_clients_localitat1_idx` (`localitat_id` ASC) VISIBLE,
  CONSTRAINT `fk_clients_provincia1`
    FOREIGN KEY (`provincia_id`)
    REFERENCES `pizzeria`.`provincia` (`provincia_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_clients_localitat1`
    FOREIGN KEY (`localitat_id`)
    REFERENCES `pizzeria`.`localitat` (`localitat_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`botiga`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`botiga` (
  `botiga_id` INT NOT NULL AUTO_INCREMENT,
  `adreca` VARCHAR(105) NOT NULL,
  `codi_postal` VARCHAR(45) NOT NULL,
  `localitat_id` INT NOT NULL,
  `provincia_id` INT NOT NULL,
  PRIMARY KEY (`botiga_id`),
  INDEX `fk_botiga_localitat1_idx` (`localitat_id` ASC) VISIBLE,
  INDEX `fk_botiga_provincia1_idx` (`provincia_id` ASC) VISIBLE,
  CONSTRAINT `fk_botiga_localitat1`
    FOREIGN KEY (`localitat_id`)
    REFERENCES `pizzeria`.`localitat` (`localitat_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_botiga_provincia1`
    FOREIGN KEY (`provincia_id`)
    REFERENCES `pizzeria`.`provincia` (`provincia_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`empleats`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`empleats` (
  `empleat_id` INT NOT NULL AUTO_INCREMENT,
  `treballa_botiga_id` INT NOT NULL,
  `nom` VARCHAR(45) NOT NULL,
  `cognom1` VARCHAR(45) NOT NULL,
  `cognom2` VARCHAR(45) NOT NULL,
  `nif` VARCHAR(45) NOT NULL,
  `telefon` VARCHAR(45) NOT NULL,
  `carrec` ENUM('cuiner', 'repartidor') NOT NULL,
  PRIMARY KEY (`empleat_id`),
  INDEX `fk_empleats_botiga1_idx` (`treballa_botiga_id` ASC) VISIBLE,
  CONSTRAINT `fk_empleats_botiga1`
    FOREIGN KEY (`treballa_botiga_id`)
    REFERENCES `pizzeria`.`botiga` (`botiga_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`comandes_domicili`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`comandes_domicili` (
  `comanda_domicili_id` INT NOT NULL AUTO_INCREMENT,
  `repartidor_empleat_id` INT NOT NULL,
  `data_hora_lliurament` DATETIME NOT NULL,
  PRIMARY KEY (`comanda_domicili_id`),
  INDEX `fk_comandes_domicili_empleats1_idx` (`repartidor_empleat_id` ASC) VISIBLE,
  CONSTRAINT `fk_comandes_domicili_empleats1`
    FOREIGN KEY (`repartidor_empleat_id`)
    REFERENCES `pizzeria`.`empleats` (`empleat_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`comandes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`comandes` (
  `comanda_id` INT NOT NULL AUTO_INCREMENT,
  `client_id` INT NOT NULL,
  `data_hora` DATETIME NOT NULL,
  `repartir_o_recollir` ENUM('repartir', 'recollir') NOT NULL,
  `gestiona_botiga_id` INT NOT NULL,
  `preu_total` DECIMAL(5,2) UNSIGNED NOT NULL,
  `comandes_domicili_id` INT NULL,
  PRIMARY KEY (`comanda_id`),
  INDEX `fk_comandes_clients1_idx` (`client_id` ASC) VISIBLE,
  INDEX `fk_comandes_botiga1_idx` (`gestiona_botiga_id` ASC) VISIBLE,
  INDEX `fk_comandes_comandes_domicili1_idx` (`comandes_domicili_id` ASC) VISIBLE,
  CONSTRAINT `fk_comandes_clients1`
    FOREIGN KEY (`client_id`)
    REFERENCES `pizzeria`.`clients` (`client_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_comandes_botiga1`
    FOREIGN KEY (`gestiona_botiga_id`)
    REFERENCES `pizzeria`.`botiga` (`botiga_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_comandes_comandes_domicili1`
    FOREIGN KEY (`comandes_domicili_id`)
    REFERENCES `pizzeria`.`comandes_domicili` (`comanda_domicili_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`categoria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`categoria` (
  `categoria_id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`categoria_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`productes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`productes` (
  `producte_id` INT NOT NULL AUTO_INCREMENT,
  `tipus` ENUM('pizza', 'hamburguesa', 'beguda') NOT NULL,
  `nom` VARCHAR(45) NOT NULL,
  `descripcio` VARCHAR(45) NOT NULL,
  `imatge` BLOB NOT NULL,
  `categoria_id` INT NOT NULL,
  `preu` DECIMAL(5,2) UNSIGNED NOT NULL,
  PRIMARY KEY (`producte_id`),
  INDEX `fk_productes_categoria1_idx` (`categoria_id` ASC) VISIBLE,
  CONSTRAINT `fk_productes_categoria1`
    FOREIGN KEY (`categoria_id`)
    REFERENCES `pizzeria`.`categoria` (`categoria_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`comanda_items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`comanda_items` (
  `comanda_id` INT NOT NULL,
  `producte_id` INT NOT NULL,
  `cuantitat` TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (`comanda_id`, `producte_id`),
  INDEX `fk_comanda_items_comandes1_idx` (`comanda_id` ASC) VISIBLE,
  INDEX `fk_comanda_items_productes1_idx` (`producte_id` ASC) VISIBLE,
  CONSTRAINT `fk_comanda_items_comandes1`
    FOREIGN KEY (`comanda_id`)
    REFERENCES `pizzeria`.`comandes` (`comanda_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_comanda_items_productes1`
    FOREIGN KEY (`producte_id`)
    REFERENCES `pizzeria`.`productes` (`producte_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
