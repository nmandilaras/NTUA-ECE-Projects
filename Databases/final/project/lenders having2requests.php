<!DOCTYPE html>
<html style="background-color:#f8f0e2;">

<head>

	<title>lenders having >=2 commitments</title>
	
	<link type="text/css" rel="stylesheet" href="stylesheet.css"/>

</head>

<body>

	<div style="margin:auto;">

		<h1 style="text-align:center;color:#77419b;font-family:Lucida Handwriting;color:darkred;"><strong>lenders having >=2 commitments</strong></h1>
	
	</div>

	<!--
	<div style="margin:auto;">
		
		<h3><strong>"Show me those lenders, who have fullfilled 2 or more requests."</strong></h3>
	
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
		
		$result = mysqli_query($con, "SELECT lender.Name,COUNT(*) as \"NumberofCommitments\" FROM (commitment
INNER JOIN lender ON
  commitment.lid=lender.lid)
GROUP BY lender.name
having count(*)>=2;");
		if($result === FALSE) { 
			die(mysqli_error($con)); 
		}
		echo "<table align = 'center'>";
		echo "<tr>";
		echo "<td>";echo "<strong>";echo "Name";echo "</strong>";echo "</td>";
		echo "<td>";echo "<strong>";echo "Number of Commitments";echo "</strong>";echo "</td>";
		echo "</tr>";
		
		while($row = mysqli_fetch_array($result)) {
		echo "<tr>";
		echo "<td>";echo $row['Name'];echo "</td>";
		echo "<td>";echo $row['NumberofCommitments'];echo "</td>";
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