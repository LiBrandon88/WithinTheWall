<!DOCTYPE html>
<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %> 
<%@ page import="java.util.ArrayList" %> 


<html lang="en" dir="ltr">
<head>
<meta charset="utf-8">
<title>Within the Walls Virtual Tours</title>
    <link rel="stylesheet" href="stylesheet.css">
    <link rel = "icon" href =
    "https://i.ibb.co/DYx2kh0/Logo.png"
    type = "image/x-icon">
    </head>

    <div class="navbar-logo" onclick = "location.href='index.html';">
        <div style="float:left;">
          <a><img src="https://i.ibb.co/DYx2kh0/Logo.png" alt="Logo" height="75" width="75"></a>
        </div>
        <div style="padding-top: 20px; display: inline-block;">
          <a>Within the Walls Virtual Tours</a>
        </div>
      </div>

    <h2>Welcome Admin!</h2>

    <div class="tab">
      <button class="tabButton" onclick="openTab(event, 'Inquiries')" id="defaultOpen">Inquiries</button>
      <button class="tabButton" onclick="openTab(event, 'Messages')">Messages</button>
      <button class="tabButton" onclick="openTab(event, 'CompletedOrders')">Completed Orders</button>
      <button class="tabButton" onclick="openTab(event, 'EditBrowseContent')">Edit Browse Content</button>
    </div>

    <div id="Inquiries" class="tabcontent">
          <h3>INQURIES</h3>

      		<%
      			Class.forName("com.mysql.jdbc.Driver");
	        	String dbURL = "jdbc:mysql://localhost:3306/newschema"; 
	       	 	Connection con = DriverManager.getConnection(dbURL, "root", "Hakar123");
	       	 	Statement stmnt = con.createStatement();
				%>
				<table id = "inquiryTable">
				<th>Order Number</th>
				<th>Customer Name</th>
				<th>Customer Email</th>
				<th>Business</th>
				<th>Business Size</th>
				<th>Time</th>
				<%
				
				String inquiryQ = "Select Inquiry.InquiryId, Customer.Name, Customer.Email, Inquiry.BusinessType, Inquiry.Size, Inquiry.Timestamp from Inquiry, Customer where ((FK_Inquiry_CustomerId = Customer.CustomerId) ";
				inquiryQ += "and (Inquiry.Complete = 0))";
				ResultSet resInq = stmnt.executeQuery(inquiryQ);
				%>

				<% int i = 0;
 					while(resInq.next()) { 
						i = resInq.getInt(1);
 					%>

					<tr>
						<td id = "inquiry_row<%=i%>">
							<%= i%>
						</td>
						<td>
							<%= resInq.getString(2)%>
						</td>
						<td>
							<%= resInq.getString(3)%>
						</td>
						<td>
							<%= resInq.getString(4)%>
						</td>
						<td>
							<%= resInq.getInt(5)%>
						</td>
						<td>
							<%= resInq.getString(6)%>
						</td>
						<td id = "Complete Order>">
							<input type="button" value="Complete Order #<%=i%>" onclick="complete(<%=i%>), document.getElementById('idOrder').style.display='block';" style="width:auto;">
							 			    
						</td>
					</tr>
					<%
					i++;
				}//while
				resInq.close();
				stmnt.close();
				
      			%>          
      		</table>
      </div>
  <div id="idOrder" class="modal">

    <form class="modal-content animate" action="WithinTheServlet" method="post">
      <div class="imgcontainer">
        <span onclick="document.getElementById('idOrder').style.display='none'" class="close" title="Close Modal">&times;</span>
        <img src="https://i.ibb.co/DYx2kh0/Logo.png" alt="logo" class="logo">
      </div>

      <div class="container">
        <label><b>Price</b></label>
		<input type="number" min="0.00" max="10000.00" step="0.01" placeholder="Enter Price" name="price" required>
        <label><b>Tour Link</b></label>
        <input type="url" placeholder="Enter Url to Tour" name="tourLink" pattern="https://.*" size="30" required>
        <label><b>Tour Name</b></label>
        <input type="text" placeholder="Enter Tour Name" name="tourName" required>
        <input type="radio" name="tourType" value="tour" required> Virtual Tour<br>
  		<input type="radio" name="tourType" value="clip"> Virtual Clip<br>
 		<input id="page" name="page" type="hidden" value="complete">
		<input id="inquiryId" name="inquiryId" type="hidden">
 		<button type="submit" >Complete Order</button>
 		
      </div>

      <div class="container" style="background-color:#f1f1f1">
        <button type="button" onclick="document.getElementById('idOrder').style.display='none'" class="cancelbtn">Cancel</button>
