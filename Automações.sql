--* -------------------------------------------------------------------------- *--
--*                                Log Produtos                                *--
--* -------------------------------------------------------------------------- *--
--? Sequence Log
create sequence SEQ_LOG
    start with 1
    increment by 1
    nocache
    nocycle;

--? Procedure InserirLog
create or replace procedure SP_INSERIRLOG (P_CD_PRODUTO T_LOG.T_PRODUTO_CD_PRODUTO%TYPE,
                                           P_CD_FUNCIONARIO T_LOG.CD_LOG_FUNC%TYPE,
                                           P_TP_LOG T_LOG.TP_LOG%TYPE,
                                           P_NM_NV_PRODUTO T_LOG.NM_NV_PRODUTO%TYPE,
                                           P_UPDATE_AT T_LOG.UPDATE_AT%TYPE,
                                           P_VL_NV_COMPRA T_LOG.VL_NV_COMPRA%TYPE,
                                           P_VL_NV_VENDA T_LOG.VL_NV_VENDA%TYPE,
                                           P_DSC_LOG T_LOG.DSC_LOG%TYPE,
                                           P_NM_OLD_PRODUTO T_LOG.NM_OLD_PRODUTO%TYPE,
                                           P_VL_OLD_COMPRA T_LOG.VL_OLD_COMPRA%TYPE,
                                           P_VL_OLD_VENDA T_LOG.VL_OLD_VENDA%TYPE,
                                           P_DSC_NV_LOG T_LOG.DSC_NV_LOG%TYPE)
    as
    begin
        insert into T_LOG(CD_LOG, T_PRODUTO_CD_PRODUTO, CD_LOG_FUNC, TP_LOG, NM_NV_PRODUTO, UPDATE_AT, VL_NV_COMPRA,
                          DSC_LOG, NM_OLD_PRODUTO, VL_OLD_COMPRA, VL_OLD_VENDA, DSC_NV_LOG)
                          values (SEQ_LOG.nextval, P_CD_PRODUTO, P_CD_FUNCIONARIO, P_TP_LOG, P_NM_NV_PRODUTO, P_UPDATE_AT, P_VL_NV_COMPRA,
                                  P_DSC_LOG, P_NM_OLD_PRODUTO, P_VL_OLD_COMPRA, P_VL_OLD_VENDA, P_DSC_NV_LOG);
    end;
/

--? Trigger After Log
create or replace trigger TG_LOG_AFTER
    after insert or update
    of CD_PRODUTO, T_CATEGORIA_CD_CATEGORIA, NM_PRODUTO, VL_UNITARIO_COMPRA, VL_UNITARIO_VENDA, QTD_ESTOQUE, QTD_LIQUIDO
    on T_PRODUTO
    for each row
    begin
        if (INSERTING) then
            SP_INSERIRLOG(:NEW.CD_PRODUTO, :NEW.T_FUNCIONARIO_CD_FUNCIONARIO, 0, :NEW.NM_PRODUTO, sysdate, :NEW.VL_UNITARIO_COMPRA,
                          :NEW.VL_UNITARIO_VENDA, :NEW.DSC_PRODUTO, '', 0, 0, '');
        elsif (UPDATING) then
            SP_INSERIRLOG(:NEW.CD_PRODUTO, :NEW.T_FUNCIONARIO_CD_FUNCIONARIO, 1, :NEW.NM_PRODUTO, sysdate, :NEW.VL_UNITARIO_COMPRA,
                          :NEW.VL_UNITARIO_VENDA, :NEW.DSC_PRODUTO, :OLD.NM_PRODUTO, :OLD.VL_UNITARIO_COMPRA, :OLD.VL_UNITARIO_VENDA,
                          :OLD.DSC_PRODUTO);
        end if;
    exception
        when others then
            DBMS_OUTPUT.PUT_LINE(sqlerrm);
    end;
/

--? Trigger Before Log
create or replace trigger TG_LOG_BEFORE
    before delete on T_PRODUTO
    for each row
    begin
        SP_INSERIRLOG(:OLD.CD_PRODUTO, :OLD.T_FUNCIONARIO_CD_FUNCIONARIO, 2, '', sysdate, 0,
                        0, '', :OLD.NM_PRODUTO, :OLD.VL_UNITARIO_COMPRA, :OLD.VL_UNITARIO_VENDA,
                        :OLD.DSC_PRODUTO);
    exception
        when others then
            DBMS_OUTPUT.PUT_LINE(sqlerrm);
    end;
/

--* -------------------------------------------------------------------------- *--
--*                                 Funcionário                                *--
--* -------------------------------------------------------------------------- *--
--? Sequence Funcionário
create sequence SEQ_FUNC
    start with 1
    increment by 1
    nocache
    nocycle;

