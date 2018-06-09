--1 joinOne ennonei daneizomenous me aithseis daneiwn
SELECT
  *
FROM
  borrower
 JOIN loanrequest ON
  borrower.bid= loanrequest.bid
 WHERE
 loanrequest.percentage>10;
 
--2 joinTwo  ennonei daneistes me desmeuseis emfanizontas mono sygkekrimena pedia me diaforetika onomata
 SELECT
  lender.lid As "lender's id",
  lender.name As "lender's name",
  commitment.bid As "borrower's id",
  commitment.dateofrequest,
  commitment.amount
FROM
  lender
 JOIN commitment ON
  lender.lid= commitment.lid
 WHERE
 commitment.amount>1000;
 
 --3 AVG meso poso ana dosi
 SELECT ROUND(AVG(amount),2) FROM repayment;
 
 --4 SUM,GROUPBY,ORDERBY,LIMIT,nested query epistrefei to daneistei poy prosefere na daneisei synolika ta perissotera xrimata
select name from lender
where  lid=(select lid from commitment c 
        group by c.lid 
        order by Sum(amount) 
		DESC limit 1)
 

--5 GROUPBY deixnei poses aithseis exei kanei kathe xristis
SELECT bid, COUNT(*) FROM loanrequest
GROUP BY bid;

--6 OrderBy taxinomisi fthinousas seiras me vash to onoma kai periorismos apotelesmatwn sta 8 prwta
SELECT * FROM borrower
ORDER by name desc
limit 8;

--7 GroupBy having ennonei pinakes lender kai commitment kai emfanizei ta onomata ekeinwn twn daneistwn poy exoyn kanei dyo kai perissoteres aithseis
SELECT lender.Name,COUNT(*) as "NumberofCommitments" FROM (commitment
INNER JOIN lender ON
  commitment.lid=lender.lid)
GROUP BY lender.name
having count(*)>=2;

--8 nested query emfanizei ta onomata twn daneizomenwn gia tous opoious exei egkithei hdh toylaxiston ena daneio
select Name from borrower b 
   where exists 
      (select * from loan d 
	      where b.bid=d.bid)	
		  
--9 like psaxnoume gia onomata periexoyn to "papakwnstantinou" me diafores orthografies
SELECT * FROM lender
WHERE name LIKE '%papak_nstantino%';

--10 UNION emfanizei to onoma toy mesazonta an exei emplakei se daneio eite kapoia sygkekrimenh hmeromonia egkrishs h aithshs
(select Name from intermediary, loan
 where intermediary.mid=loan.mid and Dateofapproval='2010-12-05') 
union 
(select Name from intermediary, loan
 where intermediary.mid=loan.mid and Dateofrequest='2012-11-19') 		  