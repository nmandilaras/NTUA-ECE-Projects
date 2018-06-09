<!DOCTYPE html>
<html style="background-color:#f8f0e2;">

<head>

	<title>Non-Updateable</title>
	
	<link type="text/css" rel="stylesheet" href="stylesheet.css"/>

</head>

<body>

	<div style="margin:auto;">

	<h1 style="text-align:center;color:#77419b;font-family:Lucida Handwriting;color:darkred;"><strong>Non-Updateable</strong></h1>
	
	</div>

	<div style="margin:auto;">		
		<h3 style="height:120px;"><strong>The names of lenders in descending order of >10000 total amount willing to lend.</strong></h3>
	</div>
		<?php
		$con = mysqli_connect("localhost:3306","root","","project");
		if (mysqli_connect_errno())
		{
			die('Could not connect: ' . mysqli_error($con));
		}
		
		$result=mysqli_query($con,"SELECT * FROM v");
		if($result === FALSE) { 
			die(mysqli_error($con));
		}
		
		echo "<table align='center' >";
		echo "<tr>";
		echo "<td>";echo "<strong>";echo "Lender Name";echo "</strong>";echo "</td>"; 
		echo "<td>";echo "<strong>";echo "Lender ID";echo "</strong>";echo "</td>"; 
		echo "<td>";echo "<strong>";echo "Total Amount";echo "<strong>";echo "</td>"; 
		echo "</tr>";
		
			while($row = mysqli_fetch_array($result)) {
				echo "<tr>";
				echo "<td>";
				echo $row['lendername'];
				echo "</td>";
				echo "<td>";
				echo $row['lenderid'];
				echo "</td>";
				echo "<td>";
				echo $row['TotalAmount'];
				echo "</td>";
				echo "</tr>";
			}
		echo "</table>";

		mysqli_close($con);
?>
	<br>
		
	<div>	
		<h2 ><strong><a href="Views.html">Back</a></strong></h2>
	</div>

</body>

</html>