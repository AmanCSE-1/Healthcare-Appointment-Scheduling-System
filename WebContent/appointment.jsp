<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
    <%@page import ="java.sql.*" %>
    <%@page import ="codeGenerator.*" %>
    
    
	<%		
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/queless?serverTimezone=UTC", "root", "");
		
		String doctorId = request.getParameter("doctorId");
		if (doctorId == null) doctorId="1";
		String user = (String)session.getAttribute("user");
		
		PreparedStatement ps = connection.prepareStatement("SELECT * FROM `doctor` JOIN hospital JOIN working_hour ON doctor.hospital_id=hospital.hospital_id AND doctor.doctor_id=working_hour.doctor_id WHERE doctor.doctor_id = ? ");
		ps.setString(1, doctorId);
		ResultSet result = ps.executeQuery();
		result.next();
		
		PreparedStatement ps2 = connection.prepareStatement("SELECT * FROM `availability` WHERE doctor_id =? and status= \"Unreserved\" ");
		ps2.setString(1, doctorId);
		ResultSet rs2 = ps2.executeQuery();
		rs2.next();
		
		
		if (request.getParameter("bookapp") != null) {
			String query1 = "INSERT INTO `appointment`(`unique_code`, `date`, `time`, `username`, `doctor_id`) VALUES (?, ?, ?, ?, ?)";
			PreparedStatement ps4 = connection.prepareStatement(query1);
			
			codeGenerator cg = new codeGenerator();
			String uniqueCode = cg.getCode(6);
			ps4.setString(1, uniqueCode);
			ps4.setString(2, rs2.getString("date"));
			ps4.setString(3, rs2.getString("time"));
			ps4.setString(4, user);
			ps4.setString(5, doctorId);
			ps4.executeUpdate();
			
			String query2 = "UPDATE `availability` SET status =\"Reserved\" WHERE doctor_id =? and date =? and time =?";
			ps = connection.prepareStatement(query2);
			
			ps.setString(1, doctorId);
			ps.setString(2, rs2.getString("date"));
			ps.setString(3, rs2.getString("time"));
			ps.executeUpdate();	
	%>	
	
	<script type="text/javascript">
		alert("Appointment Booked Successfully!");
	</script>
	
   <%	response.setIntHeader("Refresh", 1);
  		}
		
	%> 
	
   
   <%!	public String convertday (String day){
	   
			if (day.matches("0")) return "Sunday";
			else if (day.matches("1")) return "Monday";
			else if (day.matches("2")) return "Tuesday";
			else if (day.matches("3")) return "Wednesday";
			else if (day.matches("4")) return "Thursday";
			else if (day.matches("5")) return "Friday";
			else if (day.matches("6")) return "Saturday";
			
			return "Error!";
	}	
   
   		public String convertAM (String time){
			int hour = Integer.valueOf(time.substring(0,2));
			String temp="AM";
			
			if (hour == 12) 
				temp="PM"; 
			else if (hour > 12) { 
				hour -=12; 
				temp="PM";
				}
			
			if(hour<10)
				return "0" + String.valueOf(hour) + time.substring(2, 5) + " " + temp;
			
			return String.valueOf(hour) + time.substring(2, 5) + " " + temp;
   		}
   		
   		
	%>
	
	
    
    
    
<!doctype html>
<html lang="en">

<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css"
        integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2" crossorigin="anonymous">
    <link rel="stylesheet" href="assets/css/appointment.css">
    <script src="https://kit.fontawesome.com/eaa49e7ea2.js" crossorigin="anonymous"></script>
    <title>Appointment</title>
    
</head>