create or replace procedure SP_INSERIRFUNCIONARIO (P_NM_FUNCIONARIO T_FUNCIONARIO.NM_FUNCIONARIO%TYPE)
    as
    begin
        insert into T_FUNCIONARIO (CD_FUNCIONARIO, NM_FUNCIONARIO) values (SEQ_FUNC.nextval, P_NM_FUNCIONARIO);
    end;
/

--* -------------------------------------------------------------------------- *--
--*                                   Produto                                  *--
--* -------------------------------------------------------------------------- *--
--? Sequence Produto
create sequence SEQ_PRODUTO
    start with 1
    increment by 1
    nocache
    nocycle;

-- drop procedure SP_INSERIRPRODUTO;

--? Procedure Inserir Produto
create or replace procedure SP_INSERIRPRODUTO (P_CD_FUNCIONARIO T_FUNCIONARIO.CD_FUNCIONARIO%TYPE,
                                               P_CD_CATEGORIA T_CATEGORIA.CD_CATEGORIA%TYPE,
                                               P_NM_PRODUTO T_PRODUTO.NM_PRODUTO%TYPE,
                                               P_VL_UNITARIO_COMPRA T_PRODUTO.VL_UNITARIO_COMPRA%TYPE,
                                               P_VL_UNITARIO_VENDA T_PRODUTO.VL_UNITARIO_VENDA%TYPE,
                                               P_DSC_PRODUTO T_PRODUTO.DSC_PRODUTO%TYPE,
                                               P_QTD_ESTOQUE T_PRODUTO.QTD_ESTOQUE%TYPE,
                                               P_QTD_LIQUIDO T_PRODUTO.QTD_LIQUIDO%TYPE)
    as
    begin
        insert into T_PRODUTO (CD_PRODUTO, T_FUNCIONARIO_CD_FUNCIONARIO, T_CATEGORIA_CD_CATEGORIA, NM_PRODUTO, VL_UNITARIO_COMPRA, VL_UNITARIO_VENDA, DSC_PRODUTO, QTD_ESTOQUE, QTD_LIQUIDO)
                              values (SEQ_PRODUTO.nextval, P_CD_FUNCIONARIO, P_CD_CATEGORIA, P_NM_PRODUTO, P_VL_UNITARIO_COMPRA, P_VL_UNITARIO_VENDA, P_DSC_PRODUTO,
                                      P_QTD_ESTOQUE, P_QTD_LIQUIDO);
    end;
/

--? Procedure Alterar Produto
create or replace procedure SP_ALTERARPRODUTO (P_CD_PRODUTO T_PRODUTO.CD_PRODUTO%TYPE,
                                               P_CD_FUNCIONARIO T_FUNCIONARIO.CD_FUNCIONARIO%TYPE,
                                               P_CD_CATEGORIA T_CATEGORIA.CD_CATEGORIA%TYPE,
                                               P_NM_PRODUTO T_PRODUTO.NM_PRODUTO%TYPE,
                                               P_VL_UNITARIO_COMPRA T_PRODUTO.VL_UNITARIO_COMPRA%TYPE,
                                               P_VL_UNITARIO_VENDA T_PRODUTO.VL_UNITARIO_VENDA%TYPE,
                                               P_DSC_PRODUTO T_PRODUTO.DSC_PRODUTO%TYPE,
                                               P_QTD_ESTOQUE T_PRODUTO.QTD_ESTOQUE%TYPE,
                                               P_QTD_LIQUIDO T_PRODUTO.QTD_LIQUIDO%TYPE)
    as
    begin
        update T_PRODUTO 
            set T_CATEGORIA_CD_CATEGORIA = P_CD_CATEGORIA, NM_PRODUTO = P_NM_PRODUTO, VL_UNITARIO_COMPRA = P_VL_UNITARIO_COMPRA,
                VL_UNITARIO_VENDA = P_VL_UNITARIO_VENDA, DSC_PRODUTO = P_DSC_PRODUTO, QTD_ESTOQUE = P_QTD_ESTOQUE, QTD_LIQUIDO = P_QTD_LIQUIDO
            where CD_PRODUTO = P_CD_PRODUTO;
    end;
/

--? Procedure Excluir Produto
create or replace procedure SP_EXCLUIRPRODUTO (P_CD_PRODUTO T_PRODUTO.CD_PRODUTO%TYPE,
                                               P_CD_FUNCIONARIO T_FUNCIONARIO.CD_FUNCIONARIO%TYPE)
    as
    begin


        update T_PRODUTO set T_FUNCIONARIO_CD_FUNCIONARIO = P_CD_FUNCIONARIO where CD_PRODUTO = P_CD_PRODUTO;
        delete from T_PRODUTO where CD_PRODUTO = P_CD_PRODUTO;
    end;
