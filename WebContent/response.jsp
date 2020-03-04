<%-- 
    Document   : response
    Created on : Apr 12, 2016, 11:16:43 AM
    Author     : Administrator
--%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ page import="java.net.InetAddress" %>

     <sql:query var="counsSubjRs" maxRows="1" dataSource="jdbc/searchDB">
        SELECT s.name, s.description,
        CONCAT(c.first_name," ",c.last_name) as counselor,
        c.member_since as memberSince, c.telephone, c.email
        FROM Subject as s, Counselor as c
        WHERE c.counselor_id = s.counselor_idfk
        AND s.subject_id = ? <sql:param value="${param.subject_id}"/>
    </sql:query>
    
<c:set var="counsSubj" scope="request" value="${counsSubjRs.rows[0]}"/>    
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <link rel="stylesheet" type="text/css" href="style.css">
        <title>IT Consultant Directory - ${counsSubj.name}</title>
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
        

        <table class="search" style="width:100%">
            <tr>
                <th colspan="2">Technology: ${counsSubj.name}</th>
            </tr>
            <tr>
                <td><strong>Description: </strong></td>
                <td><span style="font-size:smaller; font-style:italic;">${counsSubj.description}</span></td>
            </tr>
            <tr>
                <td><strong>Consultant: </strong></td>
                <td><strong>${counsSubj.counselor}</strong>
                    <br><span style="font-size:smaller; font-style:italic;">
                    member since: ${counsSubj.member_since}</span></td>
            </tr>
            <tr>
                <td><strong>Contact Details: </strong></td>
                <td><strong>email: </strong>
                    <a href="mailto:${counsSubj.email}">${counsSubj.email}</a>
                    <br><strong>phone: </strong>${counsSubj.telephone}</td>
            </tr>
            
            <tr>
                <td>
                	<form>
						<input id="inp" type="button" value="Search Another" onclick="location.href='index.jsp';" />
					</form>
                </td>
                <td>
                	<form action="delete.jsp" method="post">
						<input type="hidden" name="subject_id" value="${param.subject_id}"> 
						<input type="submit" value="Delete Record" name="Delete Record">
							
					</form>
                </td>
                <td></td>
            </tr>
        </table>
        <table class="footer" border="0" style="width:100%" >
		<tbody>
			<tr>
				<td> <i>Request served by server Hostname: <b><%= InetAddress.getLocalHost().getHostName() %> </b>  IP Address: <b><%= InetAddress.getLocalHost().getHostAddress() %></b> </i>
				
				</td>
			</tr>
		</tbody>
		
		</table>
    </body>
</html>
