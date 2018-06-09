	<?php	
		$con = mysqli_connect("localhost:3306","root","","project");
		if (mysqli_connect_errno())
		{
			die('Could not connect: ' . mysqli_error($con));
		}

		$BId=$_GET['BId'];
		$DateofRequest=$_GET['DateofRequest'];
		$Deadline=$_GET['Deadline'];
		$Amount=$_GET['Amount'];
		$PaybackPeriod=$_GET['PaybackPeriod'];
		$Description=$_GET['Description'];
		$Percentage=$_GET['Percentage'];

		if ($BId==='' or $DateofRequest===''){
			header('Location:Loanrequest-Update.html');
			exit;
		}

		if ($Deadline==''){$Deadline='NULL';}
		if ($Amount==''){$Amount='NULL';}
		if ($PaybackPeriod==''){$PaybackPeriod='NULL';}
		if ($Description==''){$Description='NULL';}
		if ($Percentage==''){$Percentage='NULL';}
		
		$result = mysqli_query($con, "UPDATE loanrequest SET Deadline='$Deadline', Amount=$Amount, PaybackPeriod=$PaybackPeriod, 
		Description='$Description', Percentage=$Percentage WHERE BId=$BId AND DateofRequest='$DateofRequest'");
		
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