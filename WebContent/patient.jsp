<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

	<%@page import="java.sql.*"%>

<%
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/queless?serverTimezone=UTC", "root","");

	PreparedStatement ps = connection.prepareStatement("SELECT * FROM `doctor` JOIN hospital ON doctor.hospital_id=hospital.hospital_id");
	ResultSet result = ps.executeQuery();

	String user = (String)session.getAttribute("user");
	if (user==null) user="Aman01";
	PreparedStatement ps2 = connection.prepareStatement("SELECT * from appointment JOIN doctor JOIN hospital WHERE appointment.doctor_id=doctor.doctor_id AND doctor.hospital_id=hospital.hospital_id and username like ? ORDER BY date,time ASC");
	ps2.setString(1, user);
	ResultSet r2 = ps2.executeQuery();

	if (request.getParameter("search") != null) {
		String search = request.getParameter("enter_search");
		String query = "SELECT * from doctor JOIN hospital WHERE doctor.hospital_id= hospital.hospital_id and concat(doctor.firstname, \" \", doctor.lastname) LIKE ?";
	
		ps = connection.prepareStatement(query);
		ps.setString(1, "%" + search + "%");
		result = ps.executeQuery();
	}
	
	if (request.getParameter("specialist1") != null) {
		String query = "SELECT * from doctor JOIN hospital WHERE doctor.hospital_id= hospital.hospital_id and doctor.specialist LIKE ? ";
		ps = connection.prepareStatement(query);
		ps.setString(1, "%Pediatrician%");
		result = ps.executeQuery();
	}
	
	if (request.getParameter("specialist2") != null) {
		String query = "SELECT * from doctor JOIN hospital WHERE doctor.hospital_id= hospital.hospital_id and doctor.specialist LIKE ? ";
		ps = connection.prepareStatement(query);
		ps.setString(1, "%Gynaecologist%");
		result = ps.executeQuery();
	}
	
	if (request.getParameter("specialist3") != null) {
		String query = "SELECT * from doctor JOIN hospital WHERE doctor.hospital_id= hospital.hospital_id and doctor.specialist LIKE ? ";
		ps = connection.prepareStatement(query);
		ps.setString(1, "%Cardiologist%");
		result = ps.executeQuery();
	}
	
	if (request.getParameter("location1") != null) {
		String query = "SELECT * from doctor JOIN hospital WHERE doctor.hospital_id= hospital.hospital_id and hospital.city LIKE ? ";
		ps = connection.prepareStatement(query);
		ps.setString(1, "%Mumbai%");
		result = ps.executeQuery();
	}
	
	if (request.getParameter("location2") != null) {
		String query = "SELECT * from doctor JOIN hospital WHERE doctor.hospital_id= hospital.hospital_id and hospital.city LIKE ? ";
		ps = connection.prepareStatement(query);
		ps.setString(1, "%New Delhi%");
		result = ps.executeQuery();
	}
	
	if (request.getParameter("location3") != null) {
		String query = "SELECT * from doctor JOIN hospital WHERE doctor.hospital_id= hospital.hospital_id and hospital.city LIKE ? ";
		ps = connection.prepareStatement(query);
		ps.setString(1, "%Bangalore%");
		result = ps.executeQuery();
	}
	
	if (request.getParameter("sort1") != null) {
		String query = "SELECT * from doctor JOIN hospital WHERE doctor.hospital_id= hospital.hospital_id ORDER BY firstname ";
		ps = connection.prepareStatement(query);
		result = ps.executeQuery();
	}
	
	if (request.getParameter("sort2") != null) {
		String query = "SELECT * from doctor JOIN hospital WHERE doctor.hospital_id= hospital.hospital_id ORDER BY firstname DESC";
		ps = connection.prepareStatement(query);
		result = ps.executeQuery();
	}
	
	if (request.getParameter("sort3") != null) {
		String query = "SELECT * from doctor JOIN hospital WHERE doctor.hospital_id= hospital.hospital_id ORDER BY ratings DESC, experience DESC";
		ps = connection.prepareStatement(query);
		result = ps.executeQuery();
	}
	
	if (request.getParameter("bookapp") != null) {
		RequestDispatcher dispatcher = request.getRequestDispatcher("appointment.jsp");
		dispatcher.forward(request, response);
	}
	%>
	
	<%!public String convertAM(String time) {
			int hour = Integer.valueOf(time.substring(0, 2));
			String temp = "AM";
	
			if (hour == 12) {
				temp = "PM";
			} else if (hour > 12) {
				hour -= 12;
				temp = "PM";
			}
	
			if (hour < 10)
				return "0" + String.valueOf(hour) + time.substring(2, 5) + " " + temp;
	
			return String.valueOf(hour) + time.substring(2, 5) + " " + temp;
		}
		
		public String month (String m){
			if (m.matches("01"))
				return " Jan";
			else if (m.matches("02"))
				return " Feb";
			else if (m.matches("03"))
				return " Mar";
			else if (m.matches("04"))
				return " Apr";
			else if (m.matches("05"))
				return " May";
			else if (m.matches("06"))
				return " Jun";
			else if (m.matches("07"))
				return " Jul";
			else if (m.matches("08"))
				return " Aug";
			else if (m.matches("09"))
				return " Sep";
			else if (m.matches("10"))
				return " Oct";
			else if (m.matches("11"))
				return " Nov";
			return " Dec";
		}
	%>


