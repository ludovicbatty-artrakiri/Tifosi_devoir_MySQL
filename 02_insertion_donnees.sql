-- =====================================================================
--  Projet  : Tifosi - Restaurant de street-food italien
--  Script  : 02_insertion_donnees.sql
--  Rôle    : Peuplement de la base avec les données de test fournies
--            (marque.xlsx, boisson.xlsx, ingredient.xlsx, focaccia.xlsx)
--  Exécution :
--      mysql -u tifosi -p tifosi < 02_insertion_donnees.sql
--  Pré-requis : avoir exécuté 01_creation_schema.sql
-- =====================================================================

USE tifosi;

-- Encodage de la connexion : indispensable pour que les accents
-- (é, è, œ...) soient enregistrés et affichés correctement.
SET NAMES utf8mb4;


-- Ordre d'insertion imposé par les clés étrangères :
--   marque -> boisson, ingredient + focaccia -> comprend
-- Les identifiants sont repris tels quels depuis les fichiers Excel.
-- Tout le peuplement est fait dans une transaction : soit tout passe,
-- soit rien n'est inséré (pas de base à moitié remplie en cas d'erreur).

START TRANSACTION;