<!DOCTYPE html>
<html style="background-color:#f8f0e2;">

<head>

	<title>"papak%knstantino%"</title>
	
	<link type="text/css" rel="stylesheet" href="stylesheet.css"/>

</head>

<body>

	<div style="margin:auto;">

		<h1 style="text-align:center;color:#77419b;font-family:Lucida Handwriting;color:darkred;"><strong>"papak%knstantino%"</strong></h1>
	
	</div>
	
	<!--
	<div style="margin:auto;">
		
		<h3><strong>"Show me all those users whose name is 'Papakwnstantinou' but each of them could be written differently."</strong></h3>
	
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
		
		$result = mysqli_query($con, "SELECT * FROM lender WHERE name LIKE '%papak_nstantino%';");
		if($result === FALSE) { 
			die(mysqli_error($con)); 
		}

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
		mysqli_close($con);	
	?>
	
	<div>
	
		<h2><strong><a href="Queries.html">Back</a></strong></h2>
			
	</div>

</body>

</html>