<body>

    <!-- Nav Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark p-3">
        <a class="navbar-brand pl-5" href="#">Queless</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav"
            aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav my-2 my-lg-0 ml-auto align-items-center">
                <li class="nav-item"><a class="nav-link" href="#">Home</a></li>
                <li class="nav-item active"><a class="nav-link" href="#">Patient <span class="sr-only">(current)</span></a></li>
                <li class="nav-item"> <a class="nav-link" href="#">About Us</a> </li>
                <li class="nav-item"> <a class="nav-link" href="#">Contact Us</a>  </li>
                <li class="nav-item dropdown ml-2">
                    <a class="nav-link dropdown-toggle" id="navbarDropdownMenuLink-333" data-toggle="dropdown"
                        aria-haspopup="true" aria-expanded="false">
                        <i class="fas fa-user fa-2x"></i> <%=user %>
                    </a>
                    <div class="dropdown-menu dropdown-menu-right dropdown-default"
                        aria-labelledby="navbarDropdownMenuLink-333">
                        <a class="dropdown-item" href="patient_profile.jsp">My Account</a>
                        <a class="dropdown-item" href="login.jsp">Log Out</a>
                    </div>
                </li>
            </ul>

        </div>
    </nav>

    <!--Card-->
    <div class="container mt-5">
        <div class="container my-card rounded">
            <div class="row shadow py-3 my-5">
                <div class="col-lg-4 col-md-4 col-sm-12 my-card-img">
                    <img src="assets/img/Doctor.png" alt="" class="card-img">
                </div>

                <div class="col-lg-4 col-md-5 col-sm-12 mt-2">
                    <h1 class="card-title">Dr. <%=result.getString("firstname")%> <%=result.getString("lastname")%></h1>
                    <p class="card-text" style="font-size: 17px;">
                    		<b><%=result.getString("name")%>, <%=result.getString("city")%><br>
                            Specialist : <%=result.getString("specialist") %></b><br>
                        	Qualification : <%=result.getString("qualification") %><br>
                        	Age : <%=result.getString("age") %> years<br>
                        	Experience : <%=result.getString("experience") %> years
                    </p>
                </div>

                <div class="d-flex justify-content-center my-ratings col-lg-4 col-md-3 col-sm-12 mt-2">
                    <!--Ratings-->
                    <div class="d-flex">
                        <span class="text" style="font-size:17px">Ratings<br>
                        
				              <%float ratings = result.getFloat("ratings");
				              	for(int i=1; i<=ratings; i++) { %>
				              		<i class="fas fa-star"></i>
				              <% 	}	
				              	if (result.getInt("ratings") != result.getFloat("ratings")) { %>
				              	<i class="fas fa-star-half"></i>
				             <% } %>
				             
                        </span>
                    </div>
                </div>

            </div>

        </div>

        <!--Working Hours-->
        <div class="d-flex justify-content-center">
            <h4>Working Hours <i class="fas fa-clock"></i></h4>
        </div>
        <div class="d-flex justify-content-center">
            <table class="table table-bordered col-lg-10 col-md-12 col-sm-12">
                <thead class="thead-light">
                    <tr>
                        <th scope="col">Slot</th>
                        
                        <%  int day = result.getInt("day");
                    		int array[] = new int[3], i=0;
                    		while(day>0){
                    			array[i++]=day%10;
                    			day/=10;
                    		}
                    		
                    		String day1 = convertday(String.valueOf(array[2]));
                    		String day2 = convertday(String.valueOf(array[1]));
                    		String day3 = convertday(String.valueOf(array[0]));
                        %>
                        
                        <th scope="col"><%=day1 %></th>
                        <th scope="col"><%=day2 %></th>
                        <th scope="col"><%=day3 %></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <th scope="row">Morning</th>
                        <td><%= convertAM(result.getString("m_start")) %> to <%= convertAM(result.getString("m_end")) %></td>
                        <td><%= convertAM(result.getString("m_start")) %> to <%= convertAM(result.getString("m_end")) %></td>
                        <td><%= convertAM(result.getString("m_start")) %> to <%= convertAM(result.getString("m_end")) %></td>
                    </tr>
                    <tr>
                        <th scope="row">Evening</th>
                        <td><%= convertAM(result.getString("e_start")) %> to <%= convertAM(result.getString("e_end")) %></td>
                        <td><%= convertAM(result.getString("e_start")) %> to <%= convertAM(result.getString("e_end")) %></td>
                        <td><%= convertAM(result.getString("e_start")) %> to <%= convertAM(result.getString("e_end")) %></td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!--Slot Availability-->
        <br>
        <div class="row justify-content-center">
        	<%  String year = rs2.getString("date").substring(0,4);
        		String month = rs2.getString("date").substring(5,7);
        		String date = rs2.getString("date").substring(8,10);
        		
        		String time = rs2.getString("time").substring(0,5);
        	%>
        	
            <h5 style="color: #E83151;">Slot Available: <%=date%>/<%=month %>/<%=year %> <%=convertAM(time) %> <i class="fas fa-check-circle"></i></h5>
        </div>
        
        <form method="post">
        <div class="row justify-content-center">
        	<button type="submit" name="bookapp" class="btn btn-dark"style="background-color: #E83151;">Book Appointment</button>
        </div>
        </form>
    </div>

<br><br>
	<!--append this code at bottom of your page-->
    <footer>
      <div class="container">
        <div class="row text-center py-5 justify-content-center text-light">
        
          <div class="col-lg-10 col-md-8 col-sm-6">
            <h1 class="display-4">Queless</h1>
            <p>book appointment as per your ease anytime anywhere</p>
            <ul class="social container mt-5">
              <li><a href="#"><i class="fab fa-instagram fa-2x"></i></a></li>
              <li><a href="#"><i class="fab fa-twitter fa-2x"></i></a></li>
              <li><a href="#"><i class="fab fa-facebook fa-2x"></i></a></li>
            </ul>
           </div>
    	</div>
      
    </footer>

    <div class="socket text-center text-light py-3 text-capitalize">
      <p>&copy; PBL group 11  all rights are reserved </p>
    </div>
    
    
    <!--jQuery, Popper.js, and Bootstrap JS-->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"
        integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj"
        crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"
        integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN"
        crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.min.js"
        integrity="sha384-w1Q4orYjBQndcko6MimVbzY0tgp4pWB4lZ7lr30WKz0vr/aWKhXdBNmNb5D92v7s"
        crossorigin="anonymous"></script>
</body>

</html>
