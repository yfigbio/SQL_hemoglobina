-- =========================================================
-- Script name: Create_table.sql
-- Author: Yaiza Anido
-- Description: Creates SQL table for genomic data related to haemoglobin genes.
-- Notes: Run this file to create the database and all tables.
-- =========================================================

-- ====== PART 1: CREATE AND IMPORT DB ==========
CREATE DATABASE IF NOT EXISTS sql_hemoglobin
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE sql_hemoglobin;


-- =========================================================
-- ====== PART 2: CREATE TABLE GEN ===========
-- Stores core information about each gene, including name,
-- description, chromosome location and strand.
-- =========================================================

CREATE TABLE GEN (
    id_gen INT PRIMARY KEY AUTO_INCREMENT,
    name_gen VARCHAR(50) NOT NULL UNIQUE,
    descrip TEXT NOT NULL,
    chrm VARCHAR(10) NOT NULL,
    pos_in INT UNSIGNED NOT NULL,
    pos_fin INT UNSIGNED NOT NULL,
    strand ENUM('+','-') DEFAULT '+',
    CHECK (pos_fin >= pos_in)
);

