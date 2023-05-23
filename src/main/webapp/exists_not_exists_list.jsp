<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.sql.*"%>

<%
	/*
		select e.employee_id, e.first_name
		from employees e 
		where not exists (select * from departments d where d.department_id = e.department_id);
	*/

	// 현재페이지 유효성 검사
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println(currentPage+ " <-- 현재 페이지");

	// DB연동
	String driver = "oracle.jdbc.driver.OracleDriver";		
	String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
	String dbuser = "hr";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn + "접속");

	// 전체 행 개수 쿼리문
	int totalRow = 0;
	String totalRowSql = "select count(*) from (select e.employee_id 사원ID, e.first_name 이름 from employees e where not exists (select * from departments d where d.department_id = e.department_id))";
	PreparedStatement totalRowStmt = conn.prepareStatement(totalRowSql);
	ResultSet totalRwoRs = totalRowStmt.executeQuery();
	if(totalRwoRs.next()) {
		totalRow = totalRwoRs.getInt(1);	// totalRwoRs.getInt("count(*)")
	}
	
	int rowPerPage = 10;
	int beginRow = (currentPage-1) * rowPerPage+1;
	int endRow = beginRow + (rowPerPage -1);
	if(endRow > totalRow) {
		endRow =  totalRow;
	}

	// 번호(rownum) ? 부터 ? 까지 조회하는 쿼리문
	String sql= "SELECT 번호, 사원ID, 이름 FROM(SELECT rownum 번호, 사원ID, 이름 from(SELECT e.employee_id 사원ID, e.first_name 이름 from employees e WHERE not exists (select * FROM departments d WHERE d.department_id = e.department_id)))WHERE 번호 between ? and ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, beginRow);
	stmt.setInt(2, endRow);
	ResultSet rs = stmt.executeQuery();
	ArrayList<HashMap<String, Object>> list = new ArrayList<>();
	while(rs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("번호", rs.getInt("번호"));
		m.put("사원ID", rs.getInt("사원ID"));
		m.put("이름", rs.getString("이름"));
		list.add(m);
	}	
	System.out.println(list+ " <--list");
	System.out.println(list.size()+ " <--list.size()");
	
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
	
	// 페이지당 출력 할 페이지
	int pagePerPage = 10;
			
	// 출력할 페이지의 최솟값과 최댓값
	int minPage = (((currentPage-1) / pagePerPage) * pagePerPage) + 1;
	int maxPage = minPage + (pagePerPage -1);
			
	// 빈페이지 생성을 방지
	if(maxPage > lastPage) {
		maxPage = lastPage;
	}

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1> not exists()</h1>
	<table border="1">
		<tr>
			<td>번호</td>
			<td>사원ID</td>
			<td>이름</td>
		</tr>
		<%
			for(HashMap<String, Object> m : list) {
		%>
				<tr>
					<td><%=(Integer)(m.get("번호")) %></td>
					<td><%=(Integer)(m.get("사원ID")) %></td>
					<td><%=(String)(m.get("이름")) %></td>
				</tr>				
		<%
			}
		%>
	</table>


	<!--  페이지 네비게이션 페이징 -->
	<%	
		if(minPage>1) {	// 1보다 작으면 이전 버튼이 사라진다.
	%>	
			
		<a href="<%=request.getContextPath()%>/exists_not_exists_list.jsp?currentPage=<%=minPage-pagePerPage%>">이전</a>
			
	<%
		}
		
		
		for(int i = minPage; i<=maxPage; i=i+1) {	
			if(i ==  currentPage) {	// currentPage가 i와 같으면 a태그가 사라진다.
	%>
				<span><%=i%></span>
	
	<%						
			} else { // currentPage가 i와 같지 않으면 a태그가 생긴다.
				
	%>		
			<a href="<%=request.getContextPath()%>/exists_not_exists_list.jsp?currentPage=<%=i%>"><%=i%></a>&nbsp;
			
	<%
			}
		}
		
		if(maxPage != lastPage) {	// maxPage와 lastPage가 같으면 다은 버튼이 사라진다.
	
	%>	
		<!-- maxPage +1 -->
		<a href="<%=request.getContextPath()%>/exists_not_exists_list.jsp?currentPage=<%=minPage+pagePerPage%>">다음</a>
		
	<%
		}	
	%>					
		
</body>
</html>