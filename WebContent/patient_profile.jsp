<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
    <%@page import ="java.sql.*" %>

	<%		
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/queless?serverTimezone=UTC", "root", "");
		
		String user = (String)session.getAttribute("user");
		PreparedStatement ps= connection.prepareStatement("SELECT * from patient where username like ? ");
		ps.setString(1, user);
		ResultSet result = ps.executeQuery();
		result.next();
		
		
		if (request.getParameter("apply")!=null){
			String firstname = request.getParameter("firstname");
			if(firstname==""){firstname = result.getString("firstname");}
			
			String lastname = request.getParameter("lastname");
			if(lastname==""){lastname = result.getString("lastname");}
			
			String username = request.getParameter("username");
			if(username==""){username = result.getString("username");}
			
			String email = request.getParameter("email");
			if(email==""){email = result.getString("email");}
			
			String password = request.getParameter("password");
			if(password==""){password = result.getString("password");}
			
			String city = request.getParameter("city");
			if(city==""){city = result.getString("city");}
			
			String contact_no = request.getParameter("contact_no");
			if(contact_no==""){contact_no = result.getString("contact_no");}
			
			String age = request.getParameter("age");
			if(age==""){age = result.getString("age");}
			
			String gender=request.getParameter("gender");
			if(gender==""){gender = result.getString("gender");}
			
			String blood_group = request.getParameter("blood_group");
			if(blood_group==""){blood_group = result.getString("blood_group");}
			
			PreparedStatement preparedStatement = connection.prepareStatement("UPDATE patient SET username=?, email=?, password=?, firstname=?, lastname=?, city=?, contact_no=?,age=?,gender=?,blood_group=? WHERE username like ? ");
			preparedStatement.setString(1, username);
			preparedStatement.setString(2, email);
			preparedStatement.setString(3, password);
			preparedStatement.setString(4, firstname);
			preparedStatement.setString(5, lastname);
			preparedStatement.setString(6, city);
			preparedStatement.setString(7, contact_no);
			preparedStatement.setString(8, age);
			preparedStatement.setString(9, gender);
			preparedStatement.setString(10, blood_group);
			
			preparedStatement.setString(11, user);
			
			preparedStatement.executeUpdate();
		}
	%>
    
    
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"
    integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous">
    
    <script src='https://kit.fontawesome.com/a076d05399.js'></script>
    <link href="assets/css/patient_profile.css" rel="stylesheet">
    
    <title>Patient Profile</title>
</head>


