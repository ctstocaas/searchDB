<%-- 
    Document   : index
    Created on : Apr 12, 2016, 10:57:06 AM
    Author     : Administrator
--%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ page import="java.net.InetAddress" %>
  
<c:set var="register_data" value="false" />
<c:if test="${param.txtFirstName!=null}">

<sql:update var="result" dataSource="jdbc/searchDB">
    INSERT INTO Counselor (counselor_id, first_name, nick_name, last_name, telephone, email, member_since) VALUES (null,?,?,?,?,?,now());
     <sql:param value="${param.txtFirstName}"/>
     <sql:param value="${param.txtNickName}"/>
     <sql:param value="${param.txtLastName}"/>
     <sql:param value="${param.txtTelephone}"/>
     <sql:param value="${param.txtEmail}"/>
 </sql:update>    
<sql:update var="result" dataSource="jdbc/searchDB">
    INSERT INTO Subject (subject_id, name, description, counselor_idfk) VALUES (null,?,?,LAST_INSERT_ID());
     <sql:param value="${param.txtSubjectName}"/>
     <sql:param value="${param.txtSubjectDescription}"/>
     
</sql:update>
 
<c:set var="register_data" value="true" /> 

</c:if>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
       <link rel="stylesheet" type="text/css" href="style.css">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>IT Consultant Directory</title>
        <link rel="SHORTCUT ICON" href="images/cognizant_favicon.ico" type="image/ico">
 
    </head>
    <body>
	    <!--  prevent a resubmit on refresh and back button using following javascript code -->
	    <script>
		    if ( window.history.replaceState ) {
		        window.history.replaceState( null, null, window.location.href );
		    }
		</script>
      	<img src="images/cognizant-logo-white.png" alt="cognizant-logo-white" height="73" width="340">

        <h1>IT Consultant Directory</h1>
        <h3>  
        Welcome to Directory of IT consultants. <br><br>
        Here you can find contacts of IT Consultants on various technologies. <br><br>
        If you are an IT Consultant, you can add your contact details in this directory. 
        </h3>

		<table class="search" border="0" style="width:100%" >
			<tbody>
				<tr>
			     	
			     		<th><strong> To view the contact details of a registered IT Consultant, select a technology below:</strong></th>
			     		<c:if test="${register_data == true}">
				     		<script>
								alert("Consultant registered successfully !!!");
							</script>
			     		</c:if>
				</tr>
				<sql:query var="subjects" dataSource="jdbc/searchDB">
				    SELECT subject_id as id, name FROM Subject;
				</sql:query>
				<tr><form action="response.jsp" method="post">
					<td>
						
					
					
					<c:choose> 
					  <c:when test="${subjects.getRowCount() > 0 }">
						<select name="subject_id">
							<c:forEach var="subject" items="${subjects.rows}">
								<option value="${subject.subject_id}">${subject.name}</option>
							</c:forEach>
						</select>
					    
					    <input type="submit" value="Search" name="Search" /></td>
					  </c:when>
					  <c:otherwise>
					    <input type="text" id="subject_id" disabled="disabled" value="Consultant directory empty!!!"/>
					    
					    <input type="submit" value="Search" name="Search"  disabled="disabled"/></td>
					  </c:otherwise>
					</c:choose>
				    </form>
				</tr>
			    
		</table>
		
		<table class="register" border="0" style="width:100%" >
			<tbody>
				
				<tr>
					<th><strong>Register a new Consultant</strong></th>
				</tr>
			    <tr>
					
				</tr>
			</tbody>
		</table>
		<table class="register" border="0" style="width:100%" >
			<tbody>
				<form action="index.jsp" method="post">
				<tr>
					<td> <strong>First Name:</strong></td> 
					<td><input type="text" name="txtFirstName"></td>
					<td><strong>Last Name:</strong></td> 
					<td><input type="text" name="txtLastName" value=""></td>
					
				</tr>
				<tr>
					<td><strong>Telephone:</strong></td> 
					<td><input type="text" name="txtTelephone"></td>
					<td> <strong>Email:</strong></td> 
					<td><input type="text" name="txtEmail"></td>
			            
			    <!--<th>XYZ Consultancy offers expert consultation in a wide range of fields.</th>-->
			             
				</tr>
				<tr>
					<td> <strong>Technology:</strong></td> 
					<td><input type="text" name="txtSubjectName"></td>
					<td><strong>Technology Description:</strong></td> 
					<td><input type="text" name="txtSubjectDescription" value=""></td>
				</tr>
				<tr>
					<td><input type="submit" value="Register" name="Register" /></td>
				</tr>
			    </form>
			</tbody>
		</table>
		<table class="footer" style="width:100%" >
		<tbody>
			<tr>
				<td> <i>Request served by server Hostname: <b><%= InetAddress.getLocalHost().getHostName() %> </b>  IP Address: <b><%= InetAddress.getLocalHost().getHostAddress() %></b> </i>
				
				</td>
			</tr>
		</tbody>
		
		</table>
    </body>
</html>