/

--* -------------------------------------------------------------------------- *--
--*                                  Categoria                                 *--
--* -------------------------------------------------------------------------- *--
--? Sequencia Categoria
create sequence SEQ_CATEGORIA
    start with 1
    increment by 1
    nocache
    nocycle;

create or replace procedure SP_INSERIRCATEGORIA (P_TP_CATEGORIA T_CATEGORIA.TP_CATEGORIA%TYPE)
    as
    begin
        insert into T_CATEGORIA (CD_CATEGORIA, TP_CATEGORIA) values (SEQ_CATEGORIA.nextval, P_TP_CATEGORIA);
    end;
/

--* -------------------------------------------------------------------------- *--
--*                               Carga de Dados                               *--
--* -------------------------------------------------------------------------- *--
set SERVEROUTPUT on;
--? Dados de Funcionarios
create global temporary table TT_NOMES (NOME varchar2(50) not null);
create global temporary table TT_SOBRENOMES (SOBRENOME varchar2(50) not null);
declare
    v_nome varchar2(50);
    v_sobrenome varchar2(50);
    v_ultimonome varchar2(50);
begin
    insert into TT_NOMES (NOME) values ('Gabriel');
    insert into TT_NOMES (NOME) values ('Emilson');
    insert into TT_NOMES (NOME) values ('Mateus');
    insert into TT_NOMES (NOME) values ('Matheus');
    insert into TT_NOMES (NOME) values ('Rafael');
    insert into TT_NOMES (NOME) values ('Thiago');
    insert into TT_NOMES (NOME) values ('Bruce');
    insert into TT_NOMES (NOME) values ('Martha');
    insert into TT_NOMES (NOME) values ('Thomas');
    insert into TT_NOMES (NOME) values ('Christian');
    insert into TT_NOMES (NOME) values ('Joaquin');
    insert into TT_NOMES (NOME) values ('Heath');
    insert into TT_NOMES (NOME) values ('Robert');
    insert into TT_NOMES (NOME) values ('Michael');
    insert into TT_NOMES (NOME) values ('Benjamin');
    insert into TT_NOMES (NOME) values ('Adam');
    insert into TT_NOMES (NOME) values ('Val');
    insert into TT_NOMES (NOME) values ('George');
    insert into TT_NOMES (NOME) values ('Lewis');
    insert into TT_NOMES (NOME) values ('William');
    insert into TT_NOMES (NOME) values ('Jared');
    insert into TT_NOMES (NOME) values ('John');
    insert into TT_NOMES (NOME) values ('Jack');
    insert into TT_NOMES (NOME) values ('Mark');
    insert into TT_NOMES (NOME) values ('Kevin');
    insert into TT_NOMES (NOME) values ('Márcio');
    insert into TT_NOMES (NOME) values ('Isaac');
    insert into TT_NOMES (NOME) values ('Hélio');
    insert into TT_NOMES (NOME) values ('Júlio');
    insert into TT_NOMES (NOME) values ('Márcio');
    insert into TT_NOMES (NOME) values ('Ettore');
    insert into TT_NOMES (NOME) values ('Jorge');
    insert into TT_NOMES (NOME) values ('Duda');
    
    insert into TT_SOBRENOMES (SOBRENOME) values ('Silva');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Neto');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Ferreira');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Sales');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Azola');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Plens');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Wayne');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Napier');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Bale');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Phoenix');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Ledger');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Pattinson');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Keaton');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Affleck');
    insert into TT_SOBRENOMES (SOBRENOME) values ('West');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Kilmer');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Clooney');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Wilson');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Lowery');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Arnett');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Lowery');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Carroll');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Leto');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Nicholson');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Hamill');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Emerson');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Richardson');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Simões');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Shneider');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Ribeiro');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Chaves');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Conroy');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Seixas');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Zuim');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Lucas');
    insert into TT_SOBRENOMES (SOBRENOME) values ('Ribeiro');

    for i in 1..80
    loop
        select nome into v_nome from TT_NOMES order by DBMS_RANDOM.RANDOM fetch first 1 row only;
        select sobrenome into v_sobrenome from TT_SOBRENOMES order by dbms_random.RANDOM fetch first 1 row only;
        select sobrenome into v_ultimonome from TT_SOBRENOMES order by dbms_random.RANDOM fetch first 1 row only;
        if (DBMS_RANDOM.VALUE(0, 1) > 0.5) then
            SP_INSERIRFUNCIONARIO(v_nome || ' ' || v_sobrenome || ' ' || v_ultimonome);
        else
            SP_INSERIRFUNCIONARIO(v_nome || ' ' || v_ultimonome);
        end if;
        
    end loop;

    commit;
