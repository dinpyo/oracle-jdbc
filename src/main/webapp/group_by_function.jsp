<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.sql.*"%>
<%
	/*
		select department_id, job_id, count(*) from employees
		group by department_id, job_id;
		
		select department_id, job_id, count(*) from employees
		group by rollup(department_id, job_id);
		
		select department_id, job_id, count(*) from employees
		group by cube(department_id, job_id);
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

	String sql1 = "select department_id 부서ID, job_id 직무ID, count(*) 부서인원 from employees group by department_id, job_id";
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	System.out.println(stmt1);
	ResultSet rs1 = stmt1.executeQuery();
	ArrayList<HashMap<String, Object>> list1 = new ArrayList<HashMap<String, Object>>();
	while(rs1.next()) {
		HashMap<String, Object> m1 = new HashMap<String, Object>();
		m1.put("부서ID", rs1.getInt("부서ID"));
		m1.put("직무ID", rs1.getString("직무ID"));
		m1.put("부서인원", rs1.getInt("부서인원"));
		list1.add(m1);			
	}
	System.out.println(list1);
	
	
	String sql2 = "select department_id 부서ID, job_id 직무ID, count(*) 부서인원 from employees group by rollup(department_id, job_id)";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	System.out.println(stmt2);
	ResultSet rs2 = stmt2.executeQuery();
	ArrayList<HashMap<String, Object>> list2 = new ArrayList<HashMap<String, Object>>();
	while(rs2.next()) {
		HashMap<String, Object> m2 = new HashMap<String, Object>();
		m2.put("부서ID", rs2.getInt("부서ID"));
		m2.put("직무ID", rs2.getString("직무ID"));
		m2.put("부서인원", rs2.getInt("부서인원"));
		list2.add(m2);			
	}
	System.out.println(list2);
	
	String sql3 = "select department_id 부서ID, job_id 직무ID, count(*) 부서인원 from employees group by cube(department_id, job_id)";
	PreparedStatement stmt3 = conn.prepareStatement(sql3);
	System.out.println(stmt3);
	ResultSet rs3 = stmt3.executeQuery();
	ArrayList<HashMap<String, Object>> list3 = new ArrayList<HashMap<String, Object>>();
	while(rs3.next()) {
		HashMap<String, Object> m3 = new HashMap<String, Object>();
		m3.put("부서ID", rs3.getInt("부서ID"));
		m3.put("직무ID", rs3.getString("직무ID"));
		m3.put("부서인원", rs3.getInt("부서인원"));
		list3.add(m3);			
	}
	System.out.println(list3);

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="container">
		<div class="row">
			<div class="col-sm-4">
			<h3>GROUP BY</h3>
				<table border="1">
					<tr>
						<td>부서ID</td>
						<td>직무ID</td>
						<td>부서인원</td>	
					</tr>
					<%
						for(HashMap<String, Object> m1 : list1) {
							
					%>
							<tr>
								<td><%=(Integer)(m1.get("부서ID"))%></td>
								<td><%=(String)(m1.get("직무ID"))%></td>
								<td><%=(Integer)(m1.get("부서인원"))%></td>			
							</tr>
					<%
						}
					%>
				</table>
			</div>
			<div class="col-sm-4">
			<h3>GROUP BY ROLLUP</h3>
				<table border="1">
					<tr>
						<td>부서ID</td>
						<td>직무ID</td>
						<td>부서인원</td>	
					</tr>
					<%
						for(HashMap<String, Object> m2 : list2) {
							
					%>
							<tr>
								<td><%=(Integer)(m2.get("부서ID"))%></td>
								<td><%=(String)(m2.get("직무ID"))%></td>
								<td><%=(Integer)(m2.get("부서인원"))%></td>			
							</tr>
					<%
						}
					%>
				</table>
			</div>	
			<div class="col-sm-4">

			<h3>GROUP BY CUBE</h3>
				<table border="1">
					<tr>
						<td>부서ID</td>
						<td>직무ID</td>
						<td>부서인원</td>	
					</tr>
					<%
						for(HashMap<String, Object> m3 : list3) {
							
					%>
							<tr>
								<td><%=(Integer)(m3.get("부서ID"))%></td>
								<td><%=(String)(m3.get("직무ID"))%></td>
								<td><%=(Integer)(m3.get("부서인원"))%></td>			
							</tr>
					<%
						}
					%>
				</table>
			</div>
		</div>
	</div>	
</body>
</html>