	<?php	
		$con = mysqli_connect("localhost:3306","root","","project");
		if (mysqli_connect_errno())
		{
			die('Could not connect: ' . mysqli_error($con));
		}
		
		$Name=$_GET['Name'];
		$Town=$_GET['Town'];
		$StreetName=$_GET['StreetName'];
		$StreetNumber=$_GET['StreetNumber'];
		$PoastalCode=$_GET['PoastalCode'];
		
		if ($Name==='' or $Town==='' or $StreetName==='' or $StreetNumber==='' or $PoastalCode===''){
			header('Location:Lender-Insert.html');
			exit;
		}
		
		$result = mysqli_query($con, "INSERT INTO `lender` (`Name`, `Town`, `StreetName`, `StreetNumber`, `PoastalCode`) VALUES
('$Name', '$Town', '$StreetName', $StreetNumber, $PoastalCode)");
		
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