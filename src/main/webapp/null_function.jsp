<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.sql.*"%>
<%
	/*
		select 이름, nvl(일분기, 0) from 실적;
		select 이름, nvl2(일분기, 'success', 'fail') from 실적;
		select 이름, nullif(사분기, 100) from 실적;
		select 이름, coalesce(일분기, 이분기, 삼분기, 사분기) from 실적;
	*/

	//db 연동
	String driver = "oracle.jdbc.driver.OracleDriver";		
	String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
	String dbuser = "hr";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn + "접속");

	String sql1 ="select 이름, nvl(일분기, 0) result from 실적";
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	System.out.println(stmt1);
	ResultSet rs1 = stmt1.executeQuery();
	ArrayList<HashMap<String, Object>> list1 = new ArrayList<HashMap<String, Object>>();
	while(rs1.next()) {
		HashMap<String, Object> m1 = new HashMap<String, Object>();
		m1.put("이름", rs1.getString("이름"));
		m1.put("result", rs1.getInt("result"));
		list1.add(m1);			
	}
	System.out.println(list1);

	String sql2 ="select 이름, nvl2(일분기, 'success', 'fail') result from 실적";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	System.out.println(stmt2);
	ResultSet rs2 = stmt2.executeQuery();
	ArrayList<HashMap<String, Object>> list2 = new ArrayList<HashMap<String, Object>>();
	while(rs2.next()) {
		HashMap<String, Object> m2 = new HashMap<String, Object>();
		m2.put("이름", rs2.getString("이름"));
		m2.put("result", rs2.getString("result"));
		list2.add(m2);			
	}
	System.out.println(list2);

	String sql3 ="select 이름, nullif(사분기, 100) result from 실적";
	PreparedStatement stmt3 = conn.prepareStatement(sql3);
	System.out.println(stmt3);
	ResultSet rs3 = stmt3.executeQuery();
	ArrayList<HashMap<String, Object>> list3 = new ArrayList<HashMap<String, Object>>();
	while(rs3.next()) {
		HashMap<String, Object> m3 = new HashMap<String, Object>();
		m3.put("이름", rs3.getString("이름"));
		m3.put("result", rs3.getInt("result"));
		list3.add(m3);			
	}
	System.out.println(list3);

	String sql4 ="select 이름, coalesce(일분기, 이분기, 삼분기, 사분기) result from 실적";
	PreparedStatement stmt4 = conn.prepareStatement(sql4);
	System.out.println(stmt4);
	ResultSet rs4 = stmt4.executeQuery();
	ArrayList<HashMap<String, Object>> list4 = new ArrayList<HashMap<String, Object>>();
	while(rs4.next()) {
		HashMap<String, Object> m4 = new HashMap<String, Object>();
		m4.put("이름", rs4.getString("이름"));
		m4.put("result", rs4.getInt("result"));
		list4.add(m4);			
	}
	System.out.println(list4);

%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<h3>nvl()</h3>
		<table border="1">
			<tr>
				<td>이름</td>
				<td>result</td>
			</tr>
			<%
				for(HashMap<String, Object> m1 : list1) {			
			%>
					<tr>
						<td><%=(String)(m1.get("이름"))%></td>		
						<td><%=(Integer)(m1.get("result"))%></td>
					</tr>
					<%
						}
					%>
		</table>

	<h3>nvl2()</h3>
		<table border="1">
			<tr>
				<td>이름</td>
				<td>result</td>
			</tr>
			<%
				for(HashMap<String, Object> m2 : list2) {			
			%>
					<tr>
						<td><%=(String)(m2.get("이름"))%></td>		
						<td><%=(String)m2.get("result")%></td>
					</tr>
					<%
						}
					%>
		</table>

	<h3>nullif()</h3>
		<table border="1">
			<tr>
				<td>이름</td>
				<td>result</td>
			</tr>
			<%
				for(HashMap<String, Object> m3 : list3) {			
			%>
					<tr>
						<td><%=(String)(m3.get("이름"))%></td>		
						<td><%=(Integer)(m3.get("result"))%></td>
					</tr>
					<%
						}
					%>
		</table>

	<h3>coalesce()</h3>
		<table border="1">
			<tr>
				<td>이름</td>
				<td>result</td>
			</tr>
			<%
				for(HashMap<String, Object> m4 : list4) {			
			%>
					<tr>
						<td><%=(String)(m4.get("이름"))%></td>		
						<td><%=(Integer)(m4.get("result"))%></td>
					</tr>
					<%
						}
					%>
		</table>
</body>
</html>