<body>
<!-- Nav Bar -->
		<nav class="navbar navbar-expand-lg navbar-dark bg-dark p-3">
			<a class="navbar-brand pl-5" href="#">Queless</a>
			<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarNav">
				<ul class="navbar-nav my-2 my-lg-0 ml-auto align-items-center">
					<li class="nav-item"><a class="nav-link" href="#">Home</a></li>
					<li class="nav-item active"><a class="nav-link" href="#">Patient<span class="sr-only">(current)</span></a></li>
					<li class="nav-item"><a class="nav-link" href="#">About Us</a></li>
					<li class="nav-item"><a class="nav-link" href="#">Rate us</a></li>
					<li class="nav-item dropdown ml-2"><a class="nav-link dropdown-toggle" id="navbarDropdownMenuLink-333" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
							<i class="fas fa-user fa-2x"></i> <%=user %>
					</a>
						<div class="dropdown-menu dropdown-menu-right dropdown-default"aria-labelledby="navbarDropdownMenuLink-333">
							<a class="dropdown-item" href="login.jsp">Log Out</a>
						</div></li>
				</ul>
			</div>
		</nav>
		
		
    <div class="warpper fl">
        <div class="main">
            <div class="head">
                <p>
                    <i class='fas fa-heartbeat' style='font-size:24px'></i>
                    My Profile <i class='fas fa-heartbeat' style='font-size:24px'></i>
                </p>
            </div>
            
            <div class="form fl">
                <form method="post">

                    <p class="name">FULL NAME :
                        <input type="text" name="firstname" placeholder="<%=result.getString("firstname")%>" class="pass" style="margin-left: 45px">
                        <input type="text" name="lastname" placeholder=<%=result.getString("lastname")%> class="pass">
                    </p>
                    
                    <p class="name">USERNAME :<input type="username" name="username" placeholder=<%=result.getString("username")%> class="name-inp" style="margin-left: 52px"></p>

                    <p class="name">EMAIL ID :<input type="email" name="email" placeholder=<%=result.getString("email")%> class="name-inp" style="margin-left: 70px"></p>

                    <p class="name">PASSWORD :<input type="password" name="password" placeholder=<%=result.getString("password")%> class="name-inp" style="margin-left: 49px" >
                    
                    </p>
                    <button id="toggle-password" type="button" class="d-none"></button>
                    
                    <p class="name">CITY :
                    <select id="cars" name="city" class="name-inp" style="margin-left: 106px">
                    		<option><%=result.getString("city")%></option>
                            <option>Select Your City</option>
                            <option>Mumbai</option>
                            <option>Chennai</option>
                            <option>Jaipur</option>
                            <option>Bengaluru</option>
                            <option>Chandigarh</option>
                            <option>Hyderabad</option>
                            <option>Lucknow</option>
                            <option>Gandhinagar</option>
                        </select>
                    </p>

                    <p class="name">CONTACT NO :<input type="tel" name="contact_no" placeholder=<%=result.getString("contact_no")%> class="name-inp" style="margin-left: 45px"> </p>


                    <p class="name">AGE :<input type="number" name="age" placeholder="<%=result.getString("age")%>" class="name-inp" style="margin-left: 110px">
                    </P>
                    

                    <p class="gender">
                        <span class="gen">GENDER :</span>
                        <% String mygender= result.getString("gender");
                        	int check=0;
    					 	if (mygender.matches("M")){check=1;}
    					 	else if (mygender.matches("F")){check=2;}
    					 	else if (mygender.matches("Other")){check=3;}
    					 	
    					   if(check==1){ %> <input type="radio" name="gender" value="M" checked="checked" style="margin-left: 73px"> Male <% } %>
                        <% if(check!=1) { %> <input type="radio" name="gender" value="M" style="margin-left: 73px"> Male <% } %>
                        
                        <% if(check==2) { %><input type="radio" name="gender" value="F" checked="checked" style="margin-left: 15px"> Female<% } %>
                        <% if(check!=2) { %><input type="radio" name="gender" value="F" style="margin-left: 15px"> Female<% } %>
                        
                        <% if(check==3) { %><input type="radio" name="gender" value="Other" checked="checked" style="margin-left: 15px"> Other<% } %>
                        <% if(check!=3) { %><input type="radio" name="gender" value="Other" style="margin-left: 15px"> Other<% } %>
                    </p>
 
                    <p class="name">BLOOD GROUP :
                        <select name="blood_group" class="name-inp" >
                        <option><%=result.getString("blood_group")%></option>
                            <option value="">Select Your Blood Group </option>
                            <option value="A+">A+</option>
                            <option value="A-">A-</option>
                            <option value="B+">B+</option>
                            <option value="B-">B-</option>
                            <option value="O+">O+</option>
                            <option value="O-">O-</option>
                            <option value="AB+">AB+</option>
                            <option value="AB-">AB-</option>
                        </select>
                        
                        <br><br><br>
                    </p><input type="submit" name="apply" value="Apply" class="sub">
                    
                </form>
            </div>
        </div>
    </div>
    
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
    	</div>
      
    </footer>

    <div class="socket text-center text-light py-3 text-capitalize">
      <p>&copy; PBL group 11  all rights are reserved </p>
    </div>
    
    <!-- Some Scripts -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"
    integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj"
    crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"
    integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN"
    crossorigin="anonymous"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"
    integrity="sha384-B4gt1jrGC7Jh4AgTPSdUtOBvfO8shuf57BaghqFfPlYxofvL8/KUEfYiJOMMV+rV"
    crossorigin="anonymous"></script>
    
</body>

</html>
