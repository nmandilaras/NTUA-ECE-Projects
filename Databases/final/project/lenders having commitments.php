<!DOCTYPE html>
<html style="background-color:#f8f0e2;">

<head>

	<title>lenders having commitments</title>
	
	<link type="text/css" rel="stylesheet" href="stylesheet.css"/>

</head>

<body>

	<div style="margin:auto;">

		<h1 style="text-align:center;color:#77419b;font-family:Lucida Handwriting;color:darkred;"><strong>lenders having commitments</strong></h1>
	
	</div>

	<!--
	<div style="margin:auto;">
		
		<h3><strong>"Show me those lenders, who have commited an amount of their money. Reveal only their main characteristics."</strong></h3>
	
	</div>
	-->
	
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
		
		$result = mysqli_query($con, "SELECT lender.lid As \"lender's id\", lender.name As \"lender's name\", commitment.bid As \"borrower's id\", commitment.dateofrequest, commitment.amount FROM lender JOIN commitment ON lender.lid= commitment.lid WHERE commitment.amount>1000;");
		if($result === FALSE) { 
			die(mysqli_error($con)); 
		}
		echo "<table align = 'center'>";
		echo "<tr>";
		echo "<td>";echo "<strong>";echo "lender's id";echo "</strong>";echo "</td>"; 
		echo "<td>";echo "<strong>";echo "lender's name";echo "</strong>";echo "</td>"; 
		echo "<td>";echo "<strong>";echo "borrower's id";echo "</strong>";echo "</td>"; 
		echo "<td>";echo "<strong>";echo "dateofrequest";echo "</strong>";echo "</td>"; 
		echo "<td>";echo "<strong>";echo "amount";echo "</strong>";echo "</td>"; 
		echo "</tr>";
		
		while($row = mysqli_fetch_array($result)) {
			echo "<tr>";
			echo "<td>";echo $row['lender\'s id'];echo "</td>"; 
			echo "<td>";echo $row['lender\'s name'];echo "</td>"; 
			echo "<td>";echo $row['borrower\'s id'];echo "</td>"; 
			echo "<td>";echo $row['dateofrequest'];echo "</td>"; 
			echo "<td>";echo $row['amount'];echo "</td>"; 
			echo "<tr>";
		}
		
		echo "</table>";
		mysqli_close($con);
	?>

	<div>
	
		<h2><strong><a href="Queries.html">Back</a></strong></h2>
			
	</div>

</body>

</html>