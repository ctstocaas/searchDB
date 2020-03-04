<%-- 
    Document   : index
    Created on : Apr 12, 2016, 10:57:06 AM
    Author     : Administrator
--%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ page import="java.net.InetAddress" %>

<c:if test="${param.subject_id!=null}">

<sql:update var="subjDel" dataSource="jdbc/searchDB">
    DELETE FROM Subject where subject_id = ?; <sql:param value="${param.subject_id}"/>
</sql:update>
<sql:update var="counsDel" dataSource="jdbc/searchDB">
    DELETE FROM Counselor where counselor_id = ?; <sql:param value="${param.subject_id}"/>
</sql:update>
						    
</c:if>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <link rel="stylesheet" type="text/css" href="style.css">
        <title>IT Consultant Directory - Delete Record</title>
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
                <th colspan="2">Record deleted.</th>
            </tr>
            
            <tr>
                <td>
                	<form>
						<input id="inp" type="button" value="Search Another" onclick="location.href='index.jsp';" />
					</form>
                </td>
                <td>
                	
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
