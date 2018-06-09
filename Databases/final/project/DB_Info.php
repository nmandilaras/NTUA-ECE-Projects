<!DOCTYPE html>
<html style="background-color:#f8f0e2;">

<head>

	<title>Info</title>
	
	<link type="text/css" rel="stylesheet" href="stylesheet.css"/>

</head>

<body>
	
	<?php
		// create a connection to the database with
		// mysql_connect(servername, username, password) function
		$con = mysqli_connect("localhost:3306","root","","project");
		if (mysqli_connect_errno())
		{
			die('Could not connect: ' . mysqli_error($con));
		}
		// a database must be selected before a query is executed on it
		//mysql_select_db("project", $con) or die(mysqli_error($con));
		// execute an SQL statement with mysql_query(statement) function
		// storing the data returned in the $result variable
		
		$dd = $_POST['mydropdown'];
		$result = mysqli_query($con, "SELECT * FROM $dd");
		if (mysqli_connect_errno())
		{
			die('Could not connect: ' . mysqli_error($con));
		}
		
		$i=0;
		if ($dd=='borrower'){
			echo"<div style=\"margin:auto;\">";

				echo"<h1 style=\"text-align:center;color:#77419b;font-family:Lucida Handwriting;color:darkred;\"><strong>Borrower</strong></h1>";
	
			echo"</div>";
			
			echo "<table align = 'center'>";
			echo "<tr>";
			echo "<td>";echo "<strong>";echo "BId";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "Name";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "Town";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "StreetName";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "StreetNumber";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "PostalCode";echo "</strong>";echo "</td>";
			echo "</tr>";
			
			while($row = mysqli_fetch_array($result)) {
				echo "<tr>";
				echo "<td>";echo $row['BId'];echo "</td>";
				echo "<td>";echo $row['Name'];echo "</td>";
				echo "<td>";echo $row['Town'];echo "</td>";
				echo "<td>";echo $row['StreetName'];echo "</td>";
				echo "<td>";echo $row['StreetNumber'];echo "</td>";
				echo "<td>";echo $row['PoastalCode'];echo "</td>";
				echo "</tr>";
			}
			echo "</table>";
		}
		
		if ($dd=='commitment'){
			echo"<div style=\"margin:auto;\">";

				echo"<h1 style=\"text-align:center;color:#77419b;font-family:Lucida Handwriting;color:darkred;\"><strong>Commitment</strong></h1>";
	
			echo"</div>";
			
			echo "<table align = 'center'>";
			echo "<tr>";
			echo "<td>";echo "<strong>";echo "LId";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "BId";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "DateofRequest";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "Amount";echo "</strong>";echo "</td>";
			echo "</tr>";
			
			while($row = mysqli_fetch_array($result)) {
				echo "<tr>";
				echo "<td>";echo $row['LId'];echo "</td>";
				echo "<td>";echo $row['Bid'];echo "</td>";
				echo "<td>";echo $row['DateofRequest'];echo "</td>";
				echo "<td>";echo $row['Amount'];echo "</td>";
				echo "</tr>";
			}
			echo "</table>";
		}
		
		if ($dd=='deadline'){
			echo"<div style=\"margin:auto;\">";

				echo"<h1 style=\"text-align:center;color:#77419b;font-family:Lucida Handwriting;color:darkred;\"><strong>Deadline</strong></h1>";
	
			echo"</div>";		
			
			echo "<table align = 'center'>";
			echo "<tr>";
			echo "<td>";echo "<strong>";echo "Id";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "DateofAgreement";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "Deadline";echo "</strong>";echo "</td>";
			echo "</tr>";
			
			while($row = mysqli_fetch_array($result)) {
				echo "<tr>";
				echo "<td>";echo $row['Id'];echo "</td>";
				echo "<td>";echo $row['DateofAgreement'];echo "</td>";
				echo "<td>";echo $row['Deadline'];echo "</td>";
				echo "</tr>";
			}
			echo "</table>";
		}
		
		if ($dd=='intermediary'){
			echo"<div style=\"margin:auto;\">";

				echo"<h1 style=\"text-align:center;color:#77419b;font-family:Lucida Handwriting;color:darkred;\"><strong>Intermediary</strong></h1>";
	
			echo"</div>";
			
			echo "<table align = 'center'>";
			echo "<tr>";
			echo "<td>";echo "<strong>";echo "MId";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "Name";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "Town";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "StreetName";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "StreetNumber";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "PostalCode";echo "</strong>";echo "</td>";
			echo "</tr>";
			
			while($row = mysqli_fetch_array($result)) {
				echo "<tr>";
				echo "<td>";echo $row['MId'];echo "</td>";
				echo "<td>";echo $row['Name'];echo "</td>";
				echo "<td>";echo $row['Town'];echo "</td>";
				echo "<td>";echo $row['StreetName'];echo "</td>";
				echo "<td>";echo $row['StreetNumber'];echo "</td>";
				echo "<td>";echo $row['PoastalCode'];echo "</td>";
				echo "</tr>";
			}
			echo "</table>";
		}
		
		if ($dd=='lender'){
			echo"<div style=\"margin:auto;\">";

				echo"<h1 style=\"text-align:center;color:#77419b;font-family:Lucida Handwriting;color:darkred;\"><strong>Lender</strong></h1>";
	
			echo"</div>";	
			
			echo "<table align = 'center'>";
			echo "<tr>";
			echo "<td>";echo "<strong>";echo "LId";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "Name";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "Town";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "StreetName";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "StreetNumber";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "PostalCode";echo "</strong>";echo "</td>";
			echo "</tr>";
			
			while($row = mysqli_fetch_array($result)) {
				echo "<tr>";
				echo "<td>";echo $row['LId'];echo "</td>";
				echo "<td>";echo $row['Name'];echo "</td>";
				echo "<td>";echo $row['Town'];echo "</td>";
				echo "<td>";echo $row['StreetName'];echo "</td>";
				echo "<td>";echo $row['StreetNumber'];echo "</td>";
				echo "<td>";echo $row['PoastalCode'];echo "</td>";
				echo "</tr>";
			}
			echo "</table>";
		}
		
		if ($dd=='loan'){
			echo"<div style=\"margin:auto;\">";

				echo"<h1 style=\"text-align:center;color:#77419b;font-family:Lucida Handwriting;color:darkred;\"><strong>Loan</strong></h1>";
	
			echo"</div>";			
			
			echo "<table align = 'center'>";
			echo "<tr>";
			echo "<td>";echo "<strong>";echo "Id";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "DateofApproval";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "MId";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "BId";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "DateofRequest";echo "</strong>";echo "</td>";
			echo "</tr>";
			
			while($row = mysqli_fetch_array($result)) {
				echo "<tr>";
				echo "<td>";echo $row['Id'];echo "</td>";
				echo "<td>";echo $row['DateofApproval'];echo "</td>";
				echo "<td>";echo $row['MId'];echo "</td>";
				echo "<td>";echo $row['BId'];echo "</td>";
				echo "<td>";echo $row['DateofRequest'];echo "</td>";
				echo "</tr>";
			}
			echo "</table>";
		}
		
		if ($dd=='loanrequest'){
			echo"<div style=\"margin:auto;\">";

				echo"<h1 style=\"text-align:center;color:#77419b;font-family:Lucida Handwriting;color:darkred;\"><strong>Loanrequest</strong></h1>";
	
			echo"</div>";		
			
			echo "<table align = 'center'>";
			echo "<tr>";
			echo "<td>";echo "<strong>";echo "BId";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "DateofRequest";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "Deadline";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "Amount";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "PaybackPeriod";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "Description";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "Percentage";echo "</strong>";echo "</td>";
			echo "</tr>";
			
			while($row = mysqli_fetch_array($result)) {
				echo "<tr>";
				echo "<td>";echo $row['BId'];echo "</td>";
				echo "<td>";echo $row['DateofRequest'];echo "</td>";
				echo "<td>";echo $row['Deadline'];echo "</td>";
				echo "<td>";echo $row['Amount'];echo "</td>";
				echo "<td>";echo $row['PaybackPeriod'];echo "</td>";
				echo "<td>";echo $row['Description'];echo "</td>";
				echo "<td>";echo $row['Percentage'];echo "</td>";
				echo "</tr>";
			}
			echo "</table>";
		}
				
		if ($dd=='repayment'){
			echo"<div style=\"margin:auto;\">";

				echo"<h1 style=\"text-align:center;color:#77419b;font-family:Lucida Handwriting;color:darkred;\"><strong>Repayment</strong></h1>";
	
			echo"</div>";		
			
			echo "<table align = 'center'>";
			echo "<tr>";
			echo "<td>";echo "<strong>";echo "Id";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "DateofPayment";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "Amount";echo "</strong>";echo "</td>";
			echo "</tr>";
			
			while($row = mysqli_fetch_array($result)) {
				echo "<tr>";
				echo "<td>";echo $row['Id'];echo "</td>";
				echo "<td>";echo $row['DateofPayment'];echo "</td>";
				echo "<td>";echo $row['Amount'];echo "</td>";
				echo "</tr>";
			}
			echo "</table>";
		}
		
		if ($dd=='trust'){
			echo"<div style=\"margin:auto;\">";

				echo"<h1 style=\"text-align:center;color:#77419b;font-family:Lucida Handwriting;color:darkred;\"><strong>Trust</strong></h1>";
	
			echo"</div>";
			
			echo "<table align = 'center'>";
			echo "<tr>";
			echo "<td>";echo "<strong>";echo "BId";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "LId";echo "</strong>";echo "</td>";
			echo "<td>";echo "<strong>";echo "Percentage";echo "</strong>";echo "</td>";
			echo "</tr>";
			
			while($row = mysqli_fetch_array($result)) {
				echo "<tr>";
				echo "<td>";echo $row['BId'];echo "</td>";
				echo "<td>";echo $row['LId'];echo "</td>";
				echo "<td>";echo $row['Percentage'];echo "</td>";
				echo "</tr>";
			}
			echo "</table>";
		}
		
		mysqli_close($con);	
	?>
	
	<div>
	
		<h2><strong><a href="DB_Info.html">Back</a></strong></h2>
			
	</div>

</body>

</html>