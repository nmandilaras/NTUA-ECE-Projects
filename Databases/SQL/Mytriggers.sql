--Mytriggers
-- 1 trigger - opote ginetai kataxwrhsh ston pinaka commitment elegxei an gia kapoio daneio exei symplhrwthei to poso
 --kai an nai prosthetei nea kataxwrhsh ston pinaka loan. To id sto loan ayxanei automata, hmeromhnia egkrishs 
 -- tithetai h current, epilegetai tyxaia ena endiamesos gia thn apoplhrwmh kai ta bid kai dateofrequest
 -- einai ta idia me thn antistoixh aithsh daneioy. Telos se periptwsh poy kapoio daneio yparxei hdh den xanabainei 
 --(to for each row de xreiazetai nomizw, alla moy evgaze syntax error xwris ayto, wstoso den epireazei kapws to apotelesma )
 
CREATE TRIGGER `trigger1` AFTER INSERT ON `commitment`
 FOR EACH ROW 	insert into loan (dateofapproval,mid,bid,dateofrequest)
    select CURDATE(),(SELECT mid FROM intermediary ORDER BY RAND() LIMIT 1),l.bid,l.dateofrequest from loanrequest l 
    where l.amount <= 
    (select sum(d.amount) from commitment d 
	where l.bid=d.bid and l.dateofrequest=d.dateofrequest 
	group by d.bid,d.dateofrequest )
	and not exists (select 1
	                from loan 
	                where bid=l.bid
                    and	dateofrequest=l.dateofrequest)

-- example for trigger1
insert into commitment
values (9,10, '2013-03-12', 50000),
(8,10, '2015-12-17',80000)

--2o trigger - kathe fora poy prostithetai enas daneizomenos dimioyrgeitai aytomata mia nea aithsh daneioy
--opoy symplhrwnontai bid kai mera aithshs. Ta ypoloipa pedia tithontai null
 
 CREATE TRIGGER `trigger2` AFTER INSERT ON `borrower`
 FOR EACH ROW INSERT INTO loanrequest VALUES 
(new.bid,CURDATE(),NULL,NULL,NULL,NULL,NULL);

-- example for trigger2
insert into borrower (`Name`, `Town`, `StreetName`, `StreetNumber`, `PoastalCode`) values 
('VOLFGANG SOIMPLE', 'KOZANH', 'KOLETTH', 59, 14598),
( 'VASILEIOS MPATSHS', 'BERGAMO', 'MARATHONOMAXON', 45, 14637),
( 'Internation Momentary Fund', 'New York', 'TRIPOLEOS', 61, 16873)