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

-- ---------------------------------------------------------------------
-- Table marque (marque.xlsx)
-- ---------------------------------------------------------------------
INSERT INTO marque (id_marque, nom) VALUES
    (1, 'Coca-cola'),
    (2, 'Cristalline'),
    (3, 'Monster'),
    (4, 'Pepsico');

    -- ---------------------------------------------------------------------
-- Table boisson (boisson.xlsx)
-- ---------------------------------------------------------------------
INSERT INTO boisson (id_boisson, nom, id_marque) VALUES
    (1, 'Coca-cola zéro', 1),                   -- Coca-cola
    (2, 'Coca-cola original', 1),               -- Coca-cola
    (3, 'Fanta citron', 1),                     -- Coca-cola
    (4, 'Fanta orange', 1),                     -- Coca-cola
    (5, 'Capri-sun', 1),                        -- Coca-cola
    (6, 'Pepsi', 4),                            -- Pepsico
    (7, 'Pepsi Max Zéro', 4),                   -- Pepsico
    (8, 'Lipton zéro citron', 4),               -- Pepsico
    (9, 'Lipton Peach', 4),                     -- Pepsico
    (10, 'Monster energy ultra gold', 3),       -- Monster
    (11, 'Monster energy ultra blue', 3),       -- Monster
    (12, 'Eau de source', 2);                   -- Cristalline

-- ---------------------------------------------------------------------
-- Table ingredient (ingredient.xlsx)
-- ---------------------------------------------------------------------
INSERT INTO ingredient (id_ingredient, nom) VALUES
    (1, 'Ail'),
    (2, 'Ananas'),
    (3, 'Artichaut'),
    (4, 'Bacon'),
    (5, 'Base Tomate'),
    (6, 'Base crème'),
    (7, 'Champignon'),
    (8, 'Chevre'),
    (9, 'Cresson'),
    (10, 'Emmental'),
    (11, 'Gorgonzola'),
    (12, 'Jambon cuit'),
    (13, 'Jambon fumé'),
    (14, 'Oeuf'),
    (15, 'Oignon'),
    (16, 'Olive noire'),
    (17, 'Olive verte'),
    (18, 'Parmesan'),
    (19, 'Piment'),
    (20, 'Poivre'),
    (21, 'Pomme de terre'),
    (22, 'Raclette'),
    (23, 'Salami'),
    (24, 'Tomate cerise'),
    (25, 'Mozarella');