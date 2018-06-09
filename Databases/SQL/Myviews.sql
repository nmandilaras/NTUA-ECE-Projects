--1 Myviews - parousiazei onomata daneistwn, daneizomenwn kai to deikth empistosynhs twn prwtwn gia tous deyterous
CREATE VIEW thea (lenderName, borrowerName, trust)
AS select l.name, b.name, percentage
from borrower b, lender l, trust t
where b.bid = t.bid and t.lid=l.lid
ORDER by percentage 

--query sto view1
select * from thea

--enimerwsimi
update thea set trust=trust+5 where trust<96


--2 Myviews - parousiazei me fthinousa seira ta posa poy einai diatethimenos na daneisei SYNOLIKA o kathe daneisths
create view V (lenderid,TotalAmount) 
As select lid,Sum(amount) from commitment  
        group by lid 
        order by Sum(amount) DESC 
		
--query sto view3 - mh enimerwsimi 
select * from V

--3 Myviews
CREATE View agnantema AS 
   select name,town,streetname,streetnumber
   from lender 
   where poastalcode> 15100
   
--query sto view2  
select * from agnantema 