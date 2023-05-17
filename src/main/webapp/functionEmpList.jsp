<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.sql.*"%>

<%
	/*
		select 번호, 이름, 이름첫글자, 연봉, 급여, 입사날짜, 입사년도 
		from
		    (select rownum 번호, last_name 이름, substr(last_name, 1, 1) 이름첫글자, salary 연봉, round(salary/12, 2) 급여, hire_date 입사날짜, extract(year from hire_date) 입사년도 
		    from employees)
		where 번호 between ? and ?;
	*/

	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
// --------------------------- db 연동 -----------------------------------------------------------------------
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
	
	// 번호(rownum) ? 부터 ? 까지 조회하는 쿼리문
	String sql= "select 번호, 이름, 이름첫글자, 연봉, 급여, 입사날짜, 입사년도 from(select rownum 번호, last_name 이름, substr(last_name, 1, 1) 이름첫글자, salary 연봉, round(salary/12, 2) 급여, hire_date 입사날짜, extract(year from hire_date) 입사년도 from employees) where 번호 between ? and ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, beginRow);
	stmt.setInt(2, endRow);
	ResultSet rs = stmt.executeQuery();
	ArrayList<HashMap<String, Object>> list = new ArrayList<>();
	while(rs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("번호", rs.getInt("번호"));
		m.put("이름", rs.getString("이름"));
		m.put("이름첫글자", rs.getString("이름첫글자"));
		m.put("연봉", rs.getInt("연봉"));
		m.put("급여", rs.getDouble("급여"));
		m.put("입사날짜", rs.getString("입사날짜"));
		m.put("입사년도", rs.getInt("입사년도"));
		list.add(m);
	}
	
	System.out.println(list.size()+ " <--list.size()");
	

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<table border="1">
		<tr>
			<td>번호</td>
			<td>이름</td>
			<td>이름첫글자</td>
			<td>연봉</td>
			<td>급여</td>
			<td>입사날짜</td>
			<td>입사년도</td>
		</tr>
		<%
			for(HashMap<String, Object> m : list) {
		%>
				<tr>
					<td><%=(Integer)(m.get("번호")) %></td>
					<td><%=(String)(m.get("이름")) %></td>
					<td><%=(String)(m.get("이름첫글자")) %></td>
					<td><%=(Integer)(m.get("연봉")) %></td>
					<td><%=(Double)(m.get("급여")) %></td>
					<td><%=(String)(m.get("입사날짜")) %></td>
					<td><%=(Integer)(m.get("입사년도")) %></td>
				</tr>				
		<%
			}
		%>
	</table>

	<%
		/*
			cp				minPage	~  maxPage
			1				1		~  10
			2				1		~  10
			10				1		~  10
			
			11				11		~  20
			12				11		~  20
			20				11		~  20
			
			(cp-1) / pagePerPage * pagePerPage + 1 --> minPage
			minPage + (pagePerPage-1) --> maxPage
			maxPage < lastPage --> maxPage = lastPage
		*/
	
		int lastPage = totalRow / rowPerPage;
		if(totalRow % rowPerPage != 0) {
			lastPage = lastPage + 1;
		}
			
			
// -------------------------------- 페이지 네비게이션 페이징 ----------------------------------------------------------
		
		// 페이지당 출력 할 페이지
		int pagePerPage = 10;
		
		// 출력할 페이지의 최솟값과 최댓값
		int minPage = (((currentPage-1) / pagePerPage) * pagePerPage) + 1;
		int maxPage = minPage + (pagePerPage -1);
		
		// 빈페이지 생성을 방지하려고 ex) 행이 총 107개이므로 마지막페이지는 11이고 7개가 출력되는데 12페이지부터 안나오게 하려고
		if(maxPage > lastPage) {
			maxPage = lastPage;
		}
		
		
		if(minPage>1) {	// 1보다 작으면 이전 버튼이 사라진다.
	%>	
			
		<a href="<%=request.getContextPath()%>/functionEmpList.jsp?currentPage=<%=minPage-pagePerPage%>">이전</a>
			
	<%
		}
		
		
		for(int i = minPage; i<=maxPage; i=i+1) {	
			if(i ==  currentPage) {	// currentPage가 i와 같으면 a태그가 사라진다.
	%>
				<span><%=i%></span>
	
	<%						
			} else { // currentPage가 i와 같지 않으면 a태그가 생긴다.
				
	%>		
			<a href="<%=request.getContextPath()%>/functionEmpList.jsp?currentPage=<%=i%>"><%=i%></a>&nbsp;
			
	<%
			}
		}
		
		if(maxPage != lastPage) {	// maxPage와 lastPage가 같으면 다은 버튼이 사라진다.
	
	%>	
		<!-- maxPage +1 -->
		<a href="<%=request.getContextPath()%>/functionEmpList.jsp?currentPage=<%=minPage+pagePerPage%>">다음</a>
		
	<%
		}	
	%>					
		
</body>
</html>