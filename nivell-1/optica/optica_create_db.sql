-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema optica
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `optica` ;

-- -----------------------------------------------------
-- Schema optica
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `optica` ;
USE `optica` ;

-- -----------------------------------------------------
-- Table `optica`.`clients_adreca`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`clients_adreca` (
  `client_id` INT NOT NULL AUTO_INCREMENT,
  `carrer` VARCHAR(45) NOT NULL,
  `numero` VARCHAR(45) NOT NULL,
  `pis` VARCHAR(45) NOT NULL,
  `porta` VARCHAR(45) NOT NULL,
  `ciutat` VARCHAR(45) NOT NULL,
  `codi_postal` VARCHAR(45) NOT NULL,
  `pais` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`client_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`clients`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`clients` (
  `client_id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(60) NOT NULL,
  `primer_cognom` VARCHAR(45) NOT NULL,
  `segon_cognom` VARCHAR(45) NOT NULL,
  `adreca_id` INT NOT NULL,
  `telefon` VARCHAR(15) NOT NULL,
  `correu` VARCHAR(45) NOT NULL,
  `data_registre` DATETIME NOT NULL,
  `recomenat_per_client_id` INT NULL,
  PRIMARY KEY (`client_id`),
  INDEX `fk_clients_clients1_idx` (`recomenat_per_client_id` ASC) VISIBLE,
  INDEX `fk_clients_clients_adreca1_idx` (`adreca_id` ASC) VISIBLE,
  CONSTRAINT `fk_clients_clients1`
    FOREIGN KEY (`recomenat_per_client_id`)
    REFERENCES `optica`.`clients` (`client_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_clients_clients_adreca1`
    FOREIGN KEY (`adreca_id`)
    REFERENCES `optica`.`clients_adreca` (`client_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`proveidors_adreca`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`proveidors_adreca` (
  `proveidor_id` INT NOT NULL AUTO_INCREMENT,
  `carrer` VARCHAR(45) NOT NULL,
  `numero` VARCHAR(4) NOT NULL,
  `pis` VARCHAR(15) NOT NULL,
  `porta` VARCHAR(4) NOT NULL,
  `ciutat` VARCHAR(12) NOT NULL,
  `codi_postal` VARCHAR(8) NOT NULL,
  `pais` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`proveidor_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`proveidors`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`proveidors` (
  `proveidor_id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `telefon` VARCHAR(15) NOT NULL,
  `fax` VARCHAR(15) NOT NULL,
  `nif` VARCHAR(11) NOT NULL,
  `adreca_id` INT NOT NULL,
  PRIMARY KEY (`proveidor_id`),
  INDEX `fk_proveidors_proveidors_adreca_idx` (`adreca_id` ASC) VISIBLE,
  CONSTRAINT `fk_proveidors_proveidors_adreca`
    FOREIGN KEY (`adreca_id`)
    REFERENCES `optica`.`proveidors_adreca` (`proveidor_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`ulleres_marca`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`ulleres_marca` (
  `marca_id` INT NOT NULL AUTO_INCREMENT,
  `comprat_a_proveidor_id` INT NOT NULL,
  `marca_nom` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`marca_id`),
  INDEX `fk_ulleres_marca_proveidors2_idx` (`comprat_a_proveidor_id` ASC) VISIBLE,
  CONSTRAINT `fk_ulleres_marca_proveidors2`
    FOREIGN KEY (`comprat_a_proveidor_id`)
    REFERENCES `optica`.`proveidors` (`proveidor_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`ulleres`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`ulleres` (
  `ullera_id` INT NOT NULL AUTO_INCREMENT,
  `marca_id` INT NOT NULL,
  `graduacio_esquerra` DECIMAL(2,2) UNSIGNED NOT NULL,
  `graduacio_dreta` DECIMAL(2,2) UNSIGNED NOT NULL,
  `tipus_muntura` ENUM('flotant', 'pasta', 'metàl·lica') NOT NULL,
  `color_muntura` VARCHAR(45) NOT NULL,
  `color_vidre_esquerra` VARCHAR(45) NOT NULL,
  `color_vidre_dreta` VARCHAR(45) NOT NULL,
  `preu` DECIMAL(5,2) UNSIGNED NOT NULL,
  `venut_per` VARCHAR(45) NOT NULL,
  `venut_data` DATETIME NOT NULL,
  `venut_a_client_id` INT NOT NULL,
  PRIMARY KEY (`ullera_id`),
  INDEX `fk_ulleres_ulleres_marca1_idx` (`marca_id` ASC) VISIBLE,
  INDEX `fk_ulleres_clients1_idx` (`venut_a_client_id` ASC) VISIBLE,
  CONSTRAINT `fk_ulleres_ulleres_marca1`
    FOREIGN KEY (`marca_id`)
    REFERENCES `optica`.`ulleres_marca` (`marca_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_ulleres_clients1`
    FOREIGN KEY (`venut_a_client_id`)
    REFERENCES `optica`.`clients` (`client_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
