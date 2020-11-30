package servlet;

import java.io.IOException;
import java.util.Calendar;
import javax.servlet.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;

/**
 * Servlet implementation class WithinTheServlet
 */
@WebServlet("/WithinTheServlet")
public class WithinTheServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public WithinTheServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setContentType("text/html");
		String type = request.getParameter("page");
		try {

			Connection connection = DBConnection();
			
			if(type.equals("addTour")) {
				String display = request.getParameter("displayTour");
				boolean d;
				if(display.equals("yes")) {
					d = true;
				}
				else {
					d = false;
				}
				String tourType = request.getParameter("tourType");
				String tourName = request.getParameter("tourName");
				String link = request.getParameter("tourLink");
				
				String addTour = "insert into VirtualTour (Name, URL, Display, Type) values (?, ?, ?, ?)";
				PreparedStatement addT = connection.prepareStatement(addTour);
				addT.setString(1, tourName);
				addT.setString(2, link);
				addT.setBoolean(3, d);
				addT.setString(4, tourType);

				addT.executeUpdate();
				addT.close();
	           	connection.close(); 
            	RequestDispatcher view = request.getRequestDispatcher("admin.jsp");
            	view.forward(request, response);


			}
			if(type.equals("tour")) {
				String tourId = request.getParameter("tourId");
				String display = request.getParameter("display");
				boolean d = Boolean.parseBoolean(display);
				if(d == true) {
					d = false;
				}
				else {
					d = true;
				}
				String updateTour = "UPDATE VirtualTour SET Display =  "+ d +"  WHERE TourId = " + tourId;
				PreparedStatement updateT = connection.prepareStatement(updateTour);
				updateT.executeUpdate();
				updateT.close();
	           	connection.close(); 
            	RequestDispatcher view = request.getRequestDispatcher("admin.jsp");
            	view.forward(request, response);
				
			}
		    
			if(type.equals("complete")) {

				String link = request.getParameter("tourLink");
				String num = request.getParameter("price");
				String name = request.getParameter("tourName");
				String id = request.getParameter("inquiryId");
				String tourType = request.getParameter("tourType");
				int inquiry = Integer.parseInt(id);
				double price = Double.parseDouble(num);

				String updateI = "UPDATE Inquiry SET Complete = 1 WHERE InquiryId = " + inquiry;
				PreparedStatement updateS = connection.prepareStatement(updateI);
				updateS.executeUpdate();
				updateS.close();

				String insertTour = "insert into VirtualTour (Name, URL, Display, Type) " + " values (?, ?, ?, ?)";
            	PreparedStatement storeTour = connection.prepareStatement(insertTour, Statement.RETURN_GENERATED_KEYS);
            	storeTour.setString(1, name);
            	storeTour.setString(2, link);
            	storeTour.setBoolean(3, false);
            	storeTour.setString(4, tourType);
            	storeTour.executeUpdate();        	

            	ResultSet rs = storeTour.getGeneratedKeys();
            	rs.next();
            	int tourId = rs.getInt(1);
            	storeTour.close();

				String insertO = "insert into CompletedOrder (PK_FK_OrderId, TourId, Price, Timestamp) values (?, ?, ?, ?)";
				PreparedStatement completeO = connection.prepareStatement(insertO);
				completeO.setInt(1, inquiry);
				System.out.println(id);
				completeO.setInt(2, tourId);
				System.out.println(tourId);
				completeO.setDouble(3, price);
				Timestamp timeStamp = new java.sql.Timestamp(Calendar.getInstance().getTime().getTime());
				completeO.setTimestamp(4, timeStamp);
				completeO.executeUpdate();       
				completeO.close();
            	connection.close(); 
            	RequestDispatcher view = request.getRequestDispatcher("admin.jsp");
            	view.forward(request, response);

			}
	      //Checks the html page is contact, or requestInquiry
			if(type.equals("contact")) {
				String name = request.getParameter("name");
				String email = request.getParameter("email");
					email = email.toLowerCase();
	            String query = "SELECT * from Customer where (Name = ? and Email = ?)";

	            PreparedStatement user = connection.prepareStatement(query);
	            user.setString(1, email);
	            user.setString(2, email);
	            ResultSet r=user.executeQuery();
	            
	            int customerId;
	            //if user exists
	            if(r.next()) {

	            	customerId = r.getInt("CustomerId");
	            	user.close();
	            }
	            else {
	            	//else, store in database and get id
	            	String q = "insert into Customer (Name, Email) " + " values (?, ?)";
	            	PreparedStatement storeUser = connection.prepareStatement(q, Statement.RETURN_GENERATED_KEYS);
	            	storeUser.setString(1, name);
	            	storeUser.setString(2, email);
	            	storeUser.executeUpdate();        	

	            	ResultSet rs = storeUser.getGeneratedKeys();
	            	rs.next();
	            	customerId = rs.getInt(1);
	            	user.close();
	            	storeUser.close();
	            }

				String subject = request.getParameter("subject");

				String message = request.getParameter("message");

				Timestamp timeStamp = new java.sql.Timestamp(Calendar.getInstance().getTime().getTime());

				PreparedStatement storeMessage = connection.prepareStatement("insert into Message (FK_Message_CustomerId, Subject, Message, Timestamp)" + " values (?, ?, ?, ?)");
				
	            storeMessage.setInt(1, customerId);
				storeMessage.setString(2, subject);
				storeMessage.setString(3, message);
				storeMessage.setTimestamp(4, timeStamp);
	            storeMessage.executeUpdate();

	            storeMessage.close(); 
	            connection.close(); 
	            RequestDispatcher view = request.getRequestDispatcher("index.html");
	            view.forward(request, response);
			}
			else {
				String name = request.getParameter("name");
				String email = request.getParameter("email");
					email = email.toLowerCase();
				String buisnessType = request.getParameter("business");
				Timestamp timeStamp = new java.sql.Timestamp(Calendar.getInstance().getTime().getTime());
				String sizeString = request.getParameter("size");
				int size = Integer.parseInt(sizeString);
				
				String query = "SELECT * from Customer where (Name = ? and Email = ?)";

				PreparedStatement user = connection.prepareStatement(query);
				user.setString(1, name);
				user.setString(2, email);
				ResultSet r=user.executeQuery();
				int customerId;
				//if user exists
				if(r.next()) {
					customerId = r.getInt("CustomerId");
					user.close();

				}
				else {
					//else, store in database and get id
					String q = "insert into Customer (Name, Email) " + " values (?, ?)";
					PreparedStatement storeUser = connection.prepareStatement(q, Statement.RETURN_GENERATED_KEYS);
					storeUser.setString(1, name);
					storeUser.setString(2, email);
					storeUser.executeUpdate(); 


					ResultSet rs = storeUser.getGeneratedKeys();
					rs.next();
					customerId = rs.getInt(1);
					user.close();
					storeUser.close();
				}	

				PreparedStatement storeInq = connection.prepareStatement("insert into Inquiry (FK_Inquiry_CustomerId, BusinessType, Size, Timestamp, Complete)" + " values (?, ?, ?, ?, ?)");
				storeInq.setInt(1, customerId);
				storeInq.setString(2, buisnessType);
				storeInq.setInt(3, size);
				storeInq.setTimestamp(4, timeStamp);
				storeInq.setBoolean(5, false);
            	storeInq.executeUpdate();

            	storeInq.close(); 
            	connection.close(); 
            	RequestDispatcher view = request.getRequestDispatcher("index.html");
            	view.forward(request, response);
			}
	       
		}
		catch (Exception e){
			
		} 
		
	}
	
	   public Connection DBConnection() throws ClassNotFoundException, SQLException{
	        Class.forName("com.mysql.jdbc.Driver");
	        String dbURL = "jdbc:mysql://localhost:3306/newschema"; 
	        Connection connection = DriverManager.getConnection(dbURL, "root", "Hakar123");
	        return connection;
	    }

}
