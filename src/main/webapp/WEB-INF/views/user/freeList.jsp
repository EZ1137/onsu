<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>On:Soo - FREE BOARD</title>
<link href="${pageContext.request.contextPath}/resources/css/free.css"
	rel="stylesheet">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.0/css/all.min.css"
	rel="stylesheet">
<script>
	function loginAlert() {
		alert("로그인 해주세요");
		location.href = "${pageContext.request.contextPath}/login/loginForm.do";
	}
</script>
</head>
<body>

	<!-- header -->
	<header id="header" class="area">
		<%@ include file="/WEB-INF/views/header.jsp"%>
	</header>

	<section class="section area">
		<!-- 타이틀 -->
		<div class="free_board_title">
			<p>FREE BOARD</p>
		</div>

		<!-- 게시판 목록 -->
		<table class="free_list">
			<colgroup>
				<col width="6%" />
				<col width="60%" />
				<col width="10%" />
				<col width="24%" />
			</colgroup>

			<thead>
				<tr>
					<th>No.</th>
					<th>TITLE</th>
					<th>WRITER</th>
					<th>DATE</th>
				</tr>
			</thead>

			<tbody>

				<c:choose>
					<c:when test="${empty list }">
						<tr>
							<th colspan="4">------------ 강의가 없습니다 ----------------</th>
						</tr>
					</c:when>
					<c:otherwise>
						<c:forEach items="${list }" var="freeboardDto">
							<tr>
								<td>${freeboardDto.free_seq }</td>
								<td><a
									href="freedetail.do?free_seq=${freeboardDto.free_seq }">${freeboardDto.free_title }</a></td>

								<td>${freeboardDto.free_writer}</td>
								<td><fmt:formatDate value="${freeboardDto.free_date}"
										pattern="yyyy-MM-dd" /></td>
							</tr>
						</c:forEach>
					</c:otherwise>
				</c:choose>

			</tbody>

			<tfoot>
				<c:choose>

					<c:when test="${logindto ne null }">
						<!--로그인했을때  -->
						<tr>
							<td colspan="6" class="qbtnbar" style="text-align: right;"><input
								type="button" value="WRITE"
								onclick="location.href='freeinsert.do'" /></td>
						</tr>
					</c:when>
					<c:otherwise>
						<sec:authorize access="isAuthenticated()">
							<form:form action="${pageContext.request.contextPath}/logout" method="POST">
    							<input type="submit" value="로그아웃" />
    							 <td colspan="6" class="qbtnbar" style="text-align: right;"><input
								type="button" value="WRITE" onclick="location.href='freeinsert.do'" /></td>
    							
							</form:form>
						</sec:authorize>
					</c:otherwise>
				</c:choose>

			</tfoot>
		</table>
	</section>

	<!-- footer -->
	<footer id="footerarea" class="area">
		<%@ include file="/WEB-INF/views/footer.jsp"%>
	</footer>

</body>
</html>