<!DOCTYPE html>
<html lang="en">
	
	<head>
	<!-- Required meta tags -->
	<meta charset="utf-8">
	<meta name="viewport"
		content="width=device-width, initial-scale=1, shrink-to-fit=no">
	
	<!-- Bootstrap CSS -->
	<link rel="stylesheet"
		href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"
		integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z"
		crossorigin="anonymous">
	<link rel="stylesheet" href="assets/css/patient.css">
	
	<script src="https://kit.fontawesome.com/5c71f8ba28.js" crossorigin="anonymous"></script>
	<title>Patient</title>
	</head>
	
	
	<body>
	
		<!-- Nav Bar -->
		<nav class="navbar navbar-expand-lg navbar-dark p-3">
			<a class="navbar-brand pl-5" href="#">Queless</a>
			<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarNav">
				<ul class="navbar-nav my-2 my-lg-0 ml-auto align-items-center">
					<li class="nav-item"><a class="nav-link" href="#">Home</a></li>
					<li class="nav-item active"><a class="nav-link" href="#">Patient<span class="sr-only">(current)</span></a></li>
					<li class="nav-item"><a class="nav-link" href="#">About Us</a></li>
					<li class="nav-item"><a class="nav-link" href="#">Contact us</a></li>
					<li class="nav-item dropdown ml-2"><a class="nav-link dropdown-toggle" id="navbarDropdownMenuLink-333" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
							<i class="fas fa-user fa-2x"></i> 
							<li class="nav-item"><a class="nav-link" href="#"><%=user %></a></li>
					</a>
						<div class="dropdown-menu dropdown-menu-right dropdown-default"aria-labelledby="navbarDropdownMenuLink-333">
							<a class="dropdown-item" href="patient_profile.jsp">My Account</a> 
							<a class="dropdown-item" href="login.jsp">Log Out</a>
						</div></li>
				</ul>
			</div>
		</nav>
	
	
	
		<div class="row no-gutters justify-content-between">
			<div class="col-lg-9 col-md-12 col-sm-12 ">
				<div class="row">
	
					<!--Search Bar-->
					<div class="col-lg-6 col-md-12 col-sm-12 my-col" style="margin-top: 18px;">
						<form class="form-inline my-12 my-lg-2" method="post">
							<input class="form-control formdoc" type="text" placeholder="Enter a Doctor" aria-label="Search" name="enter_search"> 
							<input class="btn btn-primary my-2 my-sm-2 btnss" type="submit" value="Search" name="search">
						</form>
					</div>

					<!--filter-->
					<div class="col-lg-5 col-md-12 col-sm-12 my-col" style="margin-top: 31px;" id="filter">
						<form method="post">
							<div class="row">
								<h5 class="filter" style="margin-top: 3px; font-size: 22px; color: #00004d;"><b>Filter by:  </b></h5>
								<div class="dropdown">
									<button class="btn btn-light dropdown-toggle btnf" type="button" id="dropdownMenuButton" data-toggle="dropdown"aria-haspopup="true" aria-expanded="false">Specialist</button>
									<div class="dropdown-menu mynew" aria-labelledby="dropdownMenuButton">
										<button class="dropdown-item" name="specialist1" type="submit">Pediatrician</button>
										<button class="dropdown-item" name="specialist2" type="submit">Gynaecologist</button>
										<button class="dropdown-item" name="specialist3" type="submit">Cardiologist</button>
									</div>
								</div>
	
								<div class="dropdown">
									<button class="btn btn-light dropdown-toggle btnf" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Location</button>
									<div class="dropdown-menu mynew" aria-labelledby="dropdownMenuButton">
										<button class="dropdown-item" name="location1" type="submit">Mumbai</button>
										<button class="dropdown-item" name="location2" type="submit">New Delhi</button>
										<button class="dropdown-item" name="location3" type="submit">Bangalore</button>
									</div>
								</div>
	
								<div class="dropdown">
									<button class="btn btn-light dropdown-toggle btnf" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Sort by</button>
									<div class="dropdown-menu mynew" aria-labelledby="dropdownMenuButton">
										<button class="dropdown-item" name="sort1" type="submit">A to Z</button>
										<button class="dropdown-item" name="sort2" type="submit">Z to A</button>
										<button class="dropdown-item" name="sort3" type="submit">Ratings</button>
									</div>
								</div>
							</div>
						</form>
					</div>
				</div>
				
			<% if(!result.isBeforeFirst()){ %>
				<br><br>
				<div class="d-flex justify-content-center"><i class="fas fa-exclamation-triangle fa-5x" style="color: #00CCFF"></i></div><br>
				<div class="d-flex justify-content-center"><h4>Oops! No Results to display!!</h4></div>
				<div class="d-flex justify-content-center">Please try some other keyword</div>
				<br><br>
				<div class="d-flex justify-content-center"><h5>Still have a problem - <a href="#">Contact Us</a> <i class="far fa-envelope" style="color: #3399CC; font-size: 30px;"></i></h5></div>	
				<!--  <br><br><br><br><br><br><br><br><br><br> -->
			<%	} 
				while (result.next()) {
				%>
				<!--Cards-->
				<div
					class="col-lg-8 col-md-10 col-sm-10 shadow p-3 mb-5 rounded my-card">
					<div class="row align-items-center">
						<div class="col-md-3 col-sm-4">
							<img src="assets/img/Doctor.png" class="card-img">
						</div>
	
						<div class="col-md-5 col-sm-8 card-body align-items-center">
							<h5 class="card-title">
								<b>Dr. <%=result.getString("firstname")%> <%=result.getString("lastname")%></b>
							</h5>
							<p class="card-text"><%=result.getString("name")%>, <%=result.getString("city")%><br> 
								Specialist : <%=result.getString("specialist")%><br> 
								Experience : <%=result.getString("experience")%> years<br>
								Ratings : 
								<!--Ratings-->
								<%
									float ratings = result.getFloat("ratings");
									for (int i = 1; i <= ratings; i++) {
								%>
									<i class="fas fa-star"></i>
								<%
									}
									if (result.getInt("ratings") != result.getFloat("ratings")) {
								%>
									<i class="fas fa-star-half"></i>
								<%
									}
								%>
	
							</p>
						</div>
	
	
						<div class="box col-md-4 col-sm-12">
							<form action="post">
	
								<%
								PreparedStatement ps3 = connection.prepareStatement("Select * from availability where doctor_id = ? and status = \"Unreserved\" ");
								ps3.setString(1, result.getString("doctor_id"));
								ResultSet rs3 = ps3.executeQuery();
								rs3.next();
	
								String time = rs3.getString("time").substring(0, 5);
	
								String date = rs3.getString("date");
								date = date.substring(8, 10) + date.substring(4, 8) + date.substring(0, 4);
								%>
	
								<button type="button" class="btn btn-dark" style="background-color: #3399CC;" data-container="body" data-toggle="popover" data-placement="right"
									data-content="<%=date%> <%=convertAM(time)%>">Check Availability</button>
	
								<a href="appointment.jsp?doctorId=<%=result.getInt("doctor_id")%>">
									<button class="btn btn-dark" name="bookapp" type="button" style="background-color: #E83151; border: none">Book Appointment</button>
								</a>
	
							</form>
						</div>
					</div>
				</div>
	
				<!--Card end-->
				<%
					}
				%>
	
			</div>
	
	
			<!--My Appointments-->
			<div class="col-lg-3 col-md-12 col-sm-12 my-app">
				<div class="row">
					<h3 class="header">
						My Appointment <i class="fas fa-calendar-check"></i>
					</h3>
				</div>
	
				<%
					while (r2.next()) {
					String time = r2.getString("time").substring(0, 5);
	
					String date = r2.getString("date");
					date = date.substring(8, 10) + month(date.substring(5,7));
				%>
	
				<div class="card col-md-9 col-sm-10 shadow">
					<div class="card-body">
						<h5 class="card-title"><%=date%> <%=convertAM(time)%></h5>
						<p class="card-text">
							Dr. <%=r2.getString("firstname")%> <%=r2.getString("lastname")%><br>
							<%=r2.getString("name")%>, <%=r2.getString("city")%>
						</p>
					</div>
				</div>
				<%
					}
				%>
	
	
				<div class="d-flex my-d justify-content-center">End of Results</div>
				<div class="d-flex justify-content-center">Book Appointments to view here</div>
				<br>
	
			</div>
	
		</div>
		
	<!--append this code at bottom of your page-->
    <footer>
      <div class="container">
        <div class="row text-center py-5 justify-content-center text-light">
        
          <div class="col-lg-10 col-md-8 col-sm-6">
            <h1 class="display-4">Queless</h1>
            <p>Book health appointment as per your ease anytime anywhere</p>
            <ul class="social container mt-5">
              <li><a href="#"><i class="fab fa-instagram fa-2x"></i></a></li>
              <li><a href="#"><i class="fab fa-twitter fa-2x"></i></a></li>
              <li><a href="#"><i class="fab fa-facebook fa-2x"></i></a></li>
            </ul>
           </div>
    	</div>
      </div>
      
    </footer>

    <div class="socket text-center text-light py-3 text-capitalize">
      <p>&copy; PBL group 11  all rights are reserved </p>
    </div>
		
	
		<!--Some Scripts-->
		<script
			src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
	
		<script type="text/javascript">
			$(function() {
				$('[data-toggle="popover"]').popover()
			})
		</script>
	
		<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"
			integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj"
			crossorigin="anonymous"></script>
		<script
			src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"
			integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN"
			crossorigin="anonymous"></script>
		<script
			src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"
			integrity="sha384-B4gt1jrGC7Jh4AgTPSdUtOBvfO8shuf57BaghqFfPlYxofvL8/KUEfYiJOMMV+rV"
			crossorigin="anonymous"></script>
    </body>
	
</html>
