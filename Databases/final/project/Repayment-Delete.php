	<?php	
		$con = mysqli_connect("localhost:3306","root","","project");
		if (mysqli_connect_errno())
		{
			die('Could not connect: ' . mysqli_error($con));
		}

		$Id=$_GET['Id'];
		$DateofPayment=$_GET['DateofPayment'];
		if ($Id==='' or $DateofPayment===''){header('Location:Repayment-Delete.html'); exit;}
		$Id=" Id=".$Id;
		$DateofPayment=" DateofPayment ='$DateofPayment'";

		$result = mysqli_query($con, "DELETE FROM repayment WHERE ".$Id." AND".$DateofPayment);
		if($result === FALSE) { 
			die(mysqli_error($con)); 
		}
		mysqli_close($con);
		
	?>	
	
<html style="background-color:#f8f0e2;">
<head>
	<title>Redirecting</title>
</head>
<body>
		<meta http-equiv="refresh" content="2; url=main.html" />
		<h1 align="center" style="color:darkred;font-size=200px;font-family:Lucida Handwriting;"><strong>Redirecting you in 3 seconds...</strong></h1>
</body>
</html>