exception
    when others then
        DBMS_OUTPUT.PUT_LINE(sqlerrm);
        rollback;
end;

--? Dados de Categoria
begin
    SP_INSERIRCATEGORIA('LUBRIFICANTE');
    SP_INSERIRCATEGORIA('COMBUSTIVEL');
    commit;
exception
    when others then
        DBMS_OUTPUT.PUT_LINE(sqlerrm);
        rollback;
end;

--? Dados de Produtos
create global temporary table TT_MARCAS (ID number not null primary key, NOME varchar2(50) not null, CATEGORIA number not null);
create global temporary table TT_VOLUME (ID number not null primary key, VALOR number not null);
declare
    v_total_marca number;
    v_total_volume number;

    v_marca varchar(50);
    v_volume number;
    v_categoria T_CATEGORIA.CD_CATEGORIA%TYPE;
    v_nome_categoria T_CATEGORIA.TP_CATEGORIA%TYPE;
    v_funcionario T_FUNCIONARIO.CD_FUNCIONARIO%TYPE;

    v_valor_venda number;
    v_valor_compra number;

    v_ultimo_produto number;
begin
    insert into TT_MARCAS (ID, NOME, CATEGORIA) values (1, 'Ipiranga', 2);
    insert into TT_MARCAS (ID, NOME, CATEGORIA) values (2, 'Shell', 2);
    insert into TT_MARCAS (ID, NOME, CATEGORIA) values (3, 'Petrobras', 2);
    insert into TT_MARCAS (ID, NOME, CATEGORIA) values (4, 'Ale', 2);
    insert into TT_MARCAS (ID, NOME, CATEGORIA) values (5, 'Boxter', 2);
    insert into TT_MARCAS (ID, NOME, CATEGORIA) values (6, 'Graal', 2);
    insert into TT_MARCAS (ID, NOME, CATEGORIA) values (7, 'Sim', 2);
    insert into TT_MARCAS (ID, NOME, CATEGORIA) values (8, 'Setee', 2);
    insert into TT_MARCAS (ID, NOME, CATEGORIA) values (9, 'Setta', 2);
    insert into TT_MARCAS (ID, NOME, CATEGORIA) values (10, 'Larco', 2);

    insert into TT_VOLUME (ID, VALOR) values (1, 0.5);
    insert into TT_VOLUME (ID, VALOR) values (2, 0.8);
    insert into TT_VOLUME (ID, VALOR) values (3, 1);
    insert into TT_VOLUME (ID, VALOR) values (4, 2);
    insert into TT_VOLUME (ID, VALOR) values (5, 4);
    insert into TT_VOLUME (ID, VALOR) values (6, 8);
    insert into TT_VOLUME (ID, VALOR) values (7, 16);
    insert into TT_VOLUME (ID, VALOR) values (8, 32);

    select count(*) into v_total_marca from TT_MARCAS;
    select count(*) into v_total_volume from TT_VOLUME;

    for i in 1..v_total_marca
    loop
        for j in 1..v_total_volume
        loop
            select CD_FUNCIONARIO into v_funcionario from T_FUNCIONARIO order by dbms_random.RANDOM fetch first 1 row only;
            select NOME, CATEGORIA into v_marca, v_categoria from TT_MARCAS where ID = i;
            select TP_CATEGORIA into v_nome_categoria from T_CATEGORIA where CD_CATEGORIA = v_categoria;
            select VALOR into v_volume from TT_VOLUME where ID = j;

            v_valor_compra := dbms_random.value(4, 7);
            v_valor_venda := v_valor_compra * dbms_random.value(.2, 1);

            -- dbms_output.put_line(i || ' ' || j);

            SP_INSERIRPRODUTO(v_funcionario,
                              v_categoria,
                              v_nome_categoria || ' ' || v_marca || ' ' || v_volume || ' litros',
                              v_valor_compra,
                              v_valor_venda,
                              'Descrição',
                              dbms_random.value(0, 400),
                              v_volume);

            select CD_PRODUTO into v_ultimo_produto from T_PRODUTO order by CD_PRODUTO desc fetch first 1 row only;

            SP_ALTERARPRODUTO(v_ultimo_produto,
                              v_funcionario,
                              v_categoria,
                              v_nome_categoria || ' ' || v_marca || ' ' || v_volume || ' litros Alterado',
                              v_valor_compra,
                              v_valor_venda,
                              'Descrição',
                              dbms_random.value(0, 400),
                              v_volume);
        end loop;
    end loop;
    commit;
exception
    when others then
        DBMS_OUTPUT.PUT_LINE(sqlerrm);
        rollback;
end;

--? Select Tabelas
select * from T_FUNCIONARIO;
select * from T_CATEGORIA;
select * from T_PRODUTO;
select * from T_LOG;