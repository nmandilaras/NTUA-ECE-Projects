<!DOCTYPE html>
<html style="background-color:#f8f0e2;">

<head>

	<title>intermediary in specific day</title>
	
	<link type="text/css" rel="stylesheet" href="stylesheet.css"/>

</head>

<body>

	<div style="margin:auto;">

		<h1 style="text-align:center;color:#77419b;font-family:Lucida Handwriting;color:darkred;"><strong>intermediary in specific day</strong></h1>
	
	</div>

	<!--
	<div style="margin:auto;">
		
		<h3><strong>"Show me the name of a middleman in a loan commitment at a specific day of approval, or at a specific day of request."</strong></h3>
	
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
		
		$result = mysqli_query($con, "select Name from intermediary, loan
where intermediary.mid=loan.mid and Dateofapproval='2010-12-05'
union 
select Name from intermediary, loan
where intermediary.mid=loan.mid and Dateofrequest='2012-11-19';");
		if($result === FALSE) { 
			die(mysqli_error($con)); 
		}
		
		echo "<table align = 'center'>";
		echo "<tr>";
		echo "<td>";echo "<strong>";echo "Name";echo "</strong>";echo "</td>";
		echo "</tr>";
		
		while($row = mysqli_fetch_array($result)) {
		echo "<tr>";
		echo "<td>";echo $row['Name'];echo "</td>";
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