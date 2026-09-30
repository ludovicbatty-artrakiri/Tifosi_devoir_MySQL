-- =====================================================================
--  Projet  : Tifosi - Restaurant de street-food italien
--  Script  : 01_creation_schema.sql
--  Rôle    : Création de la base de données, de l'utilisateur et du schéma
--  SGBD    : MySQL 8 (compatible MariaDB 10.x)
--  Exécution (en tant qu'administrateur, ex. root) :
--      mysql -u root -p < 01_creation_schema.sql
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Création de la base de données
-- ---------------------------------------------------------------------
-- Encodage de la connexion : indispensable pour que les accents
-- (é, è, œ...) soient enregistrés et affichés correctement.
SET NAMES utf8mb4;

DROP DATABASE IF EXISTS tifosi;

CREATE DATABASE tifosi
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- 2. Création de l'utilisateur tifosi
--    - limité à une connexion locale (localhost) : base hébergée en local
--    - droits complets UNIQUEMENT sur la base tifosi (principe du moindre
--      privilège : il ne peut pas toucher aux autres bases du serveur)
--    /!\ Remplacer le mot de passe par un mot de passe robuste personnel.
-- ---------------------------------------------------------------------
DROP USER IF EXISTS 'tifosi'@'localhost';

CREATE USER 'tifosi'@'localhost' IDENTIFIED BY 'Tif0si_Street#2026';

GRANT ALL PRIVILEGES ON tifosi.* TO 'tifosi'@'localhost';

FLUSH PRIVILEGES;


USE tifosi;

-- ---------------------------------------------------------------------
-- 3. Création des tables
--    Passage MCD -> MLD :
--      * chaque entité devient une table ;
--      * association 1,1 - 0,n  -> clé étrangère côté 1,1
--          boisson (1,1) appartient marque      -> boisson.id_marque
--          menu    (1,1) est constitué focaccia -> menu.id_focaccia
--      * association n - n      -> table de jointure
--          comprend (focaccia <-> ingredient) + attribut quantite
--          contient (menu <-> boisson)
--          achete   (client <-> menu)         + attribut date_achat
--    Moteur InnoDB : obligatoire pour que les clés étrangères soient appliquées.
-- ---------------------------------------------------------------------

-- Tables "indépendantes" (sans clé étrangère) en premier -------------

CREATE TABLE ingredient (
    id_ingredient INT          NOT NULL AUTO_INCREMENT,
    nom           VARCHAR(50)  NOT NULL,
    CONSTRAINT pk_ingredient     PRIMARY KEY (id_ingredient),
    CONSTRAINT uq_ingredient_nom UNIQUE (nom)
) ENGINE = InnoDB;

CREATE TABLE focaccia (
    id_focaccia INT           NOT NULL AUTO_INCREMENT,
    nom         VARCHAR(50)   NOT NULL,
    prix        DECIMAL(5,2)  NOT NULL,
    CONSTRAINT pk_focaccia       PRIMARY KEY (id_focaccia),
    CONSTRAINT uq_focaccia_nom   UNIQUE (nom),
    CONSTRAINT ck_focaccia_prix  CHECK (prix > 0)
) ENGINE = InnoDB;

CREATE TABLE marque (
    id_marque INT          NOT NULL AUTO_INCREMENT,
    nom       VARCHAR(50)  NOT NULL,
    CONSTRAINT pk_marque     PRIMARY KEY (id_marque),
    CONSTRAINT uq_marque_nom UNIQUE (nom)
) ENGINE = InnoDB;

CREATE TABLE client (
    id_client   INT           NOT NULL AUTO_INCREMENT,
    nom         VARCHAR(50)   NOT NULL,
    email       VARCHAR(150)  NOT NULL,
    code_postal INT           NOT NULL,
    CONSTRAINT pk_client             PRIMARY KEY (id_client),
    CONSTRAINT uq_client_email       UNIQUE (email),
    CONSTRAINT ck_client_email       CHECK (email LIKE '%_@_%._%'),
    CONSTRAINT ck_client_code_postal CHECK (code_postal BETWEEN 1000 AND 99999)
) ENGINE = InnoDB;


-- Tables avec clé étrangère (association 1,1) ------------------------

CREATE TABLE boisson (
    id_boisson INT          NOT NULL AUTO_INCREMENT,
    nom        VARCHAR(50)  NOT NULL,
    id_marque  INT          NOT NULL,          -- cardinalité 1,1 : obligatoire
    CONSTRAINT pk_boisson        PRIMARY KEY (id_boisson),
    CONSTRAINT uq_boisson_nom    UNIQUE (nom),
    CONSTRAINT fk_boisson_marque FOREIGN KEY (id_marque)
        REFERENCES marque (id_marque)
        ON UPDATE CASCADE
        ON DELETE RESTRICT                     -- interdit de supprimer une marque encore utilisée
) ENGINE = InnoDB;

CREATE TABLE menu (
    id_menu     INT           NOT NULL AUTO_INCREMENT,
    nom         VARCHAR(50)   NOT NULL,
    prix        DECIMAL(5,2)  NOT NULL,
    id_focaccia INT           NOT NULL,        -- cardinalité 1,1 : obligatoire
    CONSTRAINT pk_menu          PRIMARY KEY (id_menu),
    CONSTRAINT uq_menu_nom      UNIQUE (nom),
    CONSTRAINT ck_menu_prix     CHECK (prix > 0),
    CONSTRAINT fk_menu_focaccia FOREIGN KEY (id_focaccia)
        REFERENCES focaccia (id_focaccia)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;

