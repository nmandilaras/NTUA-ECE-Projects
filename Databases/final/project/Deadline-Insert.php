	<?php	
		$con = mysqli_connect("localhost:3306","root","","project");
		if (mysqli_connect_errno())
		{
			die('Could not connect: ' . mysqli_error($con));
		}
		
		$Id=$_GET['Id'];
		$DateofAgreement=$_GET['DateofAgreement'];
		$Deadline=$_GET['Deadline'];

		if ($Id==='' or $DateofAgreement==='' or $Deadline===''){
			header('Location:Deadline-Insert.html');
			exit;
		}
		
		$result = mysqli_query($con, "INSERT INTO `deadline` (`Id`, `DateofAgreement`, `Deadline`) VALUES 
		($Id, '$DateofAgreement', '$Deadline')");
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