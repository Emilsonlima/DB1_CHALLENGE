--* DROP TABLES
drop table t_categoria cascade constraints PURGE;
drop table t_funcionario cascade constraints PURGE;
drop table t_log cascade constraints PURGE;
drop table t_produto cascade constraints PURGE;
--? Tabelas temporarias
drop table TT_NOMES;
drop table TT_SOBRENOMES;
drop table TT_MARCAS;
drop table TT_VOLUME;

--* DROP SEQUENCES
drop sequence seq_log;
drop sequence seq_func;
drop sequence seq_produto;
drop sequence seq_categoria;

--* DROP TRIGGERS
drop trigger TG_LOG_AFTER;
drop trigger TG_LOG_BEFORE;

--* LIMPAR REGISTROS
truncate table t_categoria cascade;
truncate table t_funcionario cascade;
truncate table t_log cascade;
truncate table t_produto cascade;

--* CREATE TABLES
CREATE TABLE t_categoria (
    cd_categoria NUMBER(30) NOT NULL,
    tp_categoria VARCHAR2(30) NOT NULL
);

ALTER TABLE t_categoria ADD CONSTRAINT t_categoria_pk PRIMARY KEY ( cd_categoria );

CREATE TABLE t_funcionario (
    cd_funcionario NUMBER(30) NOT NULL,
    nm_funcionario VARCHAR2(30) NOT NULL
);

ALTER TABLE t_funcionario ADD CONSTRAINT t_funcionario_pk PRIMARY KEY ( cd_funcionario );

CREATE TABLE t_log (
    cd_log               NUMBER(30) NOT NULL,
    t_produto_cd_produto NUMBER(30),
    tp_log               NUMBER(30) NOT NULL,
    nm_nv_produto        VARCHAR2(255),
    update_at            DATE NOT NULL,
    vl_nv_compra         NUMBER(30),
    vl_nv_venda          NUMBER(30),
    dsc_log              CLOB,
    nm_old_produto       VARCHAR2(255),
    vl_old_compra        NUMBER(30),
    vl_old_venda         NUMBER(30),
    dsc_nv_log           CLOB,
    cd_log_func          NUMBER(30) NOT NULL
);

ALTER TABLE t_log ADD CONSTRAINT t_log_pk PRIMARY KEY ( cd_log );

CREATE TABLE t_produto (
    cd_produto                   NUMBER(30) NOT NULL,
    t_categoria_cd_categoria     NUMBER(30) NOT NULL,
    nm_produto                   VARCHAR2(255) NOT NULL,
    vl_unitario_compra           NUMBER(30) NOT NULL,
    vl_unitario_venda            NUMBER(30) NOT NULL,
    dsc_produto                  CLOB NOT NULL,
    qtd_estoque                  NUMBER(30) NOT NULL,
    qtd_liquido                  NUMBER(30) NOT NULL,
    t_funcionario_cd_funcionario NUMBER(30) NOT NULL
);

ALTER TABLE t_produto ADD CONSTRAINT t_produto_pk PRIMARY KEY ( cd_produto );

-- ALTER TABLE t_log
--     ADD CONSTRAINT t_log_t_produto_fk FOREIGN KEY ( t_produto_cd_produto )
--         REFERENCES t_produto ( cd_produto );

ALTER TABLE t_produto
    ADD CONSTRAINT t_produto_t_categoria_fk FOREIGN KEY ( t_categoria_cd_categoria )
        REFERENCES t_categoria ( cd_categoria );

ALTER TABLE t_produto
    ADD CONSTRAINT t_produto_t_funcionario_fk FOREIGN KEY ( t_funcionario_cd_funcionario )
        REFERENCES t_funcionario ( cd_funcionario );