=      </div>
    </form>
  </div>

  <script>
  // Get the modal
  var modal = document.getElementById('id01');
  var id = document.getElementById("inquiryId"); 

  function complete(val){
	 	console.log(val);
	 	id.setAttribute('value', val); 
	}

  // When the user clicks anywhere outside of the modal, close it
  window.onclick = function(event) {
    if (event.target == modal) {
      modal.style.display = "none";
    }
  }
  </script>
  
    <div id="Messages" class="tabcontent">
 		<h3>Completed Orders</h3>
 			 <%
      			Class.forName("com.mysql.jdbc.Driver");
	       	 	Statement msgGet = con.createStatement();
				String getMessageQ = "Select Customer.Name, Customer.Email, Message.subject, Message.Message, Message.Timestamp from Message, Customer where ((FK_Message_CustomerId = Customer.CustomerId)) ";
				ResultSet msgResults = msgGet.executeQuery(getMessageQ);

				%>
				<Table>
				
				<th>Customer Name</th>
				<th>Customer Email</th>
				<th>Subject</th>
				<th>Message</th>
				<th>Time</th>
				
				<% while (msgResults.next()) { %>
			<%-- 	<% String content = msgResults.getString(4);%>
				<%int white = 0; %>
				<% for(int j = 0; i < content.length(); i++){ 
					String temp = content.substring(j, j+1);
					if(temp.equals(" ")){
						white++;
						if(white == 3){
						%>
							<br>
						<% 	
						}
					}
				 }%> --%>
					<tr>
						<td>
							<%= msgResults.getString(1)%>
						</td>
						<td>
							<%= msgResults.getString(2)%>
						</td>
						<td>
							<%= msgResults.getString(3)%>
						</td>
						<td>
							<%= msgResults.getString(4)%>
						</td>
						<td>
							<%= msgResults.getString(5)%>
						</td>
					</tr>
					<%
					
				}//while
				msgResults.close();
				msgGet.close();
      			%>  
      		</Table>
    </div>

    <div id="CompletedOrders" class="tabcontent">
    	<h3>Completed Orders</h3>
           		<%
      			Class.forName("com.mysql.jdbc.Driver");
	       	 	Statement orderS1 = con.createStatement();
				%>
				<Table>
				<%

				String query = "Select Customer.Name, Inquiry.BusinessType, VirtualTour.Name, CompletedOrder.Price, CompletedOrder.Timestamp  from Customer, Inquiry, VirtualTour, "; 
				query += "CompletedOrder where ((Inquiry.InquiryId = CompletedOrder.PK_FK_OrderId) and (Customer.CustomerId = FK_Inquiry_CustomerId) and (VirtualTour.TourId = CompletedOrder.TourId))";
				ResultSet orderResults = orderS1.executeQuery(query);

				%>
				<th>Customer Name</th>
				<th>Business Type</th>
				<th>Tour Name</th>
				<th>Price</th>
				<th>Time</th>
				
				<% while (orderResults.next()) { %>
					<tr>
						<td>
							<%= orderResults.getString(1)%>
						</td>
						<td>
							<%= orderResults.getString(2)%>
						</td>
						<td>
							<%= orderResults.getString(3)%>
						</td>
						<td>
							$<%= orderResults.getDouble(4)%>
						</td>
						<td>
							<%= orderResults.getString(5)%>
						</td>
					</tr>
					<%
					
				}//while
				orderResults.close();
				orderS1.close();
      			%>  
      		</Table>

    </div>

    <div id="EditBrowseContent" class="tabcontent">
        <h3>Edit Browse Contents</h3>
           		<%
      			Class.forName("com.mysql.jdbc.Driver");
	       	 	Statement tourS1 = con.createStatement();
				%>
				<input type = "button" value = "Add a Tour" onclick = "document.getElementById('idAddTour').style.display='block'" >
				<Table>
				<th>Tour Name</th>
				<th>Tour Type</th>
				<th>Being Displayed?</th>
				
				<%

				String tourQuery = "select VirtualTour.TourId, VirtualTour.Name, VirtualTour.Type, VirtualTour.Display from VirtualTour ";
				ResultSet tourResults = tourS1.executeQuery(tourQuery);

				%>
				<% int x = 0;
					boolean d = false;
					while (tourResults.next()) { 
					x = tourResults.getInt(1);
					d = tourResults.getBoolean(4);
					%>
					<tr>
						<td>
							<%= tourResults.getString(2)%>
						</td>
						<td>
							<%= tourResults.getString(3)%>
						</td>
							<% 
								if(d == true) {
								%>
								<td>
									Yes
								</td>
								<td>
									<form action="WithinTheServlet" method="post">
									<input id="page" name="page" type="hidden" value="tour">
									<input id="tourId" name="tourId" type="hidden" value="<%=x%>">
									<input id="display" name="display" type="hidden" value="<%=d%>">					
									<input type="submit" value="Don't Display">
									</form>
									
								</td>
								<% }
							else {
								%>
								<td>
									No
								</td>
								<td>
									<form action="WithinTheServlet" method="post">
									<input id="page" name="page" type="hidden" value="tour">
									<input id="display" name="display" type="hidden" value="<%=d%>">
									<input id="tourId" name="tourId" type="hidden" value="<%=x%>">
									<input type="submit" value="Display Tour">
									</form>
									
								</td>
						<%
							}
							%>	 			   
					</tr>
					<%
					
				}//while
				tourResults.close();
				tourS1.close();
      			%>  
      		</Table>
      		  <div id="idAddTour" class="modal">

    		<form class="modal-content animate" action="WithinTheServlet" method="post">
      		<div class="imgcontainer">
        		<span onclick="document.getElementById('idAddTour').style.display='none'" class="close" title="Close Modal">&times;</span>
        		<img src="https://i.ibb.co/DYx2kh0/Logo.png" alt="logo" class="logo">
      		</div>

     		 <div class="container">
        		<label><b>Enter Tour Name</b></label>
				 <input type="text" placeholder="Enter Tour Name" name="tourName" required>
        		<label><b>Enter URL:</b></label>
        		<input type="url" placeholder="Enter Url to Tour" name="tourLink" pattern="https://.*" size="30" required><br>
       			 <label><b>Display?</b></label><br>
        		 <input type="radio" name="displayTour" value="yes" required> Display<br>
  				<input type="radio" name="displayTour" value="no"> Do not display<br>
  				<label><b>Tour Type:</b></label><br>
        		<input type="radio" name="tourType" value="tour" required> Virtual Tour<br>
  				<input type="radio" name="tourType" value="clip"> Virtual Clip<br>
 				<input id="page" name="page" type="hidden" value="addTour">
 				<button type="submit" >Add Tour</button>
 		
      		</div>

      		<div class="container" style="background-color:#f1f1f1">
        	<button type="button" onclick="document.getElementById('idAddTour').style.display='none'" class="cancelbtn">Cancel</button>
=      		</div>
    		</form>
  			</div>

    	</div>

    <script>
    
    var tId = document.getElementById("tourId"); 

    function updateTour(val){
  	 	console.log(val);
  	 	tId.setAttribute('value', val); 
  	}
    
    function openTab(evt, tabName) {
      var i, tabcontent, tabButton;
      tabcontent = document.getElementsByClassName("tabcontent");
      for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
      }
      tabButton = document.getElementsByClassName("tabButton");
      for (i = 0; i < tabButton.length; i++) {
        tabButton[i].className = tabButton[i].className.replace(" active", "");
      }
      document.getElementById(tabName).style.display = "block";
      evt.currentTarget.className += " active";
    }

      // Get the element with id="defaultOpen" and click on it
      document.getElementById("defaultOpen").click();

      function delete_row(no)
      {
       document.getElementById("row"+no+"").outerHTML="";
      }
    </script>



