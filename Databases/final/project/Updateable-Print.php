<!DOCTYPE html>
<html style="background-color:#f8f0e2;">

<head>

	<title>Print</title>
	
	<link type="text/css" rel="stylesheet" href="stylesheet.css"/>

</head>

<body>

	<div style="margin:auto;">

		<h1 style="text-align:center;color:#77419b;font-family:Lucida Handwriting;color:darkred;"><strong>Print</strong></h1>
	
	</div>

	<?php
		$con = mysqli_connect("localhost:3306","root","","project");
		if (mysqli_connect_errno())
		{
			die('Could not connect: ' . mysqli_error($con));
		}
		
		$result=mysqli_query($con,"SELECT * FROM thea");
		if($result === FALSE) { 
			die(mysqli_error($con));
		}
		
		echo "<table align='center' >";
		echo "<tr>";
		echo "<td>";echo "<strong>";echo "Borrower ID";echo "</strong>";echo "</td>"; 
		echo "<td>";echo "<strong>";echo "Name";echo "</strong>";echo "</td>"; 
		echo "<td>";echo "<strong>";echo "Street Name";echo "<strong>";echo "</td>"; 
		echo "<td>";echo "<strong>";echo "Street Nunmber";echo "<strong>";echo "</td>"; 
		echo "<td>";echo "<strong>";echo "Postal Code";echo "<strong>";echo "</td>"; 
		echo "</tr>";
		
			while($row = mysqli_fetch_array($result)) {
				echo "<tr>";
				echo "<td>";
				echo $row['borrowerid'];
				echo "</td>";
				echo "<td>";
				echo $row['borrowername'];
				echo "</td>";
				echo "<td>";
				echo $row['streetname'];
				echo "</td>";
				echo "<td>";
				echo $row['streetnumber'];
				echo "</td>";
				echo "<td>";
				echo $row['postalcode'];
				echo "</td>";				
				echo "</tr>";
			}
		echo "</table>";
		mysqli_close($con);
	?>

	<div>
		<h2><strong><a href="Updateable.html">Back</a></strong></h2>	
	</div>

</body>

</html>