create table commune as select *  from p00000009432.commune; 

alter table commune add constraint compk primary key(codeinsee);
 ---crée aussi un index qui s'appelle compk 
 analyse index compk validate structure ;

 => index_stats 


--- commande pour voir les indexes:
SELECT index_name, blevel, table_name FROM user_indexes;
---question 1: 
select rowid, rownum, code_insee from commune;
--la commande renvoie id,le numéro et le codeinsee de  chaque ligne.
