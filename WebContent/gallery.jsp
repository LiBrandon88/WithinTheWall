<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %> 
<%@ page import="java.util.ArrayList" %> 


<!DOCTYPE html>
<html lang="en" dir="ltr">
<head>
  <meta charset="utf-8">
  <title>Within the Walls Virtual Tours</title>
  <link rel = "icon" href =
  "https://i.ibb.co/DYx2kh0/Logo.png"
  type = "image/x-icon">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
  <link rel="stylesheet" href="stylesheet.css">
  
  <%
  	String[] tours = new String[5];
  	String[] clips = new String[5];
    int x = 0;
    int y = 0; 
  //ArrayList<String> tours = new ArrayList<>();
  //ArrayList<String> clips = new ArrayList<>(); -->
  boolean nullCheckT = true;
  boolean nullCheckC = true;

  Class.forName("com.mysql.jdbc.Driver");
String dbURL = "jdbc:mysql://localhost:3306/newschema"; 
Connection con = DriverManager.getConnection(dbURL, "root", "Hakar123");
Statement stmnt = con.createStatement();
String inquiryQ = "Select URL, type from virtualTour where display = true";
ResultSet res = stmnt.executeQuery(inquiryQ);
while(res.next()){
		String type = res.getString(2);
		if(type.equals("tour")){
			tours[x] = res.getString(1);
			nullCheckT = false;
			x++;
		}else if(type.equals("clip")){
			clips[y] = res.getString(1);
			nullCheckC = false;
			y++;
		}
}
if(nullCheckT == true){
	tours[0] = "about:blank";
} 
if(nullCheckC == true){
	clips[0] = "null";
}


StringBuffer sb = new StringBuffer();
sb.append("[");
for (int i = 0; i < tours.length; i++) {
    sb.append("\"").append(tours[i]).append("\"");
    if (i + 1 < tours.length) {
        sb.append(",");
    }
}
sb.append("]");
String jsToursString = sb.toString();

StringBuffer sb2 = new StringBuffer();
sb2.append("[");
for (int i = 0; i < clips.length; i++) {
    sb2.append("\"").append(clips[i]).append("\"");
    if (i + 1 < clips.length) {
        sb2.append(",");
    }
}
sb2.append("]");
String jsClipsString = sb2.toString();
%>
  
 <script>
  
var a = 0;
 var b = 0;  
 var jsTours = <%= jsToursString%>
 var jsClips = <%= jsClipsString%>
 
function forward(){
     a++;
    if(a == <%=x%>){
      a = 0;
    } 
 document.getElementById('myFrame').src = jsTours[a];
	
}

 function backward(){
    a--;
    if(a < 0){
      a = <%=x%> - 1;
    }
    document.getElementById("myFrame").src = jsTours[a];
  }
  function forward2(){
    b++;
    if(b == <%=y%>){
      b = 0;
    }
    document.getElementById("video-bg").src = jsClips[b];
  }
  function backward2(){
    b--;
    if(b < 0){
      b = <%=y%> - 1;
    }
    document.getElementById("video-bg").src = jsClips[b];
  } 
  
  </script>
</head>


<body>
  <header>
  <nav class="navigation">
    <div class="navbar-logo" onclick = "location.href='index.html';">
      <div style="float:left;">
        <a><img src="https://i.ibb.co/DYx2kh0/Logo.png" alt="Logo" height="75" width="75"></a>
      </div>
      <div style="padding-top: 20px; display: inline-block;">
        <a>Within the Walls Virtual Tours</a>
      </div>
    </div>
    <div class="navbar-right">
      <a href="about.html">About</a>
      <a href="gallery.jsp">Gallery</a>
      <a href="request.html">Request Quote</a>
      <a href="contactus.html">Contact</a>
    </div>
    <div class="admin-log">
        <a href ="#" onclick="document.getElementById('idLogin').style.display='block'" style="width:auto;">Admin Login</a>
    </div>
  </nav>
  <div id="idLogin" class="modal">

    <form class="modal-content animate" action="admin.jsp" method="post">
      <div class="imgcontainer">
        <span onclick="document.getElementById('idLogin').style.display='none'" class="close" title="Close Modal">&times;</span>
        <img src="https://i.ibb.co/DYx2kh0/Logo.png" alt="logo" class="logo">
      </div>

      <div class="container">
        <label><b>Admin Username</b></label>
        <input type="text" placeholder="Enter Admin Username" pattern = "admin"  oninvalid="setCustomValidity('Incorrect Username')" name="username" required>

        <label><b>Admin Password</b></label>
        <input type="password" placeholder="Enter Password"  pattern = "password" oninvalid="setCustomValidity('Incorrect Password')"  name="password" required>

        <button type="submit">Login</button>
        <label>
          <input type="checkbox" checked="checked" name="remember"> Remember me
        </label>
      </div>

      <div class="container" style="background-color:#f1f1f1">
        <button type="button" onclick="document.getElementById('idLogin').style.display='none'" class="cancelbtn">Cancel</button>
        <span class="psw">Forgot <a href="#">password?</a></span>
      </div>
    </form>
  </div>

  <script>
  // Get the modal
  var modal = document.getElementById('id01');

  // When the user clicks anywhere outside of the modal, close it
  window.onclick = function(event) {
    if (event.target == modal) {
      modal.style.display = "none";
    }
  }
  </script>
  
  </header>
    <div class="virtualTours">
    <p class="pt">Interactive Tours</p>
    <iframe id="myFrame" style="max-width: 100%;" width="1200" height="520" allowfullscreen src="<%=tours[0]%>"></iframe>
    <div class="leftT">
      <button onclick="backward()" class="change"> &lt; </button>
    </div>
    <div class="rightT">
      <button onclick="forward()" class="change"> > </button>
    </div>
  </div>

  <div class="video-container2">
    <p class="pt2">Virtual Clips</p>
    <video id="video-bg" controls="controls">
      <source src="<%=clips[0]%>" type="video/mp4">
      </video>
      <div class="leftV">
        <button onclick="backward2()" class="change"> &lt; </button>
      </div>
      <div class="rightV">
        <button onclick="forward2()" class="change"> > </button>
      </div>
    </div>
    <footer>
      <div class = "footer">
        <p style="color: white; font-family: Chalkduster"> Find us on Social Media: </p>
        <a href="https://www.facebook.com/WithintheWallsTours/"  target="_blank" class="fa fa-facebook"></a>
        <a href="https://www.linkedin.com/company/within-the-walls-virtual-tours/"  target="_blank" class="fa fa-linkedin"></a>
        <a href="https://www.instagram.com/withinthewallstours/"  target="_blank" class="fa fa-instagram"></a>
      </div>
    </footer>

  </body>
  </html>
