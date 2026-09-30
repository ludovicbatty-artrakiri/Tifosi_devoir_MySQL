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

