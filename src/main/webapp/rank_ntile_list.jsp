<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.sql.*"%>

<%
	/*
		SELECT employee_id 아이디, last_name 이름, salary 급여, rank() OVER(ORDER BY salary DESC) 급여순위, ntile(10) OVER(ORDER BY salary DESC) 급여랭크 
		FROM employees; 
	
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
	String totalRowSql = "select count(*) from employees";
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
	
	// 3종류의 랭크를 담을수 있는 변수 생성
	String rank = "rank()";
	if(request.getParameter("rank") !=null){
		rank = request.getParameter("rank");
		System.out.println(rank+"<--rank");
	}
	
	// 번호(rownum) ? 부터 ? 까지 조회하는 쿼리문
	String sql= "SELECT 번호, 아이디, 이름, 급여, 급여순위, 급여랭크 FROM(SELECT rownum 번호, 아이디, 이름, 급여, 급여순위, 급여랭크 FROM (SELECT employee_id 아이디, last_name 이름, salary 급여,"+rank+" OVER(ORDER BY salary DESC) 급여순위, ntile(10) OVER(ORDER BY salary DESC) 급여랭크 FROM employees)) WHERE 번호 BETWEEN ? AND ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, beginRow);
	stmt.setInt(2, endRow);
	ResultSet rs = stmt.executeQuery();
	ArrayList<HashMap<String, Object>> list = new ArrayList<>();
	while(rs.next()){
		HashMap<String,Object> m = new HashMap<String, Object>();
		m.put("번호",rs.getInt("번호"));
		m.put("아이디",rs.getString("아이디"));
		m.put("이름",rs.getString("이름"));
		m.put("급여",rs.getInt("급여"));
		m.put("급여순위",rs.getInt("급여순위"));
		m.put("급여랭크",rs.getInt("급여랭크"));
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
	<h1>rank() AND ntile()</h1>
	<form action="<%=request.getContextPath()%>/rank_ntile_list.jsp">
		<select name="rank">
			<option value="rank()" 
				<%= (request.getParameter("rank") != null && request.getParameter("rank").equals("rank()")) ? "selected" : "" %>>rank()
			</option>
			<option value="dense_rank()" 
				<%= (request.getParameter("rank") != null && request.getParameter("rank").equals("dense_rank()")) ? "selected" : "" %>>dense_rank()
			</option>
			<option value="row_number()"
				 <%= (request.getParameter("rank") != null && request.getParameter("rank").equals("row_number()")) ? "selected" : "" %>>row_number()
			</option>
		</select>
		<button type="submit">전송</button>
	</form>
	<table class="table table-hover">
		<tr>
			<th>번호</th>
			<th>아이디</th>
			<th>이름</th>
			<th>급여</th>
			<th>급여순위</th>
			<th>급여랭크</th>
		</tr>
		<%
			for(HashMap<String,Object> m : list){
		%>
				<tr>
					<td><%=(Integer)m.get("번호")%></td>
					<td><%=m.get("아이디")%></td>
					<td><%=m.get("이름")%></td>
					<td><%=(Integer)m.get("급여")%></td>
					<td><%=(Integer)m.get("급여순위")%></td>
					<td><%=(Integer)m.get("급여랭크")%></td>
				</tr>
		<%
			}
		%>
	</table>

	<!-- 페이지 네비게이션 페이징 -->
	<%
		if(minPage>1) {	// 1보다 작으면 이전 버튼이 사라진다.
	%>	
			
		<a href="<%=request.getContextPath()%>/rank_ntile_list.jsp?currentPage=<%=minPage-pagePerPage%>&rank=<%=rank%>">이전</a>
			
	<%
		}
		
		
		for(int i = minPage; i<=maxPage; i=i+1) {	
			if(i ==  currentPage) {	// currentPage가 i와 같으면 a태그가 사라진다.
	%>
				<span><%=i%></span>
	
	<%						
			} else { // currentPage가 i와 같지 않으면 a태그가 생긴다.
				
	%>		
			<a href="<%=request.getContextPath()%>/rank_ntile_list.jsp?currentPage=<%=i%>&rank=<%=rank%>"><%=i%></a>&nbsp;
			
	<%
			}
		}
		
		if(maxPage != lastPage) {	// maxPage와 lastPage가 같으면 다은 버튼이 사라진다.
	
	%>	
		<!-- maxPage +1 -->
		<a href="<%=request.getContextPath()%>/rank_ntile_list.jsp?currentPage=<%=minPage+pagePerPage%>&rank=<%=rank%>">다음</a>
		
	<%
		}	
	%>			




		
</body>
</html>