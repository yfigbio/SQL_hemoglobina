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

CREATE TABLE GENE (
    gene_id INT PRIMARY KEY AUTO_INCREMENT,
    gene_name VARCHAR(50) NOT NULL UNIQUE,
    descrip TEXT NOT NULL,
    chrm VARCHAR(10) NOT NULL,
    start_pos INT UNSIGNED NOT NULL,
    end_pos INT UNSIGNED NOT NULL,
    strand ENUM('+','-') DEFAULT '+',
    CHECK (end_pos >= start_pos)
);


-- ---------------------------------------------------------
-- Table: GENE_SEQUENCE
-- Stores DNA sequence fragments associated with a gene, 
-- including type (exon, intron, promoter, etc.) and the 
-- relative start position within the gene.
-- ---------------------------------------------------------

CREATE TABLE GENE_SEQUENCE (
    sequence_id INT PRIMARY KEY AUTO_INCREMENT,
    gene_id INT NOT NULL,
    dna_sequence VARCHAR(1000) NOT NULL,
    sequence_type ENUM('exon','intron','promoter','CDS','UTR','other') NOT NULL DEFAULT 'other',
    relative_start INT UNSIGNED NOT NULL,
    CHECK (CHAR_LENGTH(dna_sequence) BETWEEN 10 AND 1000),
    CHECK (relative_start > 0),
    FOREIGN KEY (gene_id) REFERENCES GENE(gene_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ---------------------------------------------------------
-- Table: GENE_VARIANT
-- Stores genetic variants associated with a gene, including
-- the reference and alternative allele, the variant type,
-- and the relative position within the gene.
-- ---------------------------------------------------------

CREATE TABLE GENE_VARIANT (
    variant_id INT PRIMARY KEY AUTO_INCREMENT,
    gene_id INT NOT NULL,  -- FOREING KEY 
    relative_start INT UNSIGNED NOT NULL,
    ref_allele CHAR(1) NOT NULL, -- With constraint
    alt_allele CHAR(1) NOT NULL, -- With constraint
    variant_type ENUM('SNV','insertion','deletion','substitution','other') NOT NULL,
    CHECK (relative_start > 0),
    CHECK (ref_allele IN('A','C','T','G','-')),
    CHECK (alt_allele IN('A','C','T','G','-')),
    FOREIGN KEY (gene_id) REFERENCES GENE (gene_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ---------------------------------------------------------
-- Table: GENE_ANNOTATION
-- Stores annotations related to a gene, including annotation
-- type (functional, clinical, expression, etc.), description,
-- source of information, evidence level and creation timestamp.
-- ---------------------------------------------------------

-- ---------------------------------------------------------
-- Table: GENE_ANNOTATION
-- Stores annotations related to a gene, including annotation
-- type (functional, clinical, expression, etc.), description,
-- source of information, evidence level and creation timestamp.
-- ---------------------------------------------------------

CREATE TABLE GENE_ANNOTATION (
    annotation_id INT PRIMARY KEY AUTO_INCREMENT,
    gene_id INT NOT NULL,
    annotation_type ENUM('functional','clinical','expression','pathway','other') NOT NULL,
    description TEXT NOT NULL,
    source ENUM('Ensembl','ClinVar','OMIM','UniProt','NCBI','Other'),
    evidence_level ENUM('high','moderate','low','unknown'),
    created_at DATETIME NOT NULL,
    CHECK (TRIM(description) <> ''),
    FOREIGN KEY (gene_id) REFERENCES GENE(gene_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- ---------------------------------------------------------
-- Table: STUDY
-- Stores information about scientific studies related to 
-- genes and variants, including title, authors, journal, 
-- publication date, study type and optional reference code.
-- ---------------------------------------------------------

CREATE TABLE STUDY (
    study_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    authors VARCHAR(255) NOT NULL,
    journal VARCHAR(100) NOT NULL,
    publication_date DATE NOT NULL,
    study_type ENUM('clinical','research','review','meta-analysis','other') NOT NULL,
    reference_code VARCHAR(20),
    CHECK (TRIM(title) <> ''),
    CHECK (TRIM(authors) <> ''),
    CHECK (TRIM(journal) <> '')
);
