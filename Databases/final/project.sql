-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Φιλοξενητής: 127.0.0.1
-- Χρόνος δημιουργίας: 17 Ιαν 2016 στις 21:44:05
-- Έκδοση διακομιστή: 5.6.17
-- Έκδοση PHP: 5.5.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Βάση δεδομένων: `vasi`
--

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `borrower`
--

CREATE TABLE IF NOT EXISTS `borrower` (
  `BId` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Town` varchar(30),
  `StreetName` varchar(30) NOT NULL,
  `StreetNumber` int(11) NOT NULL,
  `PoastalCode` int(11) NOT NULL,
  PRIMARY KEY (`BId`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Άδειασμα δεδομένων του πίνακα `borrower`
--

INSERT INTO `borrower` (`BId`, `Name`, `Town`, `StreetName`, `StreetNumber`, `PoastalCode`) VALUES
(1, 'KWSTAS  KOBITSAKIS', 'ELEYSINA', 'MANDILARA', 42, 12345),
(2, 'GIORGOS XYDAS', 'SAMOS', 'VYZANTIOU', 95, 12679),
(3, 'MANOLIS MANDILARAS', 'MYTILINH', 'KOPEGXAGHS', 78, 12489),
(4, 'KATERINA KORONAIOU', 'ANTIPAROS', 'SOULIOY', 176, 13497),
(5, 'ELSA TOYRNAVITOY', 'KRHTH', 'IEROU LOXOU', 18, 18946),
(6, 'GIANNIS SIGLIDIS', 'KEFALONIA', 'SPARTAKOY', 5, 18645),
(7, 'FTWXOS SYGGENIS', 'NAXOS', 'ETHNIKIS ANTISTASEWS', 79, 17264),
(8, 'GIORGOS SINTOSIS', 'PAROS', 'SKRA', 4, 18678),
(9, 'KOSTAS KOULOGLOU', 'MYKONOS', 'KOLOKOTRONI', 3, 14563),
(10, 'ANTREI ZAXAROF', 'KATAPOLA', 'SKARAMAGKA', 89, 13245);

--
-- Δείκτες `borrower`
--
DROP TRIGGER IF EXISTS `trigger2`;
DELIMITER //
CREATE TRIGGER `trigger2` AFTER INSERT ON `borrower`
 FOR EACH ROW INSERT INTO loanrequest VALUES 
(new.bid,CURDATE(),NULL,NULL,NULL,NULL,NULL)
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `commitment`
--

CREATE TABLE IF NOT EXISTS `commitment` (
  `LId` int(11) NOT NULL,
  `Bid` int(11) NOT NULL,
  `DateofRequest` date NOT NULL,
  `Amount` int(11) NOT NULL,
  PRIMARY KEY (`LId`,`Bid`,`DateofRequest`),
  KEY `commitment_ibfk_2` (`Bid`,`DateofRequest`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Άδειασμα δεδομένων του πίνακα `commitment`
--

INSERT INTO `commitment` (`LId`, `Bid`, `DateofRequest`, `Amount`) VALUES
(1, 2, '2010-11-05', 22000),
(1, 8, '2015-05-02', 10000),
(2, 1, '2011-08-09', 2000),
(2, 9, '2012-11-19', 1000),
(3, 1, '2010-07-12', 30000),
(4, 1, '2010-07-12', 70000),
(4, 9, '2014-09-27', 3000),
(5, 2, '2010-11-05', 20000),
(6, 2, '2015-03-29', 1000),
(7, 3, '2014-05-22', 3900),
(8, 4, '2013-05-16', 2000),
(8, 10, '2013-03-12', 1000),
(9, 8, '2015-05-02', 22000),
(9, 9, '2012-11-19', 1000),
(10, 9, '2012-11-19', 1000);

--
-- Δείκτες `commitment`
--
DROP TRIGGER IF EXISTS `trigger1`;
DELIMITER //
CREATE TRIGGER `trigger1` AFTER INSERT ON `commitment`
 FOR EACH ROW insert into loan (dateofapproval,mid,bid,dateofrequest)
    select CURDATE(),(SELECT mid FROM intermediary ORDER BY RAND() LIMIT 1),l.bid,l.dateofrequest from loanrequest l 
    where l.amount <= 
    (select sum(d.amount) from commitment d 
	where l.bid=d.bid and l.dateofrequest=d.dateofrequest 
	group by d.bid,d.dateofrequest )
	and not exists (select 1
	                from loan 
	                where bid=l.bid
                    and	dateofrequest=l.dateofrequest)
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `deadline`
--

CREATE TABLE IF NOT EXISTS `deadline` (
  `Id` int(11) NOT NULL,
  `DateofAgreement` date NOT NULL,
  `Deadline` date NOT NULL,
  PRIMARY KEY (`Id`,`DateofAgreement`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Άδειασμα δεδομένων του πίνακα `deadline`
--

INSERT INTO `deadline` (`Id`, `DateofAgreement`, `Deadline`) VALUES
(1, '2010-08-12', '2016-02-19'),
(2, '2010-12-05', '2015-12-09'),
(2, '2015-12-05', '2020-12-09'),
(3, '2014-06-22', '2015-12-19'),
(3, '2015-11-22', '2018-12-19'),
(4, '2015-06-02', '2022-11-21'),
(5, '2012-12-19', '2020-12-19');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `intermediary`
--

CREATE TABLE IF NOT EXISTS `intermediary` (
  `MId` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Town` varchar(30) NOT NULL,
  `StreetName` varchar(30) NOT NULL,
  `StreetNumber` int(11) NOT NULL,
  `PoastalCode` int(11) NOT NULL,
  PRIMARY KEY (`MId`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Άδειασμα δεδομένων του πίνακα `intermediary`
--

INSERT INTO `intermediary` (`MId`, `Name`, `Town`, `StreetName`, `StreetNumber`, `PoastalCode`) VALUES
(1, 'IASIS', 'ATHENS', 'RODOY', 56, 10524),
(2, 'PRAKSIS', 'ATHENS', 'TRIKOYPH', 80, 14275),
(3, 'AIGIALI', 'AMORGOS', 'THYRAS', 5, 18923),
(4, 'YOUTHFULLY', 'THESSALONIKH', 'PANORAMA', 82, 12398),
(5, 'OHE', 'NEW YORK', '113TH STREET', 199, 10256);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `lender`
--

CREATE TABLE IF NOT EXISTS `lender` (
  `LId` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Town` varchar(30) NOT NULL,
  `StreetName` varchar(30) NOT NULL,
  `StreetNumber` int(11) NOT NULL,
  `PoastalCode` int(11) NOT NULL,
  PRIMARY KEY (`LId`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Άδειασμα δεδομένων του πίνακα `lender`
--

INSERT INTO `lender` (`LId`, `Name`, `Town`, `StreetName`, `StreetNumber`, `PoastalCode`) VALUES
(1, 'GIORGOS PAPAKONSTANTINOU', 'MAROUSSI', 'THEMISTOKLEOUS', 31, 15124),
(2, 'TROIKA', 'FLWRINA', 'AVEROF', 13, 12356),
(3, 'VOLFGANG SOIMPLE', 'KOZANH', 'KOLETTH', 59, 14598),
(4, 'VASILEIOS MPATSHS', 'BERGAMO', 'MARATHONOMAXON', 45, 14637),
(5, 'INTERNATIONAL MOMENTARY FUND', 'NEW YORK', 'TRIPOLEOS', 61, 16873),
(6, 'VASILIS PAPAKWNSTANTINOU', 'MADRID', 'MARATHONODROMON', 27, 17592),
(7, 'THANASIS PAPAKWNSTANTINOY', 'KORNOUALH', 'ELIKONOS', 185, 14838),
(8, 'GIORGOS TIRININIS', 'AIKATERINH', 'KEAS', 49, 18938),
(9, 'KYRIAZHS NIKOS', 'ATHENS', 'DRAGATSANIOU', 48, 18927),
(10, 'VAGGELIS EUSTHATHIOU', 'THESSALONIKH', 'TOUMPAS', 13, 13574);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `loan`
--

CREATE TABLE IF NOT EXISTS `loan` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `DateofApproval` date NOT NULL,
  `MId` int(11) NOT NULL,
  `BId` int(11) NOT NULL,
  `DateofRequest` date NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `MId` (`MId`),
  KEY `loan_ibfk_2` (`BId`,`DateofRequest`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Άδειασμα δεδομένων του πίνακα `loan`
--

INSERT INTO `loan` (`Id`, `DateofApproval`, `MId`, `BId`, `DateofRequest`) VALUES
(1, '2010-08-12', 2, 1, '2010-07-12'),
(2, '2010-12-05', 3, 2, '2010-11-05'),
(3, '2014-06-22', 1, 3, '2014-05-22'),
(4, '2015-06-02', 4, 8, '2015-05-02'),
(5, '2012-12-19', 5, 9, '2012-11-19');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `loanrequest`
--

CREATE TABLE IF NOT EXISTS `loanrequest` (
  `BId` int(11) NOT NULL,
  `DateofRequest` date NOT NULL,
  `Deadline` date DEFAULT NULL,
  `Amount` int(11) DEFAULT NULL,
  `PaybackPeriod` varchar(100) DEFAULT NULL,
  `Description` text,
  `Percentage` float DEFAULT NULL,
  PRIMARY KEY (`BId`,`DateofRequest`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Άδειασμα δεδομένων του πίνακα `loanrequest`
--

INSERT INTO `loanrequest` (`BId`, `DateofRequest`, `Deadline`, `Amount`, `PaybackPeriod`, `Description`, `Percentage`) VALUES
(1, '2010-07-12', '2020-07-12', 100000, '10', 'investment in new machinery', 10.5),
(1, '2011-08-09', '2023-08-09', 16000, '12', 'buying a car', 7.5),
(2, '2010-11-05', '2025-11-05', 42000, '15', 'buying a house', 16.3),
(2, '2015-03-29', '2017-03-29', 3600, '2', 'repairs', 13.72),
(3, '2014-05-22', '2017-05-22', 3900, '3', 'investment in Rnd department', 19.7),
(4, '2013-05-16', '2018-05-16', 8200, '5', 'investment in new offices', 3.72),
(5, '2013-05-16', '2017-05-16', 25000, '4', 'in order to expand production circle', 1.16),
(6, '2012-03-13', '2023-03-13', 10000, '11', 'initial bugdet for startup', 17.43),
(7, '2013-11-19', '2028-11-19', 114000, '15', 'investment in warehouse', 15.23),
(8, '2011-02-19', '2023-02-19', 15000, '12', 'buying a car', 3.2),
(8, '2015-05-02', '2045-05-02', 32000, '30', 'need for lyquidity', 9.7),
(9, '2012-11-19', '2017-11-19', 3000, '5', 'vacation loan', 13),
(9, '2014-09-27', '2021-09-27', 5000, '7', 'investment in new equipment', 16.16),
(10, '2013-03-12', '2038-03-12', 50000, '25', 'buying a house', 6.3),
(10, '2015-12-17', '2047-12-17', 70000, '32', 'in order to renovate equipment', 12.42);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `repayment`
--

CREATE TABLE IF NOT EXISTS `repayment` (
  `Id` int(11) NOT NULL,
  `DateofPayment` date NOT NULL,
  `Amount` int(11) NOT NULL,
  PRIMARY KEY (`Id`,`DateofPayment`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Άδειασμα δεδομένων του πίνακα `repayment`
--

INSERT INTO `repayment` (`Id`, `DateofPayment`, `Amount`) VALUES
(1, '2011-08-12', 1000),
(2, '2011-12-05', 2000),
(2, '2012-12-05', 500),
(2, '2014-12-05', 1000),
(3, '2014-07-22', 1500),
(3, '2014-08-22', 900),
(3, '2014-09-22', 900),
(4, '2015-07-02', 1100),
(4, '2015-08-02', 1100),
(5, '2013-12-19', 3500);

-- --------------------------------------------------------

--
-- Στημένη δομή για προβολή `thea`
--
CREATE TABLE IF NOT EXISTS `thea` (
`borrowerid` int(11)
,`borrowername` varchar(50)
,`streetname` varchar(50)
,`stretnumber` int(11)
,`postalcode` int(11)
);
-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `trust`
--

CREATE TABLE IF NOT EXISTS `trust` (
  `BId` int(11) NOT NULL,
  `LId` int(11) NOT NULL,
  `Percentage` int(11) NOT NULL,
  PRIMARY KEY (`BId`,`LId`),
  KEY `trust_ibfk_2` (`LId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Άδειασμα δεδομένων του πίνακα `trust`
--

INSERT INTO `trust` (`BId`, `LId`, `Percentage`) VALUES
(1, 5, 50),
(1, 6, 46),
(2, 2, 32),
(3, 10, 10),
(4, 4, 87),
(4, 9, 65),
(5, 10, 30),
(6, 1, 5),
(6, 10, 48),
(7, 9, 98),
(8, 7, 56),
(9, 3, 100),
(9, 5, 80),
(9, 6, 20),
(10, 7, 79);

-- --------------------------------------------------------

--
-- Στημένη δομή για προβολή `v`
--
CREATE TABLE IF NOT EXISTS `v` (
`lenderid` int(11)
,`TotalAmount` decimal(32,0)
);
-- --------------------------------------------------------

--
-- Δομή για προβολή `thea`
--
DROP TABLE IF EXISTS `thea`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW
`thea` AS select
`borrower`.`BId` AS `borrowerid` 
,`borrower`.`Name` AS `borrowername` 
,`borrower`.`StreetName` AS `streetname` 
,`borrower`.`StreetNumber` AS `streetnumber` 
,`borrower`.`PoastalCode` AS `postalcode` 
from `borrower`
where `borrower`.`PoastalCode`>15100
order by `borrower`.`Name`;

-- --------------------------------------------------------

--
-- Δομή για προβολή `v`
--
DROP TABLE IF EXISTS `v`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW 
`v` AS select `l`.`Name` AS `lendername`,
`c`.`LId` AS `lenderid`,
sum(`c`.`Amount`) AS `TotalAmount` 
from (`lender` `l` join `commitment` `c`) 
where (`l`.`LId` = `c`.`LId`) 
group by `c`.`LId` 
having (sum(`c`.`Amount`) > 10000) 
order by sum(`c`.`Amount`) desc;

--
-- Περιορισμοί για άχρηστους πίνακες
--

--
-- Περιορισμοί για πίνακα `commitment`
--
ALTER TABLE `commitment`
  ADD CONSTRAINT `commitment_ibfk_2` FOREIGN KEY (`Bid`, `DateofRequest`) REFERENCES `loanrequest` (`BId`, `DateofRequest`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `commitment_ibfk_1` FOREIGN KEY (`LId`) REFERENCES `lender` (`LId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Περιορισμοί για πίνακα `deadline`
--
ALTER TABLE `deadline`
  ADD CONSTRAINT `deadline_ibfk_1` FOREIGN KEY (`Id`) REFERENCES `loan` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Περιορισμοί για πίνακα `loan`
--
ALTER TABLE `loan`
  ADD CONSTRAINT `loan_ibfk_2` FOREIGN KEY (`BId`, `DateofRequest`) REFERENCES `loanrequest` (`BId`, `DateofRequest`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `loan_ibfk_1` FOREIGN KEY (`MId`) REFERENCES `intermediary` (`MId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Περιορισμοί για πίνακα `loanrequest`
--
ALTER TABLE `loanrequest`
  ADD CONSTRAINT `loanrequest_ibfk_1` FOREIGN KEY (`BId`) REFERENCES `borrower` (`BId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Περιορισμοί για πίνακα `repayment`
--
ALTER TABLE `repayment`
  ADD CONSTRAINT `repayment_ibfk_1` FOREIGN KEY (`Id`) REFERENCES `loan` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Περιορισμοί για πίνακα `trust`
--
ALTER TABLE `trust`
  ADD CONSTRAINT `trust_ibfk_2` FOREIGN KEY (`LId`) REFERENCES `lender` (`LId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `trust_ibfk_1` FOREIGN KEY (`BId`) REFERENCES `borrower` (`BId`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
